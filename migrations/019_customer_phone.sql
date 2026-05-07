-- Migración 019: Teléfono del cliente para notificaciones WhatsApp
-- Fecha: 2026-05-07
-- Descripción: Agregar customer_phone a orders para notificar cuando el pedido está listo

-- Agregar columna customer_phone a orders
ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_phone TEXT;

-- Índice para búsquedas por teléfono
CREATE INDEX IF NOT EXISTS idx_orders_customer_phone ON orders(customer_phone);

-- Comentario
COMMENT ON COLUMN orders.customer_phone IS 'Teléfono del cliente para notificaciones WhatsApp (formato: +549XXXXXXXXXX)';
