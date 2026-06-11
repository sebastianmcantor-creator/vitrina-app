/**
 * plans.js — Lógica de límites y features por plan
 *
 * Fuente única del plan: getPlanKey() resuelve subscription_tier → plan legacy
 * → 'free', normalizando aliases viejos. Sidebar, Facturación y la sección
 * Plan del panel deben usar SIEMPRE estas funciones (bug QA2 #5).
 */

// Catálogo definitivo (precios USD — ver /docs/contexto_funcional.md)
export const PLAN_LIMITS = {
  'free': {
    nombre: 'Free',
    precio: 0,
    maxPlatos: 45,
    maxSucursales: 1,
    tanoLimit: 75,
    pedidos: false,
    cocina: false,
    pagos: false,
  },
  'rest-menu': {
    nombre: 'Solo Menú',
    precio: 27,
    maxPlatos: -1, // ilimitado
    maxSucursales: 1,
    tanoLimit: -1,
    pedidos: true,
    cocina: true,
    pagos: true,
  },
  'rest-mkt': {
    nombre: 'Marketing',
    precio: 57,
    maxPlatos: -1,
    maxSucursales: 1,
    tanoLimit: -1,
    pedidos: false,
    cocina: false,
    pagos: false,
  },
  'rest-combo': {
    nombre: 'Combo',
    precio: 70,
    maxPlatos: -1,
    maxSucursales: 1,
    tanoLimit: -1,
    pedidos: true,
    cocina: true,
    pagos: true,
  },
  'local-mkt': {
    nombre: 'Marketing',
    precio: 62,
    maxPlatos: -1,
    maxSucursales: 1,
    tanoLimit: -1,
    pedidos: true,
    cocina: true,
    pagos: true,
  },
}

// Keys viejas que pueden quedar en restaurants.plan / subscription_tier
const LEGACY_ALIASES = {
  'menu-free':   'free',
  'menu-basico': 'rest-menu',
  'menu-pro':    'rest-menu',
  'menu-full':   'rest-menu',
  'pro':         'rest-menu',
  'full':        'rest-menu',
  'starter':     'rest-menu',
  'marketing':   'rest-mkt',
  'combo':       'rest-combo',
  'local-mktwa': 'local-mkt',
  'rest-wa':     'rest-menu',
  'rest-mktwa':  'rest-mkt',
}

/**
 * Key canónica del plan del restaurante (ej: 'rest-combo').
 * Precedencia: subscription_tier (si no es free) → plan legacy → 'free'.
 */
export function getPlanKey(restaurant) {
  const normalize = (key) => {
    if (!key) return null
    const k = String(key).toLowerCase()
    if (PLAN_LIMITS[k]) return k
    return LEGACY_ALIASES[k] || null
  }
  const tier = normalize(restaurant?.subscription_tier)
  if (tier && tier !== 'free') return tier
  const plan = normalize(restaurant?.plan)
  if (plan && plan !== 'free') return plan
  // Trial de 14 días: destraba el plan completo del rubro. Sin esto, el negocio
  // nuevo quedaba con límites Free (sin pedidos ni cocina) durante la "prueba
  // gratuita" y no podía probar justamente lo que se le vende (bug QA).
  if (isTrialing(restaurant)) {
    return restaurant?.business_type === 'restaurant' ? 'rest-combo' : 'local-mkt'
  }
  return 'free'
}

/**
 * Obtiene los límites del plan actual del restaurante
 */
export function getPlanLimits(restaurant) {
  return PLAN_LIMITS[getPlanKey(restaurant)] || PLAN_LIMITS['free']
}

/**
 * Verifica si el restaurante puede agregar más platos
 */
export function canAddMenuItem(restaurant, currentCount) {
  const limits = getPlanLimits(restaurant)
  if (limits.maxPlatos === -1) return { ok: true }
  return {
    ok: currentCount < limits.maxPlatos,
    limit: limits.maxPlatos,
    current: currentCount,
    message: `Plan ${limits.nombre} tiene un límite de ${limits.maxPlatos} platos. Actualizá tu plan para agregar más.`,
  }
}

/**
 * Verifica si el restaurante puede recibir pedidos
 */
export function canTakeOrders(restaurant) {
  const limits = getPlanLimits(restaurant)

  // Verificar feature del plan
  if (!limits.pedidos) {
    return {
      ok: false,
      message: `Tu plan ${limits.nombre} no incluye pedidos online. Actualizá a Solo Menú o Combo.`,
    }
  }

  // Verificar estado de suscripción
  if (restaurant.can_take_orders === false) {
    return {
      ok: false,
      message: 'Pedidos deshabilitados. Verificá el estado de tu suscripción.',
    }
  }

  return { ok: true }
}

/**
 * Verifica el estado de uso de mensajes de Tano
 */
export function getTanoStatus(restaurant) {
  const limits = getPlanLimits(restaurant)
  const used = restaurant.tano_messages_used || 0
  const limit = limits.tanoLimit === -1 ? null : limits.tanoLimit

  if (limit === null) {
    return { ok: true, unlimited: true }
  }

  const remaining = limit - used
  const percentage = (used / limit) * 100

  return {
    ok: remaining > 0,
    used,
    limit,
    remaining,
    percentage: Math.round(percentage),
    warning: remaining <= 15 && remaining > 0,
    exceeded: remaining <= 0,
  }
}

/**
 * Obtiene el nombre user-friendly del plan
 */
export function getPlanName(restaurant) {
  return getPlanLimits(restaurant).nombre
}

/**
 * Verifica si el restaurante está en trial
 */
export function isTrialing(restaurant) {
  // El alta usa trial_end; cuentas viejas pueden tener trial_ends_at (migración 011)
  const end = restaurant?.trial_end || restaurant?.trial_ends_at
  if (!end) return false
  return new Date(end) > new Date()
}

/**
 * Días restantes de trial
 */
export function trialDaysRemaining(restaurant) {
  const end = restaurant?.trial_end || restaurant?.trial_ends_at
  if (!end) return 0
  const diff = new Date(end) - new Date()
  return Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)))
}
