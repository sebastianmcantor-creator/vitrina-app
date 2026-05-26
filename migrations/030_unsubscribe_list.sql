-- =============================================================================
-- UNSUBSCRIBE_LIST — lista de bajas voluntarias para campañas frías
-- =============================================================================
-- Cualquier email en esta tabla NUNCA debe recibir más mails de prospección.
-- El endpoint /api/sales/unsubscribe la alimenta.
-- El endpoint /api/sales/send-prospect-mail la consulta antes de enviar.
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.unsubscribe_list (
  email             TEXT          PRIMARY KEY,
  unsubscribed_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  reason            TEXT,
  source            TEXT,         -- 'manual', 'link', 'bounce', 'complaint', 'reply_stop'
  ip                TEXT
);

CREATE INDEX IF NOT EXISTS idx_unsubscribe_list_unsubscribed_at
  ON public.unsubscribe_list(unsubscribed_at DESC);
