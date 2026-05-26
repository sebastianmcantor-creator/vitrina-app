-- ─────────────────────────────────────────────────────────────────────────────
-- Migracion 030 — Twilio modelo "numero por cliente" + sistema de limites WA
-- ─────────────────────────────────────────────────────────────────────────────
-- Cambios:
-- 1. Agregar columnas Twilio en restaurants (numero asignado, status, quality)
-- 2. Tabla wa_usage   — tracking mensual de mensajes utility/marketing por cliente
-- 3. Tabla wa_messages_log — log fino por mensaje (in/out, costo, tipo)
-- 4. Tabla wa_optin_contacts — opt-in marketing + topes por contacto
-- 5. Tabla wa_templates — plantillas pre-aprobadas en Twilio
-- 6. Funcion RPC increment_wa_usage para incrementos atomicos
-- ─────────────────────────────────────────────────────────────────────────────

-- 1) Columnas nuevas en restaurants ───────────────────────────────────────────
ALTER TABLE public.restaurants
  ADD COLUMN IF NOT EXISTS twilio_number TEXT,
  ADD COLUMN IF NOT EXISTS twilio_phone_sid TEXT,
  ADD COLUMN IF NOT EXISTS twilio_messaging_service_sid TEXT,
  ADD COLUMN IF NOT EXISTS twilio_provisioned_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS twilio_released_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS wa_status TEXT DEFAULT 'pending'
    CHECK (wa_status IN ('pending','active','paused_marketing','paused_all','released')),
  ADD COLUMN IF NOT EXISTS wa_quality_rating TEXT,
  ADD COLUMN IF NOT EXISTS wa_last_inbound_at TIMESTAMPTZ;

-- 2) wa_usage ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.wa_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  period TEXT NOT NULL, -- formato 'YYYY-MM'
  utility_count INTEGER DEFAULT 0,
  marketing_count INTEGER DEFAULT 0,
  utility_included INTEGER DEFAULT 150,
  marketing_included INTEGER DEFAULT 50,
  utility_extra_blocks INTEGER DEFAULT 0,    -- bloques extra de 50 utility comprados
  marketing_extra_blocks INTEGER DEFAULT 0,  -- bloques extra de 50 marketing comprados
  total_cost_usd NUMERIC(10,4) DEFAULT 0,
  vitrina_cost_usd NUMERIC(10,4) DEFAULT 0,
  alerted_80 BOOLEAN DEFAULT false,
  alerted_100 BOOLEAN DEFAULT false,
  alerted_120 BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (restaurant_id, period)
);

-- 3) wa_messages_log ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.wa_messages_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  twilio_sid TEXT,
  direction TEXT NOT NULL CHECK (direction IN ('in','out')),
  msg_type TEXT NOT NULL CHECK (msg_type IN ('utility','marketing','conversation','system')),
  contact_phone TEXT NOT NULL,
  status TEXT,                 -- queued / sent / delivered / read / failed
  error TEXT,
  content_preview TEXT,        -- primeros 280 chars del mensaje
  cost_usd NUMERIC(10,4) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4) wa_optin_contacts ────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.wa_optin_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  phone TEXT NOT NULL,
  opted_in_at TIMESTAMPTZ DEFAULT NOW(),
  opted_out_at TIMESTAMPTZ,
  last_inbound_at TIMESTAMPTZ,
  last_marketing_at TIMESTAMPTZ,
  marketing_count_month INTEGER DEFAULT 0,
  marketing_count_total INTEGER DEFAULT 0,
  UNIQUE (restaurant_id, phone)
);

-- 5) wa_templates ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.wa_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  template_sid TEXT,           -- SID que Twilio retorna al aprobar
  name TEXT NOT NULL,
  category TEXT CHECK (category IN ('utility','marketing','authentication')),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected','paused')),
  body TEXT NOT NULL,
  variables_json JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  approved_at TIMESTAMPTZ
);

-- 6) Indices ──────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS wa_usage_restaurant_period_idx ON public.wa_usage(restaurant_id, period);
CREATE INDEX IF NOT EXISTS wa_messages_log_restaurant_idx ON public.wa_messages_log(restaurant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS wa_messages_log_contact_idx    ON public.wa_messages_log(restaurant_id, contact_phone, created_at DESC);
CREATE INDEX IF NOT EXISTS wa_optin_contacts_restaurant_idx ON public.wa_optin_contacts(restaurant_id, phone);
CREATE INDEX IF NOT EXISTS wa_templates_restaurant_idx    ON public.wa_templates(restaurant_id);
CREATE INDEX IF NOT EXISTS restaurants_twilio_number_idx  ON public.restaurants(twilio_number) WHERE twilio_number IS NOT NULL;

-- 7) RLS ──────────────────────────────────────────────────────────────────────
ALTER TABLE public.wa_usage             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wa_messages_log      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wa_optin_contacts    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wa_templates         ENABLE ROW LEVEL SECURITY;

GRANT ALL ON public.wa_usage          TO service_role;
GRANT ALL ON public.wa_messages_log   TO service_role;
GRANT ALL ON public.wa_optin_contacts TO service_role;
GRANT ALL ON public.wa_templates      TO service_role;

-- 8) Funcion RPC atomica para incrementar contadores ─────────────────────────
CREATE OR REPLACE FUNCTION increment_wa_usage(
  p_restaurant_id UUID,
  p_period TEXT,
  p_msg_type TEXT,
  p_cost NUMERIC
) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO wa_usage (restaurant_id, period, utility_count, marketing_count, vitrina_cost_usd)
  VALUES (
    p_restaurant_id,
    p_period,
    CASE WHEN p_msg_type = 'utility'   THEN 1 ELSE 0 END,
    CASE WHEN p_msg_type = 'marketing' THEN 1 ELSE 0 END,
    p_cost
  )
  ON CONFLICT (restaurant_id, period) DO UPDATE SET
    utility_count    = wa_usage.utility_count    + CASE WHEN p_msg_type = 'utility'   THEN 1 ELSE 0 END,
    marketing_count  = wa_usage.marketing_count  + CASE WHEN p_msg_type = 'marketing' THEN 1 ELSE 0 END,
    vitrina_cost_usd = wa_usage.vitrina_cost_usd + p_cost,
    updated_at       = NOW();
END;
$$;

-- 9) Funcion auxiliar: reset mensual marketing_count_month en optin_contacts
CREATE OR REPLACE FUNCTION reset_wa_optin_month()
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  UPDATE public.wa_optin_contacts SET marketing_count_month = 0;
END;
$$;
