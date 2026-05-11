-- Migration 020: Tabla de campañas promocionales
CREATE TABLE IF NOT EXISTS campanas (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id         UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  nombre                TEXT NOT NULL,
  mensaje               TEXT NOT NULL,
  segmento              TEXT DEFAULT 'todos',
  total_destinatarios   INTEGER DEFAULT 0,
  enviados              INTEGER DEFAULT 0,
  errores               INTEGER DEFAULT 0,
  status                TEXT DEFAULT 'draft' CHECK (status IN ('draft','sending','sent','failed')),
  created_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_campanas_restaurant ON campanas(restaurant_id);
