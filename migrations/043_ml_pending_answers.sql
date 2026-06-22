-- 043 — Respuestas ML pendientes de aprobación (C3)
-- ML deja de auto-publicar respuestas a compradores. Genera una sugerencia que el
-- dueño aprueba/rechaza desde el panel. El campo ml_auto_answer queda para el futuro
-- modo automático (tras 5 aprobaciones consecutivas).

CREATE TABLE IF NOT EXISTS public.ml_pending_answers (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  restaurant_id    UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  ml_user_id       TEXT NOT NULL,
  question_id      TEXT NOT NULL,
  item_id          TEXT,
  item_title       TEXT,
  question_text    TEXT,
  suggested_answer TEXT,
  status           TEXT NOT NULL DEFAULT 'pending',  -- pending | approved | rejected
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  answered_at      TIMESTAMPTZ,
  UNIQUE (question_id)
);

CREATE INDEX IF NOT EXISTS idx_ml_pending_rest_status
  ON public.ml_pending_answers (restaurant_id, status, created_at DESC);

-- Flag para el futuro modo automático (todavía sin lógica de 5 aprobaciones)
ALTER TABLE public.integrations
  ADD COLUMN IF NOT EXISTS ml_auto_answer BOOLEAN NOT NULL DEFAULT FALSE;

-- Grants
GRANT ALL ON public.ml_pending_answers TO service_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.ml_pending_answers TO authenticated;

-- RLS: cada dueño ve/gestiona solo las de sus negocios
ALTER TABLE public.ml_pending_answers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ml_pending_owner ON public.ml_pending_answers;
CREATE POLICY ml_pending_owner ON public.ml_pending_answers
  FOR ALL TO authenticated
  USING      (restaurant_id IN (SELECT id FROM public.restaurants WHERE owner_id = auth.uid()))
  WITH CHECK (restaurant_id IN (SELECT id FROM public.restaurants WHERE owner_id = auth.uid()));
