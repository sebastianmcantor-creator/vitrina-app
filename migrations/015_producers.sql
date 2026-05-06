-- =============================================================================
-- PRODUCERS — Sistema de productores/revendedores
-- =============================================================================

-- ---------------------------------------------------------------------------
-- PRODUCERS
-- Productores que traen clientes a Vitrina
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.producers (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Datos del productor
  name                TEXT          NOT NULL,
  email               TEXT          NOT NULL UNIQUE,
  phone               TEXT,

  -- Comisiones
  commission_first    NUMERIC(5,2)  NOT NULL DEFAULT 20.00,  -- % primer mes
  commission_recurring NUMERIC(5,2) NOT NULL DEFAULT 10.00,  -- % recurrente
  is_top_producer     BOOLEAN       NOT NULL DEFAULT FALSE,  -- +10 clientes activos

  -- Metadata
  notes               TEXT,
  active              BOOLEAN       NOT NULL DEFAULT TRUE,

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_producers_email ON public.producers(email);
CREATE INDEX idx_producers_active ON public.producers(active);

-- ---------------------------------------------------------------------------
-- PRODUCER_COMMISSIONS
-- Historial de comisiones generadas y pagadas
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.producer_commissions (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  producer_id         UUID          NOT NULL REFERENCES public.producers(id) ON DELETE CASCADE,
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Período
  period_month        TEXT          NOT NULL, -- YYYY-MM

  -- Tipo
  commission_type     TEXT          NOT NULL, -- first | recurring

  -- Montos
  base_amount         NUMERIC(10,2) NOT NULL, -- Monto base sobre el que se calcula
  commission_rate     NUMERIC(5,2)  NOT NULL, -- % de comisión aplicado
  commission_amount   NUMERIC(10,2) NOT NULL, -- Monto de comisión

  -- Estado
  status              TEXT          NOT NULL DEFAULT 'pending', -- pending | paid | cancelled
  paid_at             TIMESTAMPTZ,
  payment_method      TEXT,         -- transferencia | efectivo | mercadopago
  payment_reference   TEXT,         -- Comprobante, referencia, etc.

  -- Metadata
  notes               TEXT,

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_producer_commissions_producer ON public.producer_commissions(producer_id);
CREATE INDEX idx_producer_commissions_restaurant ON public.producer_commissions(restaurant_id);
CREATE INDEX idx_producer_commissions_period ON public.producer_commissions(period_month);
CREATE INDEX idx_producer_commissions_status ON public.producer_commissions(status);
CREATE INDEX idx_producer_commissions_producer_period ON public.producer_commissions(producer_id, period_month);

-- ---------------------------------------------------------------------------
-- Agregar columna producer_id a restaurants
-- ---------------------------------------------------------------------------
ALTER TABLE public.restaurants
ADD COLUMN IF NOT EXISTS producer_id UUID REFERENCES public.producers(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_restaurants_producer ON public.restaurants(producer_id);

-- ---------------------------------------------------------------------------
-- MASTER_DASHBOARD_CACHE
-- Cache de métricas para el panel maestro (recalculado cada hora)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.master_dashboard_cache (
  id                    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  cache_key             TEXT          NOT NULL UNIQUE, -- 'global' | 'monthly_YYYY-MM'

  -- Clientes
  total_clients         INTEGER       DEFAULT 0,
  active_clients        INTEGER       DEFAULT 0,
  new_this_month        INTEGER       DEFAULT 0,
  churned_this_month    INTEGER       DEFAULT 0,
  clients_by_plan       JSONB,        -- {free: N, basic: N, pro: N, full: N}
  churn_alerts          JSONB,        -- [{restaurant_id, name, days_inactive}]

  -- Facturación
  total_revenue         NUMERIC(12,2) DEFAULT 0,
  subscription_revenue  NUMERIC(12,2) DEFAULT 0,
  transaction_fees      NUMERIC(12,2) DEFAULT 0,
  ad_fees               NUMERIC(12,2) DEFAULT 0,
  previous_month_revenue NUMERIC(12,2) DEFAULT 0,
  projected_revenue     NUMERIC(12,2) DEFAULT 0,

  -- Agentes (Tano, Viti, Sales)
  tano_messages_count   INTEGER       DEFAULT 0,
  tano_cost_usd         NUMERIC(10,2) DEFAULT 0,
  viti_messages_count   INTEGER       DEFAULT 0,
  viti_cost_usd         NUMERIC(10,2) DEFAULT 0,
  sales_prospects       INTEGER       DEFAULT 0,
  sales_cost_usd        NUMERIC(10,2) DEFAULT 0,

  -- Costos
  cloudflare_cost       NUMERIC(10,2) DEFAULT 10,
  anthropic_cost        NUMERIC(10,2) DEFAULT 0,
  replicate_cost        NUMERIC(10,2) DEFAULT 0,
  twilio_cost           NUMERIC(10,2) DEFAULT 0,
  google_workspace      NUMERIC(10,2) DEFAULT 6,
  domain_cost           NUMERIC(10,2) DEFAULT 1.25,
  total_fixed_costs     NUMERIC(10,2) DEFAULT 0,
  total_variable_costs  NUMERIC(10,2) DEFAULT 0,
  gross_margin          NUMERIC(10,2) DEFAULT 0,

  -- Productores
  total_producers       INTEGER       DEFAULT 0,
  total_commissions_pending NUMERIC(12,2) DEFAULT 0,
  total_commissions_paid NUMERIC(12,2) DEFAULT 0,

  cached_at             TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  created_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_master_cache_key ON public.master_dashboard_cache(cache_key);
CREATE INDEX idx_master_cache_cached_at ON public.master_dashboard_cache(cached_at DESC);

-- ---------------------------------------------------------------------------
-- TRIGGERS — updated_at automático
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_producers_updated_at
  BEFORE UPDATE ON public.producers
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_producer_commissions_updated_at
  BEFORE UPDATE ON public.producer_commissions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_master_dashboard_cache_updated_at
  BEFORE UPDATE ON public.master_dashboard_cache
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Actualizar comisiones de productores top automáticamente
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_top_producer_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Contar clientes activos del productor
  WITH producer_stats AS (
    SELECT
      p.id,
      COUNT(r.id) FILTER (WHERE r.subscription_status = 'active') as active_clients
    FROM producers p
    LEFT JOIN restaurants r ON r.producer_id = p.id
    WHERE p.id = NEW.producer_id
    GROUP BY p.id
  )
  UPDATE producers
  SET
    is_top_producer = (producer_stats.active_clients >= 10),
    commission_first = CASE
      WHEN producer_stats.active_clients >= 10 THEN 25.00
      ELSE 20.00
    END,
    commission_recurring = CASE
      WHEN producer_stats.active_clients >= 10 THEN 15.00
      ELSE 10.00
    END
  FROM producer_stats
  WHERE producers.id = producer_stats.id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar cuando cambia un restaurante
CREATE TRIGGER trg_update_top_producer_on_restaurant_change
  AFTER INSERT OR UPDATE OF producer_id, subscription_status ON public.restaurants
  FOR EACH ROW
  WHEN (NEW.producer_id IS NOT NULL)
  EXECUTE FUNCTION update_top_producer_status();
