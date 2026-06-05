-- Migration 038: Opening hours column on restaurants (ensure it exists)
-- Safe to run even if migration 008 was applied — uses IF NOT EXISTS
-- Run in Supabase SQL Editor

ALTER TABLE public.restaurants
  ADD COLUMN IF NOT EXISTS opening_hours JSONB;

COMMENT ON COLUMN public.restaurants.opening_hours IS
  'Horarios de atención. Ejemplo: {"lunes": {"open": "09:00", "close": "18:00", "closed": false}, ...}';
