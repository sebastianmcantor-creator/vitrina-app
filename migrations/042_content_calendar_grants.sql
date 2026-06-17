-- =============================================================================
-- Migración 042 — Grants faltantes del calendario de contenido
-- Fecha: 2026-06-17
--
-- La migración 040 otorgó permisos a las tablas del panel, pero se salteó
-- scheduled_posts y content_calendar_suggestions (creadas en la 013). Sin GRANT
-- ni RLS, el panel (rol authenticated) recibe "permission denied for table
-- scheduled_posts" al crear/listar publicaciones del calendario.
--
-- Mismo patrón que el resto del schema: GRANT a authenticated + RLS scoped por
-- has_restaurant_access(). El worker usa service_role y bypasea RLS.
-- Idempotente: se puede correr más de una vez.
-- =============================================================================

DO $$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'scheduled_posts',
    'content_calendar_suggestions'
  ] LOOP
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON public.%I TO authenticated', t);
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || '_staff_all', t);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR ALL USING (public.has_restaurant_access(restaurant_id)) WITH CHECK (public.has_restaurant_access(restaurant_id))',
      t || '_staff_all', t
    );
  END LOOP;
END $$;

-- Refrescar el schema cache de PostgREST
NOTIFY pgrst, 'reload schema';
