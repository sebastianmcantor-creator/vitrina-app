/**
 * db.js — Capa de abstracción sobre Supabase
 *
 * Patrón: módulos por entidad con operaciones nombradas.
 * El resto de la app importa de acá y nunca llama a supabase directamente,
 * lo que hace posible cambiar el backend sin tocar los consumers.
 */

import { supabase } from './supabase.js'

// ---------------------------------------------------------------------------
// Util interno
// ---------------------------------------------------------------------------
function assertNoError(error) {
  if (error) throw new Error(error.message)
}

// ---------------------------------------------------------------------------
// profiles
// ---------------------------------------------------------------------------
export const profiles = {
  async get(userId) {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()
    assertNoError(error)
    return data
  },

  async upsert({ id, full_name, avatar_url, email }) {
    const payload = { id, full_name, avatar_url, updated_at: new Date().toISOString() }
    if (email) payload.email = email
    const { data, error } = await supabase
      .from('profiles')
      .upsert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async getByEmail(email) {
    const { data, error } = await supabase
      .from('profiles')
      .select('*')
      .eq('email', email.toLowerCase().trim())
      .maybeSingle()
    assertNoError(error)
    return data
  },
}

// ---------------------------------------------------------------------------
// restaurants
// ---------------------------------------------------------------------------
export const restaurants = {
  /** Todos los restaurantes que el usuario posee o gestiona */
  async listByUser(userId) {
    const { data: owned, error: e1 } = await supabase
      .from('restaurants')
      .select('*')
      .eq('owner_id', userId)
      .order('created_at', { ascending: true })
    assertNoError(e1)

    const { data: staff, error: e2 } = await supabase
      .from('restaurant_staff')
      .select('restaurant_id, role, restaurants(*)')
      .eq('user_id', userId)
    assertNoError(e2)

    const staffRestaurants = (staff ?? []).map(s => ({ ...s.restaurants, _role: s.role }))
    const ownedIds = new Set((owned ?? []).map(r => r.id))
    const extra = staffRestaurants.filter(r => !ownedIds.has(r.id))

    return [...(owned ?? []).map(r => ({ ...r, _role: 'owner' })), ...extra]
  },

  /** Un restaurante por slug (lectura pública, incluye menú) */
  async getBySlug(slug) {
    const { data, error } = await supabase
      .from('restaurants')
      .select(`
        *,
        menu_categories(
          id, name, description, emoji, sort_order, is_visible,
          menu_items(*)
        )
      `)
      .eq('slug', slug)
      .eq('is_active', true)
      .single()
    assertNoError(error)
    return data
  },

  /** Un restaurante por id (autenticado) */
  async getById(id) {
    const { data, error } = await supabase
      .from('restaurants')
      .select('*')
      .eq('id', id)
      .single()
    assertNoError(error)
    return data
  },

  /** Crea un restaurante nuevo y agrega al usuario como owner */
  async create(payload) {
    const { data, error } = await supabase
      .from('restaurants')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async update(id, updates) {
    const { data, error } = await supabase
      .from('restaurants')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Verifica que un slug no esté en uso (devuelve true si está disponible) */
  async isSlugAvailable(slug, excludeId = null) {
    let query = supabase
      .from('restaurants')
      .select('id')
      .eq('slug', slug)
    if (excludeId) query = query.neq('id', excludeId)
    const { data, error } = await query
    assertNoError(error)
    return (data ?? []).length === 0
  },
}

// ---------------------------------------------------------------------------
// menuCategories
// ---------------------------------------------------------------------------
export const menuCategories = {
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('menu_categories')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('sort_order', { ascending: true })
    assertNoError(error)
    return data ?? []
  },

  async create(payload) {
    const { data, error } = await supabase
      .from('menu_categories')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async update(id, updates) {
    const { data, error } = await supabase
      .from('menu_categories')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async delete(id) {
    const { error } = await supabase
      .from('menu_categories')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// menuItems
// ---------------------------------------------------------------------------
export const menuItems = {
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('menu_items')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('sort_order', { ascending: true })
    assertNoError(error)
    return data ?? []
  },

  async create(payload) {
    const { data, error } = await supabase
      .from('menu_items')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async update(id, updates) {
    const { data, error } = await supabase
      .from('menu_items')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async delete(id) {
    const { error } = await supabase
      .from('menu_items')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// restaurantTables
// ---------------------------------------------------------------------------
export const restaurantTables = {
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('restaurant_tables')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('number', { ascending: true })
    assertNoError(error)
    return data ?? []
  },

  async create(payload) {
    const { data, error } = await supabase
      .from('restaurant_tables')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async update(id, updates) {
    const { data, error } = await supabase
      .from('restaurant_tables')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async delete(id) {
    const { error } = await supabase
      .from('restaurant_tables')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// restaurantStaff
// ---------------------------------------------------------------------------
export const restaurantStaff = {
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('restaurant_staff')
      .select('id, role, user_id, profiles(id, full_name, avatar_url, email)')
      .eq('restaurant_id', restaurantId)
    assertNoError(error)
    return data ?? []
  },

  async add(restaurantId, userId, role) {
    const { data, error } = await supabase
      .from('restaurant_staff')
      .insert({ restaurant_id: restaurantId, user_id: userId, role })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async updateRole(id, role) {
    const { data, error } = await supabase
      .from('restaurant_staff')
      .update({ role })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async remove(id) {
    const { error } = await supabase
      .from('restaurant_staff')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// orders
// ---------------------------------------------------------------------------
export const orders = {
  /** Staff: pedidos activos de un restaurante */
  async listActive(restaurantId) {
    const { data, error } = await supabase
      .from('orders')
      .select('*, order_items(*), customer_name')
      .eq('restaurant_id', restaurantId)
      .not('status', 'in', '("delivered","cancelled")')
      .order('created_at', { ascending: true })
    assertNoError(error)
    return data ?? []
  },

  async create(payload) {
    const { data, error } = await supabase
      .from('orders')
      .insert(payload)
      .select()
      .single()
    if (error) {
      // Si el error menciona customer_name, reintentar sin ese campo
      if (error.message && (error.message.includes('customer_name') || error.message.includes('column'))) {
        const { customer_name, ...payloadSinNombre } = payload
        const { data: data2, error: error2 } = await supabase
          .from('orders')
          .insert(payloadSinNombre)
          .select()
          .single()
        assertNoError(error2)
        return data2
      }
      assertNoError(error)
    }
    return data
  },

  async listHistory(restaurantId, days = 30, limit = 200) {
    const since = new Date()
    since.setDate(since.getDate() - days)
    const { data, error } = await supabase
      .from('orders')
      .select('id, total, created_at, status, table_number, customer_name, customer_phone, order_items(name, quantity)')
      .eq('restaurant_id', restaurantId)
      .in('status', ['delivered', 'cancelled'])
      .gte('created_at', since.toISOString())
      .order('created_at', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data ?? []
  },

  async getStats(restaurantId, days = 7, sinceOverride = null) {
    const since = sinceOverride ? new Date(sinceOverride) : (() => {
      const d = new Date(); d.setDate(d.getDate() - days); return d
    })()
    const { data, error } = await supabase
      .from('orders')
      .select('id, total, created_at, status, order_items(name, quantity, price)')
      .eq('restaurant_id', restaurantId)
      .gte('created_at', since.toISOString())
      .not('status', 'eq', 'cancelled')
    assertNoError(error)
    return data ?? []
  },

  async updateStatus(id, status) {
    const { data, error } = await supabase
      .from('orders')
      .update({ status, updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },
}

// ---------------------------------------------------------------------------
// orderItems
// ---------------------------------------------------------------------------
export const orderItems = {
  async createBatch(items) {
    // Sin .select(): el comensal anónimo puede INSERT pero no SELECT order_items
    // (la policy de lectura es solo-staff). Leer de vuelta daba 42501 y el pedido
    // "fallaba" aunque se insertara. No necesitamos el dato devuelto.
    const { error } = await supabase
      .from('order_items')
      .insert(items)
    assertNoError(error)
    return []
  },
}

// ---------------------------------------------------------------------------
// orderSessions
// ---------------------------------------------------------------------------
export const orderSessions = {
  async getOrCreate(restaurantId, tableNumber) {
    const { data: existing } = await supabase
      .from('order_sessions')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('table_number', tableNumber)
      .eq('status', 'open')
      .maybeSingle()

    if (existing) return existing

    const { data, error } = await supabase
      .from('order_sessions')
      .insert({ restaurant_id: restaurantId, table_number: tableNumber })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async close(id) {
    const { data, error } = await supabase
      .from('order_sessions')
      .update({ status: 'closed', closed_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },
}


// ---------------------------------------------------------------------------
// menuItemPriceHistory
// ---------------------------------------------------------------------------
export const menuItemPriceHistory = {
  async record(itemId, restaurantId, oldPrice, newPrice) {
    const { data, error } = await supabase
      .from('menu_item_price_history')
      .insert({ item_id: itemId, restaurant_id: restaurantId, old_price: oldPrice, new_price: newPrice })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  async getByItem(itemId, limit = 20) {
    const { data, error } = await supabase
      .from('menu_item_price_history')
      .select('*')
      .eq('item_id', itemId)
      .order('changed_at', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data ?? []
  },

  async getByRestaurant(restaurantId, limit = 50) {
    const { data, error } = await supabase
      .from('menu_item_price_history')
      .select('*, menu_items(name)')
      .eq('restaurant_id', restaurantId)
      .order('changed_at', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data ?? []
  },
}

// ---------------------------------------------------------------------------
// subscriptions
// ---------------------------------------------------------------------------
export const subscriptions = {
  /** Obtener suscripción activa de un restaurante */
  async getActive(restaurantId) {
    const { data, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('status', 'active')
      .maybeSingle()
    assertNoError(error)
    return data
  },

  /** Crear nueva suscripción */
  async create(payload) {
    const { data, error } = await supabase
      .from('subscriptions')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar suscripción */
  async update(id, updates) {
    const { data, error } = await supabase
      .from('subscriptions')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Cancelar suscripción */
  async cancel(id, reason = null) {
    const { data, error } = await supabase
      .from('subscriptions')
      .update({
        status: 'cancelled',
        cancelled_at: new Date().toISOString(),
        cancel_reason: reason,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Buscar suscripción por ID de MercadoPago */
  async getByMPId(mpSubscriptionId) {
    const { data, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('mp_subscription_id', mpSubscriptionId)
      .maybeSingle()
    assertNoError(error)
    return data
  },
}

// ---------------------------------------------------------------------------
// subscriptionPayments
// ---------------------------------------------------------------------------
export const subscriptionPayments = {
  /** Listar pagos de un restaurante */
  async listByRestaurant(restaurantId, limit = 50) {
    const { data, error } = await supabase
      .from('subscription_payments')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('created_at', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data ?? []
  },

  /** Crear registro de pago */
  async create(payload) {
    const { data, error } = await supabase
      .from('subscription_payments')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener pago por ID de MercadoPago */
  async getByMPId(mpPaymentId) {
    const { data, error } = await supabase
      .from('subscription_payments')
      .select('*')
      .eq('mp_payment_id', mpPaymentId)
      .maybeSingle()
    assertNoError(error)
    return data
  },

  /** Actualizar estado de pago */
  async updateStatus(id, status, statusDetail = null) {
    const { data, error } = await supabase
      .from('subscription_payments')
      .update({ status, status_detail: statusDetail })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },
}

// ---------------------------------------------------------------------------
// integrations
// ---------------------------------------------------------------------------
export const integrations = {
  /** Obtener integración por provider */
  async getByProvider(restaurantId, provider) {
    const { data, error } = await supabase
      .from('integrations')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('provider', provider)
      .maybeSingle()
    assertNoError(error)
    return data
  },

  /** Listar todas las integraciones de un restaurante */
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('integrations')
      .select('*')
      .eq('restaurant_id', restaurantId)
    assertNoError(error)
    return data ?? []
  },

  /** Crear o actualizar integración */
  async upsert(payload) {
    const { data, error } = await supabase
      .from('integrations')
      .upsert(payload, { onConflict: 'restaurant_id,provider' })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar tokens */
  async updateTokens(id, accessToken, refreshToken = null, expiresAt = null) {
    const updates = { access_token: accessToken, updated_at: new Date().toISOString() }
    if (refreshToken) updates.refresh_token = refreshToken
    if (expiresAt) updates.token_expires_at = expiresAt
    const { data, error } = await supabase
      .from('integrations')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Marcar última sincronización */
  async markSynced(id, error = null) {
    const updates = {
      last_sync_at: new Date().toISOString(),
      last_error: error,
      updated_at: new Date().toISOString(),
    }
    const { data, error: dbError } = await supabase
      .from('integrations')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(dbError)
    return data
  },

  /** Desconectar integración */
  async disconnect(id) {
    const { error } = await supabase
      .from('integrations')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// analyticsCache
// ---------------------------------------------------------------------------
export const analyticsCache = {
  /** Obtener datos cacheados */
  async get(restaurantId, provider, metricType, periodStart, periodEnd) {
    const { data, error } = await supabase
      .from('analytics_cache')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('provider', provider)
      .eq('metric_type', metricType)
      .eq('period_start', periodStart)
      .eq('period_end', periodEnd)
      .gt('expires_at', new Date().toISOString())
      .maybeSingle()
    assertNoError(error)
    return data
  },

  /** Guardar en cache */
  async set(payload) {
    const { data, error } = await supabase
      .from('analytics_cache')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },
}

// ---------------------------------------------------------------------------
// competitors
// ---------------------------------------------------------------------------
export const competitors = {
  /** Listar competidores de un restaurante */
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('competitors')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('rating', { ascending: false })
    assertNoError(error)
    return data ?? []
  },

  /** Crear competidor */
  async create(payload) {
    const { data, error } = await supabase
      .from('competitors')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar métricas de competidor */
  async updateMetrics(id, rating, reviewsCount) {
    const { data, error } = await supabase
      .from('competitors')
      .update({
        rating,
        reviews_count: reviewsCount,
        last_checked_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Eliminar competidor */
  async delete(id) {
    const { error } = await supabase
      .from('competitors')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// scheduledPosts
// ---------------------------------------------------------------------------
export const scheduledPosts = {
  /** Listar posts programados de un restaurante */
  async listByRestaurant(restaurantId, status = null) {
    let query = supabase
      .from('scheduled_posts')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('scheduled_for', { ascending: true })

    if (status) {
      query = query.eq('status', status)
    }

    const { data, error } = await query
    assertNoError(error)
    return data ?? []
  },

  /** Obtener post por ID */
  async getById(id) {
    const { data, error } = await supabase
      .from('scheduled_posts')
      .select('*')
      .eq('id', id)
      .single()
    assertNoError(error)
    return data
  },

  /** Crear post programado */
  async create(payload) {
    const { data, error } = await supabase
      .from('scheduled_posts')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar post */
  async update(id, updates) {
    const { data, error } = await supabase
      .from('scheduled_posts')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Cancelar post programado */
  async cancel(id) {
    const { data, error } = await supabase
      .from('scheduled_posts')
      .update({ status: 'cancelled', updated_at: new Date().toISOString() })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Eliminar post */
  async delete(id) {
    const { error } = await supabase
      .from('scheduled_posts')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },

  /** Obtener posts para publicar (scheduled y fecha pasada) */
  async getPostsToPublish() {
    const { data, error } = await supabase
      .from('scheduled_posts')
      .select('*')
      .eq('status', 'scheduled')
      .lte('scheduled_for', new Date().toISOString())
      .order('scheduled_for', { ascending: true })
    assertNoError(error)
    return data ?? []
  },
}

// ---------------------------------------------------------------------------
// contentTemplates
// ---------------------------------------------------------------------------
export const contentTemplates = {
  /** Listar templates de un restaurante */
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('content_templates')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('times_used', { ascending: false })
    assertNoError(error)
    return data ?? []
  },

  /** Crear template */
  async create(payload) {
    const { data, error } = await supabase
      .from('content_templates')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Incrementar uso de template */
  async incrementUsage(id) {
    const { data, error } = await supabase.rpc('increment_template_usage', { template_id: id })
    // Si el RPC no existe, usar update manual
    if (error) {
      const template = await this.getById(id)
      return await supabase
        .from('content_templates')
        .update({
          times_used: (template.times_used || 0) + 1,
          last_used_at: new Date().toISOString(),
        })
        .eq('id', id)
        .select()
        .single()
    }
    return data
  },

  /** Obtener template por ID */
  async getById(id) {
    const { data, error } = await supabase
      .from('content_templates')
      .select('*')
      .eq('id', id)
      .single()
    assertNoError(error)
    return data
  },

  /** Eliminar template */
  async delete(id) {
    const { error } = await supabase
      .from('content_templates')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ---------------------------------------------------------------------------
// contentCalendarSuggestions
// ---------------------------------------------------------------------------
export const contentCalendarSuggestions = {
  /** Listar sugerencias pendientes de un restaurante */
  async listByRestaurant(restaurantId, status = 'pending') {
    const { data, error } = await supabase
      .from('content_calendar_suggestions')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('status', status)
      .order('suggested_date', { ascending: true })
    assertNoError(error)
    return data ?? []
  },

  /** Crear sugerencia */
  async create(payload) {
    const { data, error } = await supabase
      .from('content_calendar_suggestions')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Aceptar sugerencia */
  async accept(id, scheduledPostId) {
    const { data, error } = await supabase
      .from('content_calendar_suggestions')
      .update({ status: 'accepted', scheduled_post_id: scheduledPostId })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Rechazar sugerencia */
  async reject(id) {
    const { data, error } = await supabase
      .from('content_calendar_suggestions')
      .update({ status: 'rejected' })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Eliminar sugerencia */
  async delete(id) {
    const { error } = await supabase
      .from('content_calendar_suggestions')
      .delete()
      .eq('id', id)
    assertNoError(error)
  },
}

// ═══════════════════════════════════════════════════════════════════════════
// SALES AGENT
// ═══════════════════════════════════════════════════════════════════════════

export const salesProspects = {
  /** Listar todos los prospectos con filtros opcionales */
  async list(filters = {}) {
    let query = supabase
      .from('sales_prospects')
      .select('*')
      .order('discovered_at', { ascending: false })

    if (filters.status) {
      query = query.eq('status', filters.status)
    }
    if (filters.city) {
      query = query.eq('city', filters.city)
    }
    if (filters.min_fit_score) {
      query = query.gte('fit_score', filters.min_fit_score)
    }

    const { data, error } = await query
    assertNoError(error)
    return data || []
  },

  /** Obtener prospecto por ID */
  async getById(id) {
    const { data, error } = await supabase
      .from('sales_prospects')
      .select('*')
      .eq('id', id)
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener prospecto por place_id de Google */
  async getByPlaceId(placeId) {
    const { data, error } = await supabase
      .from('sales_prospects')
      .select('*')
      .eq('place_id', placeId)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Crear nuevo prospecto */
  async create(payload) {
    const { data, error } = await supabase
      .from('sales_prospects')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar prospecto */
  async update(id, updates) {
    const { data, error } = await supabase
      .from('sales_prospects')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Marcar como contactado */
  async markContacted(id) {
    return this.update(id, {
      status: 'contacted',
      last_contact_at: new Date().toISOString(),
    })
  },

  /** Marcar como interesado */
  async markInterested(id, notes = null) {
    const updates = { status: 'interested' }
    if (notes) updates.notes = notes
    return this.update(id, updates)
  },

  /** Marcar como convertido */
  async markConverted(id) {
    return this.update(id, {
      status: 'converted',
      converted_at: new Date().toISOString(),
    })
  },

  /** Obtener prospectos que necesitan seguimiento */
  async getNeedingFollowup() {
    const threeDaysAgo = new Date()
    threeDaysAgo.setDate(threeDaysAgo.getDate() - 3)

    const { data, error } = await supabase
      .from('sales_prospects')
      .select('*')
      .eq('status', 'contacted')
      .lt('last_contact_at', threeDaysAgo.toISOString())
    assertNoError(error)
    return data || []
  },

  /** Obtener estadísticas generales */
  async getStats() {
    const { data, error } = await supabase
      .from('sales_prospects')
      .select('status')

    assertNoError(error)

    const stats = {
      total: data?.length || 0,
      discovered: 0,
      contacted: 0,
      interested: 0,
      not_interested: 0,
      converted: 0,
      invalid: 0,
    }

    data?.forEach(p => {
      if (stats[p.status] !== undefined) {
        stats[p.status]++
      }
    })

    return stats
  },
}

export const salesContacts = {
  /** Listar contactos de un prospecto */
  async listByProspect(prospectId) {
    const { data, error } = await supabase
      .from('sales_contacts')
      .select('*')
      .eq('prospect_id', prospectId)
      .order('created_at', { ascending: false })
    assertNoError(error)
    return data || []
  },

  /** Crear nuevo contacto */
  async create(payload) {
    const { data, error } = await supabase
      .from('sales_contacts')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar estado de contacto */
  async updateStatus(id, status, errorMessage = null) {
    const updates = { status }
    if (errorMessage) updates.error_message = errorMessage
    if (status === 'sent' || status === 'delivered') {
      updates.status = status
    }

    const { data, error } = await supabase
      .from('sales_contacts')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Registrar respuesta del prospecto */
  async registerResponse(id, response, interested) {
    const { data, error } = await supabase
      .from('sales_contacts')
      .update({
        status: 'replied',
        response,
        response_at: new Date().toISOString(),
        interested,
      })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Marcar seguimiento como enviado */
  async markFollowupSent(id) {
    const { data, error } = await supabase
      .from('sales_contacts')
      .update({ followup_sent: true })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener contactos pendientes de seguimiento */
  async getPendingFollowups() {
    const now = new Date().toISOString()
    const { data, error } = await supabase
      .from('sales_contacts')
      .select('*, sales_prospects(*)')
      .eq('followup_sent', false)
      .not('followup_scheduled', 'is', null)
      .lte('followup_scheduled', now)
    assertNoError(error)
    return data || []
  },
}

export const salesAgentConfig = {
  /** Obtener configuración actual */
  async get() {
    const { data, error } = await supabase
      .from('sales_agent_config')
      .select('*')
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar configuración */
  async update(updates) {
    const { data, error } = await supabase
      .from('sales_agent_config')
      .update(updates)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Activar/desactivar agente */
  async setActive(isActive) {
    return this.update({ is_active: isActive })
  },

  /** Actualizar templates de mensajes */
  async updateTemplates(whatsappTemplate, followupTemplate) {
    return this.update({
      whatsapp_template: whatsappTemplate,
      followup_template: followupTemplate,
    })
  },

  /** Actualizar áreas de búsqueda */
  async updateSearchLocations(locations) {
    return this.update({ search_locations: locations })
  },
}

export const salesMetrics = {
  /** Obtener métricas de una fecha */
  async getByDate(date) {
    const { data, error } = await supabase
      .from('sales_metrics')
      .select('*')
      .eq('date', date)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Incrementar contador */
  async increment(date, field, amount = 1) {
    // Primero intentar obtener el registro
    const existing = await this.getByDate(date)

    if (existing) {
      // Actualizar existente
      const { data, error } = await supabase
        .from('sales_metrics')
        .update({ [field]: existing[field] + amount })
        .eq('date', date)
        .select()
        .single()
      assertNoError(error)
      return data
    } else {
      // Crear nuevo
      const { data, error } = await supabase
        .from('sales_metrics')
        .insert({ date, [field]: amount })
        .select()
        .single()
      assertNoError(error)
      return data
    }
  },

  /** Obtener métricas de los últimos N días */
  async getLastDays(days = 30) {
    const startDate = new Date()
    startDate.setDate(startDate.getDate() - days)

    const { data, error } = await supabase
      .from('sales_metrics')
      .select('*')
      .gte('date', startDate.toISOString().split('T')[0])
      .order('date', { ascending: false })
    assertNoError(error)
    return data || []
  },

  /** Obtener resumen total */
  async getTotals() {
    const { data, error } = await supabase
      .from('sales_metrics')
      .select('*')
    assertNoError(error)

    const totals = {
      prospects_found: 0,
      prospects_contacted: 0,
      responses_received: 0,
      interested_count: 0,
      not_interested_count: 0,
      converted_count: 0,
      whatsapp_cost: 0,
      api_cost: 0,
    }

    data?.forEach(m => {
      totals.prospects_found += m.prospects_found || 0
      totals.prospects_contacted += m.prospects_contacted || 0
      totals.responses_received += m.responses_received || 0
      totals.interested_count += m.interested_count || 0
      totals.not_interested_count += m.not_interested_count || 0
      totals.converted_count += m.converted_count || 0
      totals.whatsapp_cost += parseFloat(m.whatsapp_cost || 0)
      totals.api_cost += parseFloat(m.api_cost || 0)
    })

    return totals
  },
}

// ═══════════════════════════════════════════════════════════════════════════
// PRODUCERS
// ═══════════════════════════════════════════════════════════════════════════

export const producers = {
  /** Listar todos los productores */
  async list(activeOnly = false) {
    let query = supabase
      .from('producers')
      .select('*')
      .order('name', { ascending: true })

    if (activeOnly) {
      query = query.eq('active', true)
    }

    const { data, error } = await query
    assertNoError(error)
    return data || []
  },

  /** Obtener productor por ID */
  async getById(id) {
    const { data, error } = await supabase
      .from('producers')
      .select('*')
      .eq('id', id)
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener productor por email */
  async getByEmail(email) {
    const { data, error } = await supabase
      .from('producers')
      .select('*')
      .eq('email', email)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Crear productor */
  async create(payload) {
    const { data, error } = await supabase
      .from('producers')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Actualizar productor */
  async update(id, updates) {
    const { data, error } = await supabase
      .from('producers')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener estadísticas de un productor */
  async getStats(producerId) {
    // Contar restaurantes por estado
    const { data: restaurants, error: restError } = await supabase
      .from('restaurants')
      .select('subscription_status, subscription_tier')
      .eq('producer_id', producerId)
    assertNoError(restError)

    const stats = {
      total_clients: restaurants?.length || 0,
      active_clients: restaurants?.filter(r => r.subscription_status === 'active').length || 0,
      by_plan: {
        free: 0,
        basic: 0,
        pro: 0,
        full: 0,
      }
    }

    restaurants?.forEach(r => {
      const plan = r.subscription_tier || 'free'
      if (stats.by_plan[plan] !== undefined) {
        stats.by_plan[plan]++
      }
    })

    return stats
  },
}

export const producerCommissions = {
  /** Listar comisiones de un productor */
  async listByProducer(producerId, status = null) {
    let query = supabase
      .from('producer_commissions')
      .select('*, restaurants(name), producers(name)')
      .eq('producer_id', producerId)
      .order('created_at', { ascending: false })

    if (status) {
      query = query.eq('status', status)
    }

    const { data, error } = await query
    assertNoError(error)
    return data || []
  },

  /** Listar comisiones pendientes de un productor en un período */
  async getPendingByProducerAndPeriod(producerId, periodMonth) {
    const { data, error } = await supabase
      .from('producer_commissions')
      .select('*, restaurants(name)')
      .eq('producer_id', producerId)
      .eq('period_month', periodMonth)
      .eq('status', 'pending')
      .order('created_at', { ascending: false })
    assertNoError(error)
    return data || []
  },

  /** Crear comisión */
  async create(payload) {
    const { data, error } = await supabase
      .from('producer_commissions')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Marcar comisión como pagada */
  async markAsPaid(id, paymentMethod, paymentReference = null) {
    const { data, error } = await supabase
      .from('producer_commissions')
      .update({
        status: 'paid',
        paid_at: new Date().toISOString(),
        payment_method: paymentMethod,
        payment_reference: paymentReference,
      })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Marcar múltiples comisiones como pagadas */
  async markMultipleAsPaid(ids, paymentMethod, paymentReference = null) {
    const { data, error } = await supabase
      .from('producer_commissions')
      .update({
        status: 'paid',
        paid_at: new Date().toISOString(),
        payment_method: paymentMethod,
        payment_reference: paymentReference,
      })
      .in('id', ids)
      .select()
    assertNoError(error)
    return data || []
  },

  /** Calcular total de comisiones pendientes de un productor */
  async getTotalPending(producerId, periodMonth = null) {
    let query = supabase
      .from('producer_commissions')
      .select('commission_amount')
      .eq('producer_id', producerId)
      .eq('status', 'pending')

    if (periodMonth) {
      query = query.eq('period_month', periodMonth)
    }

    const { data, error } = await query
    assertNoError(error)

    const total = data?.reduce((sum, c) => sum + parseFloat(c.commission_amount || 0), 0) || 0
    return total
  },

  /** Obtener resumen de comisiones por productor y período */
  async getSummaryByPeriod(periodMonth) {
    const { data, error } = await supabase
      .from('producer_commissions')
      .select('producer_id, commission_amount, status, producers(name, email)')
      .eq('period_month', periodMonth)

    assertNoError(error)

    // Agrupar por productor
    const summary = {}
    data?.forEach(c => {
      const pid = c.producer_id
      if (!summary[pid]) {
        summary[pid] = {
          producer_id: pid,
          producer_name: c.producers?.name || 'Sin nombre',
          producer_email: c.producers?.email || '',
          total_pending: 0,
          total_paid: 0,
          total: 0,
        }
      }

      const amount = parseFloat(c.commission_amount || 0)
      if (c.status === 'pending') {
        summary[pid].total_pending += amount
      } else if (c.status === 'paid') {
        summary[pid].total_paid += amount
      }
      summary[pid].total += amount
    })

    return Object.values(summary)
  },
}

export const masterDashboardCache = {
  /** Obtener cache por key */
  async get(cacheKey) {
    const { data, error } = await supabase
      .from('master_dashboard_cache')
      .select('*')
      .eq('cache_key', cacheKey)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Crear o actualizar cache */
  async upsert(cacheKey, payload) {
    // Intentar obtener existente
    const existing = await this.get(cacheKey)

    if (existing) {
      // Actualizar
      const { data, error } = await supabase
        .from('master_dashboard_cache')
        .update({
          ...payload,
          cached_at: new Date().toISOString(),
        })
        .eq('cache_key', cacheKey)
        .select()
        .single()
      assertNoError(error)
      return data
    } else {
      // Crear
      const { data, error } = await supabase
        .from('master_dashboard_cache')
        .insert({
          cache_key: cacheKey,
          ...payload,
          cached_at: new Date().toISOString(),
        })
        .select()
        .single()
      assertNoError(error)
      return data
    }
  },

  /** Verificar si el cache está fresco (menos de 1 hora) */
  async isFresh(cacheKey) {
    const cache = await this.get(cacheKey)
    if (!cache) return false

    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000)
    const cachedAt = new Date(cache.cached_at)

    return cachedAt > oneHourAgo
  },
}

// ═══════════════════════════════════════════════════════════════════════════
// EXCHANGE RATES
// ═══════════════════════════════════════════════════════════════════════════

export const exchangeRates = {
  /** Obtener tipo de cambio más reciente */
  async getCurrent() {
    const { data, error } = await supabase
      .from('exchange_rates')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Obtener historial de tipos de cambio */
  async getHistory(limit = 30) {
    const { data, error } = await supabase
      .from('exchange_rates')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data || []
  },

  /** Registrar nuevo tipo de cambio */
  async record(usdArs, source = 'bluelytics') {
    // Obtener el anterior
    const previous = await this.getCurrent()
    const previousRate = previous?.usd_ars || null
    const variationPct = previousRate ? ((usdArs - previousRate) / previousRate * 100).toFixed(2) : 0

    const { data, error } = await supabase
      .from('exchange_rates')
      .insert({
        usd_ars: usdArs,
        source,
        previous_rate: previousRate,
        variation_pct: variationPct,
        notified: false,
      })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Marcar como notificado */
  async markAsNotified(id) {
    const { data, error } = await supabase
      .from('exchange_rates')
      .update({
        notified: true,
        notification_sent_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener pendientes de notificar (variación >2%) */
  async getPendingNotifications() {
    const { data, error } = await supabase
      .from('exchange_rates')
      .select('*')
      .eq('notified', false)
      .or('variation_pct.gte.2,variation_pct.lte.-2')
      .order('created_at', { ascending: false })
    assertNoError(error)
    return data || []
  },
}

export const exchangeRateNotifications = {
  /** Registrar notificación enviada */
  async record(exchangeRateId, variationPct, notificationType, stats) {
    const { data, error } = await supabase
      .from('exchange_rate_notifications')
      .insert({
        exchange_rate_id: exchangeRateId,
        variation_pct: variationPct,
        notification_type: notificationType,
        restaurants_notified: stats.restaurants || 0,
        emails_sent: stats.emails || 0,
        whatsapp_sent: stats.whatsapp || 0,
        message: stats.message || null,
      })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener historial de notificaciones */
  async getHistory(limit = 20) {
    const { data, error } = await supabase
      .from('exchange_rate_notifications')
      .select('*, exchange_rates(*)')
      .order('created_at', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data || []
  },
}

// ═══════════════════════════════════════════════════════════════════════════
// EXECUTIVE REPORTS
// ═══════════════════════════════════════════════════════════════════════════

export const marketingProjections = {
  /** Crear proyección para un mes */
  async create(payload) {
    const { data, error } = await supabase
      .from('marketing_projections')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener proyección por restaurante y período */
  async getByRestaurantAndPeriod(restaurantId, periodMonth) {
    const { data, error } = await supabase
      .from('marketing_projections')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('period_month', periodMonth)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Listar proyecciones de un restaurante */
  async listByRestaurant(restaurantId) {
    const { data, error } = await supabase
      .from('marketing_projections')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('period_start', { ascending: false })
    assertNoError(error)
    return data || []
  },

  /** Actualizar proyección */
  async update(id, updates) {
    const { data, error } = await supabase
      .from('marketing_projections')
      .update(updates)
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },
}

export const executiveReports = {
  /** Crear informe ejecutivo */
  async create(payload) {
    const { data, error } = await supabase
      .from('executive_reports')
      .insert(payload)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener informe por restaurante y período */
  async getByRestaurantAndPeriod(restaurantId, periodMonth) {
    const { data, error } = await supabase
      .from('executive_reports')
      .select('*, marketing_projections(*)')
      .eq('restaurant_id', restaurantId)
      .eq('period_month', periodMonth)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Listar informes de un restaurante */
  async listByRestaurant(restaurantId, limit = 12) {
    const { data, error } = await supabase
      .from('executive_reports')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .order('report_date', { ascending: false })
      .limit(limit)
    assertNoError(error)
    return data || []
  },

  /** Marcar informe como enviado */
  async markAsSent(id, emails) {
    const { data, error } = await supabase
      .from('executive_reports')
      .update({
        sent_at: new Date().toISOString(),
        sent_to: emails,
      })
      .eq('id', id)
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener informes pendientes de envío */
  async getPendingToSend() {
    const { data, error } = await supabase
      .from('executive_reports')
      .select('*, restaurants(name, email)')
      .is('sent_at', null)
      .order('created_at', { ascending: true })
    assertNoError(error)
    return data || []
  },
}

export const monthlyMetricsSnapshots = {
  /** Crear snapshot */
  async create(payload) {
    // Usar upsert para evitar duplicados
    const { data, error } = await supabase
      .from('monthly_metrics_snapshots')
      .upsert(payload, {
        onConflict: 'restaurant_id,period_month,snapshot_type',
        ignoreDuplicates: false,
      })
      .select()
      .single()
    assertNoError(error)
    return data
  },

  /** Obtener snapshots de un restaurante en un período */
  async getByRestaurantAndPeriod(restaurantId, periodMonth) {
    const { data, error } = await supabase
      .from('monthly_metrics_snapshots')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('period_month', periodMonth)
      .order('snapshot_type', { ascending: true })
    assertNoError(error)
    return data || []
  },

  /** Obtener último snapshot de inicio de mes */
  async getLatestStart(restaurantId) {
    const { data, error } = await supabase
      .from('monthly_metrics_snapshots')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('snapshot_type', 'start')
      .order('snapshot_date', { ascending: false })
      .limit(1)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },

  /** Obtener último snapshot de fin de mes */
  async getLatestEnd(restaurantId) {
    const { data, error } = await supabase
      .from('monthly_metrics_snapshots')
      .select('*')
      .eq('restaurant_id', restaurantId)
      .eq('snapshot_type', 'end')
      .order('snapshot_date', { ascending: false })
      .limit(1)
      .maybeSingle()
    if (error && error.code !== 'PGRST116') {
      throw error
    }
    return data
  },
}
