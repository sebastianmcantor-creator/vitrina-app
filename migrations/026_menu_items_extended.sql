-- Campos extendidos para análisis de Viti y comercios
ALTER TABLE public.menu_items
  ADD COLUMN IF NOT EXISTS cost_price NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS preparation_time INTEGER,
  ADD COLUMN IF NOT EXISTS calories INTEGER,
  ADD COLUMN IF NOT EXISTS notes_for_kitchen TEXT,
  ADD COLUMN IF NOT EXISTS stock_quantity INTEGER,
  ADD COLUMN IF NOT EXISTS sku TEXT,
  ADD COLUMN IF NOT EXISTS barcode TEXT,
  ADD COLUMN IF NOT EXISTS brand TEXT,
  ADD COLUMN IF NOT EXISTS ml_listing_url TEXT,
  ADD COLUMN IF NOT EXISTS tn_product_id TEXT;

-- Índice para búsqueda por SKU
CREATE INDEX IF NOT EXISTS menu_items_sku_idx ON public.menu_items(sku);
