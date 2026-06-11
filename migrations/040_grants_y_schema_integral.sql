-- =============================================================================
-- Migración 040 — Reparación integral de permisos y schema (QA 11/06/2026)
--
-- Hallazgos del QA con usuario ficticio (El Fogón de Marta):
--   1. service_role SIN UPDATE en restaurants → el worker fallaba en silencio
--      (set-trial, webhooks MP, crons de WhatsApp, cortesía).
--   2. 26 tablas sin GRANT al rol authenticated → secciones del panel rotas:
--      Agenda, Reservas, Clientes, Redes (social_posts), historial de precios,
--      proveedores/OC, caja, y todo el maestro (sales_*, producers, leads...).
--   3. Migraciones que nunca corrieron en producción:
--      020 (tabla campanas), 026 (columnas de menu_items → GUARDAR PLATO
--      ESTABA ROTO EN PRODUCCIÓN), 027 (tabla delivery_metrics).
--
-- Todo es idempotente: se puede correr más de una vez.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1) SERVICE ROLE — el worker necesita acceso total (bypasea RLS por diseño)
-- ---------------------------------------------------------------------------
GRANT USAGE ON SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;

-- ---------------------------------------------------------------------------
-- 2) Re-aplicar migración 020 — tabla campanas (no existía en producción)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.campanas (
  id                    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id         UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  nombre                TEXT NOT NULL,
  mensaje               TEXT NOT NULL,
  segmento              TEXT DEFAULT 'todos',
  total_destinatarios   INTEGER DEFAULT 0,
  enviados              INTEGER DEFAULT 0,
  errores               INTEGER DEFAULT 0,
  status                TEXT DEFAULT 'draft' CHECK (status IN ('draft','sending','sent','failed')),
  created_at            TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_campanas_restaurant ON public.campanas(restaurant_id);
GRANT ALL ON public.campanas TO service_role;

-- ---------------------------------------------------------------------------
-- 3) Re-aplicar migración 026 — columnas extendidas de menu_items
--    (sin esto, "Guardar plato" desde el panel falla con PGRST204)
-- ---------------------------------------------------------------------------
ALTER TABLE public.menu_items
  ADD COLUMN IF NOT EXISTS cost_price NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS preparation_time INTEGER,
  ADD COLUMN IF NOT EXISTS calories INTEGER,
  ADD COLUMN IF NOT EXISTS notes_for_kitchen TEXT,
  ADD COLUMN IF NOT EXISTS stock_quantity INTEGER,
  ADD COLUMN IF NOT EXISTS sku TEXT,
  ADD COLUMN IF NOT EXISTS barcode TEXT,
  ADD COLUMN IF NOT EXISTS brand TEXT,
  ADD COLUMN IF NOT EXISTS ml_listing_url TEXT,
  ADD COLUMN IF NOT EXISTS tn_product_id TEXT;
CREATE INDEX IF NOT EXISTS menu_items_sku_idx ON public.menu_items(sku);

-- ---------------------------------------------------------------------------
-- 4) Re-aplicar migración 027 — tabla delivery_metrics (no existía)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.delivery_metrics (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('rappi', 'pedidosya')),
  period_start DATE,
  period_end DATE,
  gross_sales NUMERIC(12,2),
  commission_pct NUMERIC(5,2),
  commission_amount NUMERIC(12,2),
  ads_cost NUMERIC(12,2),
  order_count INTEGER,
  cancelled_orders INTEGER,
  rating NUMERIC(3,2),
  avg_delivery_time INTEGER,
  raw_data JSONB,
  source TEXT DEFAULT 'manual' CHECK (source IN ('screenshot', 'manual')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS delivery_metrics_restaurant_idx ON public.delivery_metrics(restaurant_id, platform, created_at DESC);
GRANT ALL ON public.delivery_metrics TO service_role;

-- ---------------------------------------------------------------------------
-- 5) Helper is_admin() — para las tablas del panel maestro
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admins a
    WHERE lower(a.email) = lower(coalesce(auth.jwt()->>'email', ''))
  );
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- ---------------------------------------------------------------------------
-- 6) Tablas del PANEL DEL CLIENTE — GRANT a authenticated + RLS scoped por
--    has_restaurant_access() (mismo patrón que el resto del schema)
-- ---------------------------------------------------------------------------
DO $$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'menu_item_price_history',
    'social_posts',
    'content_templates',
    'appointments',
    'staff_resources',
    'customers',
    'reservations',
    'suppliers',
    'purchase_orders',
    'cash_register_logs',
    'agenda_config',
    'campanas',
    'delivery_metrics',
    'smart_reminder_config'
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

-- purchase_order_items no tiene restaurant_id directo: va por la orden padre
GRANT SELECT, INSERT, UPDATE, DELETE ON public.purchase_order_items TO authenticated;
ALTER TABLE public.purchase_order_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "purchase_order_items_staff_all" ON public.purchase_order_items;
CREATE POLICY "purchase_order_items_staff_all" ON public.purchase_order_items
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.purchase_orders po
      WHERE po.id = order_id AND public.has_restaurant_access(po.restaurant_id)
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.purchase_orders po
      WHERE po.id = order_id AND public.has_restaurant_access(po.restaurant_id)
    )
  );

-- Tablas que el cliente solo LEE (las escribe el worker con service key):
-- wa_usage (contadores de límites — si el dueño pudiera escribir, podría
-- resetear sus propios contadores), executive_reports, pending_contact_orders
-- (esta última también UPDATE para "marcar contactado")
GRANT SELECT ON public.wa_usage TO authenticated;
ALTER TABLE public.wa_usage ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "wa_usage_staff_read" ON public.wa_usage;
CREATE POLICY "wa_usage_staff_read" ON public.wa_usage
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));

GRANT SELECT ON public.executive_reports TO authenticated;
ALTER TABLE public.executive_reports ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "executive_reports_staff_read" ON public.executive_reports;
CREATE POLICY "executive_reports_staff_read" ON public.executive_reports
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));

GRANT SELECT, UPDATE ON public.pending_contact_orders TO authenticated;
ALTER TABLE public.pending_contact_orders ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "pending_contact_staff_read" ON public.pending_contact_orders;
CREATE POLICY "pending_contact_staff_read" ON public.pending_contact_orders
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));
DROP POLICY IF EXISTS "pending_contact_staff_update" ON public.pending_contact_orders;
CREATE POLICY "pending_contact_staff_update" ON public.pending_contact_orders
  FOR UPDATE USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- 7) Tablas del MAESTRO (solo admins de la tabla admins)
-- ---------------------------------------------------------------------------
-- admins: cada usuario puede ver SU propia fila (para el check de acceso);
-- los admins ven todas
GRANT SELECT ON public.admins TO authenticated;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "admins_self_or_admin_read" ON public.admins;
CREATE POLICY "admins_self_or_admin_read" ON public.admins
  FOR SELECT USING (
    lower(email) = lower(coalesce(auth.jwt()->>'email', '')) OR public.is_admin()
  );

DO $$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'sales_prospects',
    'sales_contacts',
    'sales_agent_config',
    'sales_metrics',
    'producers',
    'waitlist',
    'leads',
    'unsubscribe_list',
    'wa_followup_queue'
  ] LOOP
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON public.%I TO authenticated', t);
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', t || '_admin_all', t);
    EXECUTE format(
      'CREATE POLICY %I ON public.%I FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin())',
      t || '_admin_all', t
    );
  END LOOP;
END $$;

-- ---------------------------------------------------------------------------
-- 8) REALTIME — la tabla orders no estaba en la publicación supabase_realtime:
--    la cocina, el tracking del comensal y los badges del panel NO recibían
--    eventos (la "cocina en tiempo real" solo funcionaba recargando la página).
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.orders;
EXCEPTION
  WHEN duplicate_object THEN NULL; -- ya estaba publicada
END $$;

-- ---------------------------------------------------------------------------
-- 9) Refrescar el schema cache de PostgREST
-- ---------------------------------------------------------------------------
NOTIFY pgrst, 'reload schema';
