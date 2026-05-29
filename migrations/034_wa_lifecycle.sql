-- Migración 034: Ciclo de vida automático de línea Twilio al cancelar/vencer suscripción
-- Fecha: 2026-05-27

ALTER TABLE public.restaurants
  ADD COLUMN IF NOT EXISTS wa_reserved_until TIMESTAMPTZ;

COMMENT ON COLUMN public.restaurants.wa_reserved_until IS
  'Fecha hasta la cual se reserva el número WA aunque el plan esté cancelado. 30 días desde la baja. Después de esta fecha, el cron libera el número vía releaseTwilioNumberStub.';
