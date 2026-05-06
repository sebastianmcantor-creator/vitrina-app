-- Migration 010: Logo and cover image URLs on restaurants
-- Run in Supabase SQL Editor

ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS logo_url   TEXT,
  ADD COLUMN IF NOT EXISTS cover_url  TEXT;

COMMENT ON COLUMN restaurants.logo_url  IS 'URL pública del logo del restaurante (Supabase Storage o externa)';
COMMENT ON COLUMN restaurants.cover_url IS 'URL pública de la imagen de portada del restaurante';

-- Create storage bucket for restaurant images (run once)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('restaurant-images', 'restaurant-images', true)
-- ON CONFLICT (id) DO NOTHING;

-- Storage RLS policy (run once after bucket creation):
-- CREATE POLICY "Public read" ON storage.objects FOR SELECT USING (bucket_id = 'restaurant-images');
-- CREATE POLICY "Auth insert" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'restaurant-images' AND auth.role() = 'authenticated');
-- CREATE POLICY "Auth delete" ON storage.objects FOR DELETE USING (bucket_id = 'restaurant-images' AND auth.role() = 'authenticated');
