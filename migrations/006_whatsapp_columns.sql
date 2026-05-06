-- Migration 006: WhatsApp notification columns on restaurants
-- Run in Supabase SQL Editor

ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS whatsapp_operativo TEXT,
  ADD COLUMN IF NOT EXISTS whatsapp_gestion TEXT;

COMMENT ON COLUMN restaurants.whatsapp_operativo IS 'Número WhatsApp (sin +) para alertas de pedidos al operativo del local';
COMMENT ON COLUMN restaurants.whatsapp_gestion IS 'Número WhatsApp (sin +) para alertas de gestión al dueño (límite Tano, vencimientos, etc.)';
