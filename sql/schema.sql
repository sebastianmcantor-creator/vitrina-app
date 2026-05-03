-- =============================================================================
-- VITRINA APP — Schema completo
-- Ejecutar en: Supabase Dashboard > SQL Editor
-- =============================================================================

-- ---------------------------------------------------------------------------
-- EXTENSIONES
-- ---------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ---------------------------------------------------------------------------
-- PROFILES
-- Extiende auth.users con datos públicos del usuario
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id          UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name   TEXT,
  avatar_url  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- RESTAURANTS
-- Cada fila es un restaurante cliente del SaaS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.restaurants (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  slug           TEXT        UNIQUE NOT NULL,           -- URL amigable: la-panera-rosa
  name           TEXT        NOT NULL,
  tagline        TEXT,                                  -- "El sabor de siempre"
  description    TEXT,
  logo_url       TEXT,
  cover_url      TEXT,
  address        TEXT,
  phone          TEXT,
  email          TEXT,
  city           TEXT,
  country        TEXT        NOT NULL DEFAULT 'AR',
  currency       TEXT        NOT NULL DEFAULT 'ARS',
  timezone       TEXT        NOT NULL DEFAULT 'America/Argentina/Buenos_Aires',
  primary_color  TEXT        NOT NULL DEFAULT '#B85A30',
  is_open        BOOLEAN     NOT NULL DEFAULT TRUE,
  is_active      BOOLEAN     NOT NULL DEFAULT TRUE,
  plan           TEXT        NOT NULL DEFAULT 'free',   -- free | starter | pro
  owner_id       UUID        REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- RESTAURANT STAFF
-- Usuarios con acceso a gestionar un restaurante (many-to-many)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.restaurant_staff (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id  UUID        NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  user_id        UUID        NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  role           TEXT        NOT NULL DEFAULT 'staff',  -- owner | admin | staff
  invited_by     UUID        REFERENCES public.profiles(id),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(restaurant_id, user_id)
);

-- ---------------------------------------------------------------------------
-- MENU CATEGORIES
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.menu_categories (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id  UUID        NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  name           TEXT        NOT NULL,
  description    TEXT,
  emoji          TEXT,
  sort_order     INTEGER     NOT NULL DEFAULT 0,
  is_visible     BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- MENU ITEMS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.menu_items (
  id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id   UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  category_id     UUID          REFERENCES public.menu_categories(id) ON DELETE SET NULL,
  name            TEXT          NOT NULL,
  description     TEXT,
  price           NUMERIC(12,2) NOT NULL DEFAULT 0,
  original_price  NUMERIC(12,2),                        -- precio tachado para mostrar descuento
  image_url       TEXT,
  emoji           TEXT,
  tags            TEXT[]        NOT NULL DEFAULT '{}',  -- veg | vegan | celiac | popular | spicy | new
  allergens       TEXT[]        NOT NULL DEFAULT '{}',
  is_available    BOOLEAN       NOT NULL DEFAULT TRUE,
  is_visible      BOOLEAN       NOT NULL DEFAULT TRUE,
  sort_order      INTEGER       NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- RESTAURANT TABLES
-- Las mesas físicas del local
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.restaurant_tables (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id  UUID        NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  number         INTEGER     NOT NULL,
  label          TEXT,                                  -- "Barra", "Terraza VIP"
  capacity       INTEGER     DEFAULT 4,
  qr_code_url    TEXT,
  is_active      BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(restaurant_id, number)
);

-- ---------------------------------------------------------------------------
-- ORDER SESSIONS
-- Una sesión agrupa todos los pedidos de una mesa en una visita
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.order_sessions (
  id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id  UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  table_id       UUID          REFERENCES public.restaurant_tables(id) ON DELETE SET NULL,
  table_number   INTEGER,
  status         TEXT          NOT NULL DEFAULT 'open', -- open | closed | paid | cancelled
  opened_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  closed_at      TIMESTAMPTZ,
  total          NUMERIC(12,2) NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------------
-- ORDERS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.orders (
  id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id  UUID          NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  session_id     UUID          REFERENCES public.order_sessions(id) ON DELETE SET NULL,
  table_number   INTEGER,
  status         TEXT          NOT NULL DEFAULT 'pending',
  -- pending | confirmed | preparing | ready | delivered | cancelled
  notes          TEXT,
  total          NUMERIC(12,2) NOT NULL DEFAULT 0,
  created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- ORDER ITEMS
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.order_items (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id      UUID          NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  menu_item_id  UUID          REFERENCES public.menu_items(id) ON DELETE SET NULL,
  name          TEXT          NOT NULL,   -- snapshot del nombre al momento del pedido
  price         NUMERIC(12,2) NOT NULL,   -- snapshot del precio al momento del pedido
  quantity      INTEGER       NOT NULL DEFAULT 1,
  notes         TEXT,
  status        TEXT          NOT NULL DEFAULT 'pending' -- pending | preparing | ready | delivered
);

-- =============================================================================
-- TRIGGERS — updated_at automático
-- =============================================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_restaurants_updated_at
  BEFORE UPDATE ON public.restaurants
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_menu_categories_updated_at
  BEFORE UPDATE ON public.menu_categories
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_menu_items_updated_at
  BEFORE UPDATE ON public.menu_items
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_orders_updated_at
  BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- =============================================================================
-- TRIGGER — crear profile automáticamente al registrarse
-- =============================================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================
ALTER TABLE public.profiles           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurants        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurant_staff   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_categories    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurant_tables  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_sessions     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items        ENABLE ROW LEVEL SECURITY;

-- Helper: el usuario autenticado tiene acceso a este restaurante
CREATE OR REPLACE FUNCTION public.has_restaurant_access(p_restaurant_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.restaurants r
    LEFT JOIN public.restaurant_staff rs
      ON rs.restaurant_id = r.id AND rs.user_id = auth.uid()
    WHERE r.id = p_restaurant_id
      AND (r.owner_id = auth.uid() OR rs.user_id IS NOT NULL)
  );
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- ---------------------------------------------------------------------------
-- PROFILES
-- ---------------------------------------------------------------------------
CREATE POLICY "profiles_select_own"  ON public.profiles FOR SELECT  USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own"  ON public.profiles FOR INSERT  WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update_own"  ON public.profiles FOR UPDATE  USING (auth.uid() = id);

-- ---------------------------------------------------------------------------
-- RESTAURANTS
-- Lectura pública para restaurantes activos (clientes del menú sin login)
-- Escritura solo para dueños / staff
-- ---------------------------------------------------------------------------
CREATE POLICY "restaurants_public_read"  ON public.restaurants
  FOR SELECT USING (is_active = TRUE);

CREATE POLICY "restaurants_insert_owner" ON public.restaurants
  FOR INSERT WITH CHECK (owner_id = auth.uid());

CREATE POLICY "restaurants_update_staff" ON public.restaurants
  FOR UPDATE USING (public.has_restaurant_access(id));

-- ---------------------------------------------------------------------------
-- RESTAURANT STAFF
-- ---------------------------------------------------------------------------
CREATE POLICY "staff_select" ON public.restaurant_staff
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));

CREATE POLICY "staff_insert" ON public.restaurant_staff
  FOR INSERT WITH CHECK (public.has_restaurant_access(restaurant_id));

CREATE POLICY "staff_delete" ON public.restaurant_staff
  FOR DELETE USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- MENU CATEGORIES
-- Lectura pública; escritura solo staff
-- ---------------------------------------------------------------------------
CREATE POLICY "menu_categories_public_read" ON public.menu_categories
  FOR SELECT USING (is_visible = TRUE);

CREATE POLICY "menu_categories_staff_all" ON public.menu_categories
  FOR ALL USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- MENU ITEMS
-- ---------------------------------------------------------------------------
CREATE POLICY "menu_items_public_read" ON public.menu_items
  FOR SELECT USING (is_visible = TRUE);

CREATE POLICY "menu_items_staff_all" ON public.menu_items
  FOR ALL USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- RESTAURANT TABLES
-- ---------------------------------------------------------------------------
CREATE POLICY "tables_staff_all" ON public.restaurant_tables
  FOR ALL USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- ORDER SESSIONS
-- Clientes pueden crear e insertar; staff puede leer y actualizar
-- ---------------------------------------------------------------------------
CREATE POLICY "sessions_public_insert" ON public.order_sessions
  FOR INSERT WITH CHECK (TRUE);

CREATE POLICY "sessions_public_select" ON public.order_sessions
  FOR SELECT USING (TRUE);

CREATE POLICY "sessions_staff_update" ON public.order_sessions
  FOR UPDATE USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- ORDERS
-- ---------------------------------------------------------------------------
CREATE POLICY "orders_public_insert" ON public.orders
  FOR INSERT WITH CHECK (TRUE);

CREATE POLICY "orders_staff_select" ON public.orders
  FOR SELECT USING (public.has_restaurant_access(restaurant_id));

CREATE POLICY "orders_staff_update" ON public.orders
  FOR UPDATE USING (public.has_restaurant_access(restaurant_id));

-- ---------------------------------------------------------------------------
-- ORDER ITEMS
-- ---------------------------------------------------------------------------
CREATE POLICY "order_items_public_insert" ON public.order_items
  FOR INSERT WITH CHECK (TRUE);

CREATE POLICY "order_items_staff_select" ON public.order_items
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.orders o
      WHERE o.id = order_id
        AND public.has_restaurant_access(o.restaurant_id)
    )
  );

CREATE POLICY "order_items_staff_update" ON public.order_items
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.orders o
      WHERE o.id = order_id
        AND public.has_restaurant_access(o.restaurant_id)
    )
  );

-- =============================================================================
-- ÍNDICES
-- =============================================================================
CREATE INDEX IF NOT EXISTS idx_restaurants_slug        ON public.restaurants(slug);
CREATE INDEX IF NOT EXISTS idx_restaurants_owner       ON public.restaurants(owner_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant   ON public.menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category     ON public.menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_restaurant       ON public.orders(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_session          ON public.orders(session_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order       ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_sessions_restaurant     ON public.order_sessions(restaurant_id);
