ALTER TABLE restaurants
  ADD COLUMN IF NOT EXISTS instagram_handle TEXT,
  ADD COLUMN IF NOT EXISTS facebook_url     TEXT;
COMMENT ON COLUMN restaurants.instagram_handle IS 'Usuario de Instagram (sin @)';
COMMENT ON COLUMN restaurants.facebook_url     IS 'URL de la página de Facebook';
