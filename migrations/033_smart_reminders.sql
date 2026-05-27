-- Migración 033: Smart Visit Reminders
-- Sistema de recordatorios inteligentes de visita para rubros de servicios

-- Columnas nuevas en customers (tabla ya existente)
ALTER TABLE public.customers
  ADD COLUMN IF NOT EXISTS visit_interval_days INTEGER,
  ADD COLUMN IF NOT EXISTS last_visit_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS next_visit_estimated TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS reminder_enabled BOOLEAN DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS reminder_last_sent_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS reminder_draft TEXT,
  ADD COLUMN IF NOT EXISTS reminder_draft_generated_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS reminder_draft_approved BOOLEAN DEFAULT FALSE;

-- Tabla de configuración por negocio
CREATE TABLE IF NOT EXISTS public.smart_reminder_config (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  enabled BOOLEAN NOT NULL DEFAULT FALSE,
  days_before INTEGER NOT NULL DEFAULT 5,
  default_interval_days INTEGER NOT NULL DEFAULT 30,
  tone TEXT NOT NULL DEFAULT 'calido' CHECK (tone IN ('calido', 'amigable', 'formal')),
  service_type TEXT,
  custom_service_name TEXT,
  nudge_owner_if_pending BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (restaurant_id)
);

CREATE INDEX IF NOT EXISTS smart_reminder_config_restaurant_idx ON public.smart_reminder_config(restaurant_id);
CREATE INDEX IF NOT EXISTS customers_next_visit_idx ON public.customers(restaurant_id, next_visit_estimated) WHERE next_visit_estimated IS NOT NULL;

ALTER TABLE public.smart_reminder_config ENABLE ROW LEVEL SECURITY;
GRANT ALL ON public.smart_reminder_config TO service_role;
