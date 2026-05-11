-- Migration 013: Tabla de reservas
-- Run in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS reservations (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id   UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  customer_name   TEXT NOT NULL,
  customer_phone  TEXT,
  customer_email  TEXT,
  party_size      INTEGER NOT NULL DEFAULT 2,
  reserved_for    TIMESTAMPTZ NOT NULL,
  duration_min    INTEGER DEFAULT 90,
  notes           TEXT,
  status          TEXT NOT NULL DEFAULT 'confirmed' CHECK (status IN ('confirmed','cancelled','completed','no_show')),
  table_number    INTEGER,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reservations_restaurant ON reservations(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_reservations_date ON reservations(restaurant_id, reserved_for);

COMMENT ON TABLE reservations IS 'Reservas de mesas y turnos de clientes';
