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
ALTER TABLE public.delivery_metrics ENABLE ROW LEVEL SECURITY;
GRANT ALL ON public.delivery_metrics TO service_role;
