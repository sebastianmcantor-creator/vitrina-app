CREATE TABLE IF NOT EXISTS admins (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email      TEXT NOT NULL UNIQUE,
  name       TEXT,
  role       TEXT DEFAULT 'admin' CHECK (role IN ('superadmin','admin','readonly')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sebastián como superadmin
INSERT INTO admins (email, name, role)
VALUES ('sebastianmcantor@gmail.com', 'Sebastián Medina Cantor', 'superadmin')
ON CONFLICT (email) DO NOTHING;

COMMENT ON TABLE admins IS 'Usuarios con acceso al panel maestro de Vitrina';
