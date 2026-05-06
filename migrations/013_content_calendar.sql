-- =============================================================================
-- CONTENT CALENDAR — Calendario de contenido y publicaciones automáticas
-- =============================================================================

-- ---------------------------------------------------------------------------
-- SCHEDULED_POSTS
-- Posts programados para publicación en redes sociales vía Metricool
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.scheduled_posts (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id       UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Contenido del post
  caption             TEXT          NOT NULL,
  media_urls          TEXT[],       -- URLs de imágenes/videos subidas
  media_type          TEXT,         -- image | video | carousel

  -- Programación
  scheduled_for       TIMESTAMPTZ   NOT NULL,
  timezone            TEXT          NOT NULL DEFAULT 'America/Argentina/Buenos_Aires',

  -- Redes sociales destino
  publish_instagram   BOOLEAN       NOT NULL DEFAULT TRUE,
  publish_facebook    BOOLEAN       NOT NULL DEFAULT TRUE,
  publish_google      BOOLEAN       NOT NULL DEFAULT FALSE,
  publish_tiktok      BOOLEAN       NOT NULL DEFAULT FALSE,

  -- Estado
  status              TEXT          NOT NULL DEFAULT 'scheduled', -- scheduled | publishing | published | failed | cancelled
  published_at        TIMESTAMPTZ,
  error_message       TEXT,

  -- IDs externos (de Metricool o redes)
  metricool_post_id   TEXT,
  instagram_post_id   TEXT,
  facebook_post_id    TEXT,

  -- Metadata
  metadata            JSONB,

  created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  created_by          UUID          REFERENCES public.profiles(id)
);

CREATE INDEX idx_scheduled_posts_restaurant ON public.scheduled_posts(restaurant_id);
CREATE INDEX idx_scheduled_posts_status ON public.scheduled_posts(status);
CREATE INDEX idx_scheduled_posts_scheduled_for ON public.scheduled_posts(scheduled_for);
CREATE INDEX idx_scheduled_posts_restaurant_status ON public.scheduled_posts(restaurant_id, status);

-- ---------------------------------------------------------------------------
-- CONTENT_TEMPLATES
-- Templates de contenido sugeridos por Viti o guardados por el usuario
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.content_templates (
  id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id     UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Template
  name              TEXT          NOT NULL,
  caption_template  TEXT          NOT NULL,
  category          TEXT,         -- promocion | menu_del_dia | evento | tips | historia
  suggested_by_ai   BOOLEAN       NOT NULL DEFAULT FALSE,

  -- Uso
  times_used        INTEGER       NOT NULL DEFAULT 0,
  last_used_at      TIMESTAMPTZ,

  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  created_by        UUID          REFERENCES public.profiles(id)
);

CREATE INDEX idx_content_templates_restaurant ON public.content_templates(restaurant_id);
CREATE INDEX idx_content_templates_category ON public.content_templates(category);

-- ---------------------------------------------------------------------------
-- CONTENT_CALENDAR_SUGGESTIONS
-- Sugerencias de contenido generadas por Viti para el calendario
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.content_calendar_suggestions (
  id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id     UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Sugerencia
  suggested_date    DATE          NOT NULL,
  topic             TEXT          NOT NULL,
  caption           TEXT          NOT NULL,
  reasoning         TEXT,         -- Por qué Viti sugiere esto
  category          TEXT,

  -- Estado
  status            TEXT          NOT NULL DEFAULT 'pending', -- pending | accepted | rejected | scheduled
  scheduled_post_id UUID          REFERENCES public.scheduled_posts(id) ON DELETE SET NULL,

  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_content_suggestions_restaurant ON public.content_calendar_suggestions(restaurant_id);
CREATE INDEX idx_content_suggestions_status ON public.content_calendar_suggestions(status);
CREATE INDEX idx_content_suggestions_date ON public.content_calendar_suggestions(suggested_date);

-- ---------------------------------------------------------------------------
-- TRIGGER — updated_at automático
-- ---------------------------------------------------------------------------
CREATE TRIGGER trg_scheduled_posts_updated_at
  BEFORE UPDATE ON public.scheduled_posts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
