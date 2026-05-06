-- =============================================================================
-- EXECUTIVE REPORTS — Informes ejecutivos mensuales y medición de éxito
-- =============================================================================

-- ---------------------------------------------------------------------------
-- MARKETING_PROJECTIONS
-- Proyecciones del plan de marketing (optimista, moderado, pesimista)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.marketing_projections (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Período
  period_month        TEXT          NOT NULL, -- YYYY-MM
  period_start        DATE          NOT NULL,
  period_end          DATE          NOT NULL,

  -- Proyecciones (3 escenarios)
  projections         JSONB         NOT NULL, -- {optimistic: {...}, moderate: {...}, pessimistic: {...}}

  -- Cada escenario contiene:
  -- {
  --   instagram_followers: { start: N, end: N, growth: N },
  --   facebook_followers: { start: N, end: N, growth: N },
  --   google_reviews: { start: N, end: N, growth: N },
  --   google_rating: { start: N, end: N },
  --   engagement_rate: N,
  --   reach: N,
  --   estimated_orders: N
  -- }

  -- Estrategia del mes
  strategy_summary    TEXT,
  key_actions         TEXT[],       -- ["acción 1", "acción 2", ...]
  target_audience     TEXT,
  content_pillars     TEXT[],       -- ["pilar 1", "pilar 2", ...]

  -- Metadata
  created_by          UUID          REFERENCES public.profiles(id),

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_marketing_projections_restaurant ON public.marketing_projections(restaurant_id);
CREATE INDEX idx_marketing_projections_period ON public.marketing_projections(period_month);
CREATE INDEX idx_marketing_projections_restaurant_period ON public.marketing_projections(restaurant_id, period_month);

-- ---------------------------------------------------------------------------
-- EXECUTIVE_REPORTS
-- Informes ejecutivos generados mensualmente
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.executive_reports (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  projection_id       UUID          REFERENCES public.marketing_projections(id) ON DELETE SET NULL,

  -- Período
  period_month        TEXT          NOT NULL, -- YYYY-MM
  report_date         DATE          NOT NULL,

  -- Resultados reales
  actual_results      JSONB         NOT NULL,
  -- {
  --   instagram_followers: { start: N, end: N, growth: N },
  --   facebook_followers: { start: N, end: N, growth: N },
  --   google_reviews: { start: N, end: N, growth: N },
  --   google_rating: { start: N, end: N },
  --   engagement_rate: N,
  --   reach: N,
  --   orders_count: N,
  --   revenue: N
  -- }

  -- Comparación con proyecciones
  performance_vs_projection JSONB, -- {metric: "achieved" | "exceeded" | "below", ...}
  achieved_scenario     TEXT,         -- "optimistic" | "moderate" | "pessimistic" | "below_pessimistic"

  -- Análisis generado por Viti
  viti_analysis       TEXT,          -- Análisis completo en texto
  success_factors     TEXT[],        -- Qué funcionó bien
  improvement_areas   TEXT[],        -- Qué puede mejorar
  recommendations     TEXT[],        -- Recomendaciones para el próximo mes

  -- PDF
  pdf_url             TEXT,          -- URL del PDF generado (si se guarda en storage)
  pdf_generated_at    TIMESTAMPTZ,

  -- Envío
  sent_at             TIMESTAMPTZ,
  sent_to             TEXT[],        -- Emails a los que se envió

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_executive_reports_restaurant ON public.executive_reports(restaurant_id);
CREATE INDEX idx_executive_reports_period ON public.executive_reports(period_month);
CREATE INDEX idx_executive_reports_sent ON public.executive_reports(sent_at);
CREATE INDEX idx_executive_reports_restaurant_period ON public.executive_reports(restaurant_id, period_month);

-- ---------------------------------------------------------------------------
-- MONTHLY_METRICS_SNAPSHOTS
-- Snapshots de métricas al inicio y fin de cada mes para comparación
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.monthly_metrics_snapshots (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Período y momento
  period_month        TEXT          NOT NULL,
  snapshot_type       TEXT          NOT NULL, -- start | end
  snapshot_date       DATE          NOT NULL,

  -- Métricas capturadas
  instagram_followers INTEGER,
  instagram_posts     INTEGER,
  facebook_followers  INTEGER,
  facebook_posts      INTEGER,
  google_rating       NUMERIC(2,1),
  google_reviews      INTEGER,
  tano_messages       INTEGER,
  orders_count        INTEGER,
  revenue             NUMERIC(12,2),

  -- Metadata
  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_monthly_snapshots_restaurant ON public.monthly_metrics_snapshots(restaurant_id);
CREATE INDEX idx_monthly_snapshots_period ON public.monthly_metrics_snapshots(period_month, snapshot_type);
CREATE UNIQUE INDEX idx_monthly_snapshots_unique ON public.monthly_metrics_snapshots(restaurant_id, period_month, snapshot_type);

-- ---------------------------------------------------------------------------
-- TRIGGERS — updated_at automático
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_marketing_projections_updated_at
  BEFORE UPDATE ON public.marketing_projections
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_executive_reports_updated_at
  BEFORE UPDATE ON public.executive_reports
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
