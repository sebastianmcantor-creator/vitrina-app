-- Migration 008: Opening hours column on restaurants
-- Run in Supabase SQL Editor

ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS opening_hours JSONB;

-- Format: {"1":{"o":"11:00","c":"23:00"},"2":{...},...,"0":null}
-- Keys 0-6 where 0=Sunday, 1=Monday...6=Saturday
-- null value means closed that day
-- o = opening time (HH:MM), c = closing time (HH:MM)

COMMENT ON COLUMN restaurants.opening_hours IS 'Horarios de apertura por día (0=Dom, 1=Lun...6=Sab). null = cerrado ese día';
