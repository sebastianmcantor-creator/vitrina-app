---
name: vitrina
description: Skill maestro del proyecto Vitrina — SaaS de presencia digital inteligente para restaurantes, comercios y vendedores online, desarrollado por Sebastián. Activar SIEMPRE que Sebastián mencione Vitrina, restaurantes, locales, su app, su proyecto, clientes, menú digital, QR, mozo IA, Tano, Viti, La Panera Rosa, vitrinaapp.com.ar, Cloudflare, planes, precios, MercadoLibre, Tienda Nube, agente programador, o cualquier tema relacionado con el desarrollo de su plataforma.
---

# Vitrina — Skill Maestro del Proyecto

**Última actualización: 2026-05-23** · Fuente única de verdad. Sustituye y deja obsoletos todos los .md anteriores del proyecto.

---

## Quién es Sebastián

Trabaja solo, sin programadores. Experiencia en banca y finanzas (8 años). No sabe programar — construye Vitrina con Claude. Plan Claude Max $100 USD/mes para desarrollo, API key separada `ANTHROPIC_API_KEY` para producción.

Respuestas directas, sin "qué buena pregunta", "perfecto", "excelente", ni condescendencia. Cuando no hay contexto específico, mostrar estado actual y sugerir próximo paso lógico.

---

## Qué es Vitrina

SaaS de presencia digital y operaciones para comercios y restaurantes argentinos. Dos módulos que se contratan juntos o por separado:

**Módulo 1 — Presencia Digital:**
Análisis de Google Business, Instagram, Facebook. Estrategia mensual con Viti (IA sin género). Publicación automática directa vía API Meta (sin intermediarios como Metricool). Auto-respuesta de reseñas y comentarios. Análisis de competidores. Informe PDF mensual.

**Módulo 2 — Operaciones digitales:**
Menú/catálogo QR con Tano (asistente IA), sistema de pedidos, pantalla de cocina en tiempo real, pagos MercadoPago (restaurante conecta su propia cuenta MP), agenda de turnos, MercadoLibre y Tienda Nube integrados.

**Dos asistentes IA:**
- **Tano** — asistente para clientes finales. Nombre default para restaurantes, personalizable en onboarding.
- **Viti** — asistente estratégico del dueño. Sin género (siempre "Viti dice", "Viti analizó", nunca "él" ni "ella"). Analiza datos, genera estrategia, gestiona automatizaciones, responde consultas del negocio.
- Asistente personalizable para rubros no gastronómicos. Cada dueño elige el nombre desde el inicio del onboarding.

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
| WhatsApp Business | Twilio como BSP (Business Solution Provider). Vitrina compra los números, los gestiona, los asigna a clientes |
| Analytics | GA4 propiedad "Vitrina Web" ID `G-9FW2MERRWT` |
| Google OAuth | App publicada en producción |
| Meta App | ID `1626148071948901` namespace `vitrinaapp` (Live) |
| MP App OAuth | Client ID `3797856969955324` |
| Local | Claude Code, Node.js v24.15.0, Wrangler 4.85.0 |
| Carpetas | `C:\Users\sebas\vitrina-app` (frontend) y `C:\Users\sebas\vitrina-server-worker` (backend) |

---

## Planes y precios DEFINITIVOS (sin add-ons separados)

**Todos los precios en USD, cobrados en ARS al TC oficial Banco Nación (venta).** Actualización automática lunes 10am ART. Fallback 1.418 ARS/USD si la API cae.

**WhatsApp Business está incluido en TODOS los planes pagos.** Vitrina asigna el número (vía Twilio). El cliente NO trae su propio número Meta. NO hay planes "+WA" separados.

**Sin fee de transacción en ningún plan.**

### Restaurantes / Gastronomía

| Plan | USD/mes | Incluye |
|------|---------|---------|
| Free | $0 | Menú QR, Tano 75 msg/mes, 1 idioma, máx 45 platos, marca de agua |
| **Solo Menú** | **$27** | Pedidos online, cocina, pagos MP, Tano ilimitado ES/EN/PT, fotos IA. WA operativo (Tano responde consultas del menú + recordatorios de reserva + pedido listo). SIN campañas marketing por WA. |
| **Marketing** | **$57** | Viti estrategia mensual, 30 publicaciones auto/mes API Meta (IG+FB+Google), análisis competidores, informe PDF, WA con campañas (50/mes incluidas). |
| **Combo** | **$70** | Solo Menú + Marketing en un solo plan. Ahorra $14 vs separado. |

### Comercios / Locales / Servicios / Vendedores Online

| Plan | USD/mes | Incluye |
|------|---------|---------|
| Free | $0 | Catálogo QR, asistente con 75 msg/mes |
| **Marketing** | **$62** | Catálogo digital, asistente IA, ML + TN sync bidireccional, Viti, 30 publicaciones/mes, análisis competidores, WA con campañas. |

### WhatsApp incluido en TODOS los planes pagos — qué incluye

| Recurso | Solo Menú $27 | Marketing/Combo/Comercio |
|---------|---------------|--------------------------|
| Número exclusivo gestionado por Vitrina | ✅ | ✅ |
| Conversaciones service (iniciadas por cliente final) | Ilimitadas (free tier Meta 1000/mes) | Ilimitadas (idem) |
| Mensajes operativos (utility) | 150/mes | 150/mes |
| Campañas marketing | 0 (no incluye) | 50/mes |
| Asistente IA responde 24/7 | ✅ (consultas del menú/productos) | ✅ |
| Bandeja de mensajes en panel | ✅ | ✅ |

### Extensiones (todos los planes)

| Recurso | Incluido | Extensión | Precio |
|---------|----------|-----------|--------|
| Mensajes operativos WA | 150/mes | +50 mensajes | $2 USD |
| Campañas marketing WA | 50/mes | +50 mensajes | $3 USD |
| Tope marketing por línea (anti-baneo) | 500/mes | No extendible | — |
| Fotos IA | 60 al activar + 5/mes | +10 fotos | 1.000 ARS |
| Subtítulos Whisper | 10 videos/mes | +10 videos | $2 USD |
| Publicaciones auto | 30/mes | +15 publicaciones | $3 USD |

**Plan cortesía:** activación manual desde maestro.html. Primer mes gratis con `subscription_tier: 'rest-combo'`. Alerta a Sebastián al terminar.

---

## WhatsApp Business — modelo Twilio (definitivo)

**Decisión firme:** Vitrina opera WhatsApp Business vía Twilio como BSP. Twilio tiene sus propios permisos Meta aprobados, por lo cual Vitrina puede operar desde el día 1 sin esperar la aprobación del App Review de Meta WA.

**Flujo de activación para el cliente:**

1. Cliente contrata plan pago
2. Vitrina compra un número Twilio (~$1 USD/mes) y lo registra como WA Business
3. En 24hs hábiles el número queda operativo
4. Cliente ve "WA: Conectado" en el panel
5. Cliente imprime el QR con su nuevo número y lo pega en el local

**Lo que ve el cliente final del negocio:** el NOMBRE del negocio en grande (ej: "Ferretería López"), verificado si está aprobado. El número de EEUU aparece en segundo plano — igual como lo hacen Mercado Libre, bancos y aerolíneas.

**El cliente del negocio NO necesita:**
- Comprar chip nuevo
- Crear cuenta Meta Business Manager
- Cargar nada en developers.facebook.com
- Verificar su identidad con Meta
- Tener WhatsApp instalado en un celular

**Toda la operativa del WA pasa por el panel de Vitrina:**
- Bandeja de mensajes
- Respuestas con Tano/Viti automáticas
- Intervención manual desde el panel cuando el dueño quiere
- Campañas a la base de contactos

**Costos reales para Vitrina por número/cliente/mes (uso típico):**

| Concepto | USD |
|----------|-----|
| Línea Twilio | $1.00 |
| 150 utility × $0.0124 | $1.86 |
| Twilio fee mensajes (~300 in+out) | $1.50 |
| 50 marketing × $0.0625 | $3.13 |
| Twilio fee marketing | $0.25 |
| **Total con marketing (planes Marketing/Combo/Comercio)** | **$7.74** |
| **Total solo operativo (Solo Menú)** | **$4.36** |

**Reglas anti-baneo programadas:**

1. Opt-in obligatorio para enviar marketing. Cada contacto debe haber iniciado al menos una conversación con el negocio antes.
2. Botón "Darse de baja" en cada mensaje marketing.
3. Tope por contacto: max 3 marketing/mes, max 1 cada 7 días.
4. Plantillas pre-aprobadas en Twilio. No se permite envío con texto libre como marketing.
5. Quality Rating monitoreado. Si baja a Yellow → pausa marketing 24hs y alerta.
6. Test antes de campañas grandes: si la campaña va a más de 100 contactos, se envía primero a 10, espera 1h, mide bloqueos. Si <2, sigue. Si >2, pausa.

---

## Tipos de negocio soportados

Todo el panel, menú público y onboarding se adaptan automáticamente:

| Tipo | Sidebar muestra | Terminología |
|------|----------------|-------------|
| `restaurant` | Menú, Mesas, Reservas, Agenda, Pedidos | platos, mozo, menú, Tano |
| `services` | Servicios, Agenda, Pedidos | servicios, asistente IA, turnos |
| `local` | Catálogo, Pedidos | productos, asistente IA, catálogo |
| `ecommerce` | Catálogo, Pedidos | productos, asistente IA, tienda |

**Features exclusivas `restaurant`:**
- Mensajes de seguimiento automáticos WA post-pedido (`wa_followup_config`)
- Flujo de pago consolidado por mesa (banner acumulado, "Pedir la cuenta", botón "Cobrar" en cocina)
- Badge "💳 Pagado" en cocina al confirmarse el pago

**Rubros disponibles en onboarding:**
Restaurante/Bar/Café · Heladería/Pastelería · Rotisería/Delivery · Dietética/Almacén natural · Ropa/Calzado/Accesorios · Ferretería/Bazar/Herramientas · Peluquería/Barbería · Estética/Spa/Uñas · Veterinaria · Librería/Papelería · Kiosco/Minimarket · Servicios profesionales · Vendedor online puro · Otro (genérico)

---

## Principio de voz — Viti/Tano se hacen pasar por staff del negocio

**Regla firme aplicable a TODOS los mensajes WA al cliente final:**

Viti y Tano se hacen pasar por staff del negocio. **NUNCA** dicen:
- "soy Viti" / "soy Tano"
- "soy de Vitrina"
- "soy una IA" / "soy un asistente automático"

El cliente final cree que habla con alguien de Ferretería El Tornillo o La Panera Rosa. La voz por defecto es "el equipo" / "nosotros". Si el dueño configuró un nombre específico ("Marcos del local") se usa ese.

**Hacia el dueño del negocio** (panel + canal de gestión WA), Viti SÍ se identifica como Viti — ahí es la asistente del dueño y eso queda claro.

**Ejemplos correctos en WA al cliente final:**
- "Hola! ¿Para cuántas personas?"
- "Listo! Tu pedido está confirmado, ya lo estamos preparando."
- "Alguien del equipo te va a contactar en breve."
- "Gracias por tu compra."

**Ejemplos incorrectos (NUNCA):**
- "Hola, soy Tano, el asistente de [restaurante]"
- "Te responde Viti, soy una IA"
- "Vitrina recibió tu pedido"

---

## Cómo responde Viti/Tano por WhatsApp — flujos completos

### Restaurantes — Reservas

```
Cliente: "Hola, quiero reservar para el sábado"
Asistente: "Hola! ¿Para cuántas personas?"
Cliente: "Somos 4"
Asistente: "Para el sábado a las 4 personas tengo: 20:30, 22:00 o 22:45.
            ¿Cuál te queda mejor?"
Cliente: "21:30 si tenés"
Asistente: "Justo a las 21:30 no me queda. Te ofrezco 20:30 o 22:00.
            O si querés, sábado de la semana siguiente tengo 21:30 libre.
            ¿Qué preferís?"

[Si dice "no, gracias, otra vez será"]
Asistente: "Te entiendo. ¿Te aviso cuando se libere un horario más cercano
            a las 21:30 ese sábado?"
            [Si sí → guarda en customers con tag "waitlist_sabado_2130"]

[Si confirma horario]
Asistente: "Perfecto. ¿A nombre de quién la guardo?"
Cliente: "Martín"
Asistente: "Listo Martín, reserva para 4 el sábado a las 20:30.
            Te mando recordatorio el viernes. Si necesitás cambiar algo,
            escribime."
```

### Comercios — Venta sin TN/ML conectado

```
1. Cliente pregunta: "¿Tenés taladro Black & Decker?"
2. Asistente responde con imagen + descripción corta + precio + link pago MP
3. Cliente paga vía MP
4. Webhook MP confirma el pago
5. Worker manda DOS notificaciones simultáneas:

   → Al local (canal operativo WA, identificado como Viti):
     "Venta confirmada
      Producto: Taladro Black & Decker BDH200V
      Cliente: María González
      Teléfono: +54 11 2345-6789
      Pagó: $45.000 vía MP
      Contactala para coordinar retiro o envío."

   → Al cliente final (voz del negocio):
     "¡Listo! Tu pago se confirmó.
      Alguien del equipo te va a contactar en breve para coordinar retiro o envío.
      Si en 2 horas no tenés novedades, escribime y reviso."

6. El local llama al cliente desde SU número personal
   (NO consume conversaciones de Vitrina)

7. A las 2hs, Viti chequea si el local marcó "contactado" en el panel.
   Si no, alerta al local. Si pasa 4hs sin contacto, alerta a Sebastián.
```

### Conversaciones — conteo Meta

**Regla:** Cuando el cliente le habla al negocio, abre una **ventana service de 24hs gratis**. Dentro de la ventana, todos los mensajes del negocio son gratis. Fuera de la ventana, el negocio paga utility ($0.0124) o marketing ($0.0625) según tipo.

| Trigger | ¿Paga? |
|---------|--------|
| Confirmación de reserva (cliente acaba de escribir) | GRATIS (ventana abierta) |
| Recordatorio 24hs antes (cliente no escribió en 24hs) | PAGA utility |
| Recordatorio 2hs antes (si ya respondió al de 24hs) | GRATIS (ventana renovada) |
| Reserva del mismo día | GRATIS (ventana abierta todo el día) |
| Pedido listo (cliente confirmó por WA antes) | GRATIS |
| Pedido listo (sin ventana abierta) | PAGA utility |
| Mesa libre/waitlist (negocio inicia) | PAGA utility |
| Cerrado por feriado (cliente pregunta) | GRATIS |

Por eso 150 utility incluidas cubre uso normal con margen amplio.

### Campañas a futuro con datos del CRM

Tres tipos activables desde el panel:

1. **Reactivación de clientes existentes:** trigger "no volvió en 30/60/90 días". Mensaje promo. Max 1 vez cada 60 días al mismo cliente. Cuenta como marketing ($0.0625).
2. **Waitlist activación:** cuando se cancela una reserva del horario pedido. Mensaje al primero en la lista. Cuenta como utility ($0.0124).
3. **Eventos especiales:** el dueño lanza la campaña. A toda la base con opt-in. Max 1 cada 7 días al mismo contacto, max 3 al mismo en 30 días.

---

## Mi Catálogo — gestión de productos con descripción doble

**Campos por producto:**

| Campo | Para qué se usa | Obligatorio |
|-------|----------------|-------------|
| Nombre | QR catálogo, WA, ML, TN | Sí |
| Foto cruda | Vitrina la mejora con Cloudflare AI | Sí |
| **Descripción corta** (1-2 líneas, máx 150 chars) | QR catálogo, mensajes WA, mensajes ML rápidos | Sí |
| **Descripción completa** (texto largo, formato libre) | Publicación ML, ficha técnica TN, detalles cuando el cliente pregunta más en WA | Sí si vende por ML/TN |
| Atributos ML (marca, modelo, color, etc.) | Publicación ML | Sí si publica en ML |
| Peso y dimensiones | Cálculo de envío ML/TN | Sí si vende con envío |
| Costo de compra, precio, stock, mínimo alerta | Cálculos internos, alertas | Sí |
| SKU / código interno | Sync ML↔TN | Opcional |

**Carga por PDF o CSV:**
Cliente sube su catálogo. Claude Vision lee el PDF. La descripción corta se llena con lo extraído; la descripción completa la genera Viti automáticamente a partir del nombre + atributos y el dueño la edita.

**Cuando se publica en ML:**
Viti arma la publicación usando descripción completa + atributos. Si faltan datos, pregunta al dueño antes de publicar.

---

## Envíos para comercios

**Decisión firme: Vitrina NO integra couriers directos** (Andreani, OCA, Correo). Razones: 2-3 meses de desarrollo + soporte continuo, convenios individuales por vendedor, tarifas que cambian, mantenimiento.

**Tres opciones según qué tiene el local:**

### A) Local con Tienda Nube conectada
- Viti responde con stock/precio + "Si querés cerrar la compra, te dejo el carrito armado con envío incluido"
- Genera link al checkout TN con productos pre-cargados
- TN maneja envíos (Andreani, OCA, Mercado Envíos, retira en local)
- Vitrina recibe la venta vía webhook TN, descuenta stock en ML si está sync

### B) Local con MercadoLibre conectado (sin TN)
- Viti responde y da link directo a la publicación en ML
- ML maneja envíos (Mercado Envíos)

### C) Local SIN TN ni ML
- Viti responde + link pago MP
- Cliente paga
- Notificación dual: WA al local (con datos completos) + WA al cliente ("alguien del equipo te va a contactar en breve")
- Local coordina envío/retiro por su cuenta desde SU WhatsApp personal
- Sugerencia continua: banner en panel + mensaje mensual de Viti para que activen TN

**Mensaje en onboarding del local:**
> "Si vendés con envíos, lo más simple es activar Tienda Nube — tiene plan gratis hasta 50 productos y resuelve envíos con Andreani/OCA/Correo. Vitrina lo integra automáticamente. Si solo vendés pickup en local o coordinás envíos vos, también está OK — generamos links de pago y vos te encargás del resto."

**Cláusula en terms.html:**
> "Para productos sin envío integrado vía Tienda Nube o Mercado Libre, el comercio se contacta directamente con el comprador para coordinar entrega o retiro. Vitrina facilita la conexión y procesa el pago, pero no se hace responsable de la operativa de envío ni del cumplimiento del pedido por parte del comercio."

---

## Pago de mesa consolidado (restaurant only)

**Flujo:**

1. Comensal escanea QR → menu.html → arma pedidos
2. Banner fijo "Total acumulado de la visita: $X" se actualiza tras cada pedido
3. Cocina recibe pedidos en `cocina.html` vía Supabase Realtime
4. Comensal toca "Pedir la cuenta 💳" → `pedirLaCuenta()` → `POST /api/mp/crear-preferencia` → redirect MP
5. Si el restaurante tiene MP OAuth conectado, usa `rest.mp_access_token` (la plata va al restaurante). Si no, fallback al token Vitrina.
6. MP confirma pago → `POST /api/mp/order-webhook` → Worker marca `orders.status = 'paid'`
7. Supabase Realtime → `cocina.html` muestra "💳 Pagado" + toast verde 5s
8. Aparece botón "Cobrar mesa" en cocina con total acumulado y link MP en nueva pestaña

**Setup del restaurante:** Panel → Análisis → "💳 MercadoPago — Cobros de mesa" → "Conectar cuenta" → OAuth MP → guarda tokens en `restaurants`. Vitrina no toca esos fondos.

---

## Mensajes de seguimiento WA post-pedido (restaurant only)

Feature en panel.html → Configuración → "💬 Mensajes de seguimiento durante la visita".
Solo visible para `business_type === 'restaurant'`.

**Config guardada en `wa_followup_config` (JSONB en `restaurants`):**
```json
{
  "enabled": true,
  "messages": [
    {"delay_min": 2,  "trigger": "first_plate",  "text": "...", "enabled": true},
    {"delay_min": 30, "trigger": "all_plates",   "text": "...", "enabled": true},
    {"delay_min": 45, "trigger": "after_msg2",   "text": "...", "enabled": true}
  ]
}
```

**Flujo:**
- cocina.html → status `ready` → `scheduleFollowup(pedido, 'first_plate')` → msg1 (2 min)
- cocina.html → status `delivered` → `scheduleFollowup(pedido, 'all_plates')` → msg2 (30 min) + msg3 (75 min)
- Msg3 consulta `menu_items WHERE category ILIKE '%postre%' LIMIT 3` e interpola `{postres}`
- Worker encola en `wa_followup_queue`; cron procesa y envía via Twilio
- **Requires:** WA configurado para el restaurante. Si no, muestra aviso en lugar del toggle.

---

## Sistema de respuestas automáticas — 5 aprobaciones

Aplica a: preguntas ML, publicaciones ML desde Vitrina, respuestas IG/FB/Google, bajada de stock en TN tras venta en ML, publicaciones en redes desde Viti.

**SIEMPRE son 5 aprobaciones consecutivas para activar el modo automático.**

- Si el dueño rechaza una sugerencia: el contador vuelve a 0.
- Tras 5 aprobaciones seguidas: Viti pregunta "¿Querés que lo haga solo de ahora en más?"
- En modo automático: actúa en menos de 2 minutos, manda resumen diario.
- Excepción: si Viti no tiene certeza, manda al dueño aunque esté en modo automático.
- El dueño puede pausar el modo automático diciéndoselo a Viti: "Viti, pausá las respuestas de Instagram."

**Canales con respuestas automáticas:**
- Preguntas de compradores ML
- Comentarios en Instagram (feed + Reels)
- Mensajes directos Instagram (solo en planes con WA marketing)
- Comentarios en Facebook
- Reseñas en Google Business Profile
- Mensajes WhatsApp (todos los planes pagos)

**Aprendizaje del estilo:** Viti analiza las últimas 50 respuestas dadas por el dueño en cada canal antes de proponer respuestas propias. Mantiene la voz del dueño.

---

## Onboarding simplificado

Flujo actual:

1. **Tipo de negocio** (restaurant / services / local / ecommerce) — 4 cards visuales
2. **Solo el nombre** del negocio (URL se genera automático) → "Crear mi negocio →"
3. **Adentro** → checklist "Primeros pasos" adaptado al tipo (7 ítems según rubro)
4. Conexión de redes (Google Business + Instagram + Facebook) → análisis preliminar en 2-3 min antes de pagar
5. Nombre del asistente: restaurantes default "Tano" (personalizable), otros eligen nombre
6. Canales de notificación: gestión (dueño) + operativo (local)
7. Carga del catálogo/menú
8. QR (por mesa o genérico)
9. Activación del plan: cobro automático MP. WA Business se activa en 24hs hábiles.

---

## Sistema de alertas de costos variables

### Para Sebastián (panel maestro)
- Cada costo variable suma al acumulado del mes en Supabase por cliente
- Al 80% del costo estimado mensual: alerta en panel maestro + WA a Sebastián
- Al 100%: segunda alerta
- Al 120%: pausa automática de servicios variables (fotos, subtítulos, marketing). NUNCA se pausa: Tano, pedidos, cocina, pagos, reservas, utility WA.
- Dentro de 24hs hábiles de la pausa: Vitrina contacta al cliente

### Para el cliente
- Al 80% de fotos: aviso con opción de extensión
- Idem para subtítulos, publicaciones, marketing WA
- Utility WA al 80% (120 mensajes): aviso suave sin pánico
- Utility WA NUNCA se pausa (operativo es crítico)

### Cláusula aprobada en términos
"Los servicios variables de Vitrina están dimensionados para un uso normal según el plan contratado. Vitrina se reserva el derecho de notificar al cliente y, de ser necesario, pausar temporalmente servicios variables ante un uso significativamente superior al estimado, sin afectar en ningún caso los servicios operativos."

---

## Informes automáticos (todos los planes pagos)

### Frecuencia
- Semanas 1-4: informe diario (texto WA + email, máx 5 líneas WA)
- Inicio de semana 5: Viti pregunta "¿Seguís con diario o pasamos a semanal completo?"
- Siempre: semanal (configurable jueves/viernes) + mensual PDF el día 1

### Canales
WhatsApp + email simultáneos. PDF como adjunto en email + link Supabase Storage en WA.

### Informe diario (5 líneas WA)
- Plan Solo Menú: pedidos del día, facturación, platos más pedidos, reseñas nuevas Google
- Planes con marketing: métricas redes del día, publicaciones publicadas, nuevas preguntas ML, ventas ML, stock crítico

### Informe semanal (PDF 2 páginas)
- Métricas semana vs semana anterior
- Top 3 publicaciones
- Alertas importantes
- Competidores: qué hicieron esta semana

### Informe mensual (PDF 8-12 páginas)
- Logo del negocio en encabezado
- Performance vs proyecciones
- Análisis por canal (Google, IG, FB, ML, TN)
- Qué funcionó y qué no, con datos
- Estrategia ajustada para el mes siguiente
- Firma discreta al pie: "Generado por Vitrina"
- El dueño puede presentarlo como propio

Diseño: A4, márgenes generosos, fuente mínima 12pt, B&N friendly, gráficos de barras/líneas (no tortas).

---

## Mails — firma sin datos personales

**Regla firme:** NINGÚN mail al cliente final ni a prospects puede contener:
- "Sebastián Medina Cantor"
- CUIT 20-36594388-6
- Camargo 327
- C1414 CABA

Solo aparecen en `terms.html` y `privacy.html` por exigencia legal. En cualquier otra parte del producto: NO.

**Firma estándar:**
- "Equipo de Vitrina" (default)
- "Sebastián de Vitrina" (en mails personales como seguimiento de trial)
- "Vitrina"

**Footer estándar:**
```
Saludos,
[Firma según contexto]

Vitrina · vitrinaapp.com.ar
Si no querés recibir más mails como este: [Darse de baja]
[Política de privacidad] · [Términos]
```

**Configuración antispam (Resend):**
- Dominio verificado vitrinaapp.com.ar ✅
- SPF, DKIM, DMARC configurados
- Personalización por destinatario (no copy/paste exacto)
- Volumen gradual cuando se hagan campañas frías

---

## Panel maestro de Sebastián

URL: `vitrinaapp.com.ar/maestro.html`
Acceso: solo emails en tabla `admins` de Supabase.

**6 tabs:**
- 📊 Vista General — clientes activos, nuevos, bajas, conversión trial→pago, churn
- 👥 Clientes — listado con plan, uso IA, costos acumulados, alertas
- 💰 Facturación — suscripciones, extensiones, total vs mes anterior, proyección
- 🤝 Productores — listado, comisiones, botón "marcar como pagado"
- 🤖 Agentes IA — actividad, eficacia, costo en tokens/USD
- 📉 Costos — Metricool fijo, variables por cliente, margen bruto

**Botón "🎁 Cortesía"** por fila de cliente que NO tenga plan activo. Activa `subscription_tier: 'rest-combo'`, `trialing`, +30 días, can_take_orders, Tano ilimitado.

---

## Panel maestro de ventas (CRM de prospects)

**Estado actual:** parcialmente implementado en el backend. Endpoints `/api/sales/*` existentes:
- `/api/sales/search-restaurants` — busca prospects vía Google Places
- `/api/sales/generate-diagnosis` — genera análisis con Claude
- `/api/sales/create-prospect` — guarda en `sales_prospects`
- `/api/sales/contact` — envía WA
- `/api/sales/process-followups` — procesa seguimientos
- `/api/sales/prospects`, `/api/sales/config`, `/api/sales/metrics`

**Tablas:** `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`.

**Falta construir:**
- Vista CRM en `maestro.html`
- Envío de mail con PDF adjunto (informe personalizado del prospect)
- Cron seguimiento 4/7/15 días
- Distribución gradual de envíos (50/día semana 1 → 200/día semana 5)
- Sistema de estados (contactado/abierto/respondió/interesado/trial/cliente/baja)

**Filtros de búsqueda:**
- Rubro
- Zona (default: GBA Oeste/Sur + Córdoba + Rosario)
- Estado del negocio (solo OPERATIONAL en Google Places)
- Rating mínimo
- Reseñas mínimas (50+)
- Tiene sitio web / IG público
- Última reseña reciente
- Sin contactar antes
- Excluir ya cliente

**Horarios envío:**
- Restaurantes: 12-22 ART
- Locales/Comercios: 10-17 ART
- Cron Cloudflare lo gestiona automático

**Efectividad esperada (200 mails/día a régimen):**
- Open rate: 25-35%
- Reply rate: 2-4%
- Trial activado: 0.5-1.5%
- Trial → pago: 20-30%
- Proyección conservadora: 5-12 clientes pagos nuevos/mes

**Costos operativos del sistema de ventas/mes:** ~$12 USD total (Google Places + Claude Haiku + Resend + Twilio + Cloudflare).

---

## Metricool — modelo de activación

**Decisión:** Metricool **NO** está activo todavía. La publicación auto a IG/FB se hace directo vía API Meta desde el worker. Metricool se contratará cuando Sebastián confirme. Los endpoints del worker (`/api/metricool/*`) y los secrets (`METRICOOL_CLIENT_ID`, `METRICOOL_CLIENT_SECRET`) se mantienen para reactivarlo en cuanto se contrate.

**Plan recomendado al activar:** 15 marcas (€43/mes ≈ $46 USD). Vitrina ocupa slot 1, quedan 14 para clientes. Activar con el primer cliente Marketing pago.

**Cuándo escalar:**
| Clientes con Marketing | Plan Metricool | Costo |
|------------------------|----------------|-------|
| 0-14 | Starter 15 marcas | $46 |
| 15-24 | Advanced 25 | $73 |
| 25+ | Enterprise 50 | $138 |

**Lo que hará Metricool cuando se contrate:**
- Programación de posts IG/FB (alternativa o redundancia a la API Meta directa)
- Analytics consolidados
- Stories e Instagram Reels programados

---

## Meta App Review — estado actual (23/05/2026)

| Item | Estado |
|------|--------|
| App ID `1626148071948901` namespace `vitrinaapp` | ✅ Publicada (Live) |
| Casos de uso agregados | ✅ Instagram (Vitrina-IG `1618135162776352`), Facebook Pages, WhatsApp Business |
| Permisos base | ✅ Aprobados: `instagram_business_basic`, `instagram_manage_comments`, `instagram_business_manage_messages`, `public_profile` |
| Permisos avanzados en App Review | ⏳ Solicitados 22/05: `instagram_manage_insights`, `instagram_manage_engagement`, `instagram_manage_messages`, `instagram_content_publish`, `business_management`, `pages_*`, `read_insights`, `whatsapp_business_messaging`, `whatsapp_business_management` |
| Business Verification | ⏳ Enviada 20/05 con constancia AFIP. Verificar en Business Manager → Centro de seguridad |
| Video screencast | ⏳ Pendiente — script preparado (~3-4 min) |

**No bloquea operaciones:** mientras los permisos avanzados de Meta WA esperan aprobación, operamos WhatsApp Business vía Twilio (BSP con permisos propios ya aprobados). Esto nos permite vender desde el día 1.

**Cuando Meta WA quede aprobado:** podemos evaluar migrar de Twilio a Meta directo si conviene económicamente. Mientras tanto, Twilio es la opción operativa.

---

## Mercado Libre + Tienda Nube

**Mercado Libre:**
- OAuth implementado (`/api/ml/auth`, `/api/ml/callback`)
- Auto-responder de preguntas con guardrails estrictos (`/api/ml/answer-question`)
- Webhook ML (`/api/ml/webhook`) → procesa auto-respuesta
- **Pendiente:** cargar credenciales de la app ML (App ID + Client Secret) en `wrangler secret put`

**Tienda Nube:**
- OAuth implementado (`/api/tn/auth`, `/api/tn/callback`)
- Sync stock bidireccional ML ↔ TN

**Publicación desde Vitrina en ML:**
1. Dueño inicia publicación desde Mi Catálogo
2. Viti genera título, descripción (usa descripción_completa + atributos), fotos mejoradas, atributos, precio calculado
3. Primeras 5 publicaciones: Viti pregunta peso/dimensiones si no están cargados
4. Preview "así se verá en ML"
5. Dueño aprueba → publica via API
6. Tras 5 aprobaciones: modo automático disponible

**Cálculo de precio ML automático:**
Precio publicación = costo + margen pretendido + comisión ML + envío estimado. Si no es competitivo contra top 10 competidores, Viti avisa.

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

## Endpoints del worker (53 totales)

**Categorías:**
- `/api/claude` — proxy Anthropic (Tano + Viti)
- `/api/tipo-cambio` — TC oficial BCRA con cache 1h
- `/api/social/*` — publica/programa en IG + FB vía API Meta
- `/api/instagram/*`, `/api/facebook/*` — OAuth + métricas
- `/api/ml/*`, `/api/tn/*` — OAuth + auto-respuestas ML
- `/api/cf-ai/*` — fotos con Cloudflare AI (Flux Schnell, gratis)
- `/api/mp/*` — suscripciones, OAuth restaurante, webhooks pagos mesa
- `/api/wa/*` — envío WA via Twilio, cola followup
- `/api/notify/*`, `/api/notificar-*` — emails y WA bienvenida, trial, alertas
- `/api/admin/*` — panel maestro
- `/api/sales/*` — CRM de prospects (8 endpoints, parcialmente implementado)
- `/api/agenda/*` — turnos, recordatorios
- `/api/reports/*` — informes
- `/api/places/*`, `/api/geocode` — Google Places
- `/api/whisper/transcribe` — Whisper OpenAI subtítulos
- `/api/delivery/extract-screenshot` — Claude Vision para Rappi/PedidosYa
- `/api/exchange-rate/*` — TC bluelytics
- `/api/health` — estado de todos los servicios
- `/api/landing-chat`, `/api/lead`, `/api/waitlist` — landing public

---

## Migraciones Supabase (27 corridas)

Última: **027_delivery_metrics.sql** (tabla métricas Rappi/PedidosYa)

**Tablas principales:**
`restaurants`, `menu_categories`, `menu_items`, `orders`, `order_items`, `restaurant_tables`, `integrations`, `social_posts`, `appointments`, `staff_resources`, `customers`, `admins`, `subscriptions`, `subscription_payments`, `wa_followup_queue`, `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`, `executive_reports`, `marketing_projections`, `monthly_metrics_snapshots`, `exchange_rates`, `delivery_metrics`, `campanas`, `waitlist`, `leads`, `agenda_config`.

**Columnas críticas en `restaurants`:**
- `mp_access_token`, `mp_refresh_token`, `mp_user_id`, `mp_public_key`, `mp_connected`
- `twilio_number`, `twilio_sid` (a agregar en migración 028 cuando se implemente modelo "número por cliente")
- `wa_followup_config` (JSONB)
- `business_type` (restaurant/services/local/ecommerce)

---

## Secrets configurados en Cloudflare

| Secret | Estado |
|--------|--------|
| ANTHROPIC_API_KEY | ✅ |
| SUPABASE_URL, SUPABASE_SERVICE_KEY | ✅ |
| MP_ACCESS_TOKEN, MP_PUBLIC_KEY, MP_APP_ID, MP_APP_SECRET | ✅ |
| RESEND_API_KEY | ✅ |
| TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_WHATSAPP_FROM | ✅ rotados 10/05 |
| GOOGLE_PLACES_API_KEY, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET | ✅ |
| OPENAI_API_KEY | ✅ (Whisper) |
| INSTAGRAM_APP_ID, INSTAGRAM_APP_SECRET | ✅ (la app Vitrina-IG es ID `1618135162776352`) |
| ML_APP_ID, ML_CLIENT_SECRET | ⏳ pendiente cargar |
| TN_APP_ID, TN_CLIENT_SECRET | ✅ |
| AI binding (Cloudflare Workers AI) | ✅ |
| METRICOOL_CLIENT_ID, METRICOOL_CLIENT_SECRET | 💤 dormido hasta contratar Metricool |
| ADMIN_WHATSAPP | ✅ teléfono Sebastián para alertas |
| REPLICATE_API_TOKEN | ✅ (legacy, ya no se usa — fotos van por Cloudflare AI) |

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

## Costos operativos y márgenes (proyección)

**Costos fijos mensuales:**
| Componente | USD |
|-----------|-----|
| Cloudflare Workers | $5 |
| Dominio | $1.25 |
| Google Workspace | $6 |
| Claude Max (Sebastián) | $100 |
| Resend (plan gratis hasta 3.000 mails/mes) | $0 |
| **Total fijo** | **$112.25** |

**Costos variables por cliente/mes (uso típico):**

| Plan | Componentes | Costo | Margen | % |
|------|-------------|-------|--------|---|
| Solo Menú $27 | $3.58 base + $4.36 WA operativo | **$7.94** | **$19.06** | 71% |
| Marketing $57 | $15.06 + $7.74 WA + $3.30 Metricool (a 14 clientes) | **$26.10** | **$30.90** | 54% |
| Combo $70 | $15.58 + $7.74 + $3.30 | **$26.62** | **$43.38** | 62% |
| Comercio Marketing $62 | $15.06 + $7.74 + $3.30 | **$26.10** | **$35.90** | 58% |

**Proyección de ganancia neta mensual:**

| Clientes activos | Ingresos USD | Costos var. USD | Costos fijos USD | **Neto USD** | **Neto ARS** (×1418) |
|-----------------|--------------|-----------------|------------------|--------------|----------------------|
| 5 | $260 | $50 | $112 | **$98** | **$138.964** |
| 10 | $520 | $100 | $112 | **$308** | **$436.744** |
| 15 | $780 | $150 | $112 | **$518** | **$734.524** |
| 20 | $1.040 | $200 | $112 | **$728** | **$1.032.304** |
| 30 | $1.560 | $300 | $112 | **$1.148** | **$1.627.864** |
| 50 | $2.600 | $500 | $112 | **$1.988** | **$2.818.984** |

---

## Decisiones firmes (no se negocian)

1. **Sin fee sobre ventas** del menú/catálogo. Precio fijo mensual sin comisiones sobre transacciones.
2. **Sin fee sobre presupuesto publicitario.** Gestión de publicidad incluida.
3. **Base de datos Supabase** desde el arranque.
4. **WhatsApp Business vía Twilio** (no Meta directo). Vitrina asigna el número, el cliente NO trae el suyo.
5. **WhatsApp Business INCLUIDO en TODOS los planes pagos.** No hay +WA separado.
6. **Metricool dormido** — endpoints y secrets se mantienen pero no se usa hasta contratar.
7. **Publicación social directa vía API Meta** desde el worker. Sin intermediarios.
8. **Sin couriers directos.** Redirigimos a TN/ML o el local coordina por su cuenta.
9. **5 aprobaciones consecutivas** para cualquier modo automático (respuestas ML, publicaciones, stock sync, respuestas redes, respuestas Google).
10. **Tano default para restaurantes**, personalizable en onboarding.
11. **No gastronómicos: nombre del asistente lo elige el dueño desde el inicio.**
12. **Viti/Tano se hacen pasar por staff del negocio** hacia el cliente final. Solo se identifican como Viti hacia el dueño.
13. **Sin datos personales en mails ni en código visible al cliente final.** Los datos legales están solo en terms.html y privacy.html.
14. **Términos y privacidad publicados** antes del primer pago real y antes de solicitar aprobación de Meta. ✅ ya hecho.
15. **Instagram Basic Display API no existe** desde diciembre 2024. Solo Instagram Graph API. No mencionar Basic Display API nunca.
16. **Runway y videos generados con IA: eliminados** del producto. Solo subtítulos Whisper para videos que sube el dueño.
17. **Sebastián paga plan Claude Max $100/mes** para desarrollo. La API de producción usa su ANTHROPIC_API_KEY facturada aparte.

---

## Sistema de productores / revendedores

- Sebastián carga productores en maestro.html
- Comisión estándar: 20% primer mes + 10% recurrente
- Productor top (+10 clientes activos): 25% primer mes + 15% recurrente
- Panel: comisión por productor + botón "marcar como pagado"
- Reporte descargable para el contador

---

## Pendientes técnicos prioritarios

| # | Pendiente | Quién |
|---|-----------|-------|
| 1 | Verificar Business Verification Meta en Business Manager | Sebastián |
| 2 | Grabar video screencast para App Review (script preparado) | Sebastián |
| 3 | Migrar código Twilio a modelo "número por cliente" (asignación automática + webhook routing) | Claude |
| 4 | Implementar sistema de límites Twilio (150 utility, 50 marketing, extensiones, tope 500) | Claude |
| 5 | Construir vista CRM en maestro.html + completar sales agent | Claude |
| 6 | Agregar columnas descripción_corta + descripción_completa en menu_items | Claude |
| 7 | Implementar flujo "comercio sin TN/ML" (notificación dual local + cliente) | Claude |
| 8 | Cargar credenciales ML (App ID + Client Secret) en wrangler secrets | Sebastián |
| 9 | Hacer `npx wrangler deploy` para activar los crons recién agregados | Sebastián |
| 10 | Sincronizar este CLAUDE.md con la skill del plugin Vitrina | Claude |

---

## Arquitectura WhatsApp — número dedicado por cliente vía Twilio

Cada cliente que contrata plan pago recibe su propio número de WhatsApp Business gestionado desde la cuenta Twilio de Vitrina.

**Lo que ve el cliente final del negocio:** el NOMBRE del negocio en grande (ej: "Ferretería López"). El número de EEUU aparece en segundo plano.

**Flujo técnico:**
1. Cliente contrata plan
2. Worker compra número Twilio (~$1 USD/mes) asignado al cliente
3. Número se registra automáticamente en WA Business API de Meta vía Twilio (Twilio es BSP)
4. Twilio configura webhook → Worker
5. Worker identifica al cliente por el número entrante (routing)
6. Claude Haiku procesa el mensaje con contexto del negocio
7. Responde con voz del staff del negocio

**Costo real para Vitrina por número/mes:** $4-8 USD según marketing usado.
**Está incluido en el precio del plan**, sin add-on extra.

---

## Cómo se vende el WA por rubro

- Restaurante/Bar: "Mozo Virtual por WhatsApp"
- Ferretería/Bazar: "Asesor de Productos por WhatsApp"
- Peluquería/Estética: "Asistente de Turnos por WhatsApp"
- Vendedor ML/TN: "Vendedor Automático por WhatsApp"
- Cualquier rubro: "Tu asistente inteligente, disponible 24/7"

---

## Flujo de pedidos QR — ahorro de costos Meta

Cuando el comensal confirma un pedido desde el menú QR:

1. El pedido se registra en Supabase `orders` → la pantalla `cocina.html` lo recibe vía Realtime
2. **Acto seguido** aparece botón verde "Confirmar por WhatsApp" opcional
3. Si el comensal lo toca: se abre SU WhatsApp con un mensaje pre-escrito hacia el restaurante. **Él aprieta enviar.**
4. Ese mensaje **abre la ventana de 24hs gratuita** de Meta — durante esas 24hs todos los avisos del negocio son gratis
5. La cocina recibe el pedido **siempre** en cocina.html, independiente de si el cliente apretó WA

| Acción | Cómo se entera la cocina | Costo Vitrina |
|--------|--------------------------|---------------|
| Cliente confirma pedido en QR | Supabase Realtime → cocina.html | $0 |
| Cliente aprieta "Confirmar por WA" (opcional) | También por WA | $0 (lo inicia el cliente) |
| Cliente NO aprieta WA | Igual en cocina.html | $0 |
| Cocina aprieta "Listo" → aviso al cliente | Twilio WA → cliente | $0 si ventana abierta, $0.0124 utility si no |

---

## Estructura de cuentas y sucursales

- Cuenta madre con N sucursales adentro
- Login → selector de sucursal o vista consolidada
- Cada sucursal: catálogo propio, QR propio, pedidos propios, análisis propio
- Plan y facturación: unificados por cuenta madre
- Sucursal adicional: 35% del plan base

**Roles:**
- Administrador: acceso completo
- Operativo: solo cocina/pedidos/catálogo del día. Sin facturación, sin análisis, sin Viti.
- Usuarios operativos: ilimitados sin costo

---

## Competencia y diferenciadores

| Competidor | Precio | Lo que hace |
|-----------|--------|-------------|
| SoyMenu / Carta.menu | $15-25 USD/mes | Solo carta QR, sin IA ni marketing |
| Agencias de marketing | $150-400 USD/mes | Sin tecnología propia ni integración con el negocio |
| Nubimetrics | $30-50 USD/mes | Solo análisis ML, sin presencia física ni redes |

**Diferenciador real:** integración. No se vende como "marketing digital" ni "carta QR" sino como "el primer sistema que centraliza toda la presencia digital de un comercio en un lugar."

---

## Monitoreo de novedades

En cada sesión relevante mencionar proactivamente: nuevos modelos de IA más baratos, cambios en políticas de Meta/Google/ML/TN, nuevas APIs, herramientas de automatización, competidores nuevos en el mercado argentino.
