/**
 * plans.js — Lógica de límites y features por plan
 */

// Definición de planes y sus límites
export const PLAN_LIMITS = {
  'menu-free': {
    nombre: 'Menú Free',
    precio: 0,
    maxPlatos: 45,
    maxSucursales: 1,
    tanoLimit: 75,
    pedidos: false,
    cocina: false,
    pagos: false,
  },
  'menu-basico': {
    nombre: 'Menú Básico',
    precio: 12,
    maxPlatos: -1, // ilimitado
    maxSucursales: 1,
    tanoLimit: -1, // ilimitado
    pedidos: false,
    cocina: false,
    pagos: false,
  },
  'menu-pro': {
    nombre: 'Menú Pro',
    precio: 22,
    maxPlatos: -1,
    maxSucursales: 1,
    tanoLimit: -1,
    pedidos: true,
    cocina: true,
    pagos: true,
  },
  'menu-full': {
    nombre: 'Menú Full',
    precio: 35,
    maxPlatos: -1,
    maxSucursales: 3,
    tanoLimit: -1,
    pedidos: true,
    cocina: true,
    pagos: true,
  },
}

/**
 * Obtiene los límites del plan actual del restaurante
 */
export function getPlanLimits(restaurant) {
  const planKey = getPlanKey(restaurant)
  return PLAN_LIMITS[planKey] || PLAN_LIMITS['menu-free']
}

/**
 * Genera la key del plan del restaurante (ej: 'menu-pro')
 */
function getPlanKey(restaurant) {
  // Si tiene subscription_tier, usarlo
  if (restaurant.subscription_tier && restaurant.subscription_tier !== 'free') {
    return 'menu-' + restaurant.subscription_tier
  }
  // Fallback: usar el campo plan legacy
  if (restaurant.plan && restaurant.plan !== 'free') {
    return 'menu-' + restaurant.plan
  }
  return 'menu-free'
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
      message: `Tu plan ${limits.nombre} no incluye pedidos online. Actualizá a un plan Pro o Full.`,
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
  const limits = getPlanLimits(restaurant)
  return limits.nombre
}

/**
 * Verifica si el restaurante está en trial
 */
export function isTrialing(restaurant) {
  if (!restaurant.trial_ends_at) return false
  const trialEnd = new Date(restaurant.trial_ends_at)
  return trialEnd > new Date()
}

/**
 * Días restantes de trial
 */
export function trialDaysRemaining(restaurant) {
  if (!restaurant.trial_ends_at) return 0
  const trialEnd = new Date(restaurant.trial_ends_at)
  const now = new Date()
  const diff = trialEnd - now
  return Math.ceil(diff / (1000 * 60 * 60 * 24))
}
