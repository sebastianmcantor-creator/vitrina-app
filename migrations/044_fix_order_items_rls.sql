-- 044 — Fix RLS de order_items (CRÍTICO)
-- Síntoma: el comensal (anónimo) hacía un pedido, se creaba la fila en `orders`
-- pero los `order_items` fallaban con:
--   42501 "new row violates row-level security policy for table order_items"
-- → el pedido llegaba SIN ítems y el cliente veía "Error al enviar el pedido"
--   (y reintentaba, generando pedidos duplicados).
-- Causa: faltaba (o se perdió) la policy de INSERT público en order_items.
-- `orders` sí tenía su policy pública; order_items no.

GRANT INSERT ON public.order_items TO anon, authenticated;

DROP POLICY IF EXISTS "order_items_public_insert" ON public.order_items;
CREATE POLICY "order_items_public_insert" ON public.order_items
  FOR INSERT TO anon, authenticated
  WITH CHECK (true);
