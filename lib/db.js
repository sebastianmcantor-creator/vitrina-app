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

  async upsert({ id, full_name, avatar_url }) {
    const { data, error } = await supabase
      .from('profiles')
      .upsert({ id, full_name, avatar_url, updated_at: new Date().toISOString() })
      .select()
      .single()
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
// orders
// ---------------------------------------------------------------------------
export const orders = {
  /** Staff: pedidos activos de un restaurante */
  async listActive(restaurantId) {
    const { data, error } = await supabase
      .from('orders')
      .select('*, order_items(*)')
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
    assertNoError(error)
    return data
  },

  async getByIds(ids) {
    if (!ids || ids.length === 0) return []
    const { data, error } = await supabase
      .from('orders')
      .select('id, status')
      .in('id', ids)
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
    const { data, error } = await supabase
      .from('order_items')
      .insert(items)
      .select()
    assertNoError(error)
    return data ?? []
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
