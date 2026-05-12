-- Migration 023: campo trial_end en restaurants
ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS trial_end TIMESTAMPTZ;

COMMENT ON COLUMN restaurants.trial_end IS 'Fecha de fin del período de prueba gratuita';
