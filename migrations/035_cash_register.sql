-- Migración 035: Arqueo de caja básico
-- Tabla para registrar aperturas y cierres de caja por día

CREATE TABLE IF NOT EXISTS public.cash_register_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  opened_at TIMESTAMPTZ DEFAULT NOW(),
  closed_at TIMESTAMPTZ,
  opening_cash NUMERIC(10,2) NOT NULL DEFAULT 0,  -- efectivo al abrir
  closing_cash NUMERIC(10,2),                      -- efectivo contado al cierre
  system_sales NUMERIC(10,2) DEFAULT 0,            -- ventas del sistema (calculado)
  difference NUMERIC(10,2),                        -- closing_cash - opening_cash - system_sales
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'closed', 'reviewed')),
  notes TEXT,
  created_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (restaurant_id, date)
);

CREATE INDEX IF NOT EXISTS cash_register_logs_restaurant_date_idx
  ON public.cash_register_logs(restaurant_id, date DESC);

ALTER TABLE public.cash_register_logs ENABLE ROW LEVEL SECURITY;

GRANT ALL ON public.cash_register_logs TO service_role;
