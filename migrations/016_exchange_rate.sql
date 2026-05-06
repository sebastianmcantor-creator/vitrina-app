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
