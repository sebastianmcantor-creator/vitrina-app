-- Migración 018: Lista de espera y leads de landing
-- Fecha: 2026-05-07
-- Descripción: Tablas para capturar interesados en Marketing y leads desde chat de landing

-- Tabla de lista de espera (Marketing y otros features próximos)
CREATE TABLE IF NOT EXISTS waitlist (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  restaurant_name TEXT,
  waitlist_type TEXT NOT NULL DEFAULT 'general', -- general | marketing | menu
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notified_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_waitlist_email ON waitlist(email);
CREATE INDEX IF NOT EXISTS idx_waitlist_type ON waitlist(waitlist_type);
CREATE INDEX IF NOT EXISTS idx_waitlist_created_at ON waitlist(created_at DESC);

-- Tabla de leads capturados desde landing
CREATE TABLE IF NOT EXISTS leads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL,
  query TEXT NOT NULL, -- Consulta del usuario que mostró interés
  context TEXT, -- Contexto de la conversación
  source TEXT NOT NULL DEFAULT 'landing_chat', -- landing_chat | contact_form | other
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  contacted_at TIMESTAMPTZ,
  status TEXT DEFAULT 'new' -- new | contacted | converted | lost
);

CREATE INDEX IF NOT EXISTS idx_leads_email ON leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_source ON leads(source);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at DESC);

-- Comentarios
COMMENT ON TABLE waitlist IS 'Lista de espera para features próximos (especialmente Marketing)';
COMMENT ON TABLE leads IS 'Leads capturados desde landing page (chat IA, forms, etc.)';
COMMENT ON COLUMN waitlist.waitlist_type IS 'Tipo de feature: general, marketing, menu';
COMMENT ON COLUMN leads.source IS 'Origen del lead: landing_chat, contact_form, etc.';
COMMENT ON COLUMN leads.status IS 'Estado: new, contacted, converted, lost';
