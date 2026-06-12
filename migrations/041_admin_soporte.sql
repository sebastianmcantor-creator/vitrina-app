-- =============================================================================
-- Migración 041 — Poderes de admin para el maestro + modo soporte
-- Fecha: 2026-06-13
--
-- 1. El maestro hace updates directos sobre restaurantes de clientes
--    (cortesía, eliminar) con la sesión del admin. Las policies actuales
--    exigen ser staff del restaurante → esas acciones fallaban con RLS.
--    Se agrega una policy is_admin() (helper creado en la migración 040).
-- 2. Modo soporte: el admin puede agregarse/quitarse como staff de un
--    restaurante (rol 'support') para entrar a su panel y asistirlo.
--
-- Idempotente.
-- =============================================================================

-- Admins gestionan restaurantes desde maestro.html (cortesía, bajas, etc.)
DROP POLICY IF EXISTS "restaurants_admin_all" ON public.restaurants;
CREATE POLICY "restaurants_admin_all" ON public.restaurants
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Admins se agregan/quitan como staff de soporte de cualquier restaurante
DROP POLICY IF EXISTS "staff_admin_all" ON public.restaurant_staff;
CREATE POLICY "staff_admin_all" ON public.restaurant_staff
  FOR ALL
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

NOTIFY pgrst, 'reload schema';
