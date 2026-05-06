-- =============================================================================
-- INTEGRATIONS — OAuth tokens y datos de integraciones externas
-- =============================================================================

-- ---------------------------------------------------------------------------
-- INTEGRATIONS
-- Tokens OAuth y configuración de integraciones externas por restaurante
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.integrations (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  provider            TEXT          NOT NULL, -- google_business | instagram | facebook | metricool

  -- OAuth tokens
  access_token        TEXT,
  refresh_token       TEXT,
  token_expires_at    TIMESTAMPTZ,

  -- Provider-specific IDs
  provider_user_id    TEXT,
  provider_account_id TEXT,
  account_name        TEXT,

  -- Status
  is_active           BOOLEAN       NOT NULL DEFAULT TRUE,
  last_sync_at        TIMESTAMPTZ,
  last_error          TEXT,

  -- Metadata
  metadata            JSONB,

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  UNIQUE(restaurant_id, provider)
);

CREATE INDEX idx_integrations_restaurant ON public.integrations(restaurant_id);
CREATE INDEX idx_integrations_provider ON public.integrations(provider);
CREATE INDEX idx_integrations_active ON public.integrations(is_active);

-- ---------------------------------------------------------------------------
-- ANALYTICS_CACHE
-- Cache de datos de analytics para evitar rate limits de APIs externas
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.analytics_cache (
  id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id     UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  provider          TEXT          NOT NULL, -- google_business | instagram | internal
  metric_type       TEXT          NOT NULL, -- views | searches | followers | engagement | reviews

  -- Período de tiempo
  period_start      TIMESTAMPTZ   NOT NULL,
  period_end        TIMESTAMPTZ   NOT NULL,

  -- Datos
  data              JSONB         NOT NULL,

  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  expires_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW() + INTERVAL '1 hour'
);

CREATE INDEX idx_analytics_cache_restaurant ON public.analytics_cache(restaurant_id);
CREATE INDEX idx_analytics_cache_provider ON public.analytics_cache(provider);
CREATE INDEX idx_analytics_cache_expires ON public.analytics_cache(expires_at);

-- Eliminar cache expirado automáticamente
CREATE OR REPLACE FUNCTION public.cleanup_expired_analytics_cache()
RETURNS void AS $$
BEGIN
  DELETE FROM public.analytics_cache WHERE expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- ---------------------------------------------------------------------------
-- COMPETITORS
-- Competidores identificados para comparación
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.competitors (
  id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id     UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Datos del competidor
  name              TEXT          NOT NULL,
  address           TEXT,
  place_id          TEXT,         -- Google Places ID

  -- Tipo
  source            TEXT          NOT NULL DEFAULT 'auto', -- auto | manual

  -- Métricas snapshot
  rating            NUMERIC(2,1),
  reviews_count     INTEGER,

  -- Metadata
  metadata          JSONB,

  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  last_checked_at   TIMESTAMPTZ
);

CREATE INDEX idx_competitors_restaurant ON public.competitors(restaurant_id);
CREATE INDEX idx_competitors_source ON public.competitors(source);

-- ---------------------------------------------------------------------------
-- TRIGGER — updated_at automático
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_integrations_updated_at
  BEFORE UPDATE ON public.integrations
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_competitors_updated_at
  BEFORE UPDATE ON public.competitors
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
