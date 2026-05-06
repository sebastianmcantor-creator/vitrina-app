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
