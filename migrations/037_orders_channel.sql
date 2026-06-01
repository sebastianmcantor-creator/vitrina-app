-- Migración 037: columna channel en orders + columna delivery_channels_config en restaurants
-- orders.channel: identifica el canal de venta (propio, rappi, pedidosya, mercadolibre, otro)
-- restaurants.delivery_channels_config: configuración JSONB de canales activos y sus comisiones

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS channel TEXT DEFAULT 'propio';

ALTER TABLE public.restaurants
  ADD COLUMN IF NOT EXISTS delivery_channels_config JSONB;

COMMENT ON COLUMN public.orders.channel IS 'Canal de venta: propio, rappi, pedidosya, mercadolibre, otro';
COMMENT ON COLUMN public.restaurants.delivery_channels_config IS 'Configuración de canales de venta y comisiones para análisis de rentabilidad';

CREATE INDEX IF NOT EXISTS orders_channel_idx ON public.orders(restaurant_id, channel);
