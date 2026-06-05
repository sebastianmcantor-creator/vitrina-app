# Vitrina — Arquitectura técnica

**Última actualización: 2026-06-01**

---

## Stack técnico

| Componente | Detalle |
|-----------|---------|
| Dominio | `vitrinaapp.com.ar` (DNS Cloudflare) |
| Frontend | HTML+JS inline (vanilla, sin bundler) → GitHub Pages (`main` → producción en ~2min) |
| Backend | Cloudflare Workers `vitrina-tano.vitrinaapp.workers.dev` (~211KB en `src/index.js`) |
| Base de datos | Supabase proyecto `zigtqvwerrtyuunayduh` (São Paulo) |
| IA | Claude Haiku 4.5 vía API Anthropic |
| IA imágenes | Cloudflare Workers AI (Flux Schnell) — gratuito |
| Email | Resend API (`contacto@vitrinaapp.com.ar`) |
| Pagos suscripciones | MercadoPago — token Vitrina (`MP_ACCESS_TOKEN`) |
| Pagos mesa restaurante | MP OAuth — cada restaurante conecta su propia cuenta |
| WhatsApp Business | Twilio como BSP. Vitrina compra los números, los gestiona, los asigna a clientes |
| Analytics | GA4 propiedad "Vitrina Web" ID `G-9FW2MERRWT` |
| Google OAuth | App publicada en producción |
| Meta App | ID `1626148071948901` namespace `vitrinaapp` (Live) |
| MP App OAuth | Client ID `3797856969955324` |
| Local | Claude Code, Node.js v24.15.0, Wrangler 4.85.0 |

## Carpetas del proyecto

| Carpeta | Contenido |
|---------|-----------|
| `C:\Users\sebas\vitrina-app` | Frontend (GitHub Pages) |
| `C:\Users\sebas\vitrina-server-worker` | Backend (Cloudflare Workers) |

---

## Páginas publicadas en vitrinaapp.com.ar

### Públicas (sin login)
- `index.html` — landing principal
- `para-restaurantes.html`, `para-servicios.html`, `para-comercios.html` — landings verticales
- `demo.html` — demo Casa Lucía (restaurante) + `?tipo=comercio` Ferretería El Tornillo
- `demo-servicios.html` — demo peluquería
- `whatsapp-setup.html` — info sobre el WhatsApp incluido en el plan (modelo Twilio asignación)
- `meta-setup.html` — guía interna del trámite Meta (documentación)
- `terms.html`, `privacy.html` — legales con CUIT, GA4, AAIP, MP, WA
- `pago-ok.html` — confirmación de pago (modo individual + consolidado por mesa)
- `status.html`, `404.html`, `oauth-callback.html`
- `manifest.json` + `sw.js` — PWA instalable
- `sitemap.xml`, `robots.txt`

### Con login
- `panel.html` — admin SPA completo (~11.000 líneas, 18 secciones)
- `cocina.html` — display de pedidos en tiempo real
- `menu.html` — menú público del comensal
- `mozo.html` — chat Tano embebido
- `maestro.html` — panel maestro de Sebastián (6 tabs)
- `login.html` — auth Google
- `suspended.html` — cuenta suspendida por falta de pago

### Utilidades temporales (no se exponen al cliente)
- `logo-export.html`, `logo-opciones.html`, `og-image-gen.html`, `qr-print.html`

---

## Endpoints del worker (~53 totales)

| Categoría | Endpoints | Descripción |
|-----------|-----------|-------------|
| `/api/claude` | 1 | Proxy Anthropic (Tano + Viti) |
| `/api/tipo-cambio` | 1 | TC oficial BCRA con cache 1h |
| `/api/social/*` | varios | Publica/programa en IG + FB vía API Meta |
| `/api/instagram/*` | varios | OAuth + métricas Instagram |
| `/api/facebook/*` | varios | OAuth + métricas Facebook |
| `/api/ml/*` | varios | OAuth + auto-respuestas MercadoLibre |
| `/api/tn/*` | varios | OAuth + sync Tienda Nube |
| `/api/cf-ai/*` | varios | Fotos con Cloudflare AI (Flux Schnell) |
| `/api/mp/*` | varios | Suscripciones, OAuth restaurante, webhooks pagos mesa |
| `/api/wa/*` | varios | Envío WA via Twilio, cola followup |
| `/api/notify/*` | varios | Emails y WA bienvenida, trial, alertas |
| `/api/notificar-*` | varios | Notificaciones adicionales |
| `/api/admin/*` | varios | Panel maestro |
| `/api/sales/*` | 8 | CRM de prospects (parcialmente implementado) |
| `/api/agenda/*` | varios | Turnos, recordatorios |
| `/api/reports/*` | varios | Informes |
| `/api/places/*` | varios | Google Places |
| `/api/geocode` | 1 | Geocodificación |
| `/api/whisper/transcribe` | 1 | Whisper OpenAI subtítulos |
| `/api/delivery/extract-screenshot` | 1 | Claude Vision para Rappi/PedidosYa |
| `/api/exchange-rate/*` | varios | TC bluelytics |
| `/api/health` | 1 | Estado de todos los servicios |
| `/api/landing-chat` | 1 | Chat de landing pública |
| `/api/lead` | 1 | Captura de leads |
| `/api/waitlist` | 1 | Lista de espera |

---

## Cron jobs activos en Cloudflare

Configurados en `wrangler.json` con handler `scheduled()` en el worker:

| Cron expression (UTC) | Hora ART | Tarea |
|----------------------|----------|-------|
| `0 13 * * *` | Diario 10am | `/api/agenda/send-reminders` + `/api/sales/process-followups` + procesar `wa_followup_queue` |
| `0 14 * * *` | Diario 11am | `/api/notify/trial-followup` + aviso 3 días antes de vencer |
| `0 13 * * 1` | Lunes 10am | `/api/exchange-rate/update` |
| `0 12 1 * *` | Día 1 9am | `/api/reports/send-monthly` |

**Deploy:** `cd C:\Users\sebas\vitrina-server-worker && npx wrangler deploy`

---

## Migraciones Supabase

**Total corridas: 27**
**Última migración:** `027_delivery_metrics.sql` (tabla métricas Rappi/PedidosYa)

### Tablas principales

`restaurants`, `menu_categories`, `menu_items`, `orders`, `order_items`, `restaurant_tables`, `integrations`, `social_posts`, `appointments`, `staff_resources`, `customers`, `admins`, `subscriptions`, `subscription_payments`, `wa_followup_queue`, `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`, `executive_reports`, `marketing_projections`, `monthly_metrics_snapshots`, `exchange_rates`, `delivery_metrics`, `campanas`, `waitlist`, `leads`, `agenda_config`

### Columnas críticas en `restaurants`

- `mp_access_token`, `mp_refresh_token`, `mp_user_id`, `mp_public_key`, `mp_connected`
- `twilio_number`, `twilio_sid` — **a agregar en migración 028** cuando se implemente modelo "número por cliente"
- `wa_followup_config` (JSONB)
- `business_type` (restaurant/services/local/ecommerce)

---

## Secrets configurados en Cloudflare

| Secret | Estado |
|--------|--------|
| ANTHROPIC_API_KEY | Activo |
| SUPABASE_URL, SUPABASE_SERVICE_KEY | Activo |
| MP_ACCESS_TOKEN, MP_PUBLIC_KEY, MP_APP_ID, MP_APP_SECRET | Activo |
| RESEND_API_KEY | Activo |
| TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_WHATSAPP_FROM | Activo (rotados 10/05) |
| GOOGLE_PLACES_API_KEY, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET | Activo |
| OPENAI_API_KEY | Activo (Whisper) |
| INSTAGRAM_APP_ID, INSTAGRAM_APP_SECRET | Activo (app Vitrina-IG ID `1618135162776352`) |
| ML_APP_ID, ML_CLIENT_SECRET | Pendiente cargar |
| TN_APP_ID, TN_CLIENT_SECRET | Activo |
| AI binding (Cloudflare Workers AI) | Activo |
| METRICOOL_CLIENT_ID, METRICOOL_CLIENT_SECRET | Dormido hasta contratar Metricool |
| ADMIN_WHATSAPP | Activo (teléfono Sebastián para alertas) |
| REPLICATE_API_TOKEN | Legacy, ya no se usa (fotos van por Cloudflare AI) |

---

## WhatsApp Business — modelo Twilio

### Por qué Twilio

Vitrina opera WhatsApp Business vía Twilio como BSP (Business Solution Provider). Twilio tiene sus propios permisos Meta aprobados, por lo cual Vitrina puede operar desde el día 1 sin esperar la aprobación del App Review de Meta WA.

### Flujo técnico por cliente

1. Cliente contrata plan pago
2. Worker compra número Twilio (~$1 USD/mes) asignado al cliente
3. Número se registra automáticamente en WA Business API de Meta vía Twilio (Twilio es BSP)
4. Twilio configura webhook → Worker
5. Worker identifica al cliente por el número entrante (routing)
6. Claude Haiku procesa el mensaje con contexto del negocio
7. Responde con voz del staff del negocio

### Lo que el cliente del negocio NO necesita

- Comprar chip nuevo
- Crear cuenta Meta Business Manager
- Cargar nada en developers.facebook.com
- Verificar su identidad con Meta
- Tener WhatsApp instalado en un celular

### Reglas anti-baneo programadas

1. Opt-in obligatorio para enviar marketing. Cada contacto debe haber iniciado al menos una conversación con el negocio antes.
2. Botón "Darse de baja" en cada mensaje marketing.
3. Tope por contacto: max 3 marketing/mes, max 1 cada 7 días.
4. Plantillas pre-aprobadas en Twilio. No se permite envío con texto libre como marketing.
5. Quality Rating monitoreado. Si baja a Yellow → pausa marketing 24hs y alerta.
6. Test antes de campañas grandes: si la campaña va a más de 100 contactos, se envía primero a 10, espera 1h, mide bloqueos. Si <2, sigue. Si >2, pausa.

### Costos reales para Vitrina por número/cliente/mes (uso típico)

| Concepto | USD |
|----------|-----|
| Línea Twilio | $1.00 |
| 150 utility × $0.0124 | $1.86 |
| Twilio fee mensajes (~300 in+out) | $1.50 |
| 50 marketing × $0.0625 | $3.13 |
| Twilio fee marketing | $0.25 |
| **Total con marketing (planes Marketing/Combo/Comercio)** | **$7.74** |
| **Total solo operativo (Solo Menú)** | **$4.36** |

---

## Meta App Review — estado actual (23/05/2026)

| Item | Estado |
|------|--------|
| App ID `1626148071948901` namespace `vitrinaapp` | Publicada (Live) |
| Casos de uso agregados | Instagram (Vitrina-IG `1618135162776352`), Facebook Pages, WhatsApp Business |
| Permisos base aprobados | `instagram_business_basic`, `instagram_manage_comments`, `instagram_business_manage_messages`, `public_profile` |
| Permisos avanzados en App Review | Solicitados 22/05: `instagram_manage_insights`, `instagram_manage_engagement`, `instagram_manage_messages`, `instagram_content_publish`, `business_management`, `pages_*`, `read_insights`, `whatsapp_business_messaging`, `whatsapp_business_management` |
| Business Verification | Enviada 20/05 con constancia AFIP. Verificar en Business Manager → Centro de seguridad |
| Video screencast | Pendiente — script preparado (~3-4 min) |

**No bloquea operaciones:** mientras los permisos avanzados de Meta WA esperan aprobación, operamos WhatsApp Business vía Twilio. Cuando Meta WA quede aprobado, se evalúa migrar de Twilio a Meta directo si conviene económicamente.

---

## Panel maestro de Sebastián

URL: `vitrinaapp.com.ar/maestro.html`
Acceso: solo emails en tabla `admins` de Supabase.

**6 tabs:**
- Vista General — clientes activos, nuevos, bajas, conversión trial→pago, churn
- Clientes — listado con plan, uso IA, costos acumulados, alertas
- Facturación — suscripciones, extensiones, total vs mes anterior, proyección
- Productores — listado, comisiones, botón "marcar como pagado"
- Agentes IA — actividad, eficacia, costo en tokens/USD
- Costos — Metricool fijo, variables por cliente, margen bruto

**Botón "Cortesía"** por fila de cliente que NO tenga plan activo. Activa `subscription_tier: 'rest-combo'`, `trialing`, +30 días, can_take_orders, Tano ilimitado.

---

## Mercado Libre + Tienda Nube

### MercadoLibre
- OAuth implementado (`/api/ml/auth`, `/api/ml/callback`)
- Auto-responder de preguntas con guardrails estrictos (`/api/ml/answer-question`)
- Webhook ML (`/api/ml/webhook`) → procesa auto-respuesta
- Pendiente: cargar credenciales de la app ML (App ID + Client Secret) en `wrangler secret put`

### Tienda Nube
- OAuth implementado (`/api/tn/auth`, `/api/tn/callback`)
- Sync stock bidireccional ML ↔ TN

### Publicación desde Vitrina en ML
1. Dueño inicia publicación desde Mi Catálogo
2. Viti genera título, descripción, fotos mejoradas, atributos, precio calculado
3. Primeras 5 publicaciones: Viti pregunta peso/dimensiones si no están cargados
4. Preview "así se verá en ML"
5. Dueño aprueba → publica via API
6. Tras 5 aprobaciones: modo automático disponible

---

## Sistema de alertas de costos variables

### Para Sebastián (panel maestro)
- Al 80% del costo estimado mensual: alerta en panel maestro + WA a Sebastián
- Al 100%: segunda alerta
- Al 120%: pausa automática de servicios variables (fotos, subtítulos, marketing)
- NUNCA se pausa: Tano, pedidos, cocina, pagos, reservas, utility WA
- Dentro de 24hs hábiles de la pausa: Vitrina contacta al cliente

### Para el cliente
- Al 80% de fotos: aviso con opción de extensión
- Idem para subtítulos, publicaciones, marketing WA
- Utility WA al 80% (120 mensajes): aviso suave sin pánico
- Utility WA NUNCA se pausa (operativo es crítico)
