-- =============================================================================
-- SALES AGENT — Prospección automática de restaurantes
-- =============================================================================

-- ---------------------------------------------------------------------------
-- SALES_PROSPECTS
-- Restaurantes encontrados por el agente de ventas
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.sales_prospects (
  id                    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Datos del restaurante (de Google Places)
  place_id              TEXT          NOT NULL UNIQUE,
  name                  TEXT          NOT NULL,
  address               TEXT,
  phone                 TEXT,
  website               TEXT,
  google_rating         NUMERIC(2,1),
  google_reviews_count  INTEGER,
  price_level           INTEGER,      -- 1-4 según Google
  types                 TEXT[],       -- ['restaurant', 'food', etc.]

  -- Análisis preliminar
  diagnosis             JSONB,        -- {has_website, has_instagram, has_facebook, online_presence_score, pain_points[]}
  fit_score             INTEGER,      -- 0-100, qué tan buen cliente sería

  -- Estado del prospecto
  status                TEXT          NOT NULL DEFAULT 'discovered', -- discovered | contacted | interested | not_interested | converted | invalid

  -- Ubicación
  lat                   NUMERIC(10,7),
  lng                   NUMERIC(10,7),
  city                  TEXT,
  province              TEXT,
  country               TEXT          DEFAULT 'Argentina',

  -- Metadata
  discovered_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  last_contact_at       TIMESTAMPTZ,
  converted_at          TIMESTAMPTZ,
  notes                 TEXT,

  created_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sales_prospects_place_id ON public.sales_prospects(place_id);
CREATE INDEX idx_sales_prospects_status ON public.sales_prospects(status);
CREATE INDEX idx_sales_prospects_fit_score ON public.sales_prospects(fit_score DESC);
CREATE INDEX idx_sales_prospects_location ON public.sales_prospects(city, province);
CREATE INDEX idx_sales_prospects_discovered_at ON public.sales_prospects(discovered_at DESC);

-- ---------------------------------------------------------------------------
-- SALES_CONTACTS
-- Historial de intentos de contacto con prospectos
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.sales_contacts (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  prospect_id         UUID          NOT NULL REFERENCES public.sales_prospects(id) ON DELETE CASCADE,

  -- Tipo de contacto
  contact_type        TEXT          NOT NULL, -- whatsapp | email | phone | followup

  -- Contenido
  message             TEXT          NOT NULL,
  template_used       TEXT,         -- nombre del template si se usó uno

  -- Estado
  status              TEXT          NOT NULL DEFAULT 'pending', -- pending | sent | delivered | failed | replied

  -- Respuesta del prospecto (si la hay)
  response            TEXT,
  response_at         TIMESTAMPTZ,
  interested          BOOLEAN,      -- true si mostró interés, false si dijo que no, null si no respondió

  -- Seguimiento
  followup_scheduled  TIMESTAMPTZ,
  followup_sent       BOOLEAN       DEFAULT FALSE,

  -- Metadata
  error_message       TEXT,
  external_id         TEXT,         -- ID de Twilio, SendGrid, etc.

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sales_contacts_prospect ON public.sales_contacts(prospect_id);
CREATE INDEX idx_sales_contacts_status ON public.sales_contacts(status);
CREATE INDEX idx_sales_contacts_followup ON public.sales_contacts(followup_scheduled) WHERE followup_sent = FALSE;
CREATE INDEX idx_sales_contacts_interested ON public.sales_contacts(interested) WHERE interested = TRUE;

-- ---------------------------------------------------------------------------
-- SALES_AGENT_CONFIG
-- Configuración del agente de ventas
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.sales_agent_config (
  id                    UUID          PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Control general
  is_active             BOOLEAN       NOT NULL DEFAULT FALSE,
  max_daily_contacts    INTEGER       NOT NULL DEFAULT 10,

  -- Áreas de búsqueda
  search_locations      JSONB         NOT NULL DEFAULT '[]', -- [{city, province, radius_km}]

  -- Criterios de filtrado
  min_rating            NUMERIC(2,1)  DEFAULT 3.5,
  min_reviews           INTEGER       DEFAULT 10,
  excluded_types        TEXT[]        DEFAULT '{}', -- tipos de lugares a excluir

  -- Templates de mensajes
  whatsapp_template     TEXT          NOT NULL,
  followup_template     TEXT          NOT NULL,

  -- Horarios (no contactar fuera de este rango)
  contact_hours_start   TIME          DEFAULT '10:00',
  contact_hours_end     TIME          DEFAULT '20:00',

  -- Notificaciones a Sebastián
  notify_email          TEXT          NOT NULL,
  notify_whatsapp       TEXT,
  notify_on_interest    BOOLEAN       NOT NULL DEFAULT TRUE,

  created_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Solo debe haber una fila de configuración
CREATE UNIQUE INDEX idx_sales_agent_config_singleton ON public.sales_agent_config((TRUE));

-- Insertar configuración por defecto
INSERT INTO public.sales_agent_config (
  is_active,
  max_daily_contacts,
  search_locations,
  whatsapp_template,
  followup_template,
  notify_email
) VALUES (
  FALSE,
  10,
  '[{"city": "Buenos Aires", "province": "CABA", "radius_km": 5}]'::JSONB,
  'Hola! Soy de Vitrina, una plataforma que ayuda a restaurantes a digitalizar su menú y mejorar su presencia online. Vi que {nombre} tiene muy buena reputación en la zona. ¿Te interesaría conocer cómo podemos ayudarte a aumentar tus ventas digitales? Tenemos un plan gratuito para empezar.',
  'Hola de nuevo! Hace unos días te contacté sobre Vitrina. ¿Tuviste tiempo de revisar? Si querés, puedo mostrarte un demo rápido de 5 minutos. ¿Te viene bien?',
  'sebastianmcantor@gmail.com'
) ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------------
-- SALES_METRICS
-- Métricas del agente para tracking de performance
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.sales_metrics (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  date                DATE          NOT NULL UNIQUE,

  -- Prospección
  prospects_found     INTEGER       NOT NULL DEFAULT 0,
  prospects_contacted INTEGER       NOT NULL DEFAULT 0,

  -- Respuestas
  responses_received  INTEGER       NOT NULL DEFAULT 0,
  interested_count    INTEGER       NOT NULL DEFAULT 0,
  not_interested_count INTEGER      NOT NULL DEFAULT 0,

  -- Conversiones
  converted_count     INTEGER       NOT NULL DEFAULT 0,

  -- Costos (en USD)
  whatsapp_cost       NUMERIC(10,2) DEFAULT 0,
  api_cost            NUMERIC(10,2) DEFAULT 0,

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_sales_metrics_date ON public.sales_metrics(date DESC);

-- ---------------------------------------------------------------------------
-- TRIGGERS — updated_at automático
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_sales_prospects_updated_at
  BEFORE UPDATE ON public.sales_prospects
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_sales_contacts_updated_at
  BEFORE UPDATE ON public.sales_contacts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_sales_agent_config_updated_at
  BEFORE UPDATE ON public.sales_agent_config
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_sales_metrics_updated_at
  BEFORE UPDATE ON public.sales_metrics
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
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
-- =============================================================================
-- EXCHANGE RATE — Tipo de cambio USD/ARS con historial y notificaciones
-- =============================================================================

-- ---------------------------------------------------------------------------
-- EXCHANGE_RATES
-- Historial del tipo de cambio oficial Banco Nación (venta)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exchange_rates (
  id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Tipo de cambio
  usd_ars         NUMERIC(10,4) NOT NULL,
  source          TEXT          NOT NULL DEFAULT 'bluelytics', -- bluelytics | bcra | manual

  -- Variación respecto al anterior
  previous_rate   NUMERIC(10,4),
  variation_pct   NUMERIC(5,2),  -- Porcentaje de variación

  -- Estado de notificaciones
  notified        BOOLEAN       NOT NULL DEFAULT FALSE,
  notification_sent_at TIMESTAMPTZ,

  -- Metadata
  notes           TEXT,

  created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exchange_rates_created_at ON public.exchange_rates(created_at DESC);
CREATE INDEX idx_exchange_rates_notified ON public.exchange_rates(notified) WHERE notified = FALSE;

-- ---------------------------------------------------------------------------
-- EXCHANGE_RATE_NOTIFICATIONS
-- Log de notificaciones enviadas sobre cambios en el tipo de cambio
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.exchange_rate_notifications (
  id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  exchange_rate_id UUID         NOT NULL REFERENCES public.exchange_rates(id) ON DELETE CASCADE,

  -- Variación que disparó la notificación
  variation_pct   NUMERIC(5,2)  NOT NULL,
  notification_type TEXT        NOT NULL, -- warning_2pct | alert_5pct

  -- A quiénes se notificó
  restaurants_notified INTEGER   DEFAULT 0,
  emails_sent         INTEGER   DEFAULT 0,
  whatsapp_sent       INTEGER   DEFAULT 0,

  -- Contenido
  message         TEXT,

  created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_er_notifications_exchange_rate ON public.exchange_rate_notifications(exchange_rate_id);
CREATE INDEX idx_er_notifications_created_at ON public.exchange_rate_notifications(created_at DESC);

-- ---------------------------------------------------------------------------
-- Función para obtener el tipo de cambio más reciente
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_current_exchange_rate()
RETURNS NUMERIC(10,4) AS $$
BEGIN
  RETURN (
    SELECT usd_ars
    FROM public.exchange_rates
    ORDER BY created_at DESC
    LIMIT 1
  );
END;
$$ LANGUAGE plpgsql STABLE;

-- ---------------------------------------------------------------------------
-- Función para calcular variación porcentual
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION calculate_exchange_rate_variation(
  new_rate NUMERIC(10,4),
  old_rate NUMERIC(10,4)
)
RETURNS NUMERIC(5,2) AS $$
BEGIN
  IF old_rate IS NULL OR old_rate = 0 THEN
    RETURN 0;
  END IF;
  RETURN ROUND(((new_rate - old_rate) / old_rate * 100)::NUMERIC, 2);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ---------------------------------------------------------------------------
-- Insertar registro inicial si no existe ninguno
-- ---------------------------------------------------------------------------
INSERT INTO public.exchange_rates (usd_ars, source, notes)
SELECT 1410, 'manual', 'Tipo de cambio inicial de referencia (mayo 2026)'
WHERE NOT EXISTS (SELECT 1 FROM public.exchange_rates);
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
-- Migración 018: Lista de espera y leads de landing
-- Fecha: 2026-05-07
-- Descripción: Tablas para capturar interesados en Marketing y leads desde chat de landing

-- Tabla de lista de espera (Marketing y otros features próximos)
CREATE TABLE IF NOT EXISTS waitlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  restaurant_name TEXT,
  waitlist_type TEXT NOT NULL DEFAULT 'general', -- general | marketing | menu
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notified_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_waitlist_email ON waitlist(email);
CREATE INDEX IF NOT EXISTS idx_waitlist_type ON waitlist(waitlist_type);
CREATE INDEX IF NOT EXISTS idx_waitlist_created_at ON waitlist(created_at DESC);

-- Tabla de leads capturados desde landing
CREATE TABLE IF NOT EXISTS leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  query TEXT NOT NULL, -- Consulta del usuario que mostró interés
  context TEXT, -- Contexto de la conversación
  source TEXT NOT NULL DEFAULT 'landing_chat', -- landing_chat | contact_form | other
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  contacted_at TIMESTAMPTZ,
  status TEXT DEFAULT 'new' -- new | contacted | converted | lost
);

CREATE INDEX IF NOT EXISTS idx_leads_email ON leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_source ON leads(source);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at DESC);

-- Comentarios
COMMENT ON TABLE waitlist IS 'Lista de espera para features próximos (especialmente Marketing)';
COMMENT ON TABLE leads IS 'Leads capturados desde landing page (chat IA, forms, etc.)';
COMMENT ON COLUMN waitlist.waitlist_type IS 'Tipo de feature: general, marketing, menu';
COMMENT ON COLUMN leads.source IS 'Origen del lead: landing_chat, contact_form, etc.';
COMMENT ON COLUMN leads.status IS 'Estado: new, contacted, converted, lost';
