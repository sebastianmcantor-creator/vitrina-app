-- Migration 014: business_type on restaurants
-- Run in Supabase SQL Editor

ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS business_type TEXT DEFAULT 'restaurant'
  CHECK (business_type IN ('restaurant','local','services','ecommerce'));

COMMENT ON COLUMN restaurants.business_type IS 'Tipo de negocio: restaurant | local | services | ecommerce';
