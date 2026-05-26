-- =============================================================================
-- SALES — campos faltantes para email tracking + CRM
-- =============================================================================
-- Agrega:
--   * sales_prospects.email           — destino para campañas por mail
--   * sales_prospects.business_type   — restaurant | services | local | ecommerce
--   * sales_prospects.report_url      — URL del informe HTML publicado
--   * sales_prospects.last_open_at    — última apertura del último mail
--   * sales_prospects.last_click_at   — último click trackeado
--   * sales_prospects.opens_count, clicks_count
--   * sales_prospects.followup_step   — 0/1/2/3 cuántos seguimientos automáticos van
--   * sales_prospects.next_followup_at
--
--   * sales_contacts.subject, opens_count, clicks_count, opened_at, clicked_at
--   * sales_contacts.report_url
--
--   * sales_agent_config.daily_volume, daily_volume_current_week (rampa)
--   * sales_agent_config.email_template_subject, email_template_body
--   * sales_agent_config.contact_hours_*_local (locales) y *_resto (otros rubros)
-- =============================================================================

ALTER TABLE public.sales_prospects
  ADD COLUMN IF NOT EXISTS email             TEXT,
  ADD COLUMN IF NOT EXISTS business_type     TEXT DEFAULT 'restaurant',
  ADD COLUMN IF NOT EXISTS instagram_url     TEXT,
  ADD COLUMN IF NOT EXISTS report_url        TEXT,
  ADD COLUMN IF NOT EXISTS last_open_at      TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS last_click_at     TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS opens_count       INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS clicks_count      INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS followup_step     INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS next_followup_at  TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS replied_at        TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_sales_prospects_email ON public.sales_prospects(email);
CREATE INDEX IF NOT EXISTS idx_sales_prospects_business_type ON public.sales_prospects(business_type);
CREATE INDEX IF NOT EXISTS idx_sales_prospects_next_followup ON public.sales_prospects(next_followup_at)
  WHERE next_followup_at IS NOT NULL;

ALTER TABLE public.sales_contacts
  ADD COLUMN IF NOT EXISTS subject           TEXT,
  ADD COLUMN IF NOT EXISTS opens_count       INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS clicks_count      INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS opened_at         TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS clicked_at        TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS report_url        TEXT,
  ADD COLUMN IF NOT EXISTS bounced_at        TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS complained_at     TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_sales_contacts_opened_at ON public.sales_contacts(opened_at)
  WHERE opened_at IS NOT NULL;

ALTER TABLE public.sales_agent_config
  ADD COLUMN IF NOT EXISTS daily_volume                INTEGER NOT NULL DEFAULT 50,
  ADD COLUMN IF NOT EXISTS daily_volume_ramp_week      INTEGER NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS email_template_subject      TEXT,
  ADD COLUMN IF NOT EXISTS email_template_body         TEXT,
  ADD COLUMN IF NOT EXISTS contact_hours_local_start   TIME DEFAULT '10:00',
  ADD COLUMN IF NOT EXISTS contact_hours_local_end     TIME DEFAULT '17:00',
  ADD COLUMN IF NOT EXISTS contact_hours_resto_start   TIME DEFAULT '12:00',
  ADD COLUMN IF NOT EXISTS contact_hours_resto_end     TIME DEFAULT '22:00';

-- Template default para mail (se puede sobrescribir desde el panel)
UPDATE public.sales_agent_config
SET
  email_template_subject = COALESCE(email_template_subject,
    '{{nombre_negocio}} — análisis de tu presencia digital'),
  email_template_body = COALESCE(email_template_body,
    'Hola {{nombre_negocio}},

Hicimos un análisis de tu presencia digital y la de 3 competidores cercanos en {{ciudad}}.
Te dejo el informe completo acá: {{informe_link}}

3 cosas que detectamos:
{{puntos}}

Si querés ver cómo Vitrina te puede ayudar a implementar esto, podés probar 14 días gratis:
https://vitrinaapp.com.ar

O agendar una demo de 15 min: https://vitrinaapp.com.ar/agendar

Sebastián de Vitrina
vitrinaapp.com.ar')
WHERE TRUE;
