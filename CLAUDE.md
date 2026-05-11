---
name: vitrina
description: Skill maestro del proyecto Vitrina — SaaS de presencia digital inteligente para restaurantes, comercios y vendedores online, desarrollado por Sebastián. Activar SIEMPRE que Sebastián mencione Vitrina, restaurantes, locales, su app, su proyecto, clientes, menú digital, QR, mozo IA, Tano, Viti, La Panera Rosa, vitrinaapp.com.ar, Cloudflare, planes, precios, MercadoLibre, Tienda Nube, agente programador, o cualquier tema relacionado con el desarrollo de su plataforma.
---

# Vitrina — Skill Maestro del Proyecto (actualizado 10/05/2026)

## Quién es Sebastián
Trabaja solo, sin programadores. Experiencia en banca y finanzas (8 años). No sabe programar — construye Vitrina con Claude Code. Respuestas directas, sin "qué buena pregunta", "perfecto", "excelente", ni condescendencia. Cuando no hay contexto específico, mostrar estado actual y sugerir próximo paso lógico.

---

## Qué es Vitrina

SaaS de presencia digital inteligente para cualquier comercio a la calle o vendedor online. No es solo para restaurantes. Centraliza en un solo panel: catálogo/menú digital, pedidos, pagos, marketing en redes, análisis de competidores, integración con MercadoLibre y Tienda Nube, asistente IA para clientes finales, gestión de publicidad paga, reservas y turnos, y CRM básico.

**Dos asistentes IA:**
- **Tano** — asistente para clientes finales de restaurantes. Nombre default, personalizable por el dueño en el onboarding. Tono cálido, informal, humano. Solo habla del menú y del negocio.
- **Viti** — asistente estratégico del dueño. Sin género (siempre "Viti dice", "Viti analizó", nunca "él" ni "ella"). Analiza datos, genera estrategia, gestiona automatizaciones, responde consultas del negocio.
- **Asistente personalizable** — para rubros no gastronómicos. El dueño elige el nombre en el onboarding. Misma tecnología que Tano, adaptada al rubro.

---

## Stack técnico

- **Dominio:** vitrinaapp.com.ar (DNS Cloudflare — nameservers apollo + eleanor)
- **Frontend:** HTML/JS → GitHub Pages (github.com/sebastianmcantor-creator/vitrina-app)
- **Backend:** Cloudflare Workers (vitrina-worker.vitrinaapp.workers.dev) — carpeta local C:\Users\sebas\vitrina-server-worker
- **Base de datos:** Supabase (migrado desde Cloudflare D1)
- **IA principal:** Claude Haiku 4.5 vía API Anthropic
- **Email:** Google Workspace (contacto@vitrinaapp.com.ar)
- **Mensajería:** Twilio WhatsApp Business API (Sandbox activo: +1 415 523 8886)
- **Pagos:** MercadoPago (credenciales productivas configuradas)
- **Local:** Claude Code desktop, Node.js v24.15.0, Wrangler 4.85.0 autenticado
- **Carpetas:** C:\Users\sebas\vitrina-app (frontend) y C:\Users\sebas\vitrina-server-worker (backend)

---

## Secrets configurados en Cloudflare (actualizado 10/05/2026)

ANTHROPIC_API_KEY         OK
SUPABASE_URL              OK
SUPABASE_SERVICE_KEY      OK
MP_ACCESS_TOKEN           OK (credenciales productivas)
MP_PUBLIC_KEY             OK
RESEND_API_KEY            OK
TWILIO_ACCOUNT_SID        OK
TWILIO_AUTH_TOKEN         OK (rotado el 10/05/2026)
TWILIO_WHATSAPP_FROM      OK (whatsapp:+14155238886 — Sandbox)
GOOGLE_PLACES_API_KEY     OK
OPENAI_API_KEY            OK ($5 USD cargados — Whisper transcripción)
ML_APP_ID                 OK (3797856969955324)
ML_CLIENT_SECRET          OK
TN_APP_ID                 OK (31471)
TN_CLIENT_SECRET          OK
AI (Workers AI binding)   OK (Cloudflare AI gratuito — fotos con IA)

## Secrets pendientes de configurar

METRICOOL_API_KEY         PENDIENTE — activar cuando llegue el primer cliente de marketing ($25/mes plan Starter)
METRICOOL_USER_TOKEN      PENDIENTE — mismo lugar
REPLICATE_API_KEY         NO NECESARIO — reemplazado por Cloudflare AI (gratuito)

## Páginas publicadas en vitrinaapp.com.ar

privacy.html              OK — Política de Privacidad (incluye sección Instagram Graph API para Meta)
terms.html                OK — Términos y Condiciones (incluye tipo de cambio, servicios variables)
oauth-callback.html       OK — Maneja callbacks OAuth de ML, TN y Google

## Features completadas (sesión 10/05 + 11/05/2026)

### Panel admin (panel.html)
- Platos destacados ⭐ con sección en menú público
- QR del menú y asistente generados automáticamente
- Sección "🛒 Mi Catálogo" con conexión ML y TN
- Upload logo y portada a Supabase Storage
- Fotos de platos con IA (Cloudflare AI, gratis)
- Subtítulos automáticos de video con Whisper
- Sección "📅 Reservas" con modal completo y CRUD
- Sección "👥 Clientes (CRM)" desde datos de pedidos
- Getting Started checklist 7 pasos
- Gráfico ventas por franja horaria
- Viti conoce integraciones activas ML/TN/Google
- Geocoding real para buscar competidores
- OAuth redirect handling (ML, TN)

### Menú público (menu.html)
- Sección "⭐ Destacados" al tope
- Checkout con resumen previo + nombre del cliente
- Botón "Confirmar por WhatsApp" post-pedido
- Notificación audio + push cuando pedido listo
- Portada y logo del restaurante en el header
- Scroll spy con sección featured
- Permiso de notificaciones al primer pedido

### Cocina (cocina.html)
- Filtros: Activos / Pendientes / Preparando / Listos
- Tiempo transcurrido con color de urgencia
- "✓ Todo listo" por mesa
- Nombre del cliente en cada pedido

### Asistente Tano (mozo.html)
- Multiidioma ES/EN/PT con auto-detección
- 3 tonos (cálido, neutro, sofisticado)
- Botón 🔄 nueva sesión (expiración 4h)
- Tano conoce platos destacados
- Botón "⭐ Destacados" en sugerencias
- "Llamar al mozo" tras 3 mensajes

### Landing (index.html)
- Expandida a todos los rubros (no solo restaurantes)
- 12 chips de rubros disponibles
- Planes actualizados: Free / Solo Menú / Marketing
- Precios ARS dinámicos vía worker
- FAQ de ML/TN
- Título y meta corregidos

### Worker (vitrina-tano)
- 15 secrets configurados y funcionando
- GET /api/health — estado de todos los servicios
- GET /api/geocode — geocodificación real de direcciones
- GET /api/ml/auth + /api/ml/callback — OAuth ML
- GET /api/tn/auth + /api/tn/callback — OAuth TN
- POST /api/whisper/transcribe — Whisper OpenAI
- POST /api/cf-ai/generate-image — fotos con Cloudflare AI
- POST /api/cf-ai/enhance-image — mejora de fotos

## Migrations pendientes de correr en Supabase SQL Editor

011: ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_name TEXT;
012: ALTER TABLE integrations ADD COLUMN IF NOT EXISTS ml_user_id TEXT, ADD COLUMN IF NOT EXISTS tn_user_id TEXT;
013: CREATE TABLE IF NOT EXISTS reservations (...) — ver archivo migrations/013_reservations.sql

---

## Cron jobs activos en Cloudflare

0 10 * * 1   — tipo de cambio Banco Nación (lunes 10am)
0 10 * * *   — seguimiento ventas (diario 10am)
0 9 1 * *    — informes ejecutivos (día 1 de cada mes, 9am)

---

## Migraciones Supabase ejecutadas

OK Vitrina schema (restaurantes, menú, pedidos)
OK 011_subscriptions (planes y pagos MP)
OK 012_integrations (Google, Instagram, competidores)
OK 013_content_calendar (Metricool, posts programados)
OK ALL_PENDING_MIGRATIONS (014 al 018 — waitlist, leads, agente ventas, tipo cambio, informes)

---

## Orden de vinculaciones pendientes por prioridad

### Esta semana — desbloquean features core

1. Google Cloud Console → Places API → GOOGLE_PLACES_API_KEY
   - console.cloud.google.com → Crear proyecto "Vitrina" → Habilitar Places API + Maps JavaScript API → Generar API Key con restricción de dominio
   - $200 USD/mes de crédito gratuito de Google (alcanza para ~100 clientes sin pagar nada)

2. OpenAI → Whisper → OPENAI_API_KEY
   - platform.openai.com → Billing → cargar $10 USD → API Keys → Create
   - Costo: $0.006 USD/minuto de audio. 10 videos de 90 seg = $0.09 USD/mes por cliente

3. Replicate → fotos IA → REPLICATE_API_KEY
   - replicate.com → Billing → cargar $10 USD → Account Settings → API Tokens
   - Costo: $0.07 USD/foto. 80 fotos/mes = $5.60 USD/cliente

### Cuando llegue el primer cliente Marketing o Full

4. Metricool → plan Starter ($25/mes) → tokens → publicación automática
   - Activar desde el primer cliente. Slot 1 = marca Vitrina propia. Slots 2-5 = primeros clientes.
   - Panel Metricool → Settings → API → Generate token → cargar METRICOOL_API_KEY y METRICOOL_USER_TOKEN

### Cuando llegue el primer cliente con ML activo

5. MercadoLibre → app de desarrollador → OAuth por cliente
   - developers.mercadolibre.com.ar → Mis aplicaciones → Crear
   - URL callback: https://vitrina-server-worker.[usuario].workers.dev/auth/ml/callback
   - Testear con ML Sandbox antes de producción

6. Tienda Nube → app de partners → OAuth por cliente
   - partners.tiendanube.com → Crear aplicación

### Cuando el primer cliente pago quiera número propio

7. Verificación identidad Twilio con pasaporte → WhatsApp Sender propio
   - El DNI nuevo con QR no es reconocido — usar pasaporte
   - Una vez verificado: registrar número WhatsApp Business propio de Vitrina
   - Luego: un número dedicado por cliente que contrate plan +WA

### 4-6 semanas después de iniciar trámite con Meta

8. Instagram Graph API → métricas propias y publicación directa
   - Crear app en developers.facebook.com → tipo Business → agregar Instagram Graph API
   - Permisos: instagram_basic, instagram_manage_insights, instagram_content_publish
   - Requiere política de privacidad y términos publicados en vitrinaapp.com.ar
   - Mientras no está aprobada: Metricool cubre publicación automática
   - IMPORTANTE: Instagram Basic Display API no existe desde diciembre 2024. Solo Graph API. No mencionar Basic Display API en ningún contexto.

---

## Arquitectura WhatsApp — número dedicado por cliente

Cada cliente que contrata plan +WA recibe su propio número de WhatsApp Business gestionado desde la cuenta de Twilio de Vitrina.

Lo que ve el cliente final del negocio: el NOMBRE del negocio en grande (ej: "Ferretería López"), verificado con tilde verde si está aprobado. El número de EEUU aparece en segundo plano — igual que lo hacen Mercado Libre, bancos y aerolíneas.

Flujo técnico:
1. Cliente contrata plan +WA
2. Vitrina registra un número nuevo en Twilio (~$2 USD/mes)
3. Ese número se registra en WhatsApp Business API de Meta (~$8-10 USD/mes)
4. Twilio configura webhook del número → apunta al Worker de Vitrina
5. El Worker identifica a qué cliente pertenece el número entrante
6. Claude Haiku procesa el mensaje con contexto completo de ese negocio
7. Responde en nombre del negocio

Costo real para Vitrina por número: $10-12 USD/mes
Diferencia de precio entre plan con y sin WA: $12
Margen en el add-on WA: mínimo, pero el valor percibido para el cliente es enorme.

Si el cliente quiere su número argentino existente: puede migrarlo a Twilio. Proceso de 1-3 días, sin costo extra. Opcional.

Sandbox actual (testing y primeros pilotos): +1 415 523 8886, código: join behavior-weigh. Solo para desarrollo, no para clientes productivos.

### Cómo se vende el WA por rubro
- Restaurante/Bar: "Mozo Virtual por WhatsApp"
- Ferretería/Bazar: "Asesor de Productos por WhatsApp"
- Peluquería/Estética: "Asistente de Turnos por WhatsApp"
- Vendedor ML/TN: "Vendedor Automático por WhatsApp"
- Cualquier rubro: "Tu asistente inteligente, disponible 24/7"

---

## Flujo de pedidos y WhatsApp — ahorro de costos Meta

Cuando el comensal confirma un pedido desde el menú QR:
1. Aparece botón verde "Confirmar por WhatsApp"
2. Al tocarlo, el celular del comensal abre WhatsApp con mensaje pre-escrito: "Pedido #234 — Mesa 7: 2 milanesas, 1 agua. [Nombre restaurante]"
3. El comensal toca Enviar — él inicia la conversación, abre ventana gratuita de 24 hs
4. Dentro de esa ventana: confirmación, aviso de listo, seguimiento — todo gratis para Vitrina
5. El pedido queda registrado en el sistema aunque el comensal no mande el WhatsApp

Costo Meta por conversación iniciada por el negocio: $0.056 USD. Iniciada por el cliente: $0.

---

## Planes y precios (actualizados 11/05/2026)

### Logo
Logo D implementado: arco de vidriera SVG (storefront) + "Vitrina" en Cormorant Garamond serif.
Color terra (#B85A30) sobre fondo claro, dorado (#e8c87a) sobre fondo oscuro.

### Plan gratuito
ELIMINADO. Solo hay trial de 14 días con acceso completo al plan elegido, sin tarjeta.

### RESTAURANTES / GASTRONOMÍA

#### Solo Menú — $27 USD/mes
- Menú QR ilimitado, ES/EN/PT
- Tano atiende consultas del menú
- Pedidos online + MercadoPago
- Pantalla de cocina en tiempo real
- Sistema de reservas de mesas
- Fotos de platos con IA (Cloudflare AI, gratis)
- WhatsApp canal operativo (cocina/encargado)

#### Menú + WhatsApp — $39 USD/mes
Todo Solo Menú más:
- Número WhatsApp Business dedicado con el nombre del restaurante
- Reservas automáticas por WhatsApp
- Confirmaciones y recordatorios automáticos al cliente
- Asistente responde horarios, dirección y consultas del menú

#### Marketing — $58 USD/mes (solo marketing, SIN sistema de menú/pedidos)
- Viti: estrategia mensual personalizada con IA
- 30 publicaciones automáticas/mes en Instagram + Facebook + Google Business Profile
- Google Business Profile integrado
- Análisis de 5 competidores cercanos (3x/semana)
- $10 USD crédito publicidad de bienvenida
- Informe PDF mensual profesional con logo del restaurante
- 10 subtítulos automáticos/mes con Whisper

#### Marketing + WhatsApp — $68 USD/mes
Todo Marketing más:
- Número WhatsApp Business dedicado
- Reservas + consultas automáticas por WhatsApp
- Campañas a base de clientes (50 mensajes/mes)
- CRM básico de reservas

#### Menú + Marketing — $75 USD/mes (combo, ahorra $10 vs contratar por separado)
= Solo Menú + Marketing en un solo plan

#### Menú + Marketing + WhatsApp — $87 USD/mes (combo completo, ahorra $13 vs separado)
= Solo Menú + Marketing + WhatsApp Business

---

### COMERCIOS, SERVICIOS Y VENDEDORES ONLINE

#### Marketing — $65 USD/mes
- Catálogo QR ilimitado
- MercadoLibre: publicaciones, preguntas automáticas, stock
- Tienda Nube: sincronización bidireccional
- Viti: estrategia y análisis de competidores ML
- 30 publicaciones automáticas/mes en redes
- Google Business + Instagram
- Fotos con IA (80/mes)
- $10 USD crédito publicidad de bienvenida
- Informes completos

#### Marketing + WhatsApp — $78 USD/mes
Todo Marketing más:
- Número WhatsApp Business con nombre del negocio
- Asistente de ventas 24/7: responde stock, precios, cierra ventas
- Genera links de pago MercadoPago
- Gestión de turnos para servicios
- CRM: historial de cada cliente
- 50 mensajes promocionales/mes

---

### COMERCIOS, SERVICIOS Y VENDEDORES ONLINE

Rubros disponibles desde el lanzamiento:
Restaurante/Bar/Café · Heladería/Pastelería · Rotisería/Delivery · Dietética/Almacén natural · Ropa/Calzado/Accesorios · Ferretería/Bazar/Herramientas · Peluquería/Barbería · Estética/Spa/Uñas · Veterinaria · Librería/Papelería · Kiosco/Minimarket · Servicios profesionales (contador, abogado, etc.) · Vendedor online puro (ML/TN sin local físico) · Otro (genérico)

El rubro elegido en el onboarding adapta automáticamente: terminología, features disponibles, tipo de análisis de competidores, flujo del catálogo QR, nombre y comportamiento del asistente.

No hay plan "solo catálogo" sin marketing — sin redes el catálogo digital solo no agrega valor real.

#### Plan Marketing — $65 USD/mes
- Catálogo digital QR (configurable: solo informativo o con pedido y pago según rubro)
- Asistente IA con nombre personalizable por el dueño
- Mi Catálogo: productos con costo de compra, precio de venta, margen mínimo, stock, peso y dimensiones
- Integración MercadoLibre: lectura de publicaciones/ventas/reputación/preguntas, publicación desde Vitrina con fotos IA y descripción optimizada (5 aprobaciones → modo auto), análisis top 10 competidores misma categoría, respuestas automáticas a preguntas ML (5 aprobaciones → modo auto), sincronización de stock bidireccional ML↔TN
- Integración Tienda Nube: lectura de stock/precios/ventas, sync bidireccional con ML
- Viti ilimitado
- 30 publicaciones automáticas/mes vía Metricool
- Análisis de competidores Google Places: 3x/semana
- Respuestas automáticas Google Reviews, Instagram, Facebook (5 aprobaciones → modo auto)
- Sistema de reservas/turnos para rubros de servicios: calendario interno + Google Calendar opcional
- CRM básico: base de contactos con teléfono, nombre si detectado, historial de compras/consultas
- 50 mensajes promocionales/mes a base de contactos
- 80 fotos con IA/mes
- 10 subtítulos/mes (máx 90 seg/video)
- $10 USD crédito bienvenida publicidad
- Gestión publicidad paga incluida (Google Ads + Meta Ads, sin fee extra)
- Informes completos: diario (4 semanas → consulta preferencia) + semanal + mensual PDF
- Sin fee sobre ventas

#### Plan Marketing + WA — $78 USD/mes
Todo Marketing más:
- Número WhatsApp Business dedicado con nombre del negocio
- Asistente vendedor 24/7: responde consultas de productos/servicios, arma carrito inteligente
- Al querer comprar, el asistente ofrece tres destinos: carrito en Vitrina, tienda en Tienda Nube, o link directo a publicación específica en ML + link al perfil completo del vendedor en ML
- Gestión de turnos por WhatsApp para rubros de servicios
- CRM ampliado: cada conversación enriquece la base de contactos
- Análisis de competidores: 5x/semana (en lugar de 3x)

---

## Trial 14 días

Equivale a: Plan Marketing para restaurantes / Plan Marketing para no gastronómicos.
WhatsApp dedicado: NO disponible. Al terminar el trial, Vitrina informa sobre la posibilidad de tener línea propia suscribiéndose al plan +WA.
Metricool durante el trial: se agrega la marca, se borra al terminar, cupo liberado inmediatamente.

Límites del trial (comunicados como features, no como restricciones):

| Feature | Trial | Plan pago | Mensaje al límite |
|---------|-------|-----------|-------------------|
| Fotos IA | 10 | 80/mes | "En el plan pago tenés 80 fotos/mes" |
| Subtítulos | 3 videos | 10/mes | "Con el plan pago subtitulás hasta 10 videos por mes" |
| Publicaciones auto | 3 | 30/mes | "En el plan pago publicamos todos los días si querés" |
| Consultas Viti | 15 | Ilimitadas | "Viti te responde ilimitado con el plan pago" |
| Análisis competidores | 1x/semana | 3x/semana (5x en +WA) | "Con el plan pago analizamos 3 veces por semana y guardamos toda la evolución" |
| Productos Mi Catálogo | 10 | Ilimitados | "Con el plan pago cargás todo tu catálogo sin límite" |
| Publicaciones en ML | 10 productos | Ilimitadas | mensaje similar |
| Mensajes promo WA | 10 | 50/mes | mensaje similar |
| Respuestas auto ML/IG/FB | Manual (sin modo auto) | Auto tras 5 aprobaciones | — |
| Informes | Solo diario básico | Completos | — |
| Reservas/turnos | Completo | Completo | — |
| Tano/asistente | Ilimitado | Ilimitado | — |
| Pedidos y pagos | Completo | Completo | — |
| WA dedicado | No disponible | Con plan +WA | "Sumá tu línea WA propia por $12 más/mes" |

Lo que NUNCA se limita en el trial: Tano, pedidos, cocina, pagos, reservas. El dueño tiene que sentir que el negocio ya funciona desde el día 1.

---

## Extensiones (todos los planes)

El cliente nunca se bloquea. Si tiene "extensión automática" activada, se descuenta solo. Si no, Vitrina avisa por WhatsApp: "Usaste tus 80 fotos del mes. ¿Sumás 30 más por $3?" con botón de pago directo.

| Recurso | Incluido/mes | Extensión | Precio |
|---------|-------------|-----------|--------|
| Fotos IA | 80 | +30 fotos | $3 USD |
| Subtítulos | 10 videos | +10 videos | $2 USD |
| Publicaciones auto | 30 | +15 publicaciones | $3 USD |
| Mensajes promo WA | 50 | +50 mensajes | $3 USD |
| Análisis competidores | 3x/semana (5x en top) | No extendible | — |
| Consultas Viti | Ilimitadas | — | — |
| Respuestas auto | Ilimitadas | — | — |

---

## Flujo de fotos con IA — protección de créditos

Antes de generar cualquier foto, Vitrina muestra 3 estilos con descripción visual:
1. Fondo neutro blanco — producto puro, estilo catálogo profesional
2. Ambiente cálido — madera, luz dorada, contexto del local
3. Minimalista oscuro — fondo negro/gris, producto destacado, estilo premium

El cliente elige un estilo. Vitrina genera 1 foto de ejemplo (consume 1 crédito de prueba separado, NO del lote mensual). Si le gusta: genera el resto del lote. Si no: elige otro estilo, nueva muestra. Solo cuando confirma se consumen los créditos del mes.

---

## Sistema de respuestas automáticas — lógica unificada

Aplica a: preguntas ML, publicaciones ML desde Vitrina, respuestas IG/FB/Google, bajada de stock en TN tras venta en ML, publicaciones en redes desde Viti.

SIEMPRE son 5 aprobaciones consecutivas para activar el modo automático.

- Si el dueño rechaza una sugerencia: el contador vuelve a 0.
- Tras 5 aprobaciones seguidas: Viti pregunta "¿Querés que lo haga solo de ahora en más?" — botones Sí / No.
- En modo automático: actúa en menos de 2 minutos, manda resumen diario con todo lo ejecutado.
- Excepción siempre: si Viti no tiene certeza de la respuesta correcta, manda al dueño sin importar el modo.
- El dueño puede pausar el modo automático en cualquier canal diciéndoselo a Viti: "Viti, pausá las respuestas de Instagram." Se reactiva igual de fácil.

Canales con respuestas automáticas disponibles:
- Preguntas de compradores en MercadoLibre
- Comentarios en Instagram (feed + Reels)
- Mensajes directos en Instagram (solo en plan +WA)
- Comentarios en Facebook
- Reseñas en Google Business Profile
- Mensajes de WhatsApp (solo en plan +WA)

Cómo aprende el estilo: Viti analiza las últimas 50 respuestas dadas por el dueño en cada canal antes de proponer respuestas propias. Siempre intenta mejorar el tono y la efectividad manteniendo la voz del dueño.

---

## Mi Catálogo — gestión de stock, costos y márgenes

### Pantalla de elección de método de carga

Antes de elegir, Vitrina explica ambas opciones:

"Tenés dos formas de cargar tu catálogo. Con Tienda Nube sincronizás automáticamente productos y stock — los precios de Mercado Libre se calculan sumando comisiones, envío y Mercado Pago sobre tu precio actual. Con PDF, cargás tus productos con costos reales y Vitrina calcula tu ganancia neta exacta en cada venta. Esta segunda opción te da más control sobre tus márgenes reales."

### Opción A — Sincronización desde Tienda Nube
- OAuth: el dueño autoriza a Vitrina con su cuenta TN
- Vitrina lee: productos, precios de venta, stock actual
- Para publicar en ML: toma precio de TN y suma comisión ML (11-16.5% según categoría) + costo envío estimado + fee MercadoPago
- El dueño completa en Vitrina: costo de compra, margen pretendido, stock mínimo de alerta
- Sync bidireccional: venta en ML → descuenta stock en TN. Venta en TN → descuenta stock en ML. Automático tras 5 aprobaciones.

### Opción B — PDF
- Dueño sube PDF (lista de precios, catálogo, lo que tenga)
- Claude Vision lo lee y extrae: nombre del producto, precio de venta, descripción
- Vitrina muestra tabla pre-completada con lo encontrado
- Campos marcados en rojo = no encontrados, dueño los completa: costo de compra, margen pretendido, stock, peso y dimensiones
- Al confirmar: Vitrina genera plantilla PDF de ejemplo para que la próxima vez sea más fácil

### Campos por producto
- Nombre
- Foto (cruda → Vitrina mejora con IA)
- Costo de compra
- Precio de venta pretendido
- Margen mínimo aceptable (%)
- Stock actual
- Stock mínimo de alerta
- Peso y dimensiones (para envíos ML — se pregunta en primeras 5 publicaciones si no están cargados)
- Categoría ML (si publica en ML)

### Cálculo automático de precio ML
Precio publicación = costo + margen pretendido + comisión ML + envío estimado. Si ese precio no es competitivo contra los top 10 competidores detectados, Viti avisa: "Para cubrir tu margen necesitás publicar a $8.500. Tus competidores directos están a $7.800. Si bajás el margen mínimo al 28% quedás competitivo. ¿Lo ajustamos?"

### Alertas de stock
WhatsApp automático cuando el stock llega al mínimo: "Quedan 3 unidades de [producto]. ¿Recibiste mercadería nueva? Actualizá el stock para mantener la publicación activa en ML."

### Alerta por venta en ML
WhatsApp al dueño: "Venta en ML: 1 unidad de [producto] a $8.400. Ganancia neta después de comisiones: $2.847. Preparar despacho."
Un solo mensaje por ventana de 24 horas (Meta cobra 1 conversación/día, no 1 por venta).

---

## Publicaciones en MercadoLibre desde Vitrina

Flujo:
1. Dueño inicia publicación desde Mi Catálogo
2. Viti genera: título optimizado para algoritmo ML, descripción detallada, fotos mejoradas con Replicate, atributos del producto, precio calculado
3. Primeras 5 publicaciones: Viti pregunta peso y dimensiones si no están cargados
4. Vitrina muestra preview completo "así se verá en ML"
5. Dueño aprueba → Vitrina publica en ML vía API
6. Tras 5 aprobaciones: modo automático disponible (Viti consulta si lo activa)

Combos de productos: Viti puede sugerir combos cuando el envío compartido mejora el margen. Genera la publicación del combo automáticamente.

---

## Sistema de reservas y turnos

### Configuración del dueño (una sola vez)
- Restaurante: cantidad y tipo de mesas (2p, 4p, grupos), turnos disponibles, duración promedio de mesa, días de cierre
- Servicios: servicios con duración, profesionales disponibles, horarios, días libres, buffer entre turnos

### Flujo conversacional por WhatsApp (plan +WA)
Cliente: "Quiero reservar para el sábado"
Asistente: "Claro, ¿para cuántas personas?"
Cliente: "Somos 4"
Asistente: "Tengo disponible el sábado a las 20:30 o 21:15. ¿Cuál preferís?"
Cliente: "21:15"
Asistente: "Reservado. ¿A nombre de quién?"
Cliente: "Martín"
Asistente: "Listo Martín, reserva para 4 el sábado 21:15. Te mando recordatorio el viernes."

Recordatorio automático: 24 hs antes por WhatsApp + email.
Si no confirma: Vitrina avisa al dueño para que decida si libera el lugar.
Calendarios: interno de Vitrina (default) + Google Calendar como alternativa.

---

## CRM básico (Plan Marketing y superiores)

Al final de cada conversación de WhatsApp o pedido completado, Vitrina guarda automáticamente:
- Número de teléfono
- Nombre si fue detectado en la conversación
- Si no hay nombre: número con referencia del pedido o consulta
- Historial de compras/consultas
- Fecha del último contacto

### Mensajes promocionales a la base
- 50/mes incluidos en el plan
- El dueño arma el mensaje desde el panel, Viti sugiere mejoras
- Vitrina lo envía en horario óptimo según historial de apertura
- Se envían como mensajes de tipo Marketing de Meta (~$0.061 USD/mensaje)
- Para evitar bloqueos: máximo 1 campaña cada 7 días a los mismos contactos, nunca más de 3 mensajes al mismo número en 30 días, siempre con opción de darse de baja
- Extensión: +50 mensajes por $3 USD

---

## Sistema de alertas de costos variables

### Para Sebastián (panel maestro)
- Cada costo variable (foto, subtítulo, mensaje promo, análisis) suma al acumulado del mes en Supabase por cliente
- Al 80% del costo estimado mensual de ese cliente: alerta en panel maestro + WhatsApp a Sebastián
- Al 100%: segunda alerta
- Al 120%: pausa automática de servicios variables (fotos, subtítulos, análisis extra). NUNCA se pausa: Tano, pedidos, cocina, pagos, reservas.
- Dentro de 24 hs hábiles de la pausa: Vitrina contacta al cliente para resolverlo

### Para el cliente
Al 80% de fotos del mes: "Usaste 64 de tus 80 fotos. Te quedan 16 o podés sumar 30 más por $3." Mismo sistema para subtítulos, publicaciones y mensajes promo.

### Texto en términos y condiciones (aprobado)
"Los servicios variables de Vitrina (procesamiento de imágenes con IA, generación de subtítulos, análisis de competidores y mensajería WhatsApp) están dimensionados para un uso normal según el plan contratado. Vitrina se reserva el derecho de notificar al cliente y, de ser necesario, pausar temporalmente servicios variables ante un uso significativamente superior al estimado para el plan, sin afectar en ningún caso los servicios operativos (catálogo digital, sistema de pedidos y pagos). Ante cualquier pausa, Vitrina contactará al cliente dentro de las 24 horas hábiles para resolverlo."

---

## Informes automáticos (todos los planes)

### Frecuencia
- Semanas 1-4: informe diario
- Inicio de semana 5: Viti pregunta "¿Seguís con informe diario o pasamos a semanal más completo?" — botones de elección
- Siempre: informe semanal (jueves o viernes, configurable) + informe mensual PDF el día 1

### Canales
WhatsApp + email simultáneos. PDF como adjunto en email y como link de Supabase Storage en WhatsApp.

### Informe diario (texto, no PDF)
- Plan Menú: pedidos del día, facturación, platos más pedidos, reseñas nuevas en Google
- Planes con marketing: métricas de redes del día, publicaciones publicadas, nuevas preguntas ML, ventas ML, stock crítico
- Máximo 5 líneas en WhatsApp

### Informe semanal (PDF 2 páginas)
- Métricas de la semana vs semana anterior
- Top 3 publicaciones de redes
- Alertas importantes
- Competidores: qué hicieron esta semana

### Informe mensual (PDF 8-12 páginas)
- Logo del restaurante/local en el encabezado
- Performance vs proyecciones por escenario
- Análisis por canal (Google, Instagram, Facebook, ML, TN)
- Qué funcionó y qué no, con datos
- Estrategia ajustada para el mes siguiente
- Firma discreta al pie: "Generado por Vitrina"
- El dueño puede presentarlo como propio

Diseño del PDF: A4, márgenes generosos, fuente mínima 12pt, funciona impreso en blanco y negro, gráficos de barras y líneas (no tortas).

---

## Onboarding del cliente

1. Registro: Google login o email + contraseña
2. Tipo de negocio: elige entre los rubros disponibles. Adapta terminología y features automáticamente.
3. Conexión de redes (primero): Google Business Profile + Instagram → análisis preliminar en 2-3 min. Valor visible antes de pagar.
4. Nombre del asistente: restaurantes default "Tano" (personalizable), otros rubros eligen nombre desde el inicio.
5. Canales de notificación: canal de gestión (dueño) y canal operativo (local). WhatsApp obligatorio para operativo.
6. Carga del catálogo/menú: restaurantes cargan platos con fotos, precios, categorías, filtros. Otros rubros eligen Tienda Nube o PDF (con explicación de diferencias antes de elegir).
7. QR: configuración por mesa (restaurantes) o genérico. ¿Modo informativo o con pedido y pago? Generación de PDF + PNG con logo en el centro. Envío automático por email.
8. Google OAuth: el dueño autoriza a Vitrina con su cuenta Google Business Profile para que Viti pueda responder reseñas automáticamente.
9. Conexión ML/TN: OAuth de MercadoLibre y/o Tienda Nube. Solo en planes que incluyen estas integraciones.
10. Activación del plan: cobro automático vía MercadoPago. Primer mes con $10 USD de crédito para publicidad en planes Marketing y superiores.

---

## Metricool — detalle técnico

### Escala de planes
| Clientes marketing activos | Plan Metricool | Costo/mes |
|---------------------------|---------------|-----------|
| 0-4 (+ Vitrina propia) | Starter | $25 |
| 5-14 | Advanced mensual | $67 |
| 15-24 | Advanced+ | $97 |
| 25+ | Enterprise | $139+ |

Slot 1 siempre reservado para Vitrina propia (vitrinaapp.com.ar).
Activar desde el primer cliente de marketing — no esperar.

### Lo que Metricool hace para Vitrina
- Publicación automática programada en Instagram, Facebook, Google Business Profile
- Analytics: alcance, engagement, mejores horarios, performance por post
- Stories e Instagram Reels
- Confirmación de publicación + métricas 24 hs después

### Límites técnicos
- 200 requests/hora por cuenta (no es limitación práctica)
- Imágenes: mínimo 1080x1080px para feed, 1080x1920px para Stories
- Video: máximo 60 seg para feed, 15 seg para Stories
- Tokens OAuth: caducan cada 60 días — Vitrina avisa 7 días antes al dueño

### Flujo de publicación
1. Viti arma el post (imagen + copy + hashtags + timestamp)
2. Dueño aprueba desde panel Vitrina (o auto si modo automático)
3. Vitrina llama API Metricool con todos los datos
4. Metricool confirma que quedó programado
5. Vitrina guarda en tabla content_calendar de Supabase con estado "programado"
6. 24 hs después: Vitrina consulta métricas y actualiza Supabase

### Baja de cliente
Borrar brand en Metricool → Connections → tres puntos → Delete brand. Cupo liberado inmediatamente.

### Secrets
METRICOOL_API_KEY → wrangler secret put METRICOOL_API_KEY
METRICOOL_USER_TOKEN → wrangler secret put METRICOOL_USER_TOKEN

---

## Costos reales por plan y márgenes

Todos los valores en USD/mes por cliente.
"5c" = con 5 clientes activos de marketing (Metricool $5/cliente diluido).
"15c" = con 15 clientes activos (Metricool $1.67/cliente diluido).

### RESTAURANTES

| Plan | Precio | Costo 5c | Costo 15c | Margen 5c | Margen 15c |
|------|--------|----------|----------|-----------|-----------|
| Solo Menú | $27 | $12.27 | $12.27 | $14.73 (55%) | $14.73 (55%) |
| Menú + WA | $39 | $16.27 | $16.27 | $22.73 (58%) | $22.73 (58%) |
| Marketing | $65 | $26.58 | $23.25 | $38.42 (59%) | $41.75 (64%) |
| Marketing + WA | $78 | $30.58 | $27.25 | $47.42 (61%) | $50.75 (65%) |
| Combo | $85 | $33.42 | $30.09 | $51.58 (61%) | $54.91 (65%) |
| Combo + WA | $95 | $37.42 | $34.09 | $57.58 (61%) | $60.91 (64%) |

### NO GASTRONÓMICOS

| Plan | Precio | Costo 5c | Costo 15c | Margen 5c | Margen 15c |
|------|--------|----------|----------|-----------|-----------|
| Marketing | $65 | $26.58 | $23.25 | $38.42 (59%) | $41.75 (64%) |
| Marketing + WA | $78 | $30.58 | $27.25 | $47.42 (61%) | $50.75 (65%) |

El Plan Marketing de no gastronómicos incluye ML/TN. El costo adicional de ML/TN (~$1.50 USD por Haiku) está absorbido en el margen, no se diferencia en precio.

### Desglose de costos por componente

| Componente | Qué hace | Costo/cliente/mes |
|-----------|---------|-----------------|
| Claude Haiku — Tano | Responde a comensales en el menú | $1.50 |
| Claude Haiku — Viti | Análisis, estrategia, copies, respuestas auto | $4.00-6.00 |
| Claude Vision — PDF/screenshots | Lee PDFs de catálogo y screenshots Rappi/PedidosYa | $0.20 |
| Replicate | Mejora fotos con IA (80/mes máx, $0.07/foto) | $5.60 |
| Whisper (OpenAI) | Subtítulos automáticos (10/mes, 90 seg máx) | $0.09 |
| Google Places API | Análisis de competidores 3-5x/semana | $4.45-7.40 |
| Google Calendar API | Sincronización de reservas | $0 |
| Metricool (diluido) | Publicación automática en redes | $1.67-5.00 |
| Twilio WhatsApp mensajes | Fee por mensaje operativo ($0.005/msg) | $0.50 |
| Meta WhatsApp promo | 50 mensajes promo/mes a $0.061 | $3.05 |
| Twilio número dedicado | Número WA Business por cliente (solo +WA) | $2.00 |
| Meta WA Business número | Registro número WA Business (solo +WA) | $8-10 |
| MercadoPago fee suscripción | 3.99% sobre precio del plan | $1.08-3.79 |
| ML API | Lectura/escritura publicaciones, ventas, preguntas | $0 |
| Tienda Nube API | Lectura/escritura stock, productos | $0 |
| Supabase (prorrateado) | Base de datos, storage PDFs e informes | $0.50 |

### Ganancia neta mensual proyectada

Mix realista: 40% Solo Menú, 20% Marketing, 20% Marketing+WA, 10% Combo, 10% Full.

| Clientes | Ingresos | Costos variables | Metricool fijo | Neto USD | Neto ARS |
|---------|---------|-----------------|---------------|----------|---------|
| 5 | $256 | $105 | $25 | $126 | $176.400 |
| 10 | $513 | $210 | $25 | $278 | $389.200 |
| 15 | $769 | $315 | $67 | $387 | $541.800 |
| 20 | $1.025 | $420 | $67 | $538 | $753.200 |
| 30 | $1.538 | $630 | $97 | $811 | $1.135.400 |
| 50 | $2.563 | $1.050 | $139 | $1.374 | $1.923.600 |

No incluye extensiones ni ingresos adicionales de número WA.

---

## Estructura de cuentas y sucursales

- Cuenta madre con N sucursales adentro
- Login → selector de sucursal o vista consolidada
- Cada sucursal: catálogo propio, QR propio, pedidos propios, análisis propio
- Plan y facturación: unificados por cuenta madre
- Sucursal adicional: 35% del plan base

Roles:
- Administrador: acceso completo
- Operativo: solo pantalla de cocina/pedidos y catálogo del día. Sin facturación, sin análisis, sin Viti.
- Usuarios operativos: ilimitados en todos los planes, sin costo adicional.

---

## Sistema de notificaciones

Canal de gestión (dueño): alertas de uso, vencimientos, rendimiento, reseñas nuevas, publicaciones ejecutadas, resumen de actividad. WhatsApp y/o email según preferencia.

Canal operativo (local/cocina): pedidos nuevos, cambios de estado, alertas urgentes. Solo WhatsApp.

El dueño puede configurar ambos en el mismo número si lo prefiere.

---

## Landing page — cambios pendientes para Claude Code

- Imagen hero: vitrina de local comercial de noche, imagen libre de derechos (Unsplash/Pexels), genérica sin encasillar en ningún rubro
- Nueva sección "¿Qué tipo de negocio sos?" con íconos de cada rubro — muestra versatilidad
- Copys: reescribir para sonar humanos, no generados por IA. Usar especificidad ("El dueño de La Panera Rosa tardaba 3 horas/semana en Instagram. Ahora tarda 0."), frases coloquiales intencionales, números concretos
- Botón "Empezar gratis 14 días" repetido cada 2-3 secciones
- Cuando haya clientes reales: sección de casos de éxito con datos concretos

---

## Panel maestro de Sebastián

- Clientes: activos, nuevos, bajas, por plan, conversión trial→pago, churn (sin actividad 7+ días)
- Facturación: suscripciones, extensiones, total vs mes anterior, proyección
- Costos: Metricool fijo, variables por cliente, margen bruto del mes
- Metricool: slots disponibles, cuándo hacer upgrade
- Números WA: cuántos activos, costo fijo total
- Agentes: actividad, eficacia, costo en tokens/USD
- Por cliente: plan activo, productor asignado, uso IA este mes, costos acumulados, alertas

---

## Sistema de productores / revendedores

- Sebastián carga productores en el panel maestro
- Comisión estándar: 20% primer mes + 10% recurrente mientras el cliente siga activo
- Productor top (+10 clientes activos): 25% primer mes + 15% recurrente
- Panel muestra comisión por productor + botón "marcar como pagado"
- Reporte descargable para el contador

---

## Los agentes

### Agente programador
- Entra después de login + Supabase funcionando
- Hace solo: features completas, deploy, corrección de errores
- Consulta a Sebastián: deploy a producción, cambios de precios/planes, features nuevas no definidas
- Trabaja de noche: computadora prendida, pantalla bloqueada (no hibernando)
- Costo nocturno: Claude Haiku vía API — $0.50-2 USD por noche

### Agente de ventas
- Busca negocios con Google Places API según rubro objetivo
- Genera diagnóstico preliminar del negocio
- Manda WhatsApp (plantilla aprobada Meta) + email personalizado
- Seguimiento a los 3 días
- Registra todo en Supabase
- Avisa a Sebastián cuando hay interés real

### Agente de relaciones
- Seguimiento de clientes activos
- Detección de churn (sin actividad 7+ días)
- Encuestas de satisfacción
- Alimenta backlog del agente programador

### Agente de productores / contabilidad
- Comisiones mes a mes
- Reportes para Sebastián y contador
- Control de pagos de servicios

Todos se conectan vía Supabase. Un agente detecta algo → lo escribe en Supabase → otro agente lo toma.

---

## Decisiones firmes (no se negocian)

- Sin fee sobre ventas del menú/catálogo. Precio fijo mensual sin comisiones sobre transacciones.
- Sin fee sobre presupuesto publicitario. Gestión de publicidad paga incluida en el plan.
- Base de datos Supabase desde el arranque.
- Metricool activado desde el primer cliente de marketing (incluye marca Vitrina propia como slot 1).
- Instagram Basic Display API no existe desde diciembre 2024. Solo Instagram Graph API (4-6 semanas de aprobación). No mencionar Basic Display API en ningún contexto.
- Runway y videos generados con IA eliminados del producto. Solo subtítulos con Whisper para videos que sube el dueño.
- 5 aprobaciones consecutivas para cualquier modo automático (respuestas ML, publicaciones, stock sync, respuestas redes, respuestas Google).
- Tano es el nombre default para restaurantes, personalizable en onboarding.
- Asistente de locales no gastronómicos: el dueño elige el nombre desde el inicio del onboarding.
- Términos y condiciones y política de privacidad publicados antes del primer pago real y antes de solicitar aprobación de Meta.

---

## Competencia y diferenciadores

- SoyMenu / Carta.menu: $15-25 USD/mes, solo carta QR sin IA ni marketing
- Agencias de marketing: $150-400 USD/mes, sin tecnología propia ni integración con el negocio
- Nubimetrics: $30-50 USD/mes, solo análisis ML, sin presencia física ni redes
- Ningún competidor hace menú + pedidos + redes + ML/TN + IA conversacional + reservas + CRM en un solo panel para comercios argentinos

Diferenciador real: integración. No se vende como "marketing digital" ni "carta QR" sino como "el primer sistema que centraliza toda la presencia digital de un comercio en un lugar."

---

## Monitoreo de novedades

En cada sesión relevante mencionar proactivamente: nuevos modelos de IA más baratos, cambios en políticas de Meta/Google/ML/TN, nuevas APIs, herramientas de automatización, competidores nuevos en el mercado argentino.
