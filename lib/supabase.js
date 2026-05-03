import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// ⚠️  Reemplazar con los valores de tu proyecto en supabase.com
// Dashboard → Settings → API → Project URL y anon public key
const SUPABASE_URL      = 'https://zigtqvwerrtyuunayduh.supabase.co'
const SUPABASE_ANON_KEY = 'sb_publishable_d1x6nxOl01PPOfcGpxkRbw_25pEpJ7F'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: {
    persistSession:      true,
    autoRefreshToken:    true,
    detectSessionInUrl:  true,
  },
})
