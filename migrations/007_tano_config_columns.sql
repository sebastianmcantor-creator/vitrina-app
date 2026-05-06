-- Migration 007: Tano configuration columns on restaurants
-- Run in Supabase SQL Editor

ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS tano_tone       TEXT DEFAULT 'calido',
  ADD COLUMN IF NOT EXISTS tano_limit_message TEXT,
  ADD COLUMN IF NOT EXISTS tano_welcome    TEXT;

COMMENT ON COLUMN restaurants.tano_tone IS 'Tono de Tano: calido | neutro | sofisticado';
COMMENT ON COLUMN restaurants.tano_limit_message IS 'Mensaje personalizado cuando Tano llega al límite de mensajes del mes';
COMMENT ON COLUMN restaurants.tano_welcome IS 'Mensaje de bienvenida personalizado de Tano (opcional, sobreescribe el default)';
