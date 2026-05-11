-- Migration 012: ML and TN specific fields on integrations
-- Run in Supabase SQL Editor

ALTER TABLE integrations
  ADD COLUMN IF NOT EXISTS ml_user_id   TEXT,
  ADD COLUMN IF NOT EXISTS tn_user_id   TEXT;

COMMENT ON COLUMN integrations.ml_user_id IS 'ID de usuario de MercadoLibre vinculado';
COMMENT ON COLUMN integrations.tn_user_id IS 'ID de tienda de Tienda Nube vinculada';
