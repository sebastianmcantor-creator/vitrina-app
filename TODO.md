# Vitrina — Tareas pendientes

> Para retomar: abrí Claude Code y decí **"continuá con el TODO"**.  
> Marcar cada tarea como `[x]` al completarla y hacer commit.

---

## 🚨 SQL pendiente (Sebastián debe correr esto en Supabase)

### ✅ orders_public_select — Ejecutado el 2026-05-03

### ✅ Email en profiles — Ejecutado el 2026-05-03

---

## Prioridad 1 — Tiempo real en cocina

### [x] Supabase Realtime en cocina.html
Reemplazar el `setInterval(fetchPedidos, 10000)` por un canal Realtime de Supabase.

**Cómo:**
```js
supabase
  .channel('orders-' + rest.id)
  .on('postgres_changes', {
    event: '*',
    schema: 'public',
    table: 'orders',
    filter: 'restaurant_id=eq.' + rest.id
  }, payload => {
    // actualizar pedidos y re-renderizar
  })
  .subscribe()
```
Mantener el fetch inicial para cargar el estado actual. Cancelar suscripción si el usuario cierra/navega.

**Nota:** Requiere que Supabase Realtime esté habilitado para la tabla `orders` en el dashboard (Database → Replication → supabase_realtime publication → agregar tabla orders).

### [x] Supabase Realtime en menu.html (overlay de estado)
Reemplazar `setInterval(poll, 5000)` por Realtime en `abrirOverlayEstado()`. Misma mecánica que cocina.

---

## Prioridad 2 — Panel: completar secciones

### [x] Sección Pedidos en panel.html
Vista de pedidos activos del restaurante, similar a cocina.html pero integrada al panel.

**Cómo:**
- `section-pedidos`: reemplazar "coming soon" con una lista de pedidos activos
- Usar `orders.listActive(currentRestaurant.id)` — ya existe en db.js
- Mostrar: mesa, items, total, estado, hora
- Botones para cambiar estado (misma lógica que cocina.html)
- Polling o Realtime (hacer después de Prioridad 1)

### [x] Links rápidos en panel.html
Agregar en la sección Información (debajo de las acciones de guardar) un bloque con:
- Botón "Ver menú público" → abre `menu.html?slug={slug}` en nueva pestaña
- Botón "Panel de cocina" → abre `cocina.html?slug={slug}` en nueva pestaña
- Botón "Ver asistente" → abre `mozo.html?slug={slug}&mesa=1` en nueva pestaña

**Cómo:** simple HTML con `window.open(url, '_blank')` usando `currentRestaurant.slug`.

---

## Prioridad 3 — Estadísticas básicas

### [x] Sección Estadísticas en panel.html
Reemplazar "coming soon" con un dashboard básico.

**Métricas a mostrar:**
- Pedidos de hoy (count) y total en pesos
- Pedidos de los últimos 7 días (gráfico de barras simple con CSS, sin librería)
- Top 5 platos más pedidos (JOIN orders → order_items, GROUP BY name)
- Ticket promedio

**Cómo:**
Necesita nuevas queries en `lib/db.js` — agregar en el módulo `orders`:
```js
async getStats(restaurantId, days = 7) {
  // orders del último período
  const since = new Date()
  since.setDate(since.getDate() - days)
  const { data } = await supabase
    .from('orders')
    .select('id, total, created_at, status, order_items(name, quantity, price)')
    .eq('restaurant_id', restaurantId)
    .gte('created_at', since.toISOString())
    .not('status', 'eq', 'cancelled')
  return data ?? []
}
```
Calcular métricas en el frontend a partir del array devuelto.

---

## Prioridad 4 — Pulido y UX

### [x] Descargar/imprimir QR desde panel (sección Mesas)
En cada mesa-card, agregar botón "⬇️ Descargar QR" que descargue la imagen del QR.

**Cómo:**
```js
async function downloadQr(number) {
  const url = menuUrl(number)
  const qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=' + encodeURIComponent(url)
  const a = document.createElement('a')
  a.href = qrUrl
  a.download = 'qr-mesa-' + number + '.png'
  a.click()
}
```

### [x] Estado "Cerrado" en menu.html
Si `rest.is_open === false`, mostrar un banner en el header: "🔒 El restaurante está cerrado" y deshabilitar el botón de checkout.

**Cómo:** En `init()` de menu.html, después de cargar `rest`, agregar:
```js
if (!rest.is_open) {
  // mostrar banner, deshabilitar checkout
}
```

### [x] Manejo de sesión expirada en cocina.html
Si el token de Supabase expira durante la sesión (turno largo), reautenticar silenciosamente.

**Cómo:** Escuchar `supabase.auth.onAuthStateChange` y si el evento es `SIGNED_OUT`, mostrar el botón de login de nuevo sin recargar la página.

### [x] Validación de mesa en menu.html
Si `?mesa=` está ausente o no es un número válido, mostrar un aviso (no bloquear el menú pero no permitir confirmar pedido sin mesa).

### [x] Imagen de plato en editor de menú (panel)
El campo `image_url` existe en `menu_items` pero no está en el modal. Agregar un campo de URL de imagen en el modal de plato.

---

## Prioridad 5 — Multi-tenant completo

### [ ] cocina.html: tabla `restaurant_tables` RLS
La política actual `tables_staff_all` requiere auth para leer mesas.
`orders.listActive()` incluye `table_number` (INTEGER) que es suficiente para mostrar "Mesa X".
✅ No es bloqueante — cocina ya muestra el número de mesa sin necesitar la tabla de mesas.

### [x] Gestión de staff en panel
Sección para invitar colaboradores (mozos, cocineros) al restaurante.

**Schema ya existe:** tabla `restaurant_staff` con `user_id`, `role`, `restaurant_id`.
**Cómo:** formulario con email del usuario → buscar en `profiles` → insertar en `restaurant_staff`.
⚠️ Requiere un paso extra: buscar perfil por email (Supabase Auth no expone emails públicamente por defecto).

---

## Deuda técnica

- [x] Cloudflare Worker (`vitrina-worker.vitrinaapp.workers.dev`) — eliminado del código. Borrar desde Cloudflare Dashboard → Workers & Pages → vitrina-worker → Delete.
- [ ] `mozo.html` usa un backend Railway (`proud-illumination-production-ed01.up.railway.app`) para llamar a la API de Claude. Si ese servicio se cae, el asistente no funciona. Evaluar migrar a Cloudflare Workers AI o mantener como está.
- [x] `orders.getByIds()` eliminado de db.js (código muerto).

### ⏳ SQL opcional — Policy de lectura de profiles

Si la gestión de equipo falla al buscar colaboradores por email, correr:

```sql
-- Permite que usuarios autenticados lean todos los perfiles (necesario para buscar por email)
CREATE POLICY "authenticated_read_profiles" ON public.profiles
  FOR SELECT TO authenticated USING (true);
```

---

## Estado del flujo completo (mayo 2026)

```
Cliente escanea QR (mesa X)
  └─> menu.html?slug=X&mesa=N        ✅ funciona
        └─> banner "cerrado" si is_open=false ✅
        └─> advertencia si falta ?mesa  ✅
        └─> pide con carrito           ✅
        └─> confirma → Supabase        ✅
        └─> overlay estado Realtime    ✅
        └─> "Consultá al mozo"         ✅ (Claude via Railway)

Staff en cocina
  └─> cocina.html?slug=X             ✅
        └─> login Google              ✅
        └─> ver/cambiar estados       ✅ (Realtime)
        └─> sesión expirada → re-login ✅

Dueño en panel
  └─> panel.html                     ✅
        └─> info restaurante          ✅
        └─> links rápidos (menú/cocina/mozo) ✅
        └─> editor de menú + imagen   ✅
        └─> gestión de mesas + QR     ✅ (descarga QR 400px)
        └─> pedidos Realtime + badge global ✅
        └─> estadísticas (KPIs + gráfico + top platos) ✅
        └─> configuración / equipo    ✅ (agregar/editar/eliminar staff)
```
