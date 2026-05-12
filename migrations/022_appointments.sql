-- Migration 022: Sistema de turnos y agenda
-- Run in Supabase SQL Editor

-- Tipos de servicio por negocio
CREATE TABLE IF NOT EXISTS service_types (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id   UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,                    -- "Corte de cabello", "Coloración", etc.
  duration_min    INTEGER NOT NULL DEFAULT 45,      -- duración en minutos
  price           NUMERIC(10,2),                    -- precio del servicio
  buffer_min      INTEGER DEFAULT 10,               -- tiempo entre turnos
  is_active       BOOLEAN DEFAULT true,
  sort_order      INTEGER DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Profesionales / recursos (peluqueros, sillas, etc.)
CREATE TABLE IF NOT EXISTS staff_resources (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id   UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,                    -- "Mati", "Sandra", "Silla 1"
  type            TEXT DEFAULT 'person',            -- 'person' | 'resource'
  simultaneous    INTEGER DEFAULT 1,                -- cuántos clientes atiende al mismo tiempo
  is_active       BOOLEAN DEFAULT true,
  color           TEXT DEFAULT '#B85A30',           -- color en el calendario
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Turnos / citas
CREATE TABLE IF NOT EXISTS appointments (
  id              UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id   UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  service_type_id UUID REFERENCES service_types(id) ON DELETE SET NULL,
  staff_id        UUID REFERENCES staff_resources(id) ON DELETE SET NULL,
  customer_name   TEXT NOT NULL,
  customer_phone  TEXT,
  customer_email  TEXT,
  starts_at       TIMESTAMPTZ NOT NULL,
  ends_at         TIMESTAMPTZ NOT NULL,
  notes           TEXT,
  status          TEXT NOT NULL DEFAULT 'confirmed'
    CHECK (status IN ('pending','confirmed','cancelled','completed','no_show')),
  source          TEXT DEFAULT 'manual',            -- 'manual' | 'whatsapp' | 'web'
  google_event_id TEXT,                             -- para sync con Google Calendar
  reminder_sent   BOOLEAN DEFAULT false,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Configuración de agenda por negocio
CREATE TABLE IF NOT EXISTS agenda_config (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id         UUID NOT NULL UNIQUE REFERENCES restaurants(id) ON DELETE CASCADE,
  slot_duration_min     INTEGER DEFAULT 45,         -- duración default de turno
  advance_booking_days  INTEGER DEFAULT 30,         -- con cuántos días de anticipación se puede reservar
  min_notice_hours      INTEGER DEFAULT 2,          -- aviso mínimo para reservar
  max_simultaneous      INTEGER DEFAULT 1,          -- máx clientes al mismo tiempo
  google_calendar_id    TEXT,                       -- ID del calendario de Google
  google_access_token   TEXT,
  google_refresh_token  TEXT,
  use_google_calendar   BOOLEAN DEFAULT false,
  reminder_hours        INTEGER DEFAULT 24,         -- cuándo mandar el recordatorio
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_appointments_restaurant ON appointments(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(restaurant_id, starts_at);
CREATE INDEX IF NOT EXISTS idx_service_types_restaurant ON service_types(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_staff_resources_restaurant ON staff_resources(restaurant_id);

COMMENT ON TABLE appointments IS 'Turnos y citas del negocio';
COMMENT ON TABLE service_types IS 'Tipos de servicio con duración y precio';
COMMENT ON TABLE staff_resources IS 'Profesionales o recursos del negocio (peluqueros, sillas, etc.)';
COMMENT ON TABLE agenda_config IS 'Configuración del sistema de agenda';
