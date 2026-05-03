import { supabase } from './supabase.js'

// ---------------------------------------------------------------------------
// Sesión activa
// ---------------------------------------------------------------------------
export async function getUser() {
  const { data: { user } } = await supabase.auth.getUser()
  return user
}

export async function getSession() {
  const { data: { session } } = await supabase.auth.getSession()
  return session
}

// ---------------------------------------------------------------------------
// Guardia: redirige a login si no hay sesión
// Uso: await requireAuth()  — poner al inicio de páginas protegidas
// ---------------------------------------------------------------------------
export async function requireAuth(loginUrl = '/login.html') {
  const user = await getUser()
  if (!user) {
    window.location.replace(loginUrl)
    // detiene el resto del script mientras redirige
    await new Promise(() => {})
  }
  return user
}

// ---------------------------------------------------------------------------
// Google OAuth
// ---------------------------------------------------------------------------
export async function signInWithGoogle() {
  const { error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: `${window.location.origin}/panel.html`,
    },
  })
  if (error) throw new Error(error.message)
}

// ---------------------------------------------------------------------------
// Cerrar sesión
// ---------------------------------------------------------------------------
export async function signOut(redirectUrl = '/login.html') {
  await supabase.auth.signOut()
  window.location.replace(redirectUrl)
}

// ---------------------------------------------------------------------------
// Escuchar cambios de sesión (útil para reactividad)
// Callback recibe: 'SIGNED_IN' | 'SIGNED_OUT' | 'TOKEN_REFRESHED' | etc.
// ---------------------------------------------------------------------------
export function onAuthChange(callback) {
  return supabase.auth.onAuthStateChange((event, session) => {
    callback(event, session?.user ?? null)
  })
}
