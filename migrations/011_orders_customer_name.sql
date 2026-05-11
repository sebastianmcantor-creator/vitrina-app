-- Migration 011: customer_name on orders
-- Run in Supabase SQL Editor

ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS customer_name TEXT;

COMMENT ON COLUMN orders.customer_name IS 'Nombre del cliente que realizó el pedido (opcional, capturado en checkout)';
