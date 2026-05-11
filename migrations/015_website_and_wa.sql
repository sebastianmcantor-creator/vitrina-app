-- Migration 015: website_url y wants_whatsapp en restaurants
-- Run in Supabase SQL Editor

ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS website_url     TEXT,
  ADD COLUMN IF NOT EXISTS wants_whatsapp  BOOLEAN DEFAULT false;

COMMENT ON COLUMN restaurants.website_url    IS 'URL del sitio web propio del negocio';
COMMENT ON COLUMN restaurants.wants_whatsapp IS 'El cliente solicitó número de WhatsApp Business propio durante el onboarding';
