-- Migration 029: pending_contact_orders
-- Registra órdenes pagadas en comercios SIN TN/ML conectados,
-- donde el local debe contactar al cliente manualmente para coordinar retiro/envío.
-- Flujo: webhook MP confirma pago → si business_type local/ecommerce y sin TN/ML
-- → se inserta acá + se notifica al local y al cliente.
-- A las 2hs sin marcar 'contacted' → reminder al local.
-- A las 4hs sin marcar 'contacted' → alerta a Sebastián (ADMIN_WHATSAPP).

CREATE TABLE IF NOT EXISTS public.pending_contact_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  customer_phone TEXT NOT NULL,
  customer_name TEXT,
  product_summary TEXT NOT NULL,
  amount_ars NUMERIC(10,2) NOT NULL,
  paid_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  contacted_at TIMESTAMPTZ,
  reminder_2h_sent BOOLEAN DEFAULT FALSE,
  reminder_4h_sent BOOLEAN DEFAULT FALSE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'contacted', 'completed', 'cancelled')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS pending_contact_orders_status_idx
  ON public.pending_contact_orders(status, paid_at);
CREATE INDEX IF NOT EXISTS pending_contact_orders_restaurant_idx
  ON public.pending_contact_orders(restaurant_id);

ALTER TABLE public.pending_contact_orders ENABLE ROW LEVEL SECURITY;
GRANT ALL ON public.pending_contact_orders TO service_role;

COMMENT ON TABLE public.pending_contact_orders IS
  'Órdenes pagadas en comercios sin TN/ML conectados que requieren contacto manual del local con el cliente.';
COMMENT ON COLUMN public.pending_contact_orders.product_summary IS
  'Resumen del producto/s comprados (ej: "Taladro Black & Decker (1u) + Tornillos 4mm (3u)")';
COMMENT ON COLUMN public.pending_contact_orders.status IS
  'pending = recién pagada, contacted = local marcó que lo contactó, completed = ya se entregó, cancelled = no se concretó';
