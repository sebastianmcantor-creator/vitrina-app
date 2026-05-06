-- =============================================================================
-- SUBSCRIPTIONS — Sistema de suscripciones y planes
-- =============================================================================

-- ---------------------------------------------------------------------------
-- SUBSCRIPTIONS
-- Trackea el estado de suscripción activo de cada restaurante
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.subscriptions (
  id                      UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id           UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Plan y tipo
  plan_type               TEXT          NOT NULL, -- menu | marketing | combo
  plan_tier               TEXT          NOT NULL, -- free | basico | starter | pro | full
  status                  TEXT          NOT NULL DEFAULT 'active',
  -- active | past_due | cancelled | paused

  -- Trial
  trial_end               TIMESTAMPTZ,

  -- Período de facturación actual
  current_period_start    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  current_period_end      TIMESTAMPTZ   NOT NULL,

  -- MercadoPago
  mp_subscription_id      TEXT          UNIQUE,
  mp_preapproval_id       TEXT,
  mp_payer_id             TEXT,

  -- Precios
  amount_usd              NUMERIC(10,2) NOT NULL DEFAULT 0,
  amount_ars              NUMERIC(12,2),
  currency                TEXT          NOT NULL DEFAULT 'USD',

  -- Metadata
  cancelled_at            TIMESTAMPTZ,
  cancel_reason           TEXT,
  next_billing_date       TIMESTAMPTZ,

  created_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at              TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  UNIQUE(restaurant_id, status) WHERE status = 'active'
);

CREATE INDEX idx_subscriptions_restaurant ON public.subscriptions(restaurant_id);
CREATE INDEX idx_subscriptions_status ON public.subscriptions(status);
CREATE INDEX idx_subscriptions_mp_id ON public.subscriptions(mp_subscription_id);

-- ---------------------------------------------------------------------------
-- SUBSCRIPTION PAYMENTS
-- Histórico de pagos de cada suscripción
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.subscription_payments (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id     UUID          NOT NULL REFERENCES public.subscriptions(id) ON DELETE CASCADE,
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- MercadoPago
  mp_payment_id       TEXT          UNIQUE,
  mp_collection_id    TEXT,

  -- Pago
  amount              NUMERIC(12,2) NOT NULL,
  currency            TEXT          NOT NULL DEFAULT 'ARS',
  status              TEXT          NOT NULL, -- approved | rejected | pending | refunded
  status_detail       TEXT,

  -- Período cubierto por este pago
  period_start        TIMESTAMPTZ,
  period_end          TIMESTAMPTZ,

  -- Metadata
  payment_method      TEXT,
  payment_type        TEXT,
  payer_email         TEXT,

  paid_at             TIMESTAMPTZ,
  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  CONSTRAINT valid_payment_status CHECK (status IN ('approved', 'rejected', 'pending', 'refunded', 'cancelled'))
);

CREATE INDEX idx_payments_subscription ON public.subscription_payments(subscription_id);
CREATE INDEX idx_payments_restaurant ON public.subscription_payments(restaurant_id);
CREATE INDEX idx_payments_mp_id ON public.subscription_payments(mp_payment_id);
CREATE INDEX idx_payments_status ON public.subscription_payments(status);

-- ---------------------------------------------------------------------------
-- Agregar columnas a restaurants para trackear estado de suscripción
-- ---------------------------------------------------------------------------
ALTER TABLE public.restaurants
  ADD COLUMN IF NOT EXISTS subscription_status TEXT NOT NULL DEFAULT 'free',
  ADD COLUMN IF NOT EXISTS subscription_tier TEXT NOT NULL DEFAULT 'free',
  ADD COLUMN IF NOT EXISTS trial_ends_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS subscription_expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS can_take_orders BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS tano_messages_used INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS tano_messages_limit INTEGER NOT NULL DEFAULT 75,
  ADD COLUMN IF NOT EXISTS tano_reset_at TIMESTAMPTZ NOT NULL DEFAULT DATE_TRUNC('month', NOW() + INTERVAL '1 month');

-- ---------------------------------------------------------------------------
-- TRIGGER — updated_at automático para subscriptions
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_subscriptions_updated_at
  BEFORE UPDATE ON public.subscriptions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- FUNCIÓN — Resetear contador de mensajes de Tano cada mes
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.reset_tano_messages()
RETURNS void AS $$
BEGIN
  UPDATE public.restaurants
  SET
    tano_messages_used = 0,
    tano_reset_at = DATE_TRUNC('month', NOW() + INTERVAL '1 month')
  WHERE tano_reset_at <= NOW();
END;
$$ LANGUAGE plpgsql;

-- Comentario: Esta función debe ser llamada por un cron job diario
-- Ejemplo: SELECT cron.schedule('reset-tano-messages', '0 1 * * *', 'SELECT public.reset_tano_messages()');
