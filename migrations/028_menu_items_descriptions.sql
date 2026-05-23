-- Migración 028 — Descripciones duales + dimensiones + atributos ML
-- Para venta multicanal (QR, WhatsApp, MercadoLibre, Tienda Nube)

ALTER TABLE public.menu_items
  ADD COLUMN IF NOT EXISTS short_description TEXT,                   -- max 150 chars, para QR y WA
  ADD COLUMN IF NOT EXISTS full_description TEXT,                    -- texto largo para ML y TN
  ADD COLUMN IF NOT EXISTS weight_grams INTEGER,                     -- para cálculo de envío
  ADD COLUMN IF NOT EXISTS width_cm NUMERIC(6,2),
  ADD COLUMN IF NOT EXISTS height_cm NUMERIC(6,2),
  ADD COLUMN IF NOT EXISTS length_cm NUMERIC(6,2),
  ADD COLUMN IF NOT EXISTS ml_attributes JSONB DEFAULT '{}'::jsonb,  -- {marca, modelo, color, talle, material, ...}
  ADD COLUMN IF NOT EXISTS min_stock_alert INTEGER DEFAULT 5;        -- alerta de stock bajo

-- Constraint: short_description no puede pasar 150 caracteres
ALTER TABLE public.menu_items
  DROP CONSTRAINT IF EXISTS menu_items_short_desc_length;
ALTER TABLE public.menu_items
  ADD CONSTRAINT menu_items_short_desc_length
  CHECK (short_description IS NULL OR char_length(short_description) <= 150);

-- Índice de búsqueda full-text en español sobre la descripción completa
CREATE INDEX IF NOT EXISTS menu_items_full_desc_idx
  ON public.menu_items USING gin(to_tsvector('spanish', coalesce(full_description, '')));
