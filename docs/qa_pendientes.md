# QA + UX VITRINA — Pendientes priorizados

> Generado el 2026-06-22 por un QA multi-agente (9 agentes: bugs frontend/worker, integraciones, política de mensajes, login, UX de 3 personas). Consolidado y deduplicado.
> **Mandan los docs y Sebastián decide qué se arregla y en qué orden.** Esto es el backlog, no una orden de ejecución.

## ✅ ARREGLADOS el 2026-06-22 (sesión de fixes)
Verificados en código + endpoints del worker probados con curl (falta el click-through en navegador):
- **C1** ✓ eliminado el modal viejo con `post-caption` duplicado → el composer real funciona.
- **C2** ✓ `path`/`method` declarados + try/catch global con CORS (M3). Verificado: la zona 7640+ responde 400/404, ya no 500.
- **C4** ✓ el handler recibe `ctx` real (auto-respuesta ML en background no se cancela).
- **C5** ✓ order-webhook resuelve el token del restaurante vía `?rest=` → los pagos de mesa se marcan "paid".
- **C6** ✓ `adminFetch` manda Bearer token en maestro → panel maestro carga.
- **C7+C8** ✓ guard `isAdminRequest` en `/api/sales/*` (salvo públicos) y en `/api/wa/provision|release`. Verificado: 403 sin token, unsubscribe sigue 200.
- **C9** ✓ "Agente de Ventas" oculto, visible solo para admin.
- **C10** ✓ notificaciones usan `mesaFinal`/`mesaEfectiva()`.
- **A1** ✓ `switchSection('config')` tras pago MP. **A2/M1** ✓ tier guardado como `planId` completo. **A12** ✓ CSS de la caja WhatsApp con tokens reales.

### Quedan de la lista "antes de vender" (NO arreglados — más grandes):
- **C3** — sistema de 5 aprobaciones inexistente; ML auto-responde sin aprobación. Es un **feature** a construir, no un fix. Mínimo urgente: que ML guarde como `pending`.
- **A5** — el número Twilio comprado no es sender WhatsApp válido (requiere alta de sender aprobado por Meta en Twilio — **infra externa**, no solo código).

---

## Estado al cierre de la sesión del 2026-06-22
Lo que SÍ se construyó/arregló en esta sesión (no está en la lista de abajo):
- ✅ "Traer de mi web" (importa imágenes + info del sitio del negocio) — worker `/api/marketing/import-from-web` + botón en composer.
- ✅ Página de eliminación de datos (`eliminar-datos.html`) + link en privacy — requisito Meta App Review.
- ✅ Menú: botón 👁️ ocultar/mostrar plato (`is_visible`), distinto del toggle "no disponible".
- ✅ Borrar cuenta autoservicio: worker `/api/account/delete` + zona peligrosa en Configuración con doble confirmación.
- ✅ Guion del video de Meta App Review (en el chat, falta grabarlo).

Pendiente de fases siguientes (acordado con Sebastián): integración **Canva** (diseño) y **Google Business Profile** (reseñas/local). En ese orden.

---

## CRÍTICOS (rompen el producto o exponen datos)

- **C1. Composer roto por ID duplicado `post-caption`.** Modal viejo huérfano (`modal-create-post`) con un `post-caption` que aparece primero en el DOM → `getElementById('post-caption')` devuelve el oculto. Rompe `submitPost`, `updatePreview`, `closeNewPostModal`, `usarSugerencia`, `vitiEscribePost`. **Dónde:** `panel.html:4707` (huérfano, bloque 4696-4751) y `15914` (real). **Fix:** eliminar el modal viejo + su `saveScheduledPost` + el listener `DOMContentLoaded` de 9459.
- **C2. Router del worker revienta con 500 — `path`/`method` nunca declarados.** Desde `index.js:7640` (~25 endpoints: caja, suppliers, purchase-orders, rentabilidad, reminders) usan `path`/`method` sin declararlos → ReferenceError, 500 sin CORS, el 404 nunca se alcanza. **Fix:** junto a `const url = new URL(request.url)` (≈1521): `const path = url.pathname; const method = request.method;`.
- **C3. Auto-respuesta de ML sin las 5 aprobaciones + sistema de 5 aprobaciones inexistente.** `/api/ml/webhook`→`processMLQuestion()` genera y publica directo desde el día 0 (viola decisiones.md L93-97). No existe la máquina "5 aprobaciones consecutivas → ofrecer modo automático → reset a 0". **Dónde:** `index.js:217, 4856`; `panel.html:3204`. **Fix:** contador por canal (`auto_approvals_{canal}`/`auto_mode_{canal}`); ML sin modo auto → guardar respuesta `pending`.
- **C4. ML auto-responder puede no completar (`env.ctx` siempre undefined).** Handler interno `async fetch(request, env)` descarta el 3er parámetro; `ctx.waitUntil` usa fallback que no registra la tarea → la promesa detached puede cancelarse. **Dónde:** `index.js:1516, 4864-4865, 8746`. **Fix:** firma `async fetch(request, env, ctx)` o `env.ctx = ctx`.
- **C5. Pago de pedidos de mesa nunca se marca "paid" (MP cuenta del restaurante).** Preferencia se crea con `rest.mp_access_token` pero el order-webhook consulta SIEMPRE con `env.MP_ACCESS_TOKEN` → 404/403, nunca pasa a "paid", no dispara cocina. **Dónde:** `index.js:6856` vs `7489`. **Fix:** resolver restaurante por `external_reference`/`metadata.restaurant_id`, consultar con SU token (fallback al global).
- **C6. Panel Maestro vacío — llamadas admin sin token.** `maestro.html` llama `/api/admin/restaurants` y `/api/admin/wa-lines` sin Authorization → 403. **Dónde:** `maestro.html:1258, 1392, 1947, 1970`. **Fix:** `supabase.auth.getSession()` + `Authorization: Bearer ...`, centralizar en `adminFetch(path)`.
- **C7. `/api/sales/*` exponen prospectos sin auth.** `/prospects`, `/search-restaurants`, `/config`, `/batch-create-prospects` solo chequean que exista SERVICE_KEY → cualquiera lista PII y dispara búsquedas que cuestan plata. **Dónde:** `index.js:3164, 2843, 3396, 3411, 3457, 3968`. **Fix:** `isAdminRequest` al inicio de cada uno.
- **C8. Provisionar/liberar Twilio sin auth.** `/api/wa/provision` y `/api/wa/release` sin admin → cualquiera corta el WhatsApp de un cliente. **Dónde:** `index.js:7012, 7029`. **Fix:** `isAdminRequest` + Bearer desde `maestro.html:1446, 1459`.
- **C9. "Agente de Ventas" (herramienta interna) visible para todo dueño.** Nav-item sin `display:none`; es prospección interna de Vitrina. **Dónde:** `panel.html:1699` (nav), `3879-3898` (sección). **Fix:** ocultar por defecto, mostrar solo a admin (como `nav-maestro-link`).
- **C10. Pedido con mesa manual avisa "sin mesa" a cocina.** Si tipean la mesa (`mesaManual`), las 3 notificaciones usan `mesa` (null) en vez de `mesaFinal`. **Dónde:** `menu.html:1090-1135` (`mesaFinal` ya está en 1026). **Fix:** usar `mesaFinal` en los tres payloads.

## ALTOS

- **A1.** `navigate('config')` no existe → ReferenceError tras pago MP. `panel.html:4912`. Fix: `switchSection('config', ...)`.
- **A2.** Suscripciones MP guardan `plan.tipo`/`plan.tier` undefined (PLANES no tiene esas props). `index.js:1746-1747, 1762`; PLANES 192-209. Fix: `plan.segmento` + tier del `planId`.
- **A3.** Followup WhatsApp sin `restaurantId` → sale del número global, sin límites ni costo. `index.js:8396`. Fix: pasar `{ restaurantId, msgType:'conversation' }`.
- **A4.** WhatsApp no detecta ventana de 24hs (`wa_last_inbound_at` se guarda y no se lee) → gratis se cuenta como utility. `index.js:951, 7103`.
- **A5.** Número Twilio comprado no es sender WhatsApp válido (falta registrar sender aprobado por Meta). `index.js:663-727`. No marcar `wa_status` apto solo por comprar.
- **A6.** Webhooks MP sin verificación de firma HMAC. `index.js:7470-7476, 1782-1796`.
- **A7.** `/api/admin/verify` sin auth = oráculo de admins. `index.js:5250-5269`. Fix: usar `isAdminRequest`.
- **A8.** `isAdminRequest` no verifica la firma del JWT (`atob` sin validar). `index.js:334-366`. Fix: verificar firma contra Supabase (jose). **A7+A8 juntos = forjar admin.**
- **A9.** Borrado de restaurantes irreversible desde el cliente con un solo `confirm()`. `maestro.html:2010, 2187-2198`. Fix: confirmar tipeando el nombre + endpoint con `isAdminRequest` + soft-delete.
- **A10.** Cortesía: tier `rest-combo` inconsistente con `free/basic/pro/full`; alerta de vencimiento prometida pero inexistente. `maestro.html:2148-2166, 1284`.
- **A11.** Métricas falsas/hardcodeadas presentadas como reales (facturación $0, ROI $40/cliente, etc.). `maestro.html:1294-1526`. Fix: marcar "estimado" / empty-state.
- **A12.** Caja WhatsApp con variables CSS inexistentes (`--text1/--text2`) → texto invisible. `panel.html:2587-2592`. Fix: `--ink`/`--muted`/`--terra`.
- **A13.** Marketing: dos calendarios y dos botones "Nueva publicación". `panel.html:3293-3375`. Unificar.
- **A14.** Captura de teléfono/nombre partida en dos pantallas. `menu.html:296-302` vs `330`.
- **A15.** Pedido enviado sin CTA "seguir pidiendo". `menu.html:313`.
- **A16.** Nav lateral "Gestión" con ~17 items sin jerarquía. `panel.html:1640-1718`.

## MEDIOS (resumen)
M1 mapeo de plan en webhook MP puede dejar sin features · M2 `/api/social/schedule-post` sin try/catch · M3 router sin try/catch global con CORS · M4 prompt ML encarna "Viti" al comprador · M5 WhatsApp inbound (Tano) no responde (TODO) · M6 verificar IG App ID `1690867112058918` vs secret · M7 pago navega fuera del menú · M8 `is_open` vs `can_take_orders` · M9 permiso de notificaciones en medio del checkout · M10 plan duplicado Config/Facturación · M11 estados vacíos sin acción · M12 header de menú con 7 botones · M13 modo soporte sin salida/caducidad · M14 "Mi Marketing" del maestro solo en localStorage · M15 XSS en tabla de Clientes · M16 emails de clientes a la vista (PII) · M17 iconos de nav duplicados.

## BAJOS (resumen)
B1 ruta ML duplicada (código muerto) · B2 `generarVideoIA` sin null-check · B3 ID duplicado `viti-typing` · B4 notif al local no se identifica como Viti · B5 TC bluelytics vs BNA (fallback 1.418) · B6 rate limit en memoria · B7 state OAuth sin firmar (MP/IG/FB) · B8 cap de videos por substring de URL · B9 service key sin chequeo de ownership del `restaurant_id` · B10 gate admin depende de FALLBACK_ADMINS · B11 `requireAuth` parpadea a login · B12 onboarding descarte en sessionStorage · B13 botón recargar ambiguo · B14 Delivery con dos nombres · B15 ítem agotado tras agregarlo al carrito · B16 overlay de estado se autoabre al recargar · B17 FABs + toast solapados mobile · B18 cliente no ve estimación de tiempo · B19 alert/confirm/prompt nativos en el maestro · B20 "last-updated" no distingue error de vacío.

## ARREGLAR ANTES DE VENDER (lista corta del QA)
1. **C2** (+M3 red de seguridad) — una línea, hoy revienta ~25 endpoints.
2. **C1** — composer de publicaciones.
3. **C5** — pedidos pagados nunca llegan a cocina.
4. **C6** — Panel Maestro vacío.
5. **C7 + C8** — cerrar `/api/sales/*` y `/api/wa/provision|release` (PII + plata).
6. **C9** — ocultar "Agente de Ventas" del cliente.
7. **C10** — `mesaFinal`.
8. **C3** — 5 aprobaciones (mínimo: ML como `pending`).
9. **A1** — `switchSection` tras pago.
10. **A2 + M1** — tier undefined deja sin features al que paga.
11. **A5** — sender WhatsApp real antes de prometerlo.
12. **A12** — texto invisible (se ve roto en la demo).

Seguridad en el mismo sprint: **A6, A7+A8, A9, B9**. Antes de mostrar el maestro: **A11**.
