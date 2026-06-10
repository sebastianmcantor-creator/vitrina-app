-- =============================================================================
-- Migración 039 — Fixes QA ronda 2 (bugs críticos 1, 2 y 3)
-- Fecha: 2026-06-10
--
-- Bug 1: column orders.customer_phone does not exist → Historial roto
-- Bug 2: permission denied for table integrations → sección Análisis rota
-- Bug 3: permission denied for table subscription_payments → Facturación rota
--
-- Todo es idempotente: se puede correr más de una vez sin romper nada.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- BUG 1 — orders.customer_phone
-- La migración 019 no llegó a aplicarse en producción. Re-aplicación.
-- ---------------------------------------------------------------------------
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS customer_phone TEXT;

CREATE INDEX IF NOT EXISTS idx_orders_customer_phone ON public.orders(customer_phone);

COMMENT ON COLUMN public.orders.customer_phone IS 'Teléfono del cliente para notificaciones WhatsApp (formato: +549XXXXXXXXXX)';

-- ---------------------------------------------------------------------------
-- BUG 2 — integrations (y tablas hermanas de la migración 012)
-- Quedaron sin GRANT al rol authenticated y sin RLS. El panel accede con la
-- anon key + sesión de Supabase Auth (rol authenticated), scoped por
-- has_restaurant_access() — mismo patrón que el resto del schema.
-- El worker usa service_role, que bypasea RLS, así que no se ve afectado.
-- ---------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON public.integrations TO authenticated;
ALTER TABLE public.integrations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "integrations_staff_all" ON public.integrations;
CREATE POLICY "integrations_staff_all" ON public.integrations
  FOR ALL
  USING (public.has_restaurant_access(restaurant_id))
  WITH CHECK (public.has_restaurant_access(restaurant_id));

GRANT SELECT, INSERT, UPDATE, DELETE ON public.analytics_cache TO authenticated;
ALTER TABLE public.analytics_cache ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "analytics_cache_staff_all" ON public.analytics_cache;
CREATE POLICY "analytics_cache_staff_all" ON public.analytics_cache
  FOR ALL
  USING (public.has_restaurant_access(restaurant_id))
  WITH CHECK (public.has_restaurant_access(restaurant_id));

GRANT SELECT, INSERT, UPDATE, DELETE ON public.competitors TO authenticated;
ALTER TABLE public.competitors ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "competitors_staff_all" ON public.competitors;
CREATE POLICY "competitors_staff_all" ON public.competitors
  FOR ALL
  USING (public.has_restaurant_access(restaurant_id))
  WITH CHECK (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- BUG 3 — subscription_payments (y subscriptions, de la migración 011)
-- El panel solo necesita LEER el historial de pagos. Los INSERT/UPDATE los
-- hace el worker con service key (bypasea RLS). Solo SELECT para authenticated.
-- ---------------------------------------------------------------------------
GRANT SELECT ON public.subscription_payments TO authenticated;
ALTER TABLE public.subscription_payments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "subscription_payments_staff_read" ON public.subscription_payments;
CREATE POLICY "subscription_payments_staff_read" ON public.subscription_payments
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));

GRANT SELECT ON public.subscriptions TO authenticated;
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "subscriptions_staff_read" ON public.subscriptions;
CREATE POLICY "subscriptions_staff_read" ON public.subscriptions
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- Refrescar el schema cache de PostgREST para que la columna nueva y los
-- permisos apliquen de inmediato (sin esperar el reload automático).
-- ---------------------------------------------------------------------------
NOTIFY pgrst, 'reload schema';
