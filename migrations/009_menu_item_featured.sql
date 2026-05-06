-- Migration 009: Featured flag on menu items
-- Run in Supabase SQL Editor

ALTER TABLE menu_items
  ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT false;

COMMENT ON COLUMN menu_items.is_featured IS 'true = plato destacado, aparece en sección especial al tope del menú';
