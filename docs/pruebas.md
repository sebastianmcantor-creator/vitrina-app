# Vitrina — Estado de testing y QA

**Última actualización: 2026-06-10**

---

## QA ronda 2 (10/06/2026) — estado de los bugs

QA externo navegando producción (vitrinaapp.com.ar). Fixes aplicados el 10/06 (commit `1355589` frontend + deploy worker):

| # | Severidad | Área | Problema | Estado |
|---|-----------|------|----------|--------|
| 1 | 🔴 Crítico | Panel/BD | `column orders.customer_phone does not exist` → Historial roto | ⏳ **Migración 039 lista — falta correrla en Supabase SQL editor** (la 019 nunca llegó a producción) |
| 2 | 🔴 Crítico | Panel/BD | `permission denied for table integrations` → Análisis rota | ⏳ Idem: migración 039 agrega GRANT + RLS con `has_restaurant_access` (las tablas de 011/012 quedaron sin grants ni RLS) |
| 3 | 🔴 Crítico | Panel/BD | `permission denied for table subscription_payments` → Facturación rota | ⏳ Idem: migración 039 (SELECT para authenticated; el worker escribe con service key) |
| 4 | 🔴 Crítico | Status | `/status.html` quedaba en "Verificando" | ✅ Resuelto y verificado. Causa: el worker mandaba CORS fijo al apex y bloqueaba `www.` en TODOS los endpoints. Wrapper de CORS por request en el worker (deployado) + el catch de status.html ya no cuelga los servicios |
| 5 | 🟡 Medio | Panel | Sidebar "Combo" vs Facturación "MENÚ FREE" | ✅ Resuelto. `lib/plans.js` tenía el catálogo viejo (menu-free/basico/pro/full); ahora tiene el definitivo + `getPlanKey()` como fuente única para sidebar, Facturación y sección Plan |
| 6 | 🟡 Medio | Panel | Tipo de negocio "no persiste" entre sesiones | ✅ Resuelto. No era el tipo: al recargar siempre cargaba `restaurantList[0]` (el negocio más viejo de la cuenta). Ahora recuerda el último negocio seleccionado (localStorage) |
| 7 | 🟡 Medio | Demo | Sin flujo de carrito/pago completo en demo pública | 📋 Pendiente — es feature, no fix. Definir alcance con Sebastián |
| 8 | 🟢 Menor | Frontend | Warning GSAP `Invalid property fromVars` | ✅ Resuelto. Era un `.to()` con propiedad inexistente `fromVars` en index.html → `.fromTo()` |
| 9 | 🟢 Menor | Demo | Precio empanadas $2.800 inconsistente | ✅ Resuelto. $7.800 (HTML + objeto MENU + prompt de Tano) |

**Para cerrar los bugs 1-3:** correr `migrations/039_qa2_db_fixes.sql` en Supabase → SQL editor (es idempotente) y recargar el panel.

**Lo que funciona bien según el mismo QA:** onboarding, checklist primeros pasos, edición de información, toggle abierto/cerrado, agenda, pedidos, estadísticas, informes, configuración, chat Viti, navegación, demo menú completa (filtros dieta, categorías, cards, mesa, Tano flotante, mobile-first).

---

## Qué se testeó funcionalmente

### Flujos testeados via browser automation (Claude)

- Carga de `index.html` y landings verticales (`para-restaurantes.html`, `para-servicios.html`, `para-comercios.html`)
- Flujo de onboarding: selección de tipo de negocio, creación de cuenta, checklist de primeros pasos
- Flujo de login con Google OAuth
- Panel (`panel.html`): navegación entre secciones, carga de menú/catálogo, gestión de pedidos
- `cocina.html`: recepción de pedidos vía Supabase Realtime, cambio de estados
- `menu.html`: visualización pública del menú, flujo de pedido QR
- `maestro.html`: carga de tabs, listado de clientes, botón cortesía
- `demo.html`: demo Casa Lucía y Ferretería El Tornillo
- Responsive mobile en las páginas principales

---

## Flujos que requieren acción manual de Sebastián

Los siguientes flujos no pueden testearse automáticamente porque dependen de servicios externos con credenciales reales o flujos OAuth:

### OAuth Meta (Instagram / Facebook)
- Conectar cuenta de Instagram Business al panel requiere una cuenta real de Instagram Business
- El flujo OAuth redirige a Meta y vuelve con token — no se puede simular sin cuenta real
- **Pendiente:** testear con una cuenta de prueba de Meta cuando se aprueben los permisos avanzados

### WhatsApp real vía Twilio
- El flujo de asignación de número (migración 028 pendiente) requiere cuenta Twilio real con saldo
- Envío real de mensajes WA a un número real
- Webhook routing por número de destino (pendiente implementar)
- **Pendiente:** testear cuando se implemente el modelo número-por-cliente (pendiente técnico #3 y #4)

### Pagos MercadoPago
- El flujo de suscripción vía MP requiere cuenta real y tarjeta de prueba
- El flujo de pago de mesa (OAuth por restaurante) requiere una cuenta MP del restaurante
- **Pendiente:** hacer una prueba end-to-end con tarjeta sandbox de MP antes del primer cliente real

### Google Business Profile
- La conexión de GBP requiere acceso real a un negocio verificado en Google
- El análisis de reseñas y métricas requiere datos reales
- **Pendiente:** testear con el GBP de un negocio conocido de Sebastián

---

## Issues conocidos pendientes

### Instagram OAuth
- En algunos casos el flujo de reconexión de Instagram muestra un error si el token expiró y el usuario intenta reconectar sin desconectar primero
- **Workaround actual:** el usuario debe desconectar desde el panel y volver a conectar

### Campo URL slug
- La generación automática del slug a partir del nombre del negocio no maneja correctamente caracteres especiales (ñ, tildes, ü)
- Ejemplo: "Cafetería Ñoño" genera slug incorrecto
- **Workaround actual:** el usuario puede editar el slug manualmente

### opening_hours
- La carga de horarios de apertura desde Google Business Profile puede devolver formatos inconsistentes según el tipo de negocio
- Afecta la visualización en el menú público y los mensajes automáticos de "cerrado"
- **Pendiente:** normalización del formato en el worker antes de guardar en Supabase

---

## Resultado de la auditoría de seguridad

### Issues encontrados y estado

| Issue | Severidad | Estado |
|-------|-----------|--------|
| Tokens MP expuestos en logs de Cloudflare | Alta | Resuelto — se eliminó el logging de tokens |
| Webhook MP sin validación de firma | Alta | Resuelto — se agregó validación HMAC |
| CORS demasiado permisivo en `/api/claude` | Media | Resuelto — restringido a vitrinaapp.com.ar |
| Rate limiting ausente en endpoints públicos | Media | Parcialmente resuelto — se agregó rate limit en `/api/lead` y `/api/waitlist` |
| Supabase RLS deshabilitado en tabla `admins` | Alta | Resuelto — se habilitó RLS con política solo para emails en la tabla |
| Twilio credentials sin rotación periódica | Baja | Mitigado — rotados el 10/05. Pendiente establecer rotación semestral. |

### Issues pendientes de resolver

- Rate limiting en endpoints de panel (`/api/admin/*`) — depende de implementación de sesión más robusta
- Validación de input en endpoints ML (prevención de inyección en respuestas automáticas)

---

## Resultado del QA UX/UI

### Veredicto general
El producto es funcional y utilizable en los flujos principales. Las páginas públicas (landing, demo) están pulidas. El panel tiene roughness en secciones menos usadas.

### Verificaciones que pasaron
- Responsive mobile en landing, demo, menu.html y cocina.html
- Contraste de colores WCAG AA en elementos críticos (botones de acción, CTAs)
- Flujo de onboarding completo sin errores en camino feliz
- Navegación en panel sin errores JS en secciones principales (Menú, Pedidos, Reservas, Configuración)
- Carga de cocina.html en tablet (caso de uso principal del cocinero)
- QR generado correctamente y escaneable desde mobile

### Puntos de mejora identificados (no bloqueantes)
- El panel en mobile tiene algunas tablas que no se adaptan bien (Reservas, Clientes)
- El onboarding en paso de "conexión de redes" puede confundir si el usuario no tiene Instagram Business (recibe error genérico)
- El modal de extensiones (comprar más fotos/mensajes) no tiene confirmación de precio en ARS antes de cobrar

---

## Checklist de lo que Sebastián debe verificar antes de mostrar a un prospect

### Cuenta del negocio de prueba
- [ ] Crear una cuenta de demo limpia (no usar La Panera Rosa que es pública)
- [ ] Cargar menú/catálogo completo con fotos
- [ ] Conectar cuenta de Instagram Business de prueba
- [ ] Activar plan cortesía para la cuenta de demo

### Flujos a verificar en vivo
- [ ] Onboarding completo desde cero (incluyendo paso de redes sociales)
- [ ] Agregar un producto con foto y ver cómo queda en el menú QR
- [ ] Simular un pedido desde menu.html y verlo llegar en cocina.html
- [ ] Enviar una publicación de prueba a Instagram desde el panel
- [ ] Ver el informe diario generado por Viti

### Antes de mostrar el panel maestro (maestro.html)
- [ ] Verificar que no hay datos reales de clientes visibles si se comparte pantalla
- [ ] Tener al menos una cuenta ficticia cargada para mostrar la UI del listado

### Antes del primer cliente pago real
- [ ] Hacer una transacción de prueba con tarjeta sandbox de MercadoPago
- [ ] Verificar que el mail de bienvenida llega correctamente (revisar spam)
- [ ] Confirmar que el WA de bienvenida se envía (una vez activo el modelo Twilio número-por-cliente)
- [ ] Hacer `npx wrangler deploy` para activar los crons (pendiente técnico #9)
- [ ] Cargar credenciales ML en wrangler secrets (pendiente técnico #8)
