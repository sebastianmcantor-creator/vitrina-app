---
name: vitrina
description: Skill maestro del proyecto Vitrina â€” SaaS de presencia digital inteligente para restaurantes, comercios y vendedores online, desarrollado por SebastiÃ¡n. Activar SIEMPRE que SebastiÃ¡n mencione Vitrina, restaurantes, locales, su app, su proyecto, clientes, menÃº digital, QR, mozo IA, Tano, Viti, La Panera Rosa, vitrinaapp.com.ar, Cloudflare, planes, precios, MercadoLibre, Tienda Nube, agente programador, o cualquier tema relacionado con el desarrollo de su plataforma.
---

# Vitrina â€” Skill Maestro del Proyecto

**Ãšltima actualizaciÃ³n: 2026-05-23** Â· Fuente Ãºnica de verdad. Sustituye y deja obsoletos todos los .md anteriores del proyecto.

---

## QuiÃ©n es SebastiÃ¡n

Trabaja solo, sin programadores. Experiencia en banca y finanzas (8 aÃ±os). No sabe programar â€” construye Vitrina con Claude. Plan Claude Max $100 USD/mes para desarrollo, API key separada `ANTHROPIC_API_KEY` para producciÃ³n.

Respuestas directas, sin "quÃ© buena pregunta", "perfecto", "excelente", ni condescendencia. Cuando no hay contexto especÃ­fico, mostrar estado actual y sugerir prÃ³ximo paso lÃ³gico.

---

## QuÃ© es Vitrina

SaaS de presencia digital y operaciones para comercios y restaurantes argentinos. Dos mÃ³dulos que se contratan juntos o por separado:

**MÃ³dulo 1 â€” Presencia Digital:**
AnÃ¡lisis de Google Business, Instagram, Facebook. Estrategia mensual con Viti (IA sin gÃ©nero). PublicaciÃ³n automÃ¡tica directa vÃ­a API Meta (sin intermediarios como Metricool). Auto-respuesta de reseÃ±as y comentarios. AnÃ¡lisis de competidores. Informe PDF mensual.

**MÃ³dulo 2 â€” Operaciones digitales:**
MenÃº/catÃ¡logo QR con Tano (asistente IA), sistema de pedidos, pantalla de cocina en tiempo real, pagos MercadoPago (restaurante conecta su propia cuenta MP), agenda de turnos, MercadoLibre y Tienda Nube integrados.

**Dos asistentes IA:**
- **Tano** â€” asistente para clientes finales. Nombre default para restaurantes, personalizable en onboarding.
- **Viti** â€” asistente estratÃ©gico del dueÃ±o. Sin gÃ©nero (siempre "Viti dice", "Viti analizÃ³", nunca "Ã©l" ni "ella"). Analiza datos, genera estrategia, gestiona automatizaciones, responde consultas del negocio.
- Asistente personalizable para rubros no gastronÃ³micos. Cada dueÃ±o elige el nombre desde el inicio del onboarding.

---

## Stack tÃ©cnico

| Componente | Detalle |
|-----------|---------|
| Dominio | `vitrinaapp.com.ar` (DNS Cloudflare) |
| Frontend | HTML+JS inline (vanilla, sin bundler) â†’ GitHub Pages (`main` â†’ producciÃ³n en ~2min) |
| Backend | Cloudflare Workers `vitrina-tano.vitrinaapp.workers.dev` (~211KB en `src/index.js`) |
| Base de datos | Supabase proyecto `zigtqvwerrtyuunayduh` (SÃ£o Paulo) |
| IA | Claude Haiku 4.5 vÃ­a API Anthropic |
| IA imÃ¡genes | Cloudflare Workers AI (Flux Schnell) â€” gratuito |
| Email | Resend API (`contacto@vitrinaapp.com.ar`) |
| Pagos suscripciones | MercadoPago â€” token Vitrina (`MP_ACCESS_TOKEN`) |
| Pagos mesa restaurante | MP OAuth â€” cada restaurante conecta su propia cuenta |
| WhatsApp Business | Twilio como BSP (Business Solution Provider). Vitrina compra los nÃºmeros, los gestiona, los asigna a clientes |
| Analytics | GA4 propiedad "Vitrina Web" ID `G-9FW2MERRWT` |
| Google OAuth | App publicada en producciÃ³n |
| Meta App | ID `1626148071948901` namespace `vitrinaapp` (Live) |
| MP App OAuth | Client ID `3797856969955324` |
| Local | Claude Code, Node.js v24.15.0, Wrangler 4.85.0 |
| Carpetas | `C:\Users\sebas\vitrina-app` (frontend) y `C:\Users\sebas\vitrina-server-worker` (backend) |

---

## Planes y precios DEFINITIVOS (sin add-ons separados)

**Todos los precios en USD, cobrados en ARS al TC oficial Banco NaciÃ³n (venta).** ActualizaciÃ³n automÃ¡tica lunes 10am ART. Fallback 1.418 ARS/USD si la API cae.

**WhatsApp Business estÃ¡ incluido en TODOS los planes pagos.** Vitrina asigna el nÃºmero (vÃ­a Twilio). El cliente NO trae su propio nÃºmero Meta. NO hay planes "+WA" separados.

**Sin fee de transacciÃ³n en ningÃºn plan.**

### Restaurantes / GastronomÃ­a

| Plan | USD/mes | Incluye |
|------|---------|---------|
| Free | $0 | MenÃº QR, Tano 75 msg/mes, 1 idioma, mÃ¡x 45 platos, marca de agua |
| **Solo MenÃº** | **$27** | Pedidos online, cocina, pagos MP, Tano ilimitado ES/EN/PT, fotos IA. WA operativo (Tano responde consultas del menÃº + recordatorios de reserva + pedido listo). SIN campaÃ±as marketing por WA. |
| **Marketing** | **$57** | Viti estrategia mensual, 30 publicaciones auto/mes API Meta (IG+FB+Google), anÃ¡lisis competidores, informe PDF, WA con campaÃ±as (50/mes incluidas). |
| **Combo** | **$70** | Solo MenÃº + Marketing en un solo plan. Ahorra $14 vs separado. |

### Comercios / Locales / Servicios / Vendedores Online

| Plan | USD/mes | Incluye |
|------|---------|---------|
| Free | $0 | CatÃ¡logo QR, asistente con 75 msg/mes |
| **Marketing** | **$62** | CatÃ¡logo digital, asistente IA, ML + TN sync bidireccional, Viti, 30 publicaciones/mes, anÃ¡lisis competidores, WA con campaÃ±as. |

### WhatsApp incluido en TODOS los planes pagos â€” quÃ© incluye

| Recurso | Solo MenÃº $27 | Marketing/Combo/Comercio |
|---------|---------------|--------------------------|
| NÃºmero exclusivo gestionado por Vitrina | âœ… | âœ… |
| Conversaciones service (iniciadas por cliente final) | Ilimitadas (free tier Meta 1000/mes) | Ilimitadas (idem) |
| Mensajes operativos (utility) | 150/mes | 150/mes |
| CampaÃ±as marketing | 0 (no incluye) | 50/mes |
| Asistente IA responde 24/7 | âœ… (consultas del menÃº/productos) | âœ… |
| Bandeja de mensajes en panel | âœ… | âœ… |

### Extensiones (todos los planes)

| Recurso | Incluido | ExtensiÃ³n | Precio |
|---------|----------|-----------|--------|
| Mensajes operativos WA | 150/mes | +50 mensajes | $2 USD |
| CampaÃ±as marketing WA | 50/mes | +50 mensajes | $3 USD |
| Tope marketing por lÃ­nea (anti-baneo) | 500/mes | No extendible | â€” |
| Fotos IA del menú | 100 al iniciar + 20/mes | +10 fotos | 1.000 ARS |
| SubtÃ­tulos Whisper | 10 videos/mes | +10 videos | $2 USD |
| Publicaciones auto | 30/mes | +15 publicaciones | $3 USD |

**Plan cortesÃ­a:** activaciÃ³n manual desde maestro.html. Primer mes gratis con `subscription_tier: 'rest-combo'`. Alerta a SebastiÃ¡n al terminar.

---

## WhatsApp Business â€” modelo Twilio (definitivo)

**DecisiÃ³n firme:** Vitrina opera WhatsApp Business vÃ­a Twilio como BSP. Twilio tiene sus propios permisos Meta aprobados, por lo cual Vitrina puede operar desde el dÃ­a 1 sin esperar la aprobaciÃ³n del App Review de Meta WA.

**Flujo de activaciÃ³n para el cliente:**

1. Cliente contrata plan pago
2. Vitrina compra un nÃºmero Twilio (~$1 USD/mes) y lo registra como WA Business
3. En 24hs hÃ¡biles el nÃºmero queda operativo
4. Cliente ve "WA: Conectado" en el panel
5. Cliente imprime el QR con su nuevo nÃºmero y lo pega en el local

**Lo que ve el cliente final del negocio:** el NOMBRE del negocio en grande (ej: "FerreterÃ­a LÃ³pez"), verificado si estÃ¡ aprobado. El nÃºmero de EEUU aparece en segundo plano â€” igual como lo hacen Mercado Libre, bancos y aerolÃ­neas.

**El cliente del negocio NO necesita:**
- Comprar chip nuevo
- Crear cuenta Meta Business Manager
- Cargar nada en developers.facebook.com
- Verificar su identidad con Meta
- Tener WhatsApp instalado en un celular

**Toda la operativa del WA pasa por el panel de Vitrina:**
- Bandeja de mensajes
- Respuestas con Tano/Viti automÃ¡ticas
- IntervenciÃ³n manual desde el panel cuando el dueÃ±o quiere
- CampaÃ±as a la base de contactos

**Costos reales para Vitrina por nÃºmero/cliente/mes (uso tÃ­pico):**

| Concepto | USD |
|----------|-----|
| LÃ­nea Twilio | $1.00 |
| 150 utility Ã— $0.0124 | $1.86 |
| Twilio fee mensajes (~300 in+out) | $1.50 |
| 50 marketing Ã— $0.0625 | $3.13 |
| Twilio fee marketing | $0.25 |
| **Total con marketing (planes Marketing/Combo/Comercio)** | **$7.74** |
| **Total solo operativo (Solo MenÃº)** | **$4.36** |

**Reglas anti-baneo programadas:**

1. Opt-in obligatorio para enviar marketing. Cada contacto debe haber iniciado al menos una conversaciÃ³n con el negocio antes.
2. BotÃ³n "Darse de baja" en cada mensaje marketing.
3. Tope por contacto: max 3 marketing/mes, max 1 cada 7 dÃ­as.
4. Plantillas pre-aprobadas en Twilio. No se permite envÃ­o con texto libre como marketing.
5. Quality Rating monitoreado. Si baja a Yellow â†’ pausa marketing 24hs y alerta.
6. Test antes de campaÃ±as grandes: si la campaÃ±a va a mÃ¡s de 100 contactos, se envÃ­a primero a 10, espera 1h, mide bloqueos. Si <2, sigue. Si >2, pausa.

---

## Tipos de negocio soportados

Todo el panel, menÃº pÃºblico y onboarding se adaptan automÃ¡ticamente:

| Tipo | Sidebar muestra | TerminologÃ­a |
|------|----------------|-------------|
| `restaurant` | MenÃº, Mesas, Reservas, Agenda, Pedidos | platos, mozo, menÃº, Tano |
| `services` | Servicios, Agenda, Pedidos | servicios, asistente IA, turnos |
| `local` | CatÃ¡logo, Pedidos | productos, asistente IA, catÃ¡logo |
| `ecommerce` | CatÃ¡logo, Pedidos | productos, asistente IA, tienda |

**Features exclusivas `restaurant`:**
- Mensajes de seguimiento automÃ¡ticos WA post-pedido (`wa_followup_config`)
- Flujo de pago consolidado por mesa (banner acumulado, "Pedir la cuenta", botÃ³n "Cobrar" en cocina)
- Badge "ðŸ’³ Pagado" en cocina al confirmarse el pago

**Rubros disponibles en onboarding:**
Restaurante/Bar/CafÃ© Â· HeladerÃ­a/PastelerÃ­a Â· RotiserÃ­a/Delivery Â· DietÃ©tica/AlmacÃ©n natural Â· Ropa/Calzado/Accesorios Â· FerreterÃ­a/Bazar/Herramientas Â· PeluquerÃ­a/BarberÃ­a Â· EstÃ©tica/Spa/UÃ±as Â· Veterinaria Â· LibrerÃ­a/PapelerÃ­a Â· Kiosco/Minimarket Â· Servicios profesionales Â· Vendedor online puro Â· Otro (genÃ©rico)

---

## Principio de voz â€” Viti/Tano se hacen pasar por staff del negocio

**Regla firme aplicable a TODOS los mensajes WA al cliente final:**

Viti y Tano se hacen pasar por staff del negocio. **NUNCA** dicen:
- "soy Viti" / "soy Tano"
- "soy de Vitrina"
- "soy una IA" / "soy un asistente automÃ¡tico"

El cliente final cree que habla con alguien de FerreterÃ­a El Tornillo o La Panera Rosa. La voz por defecto es "el equipo" / "nosotros". Si el dueÃ±o configurÃ³ un nombre especÃ­fico ("Marcos del local") se usa ese.

**Hacia el dueÃ±o del negocio** (panel + canal de gestiÃ³n WA), Viti SÃ se identifica como Viti â€” ahÃ­ es la asistente del dueÃ±o y eso queda claro.

**Ejemplos correctos en WA al cliente final:**
- "Hola! Â¿Para cuÃ¡ntas personas?"
- "Listo! Tu pedido estÃ¡ confirmado, ya lo estamos preparando."
- "Alguien del equipo te va a contactar en breve."
- "Gracias por tu compra."

**Ejemplos incorrectos (NUNCA):**
- "Hola, soy Tano, el asistente de [restaurante]"
- "Te responde Viti, soy una IA"
- "Vitrina recibiÃ³ tu pedido"

---

## CÃ³mo responde Viti/Tano por WhatsApp â€” flujos completos

### Restaurantes â€” Reservas

```
Cliente: "Hola, quiero reservar para el sÃ¡bado"
Asistente: "Hola! Â¿Para cuÃ¡ntas personas?"
Cliente: "Somos 4"
Asistente: "Para el sÃ¡bado a las 4 personas tengo: 20:30, 22:00 o 22:45.
            Â¿CuÃ¡l te queda mejor?"
Cliente: "21:30 si tenÃ©s"
Asistente: "Justo a las 21:30 no me queda. Te ofrezco 20:30 o 22:00.
            O si querÃ©s, sÃ¡bado de la semana siguiente tengo 21:30 libre.
            Â¿QuÃ© preferÃ­s?"

[Si dice "no, gracias, otra vez serÃ¡"]
Asistente: "Te entiendo. Â¿Te aviso cuando se libere un horario mÃ¡s cercano
            a las 21:30 ese sÃ¡bado?"
            [Si sÃ­ â†’ guarda en customers con tag "waitlist_sabado_2130"]

[Si confirma horario]
Asistente: "Perfecto. Â¿A nombre de quiÃ©n la guardo?"
Cliente: "MartÃ­n"
Asistente: "Listo MartÃ­n, reserva para 4 el sÃ¡bado a las 20:30.
            Te mando recordatorio el viernes. Si necesitÃ¡s cambiar algo,
            escribime."
```

### Comercios â€” Venta sin TN/ML conectado

```
1. Cliente pregunta: "Â¿TenÃ©s taladro Black & Decker?"
2. Asistente responde con imagen + descripciÃ³n corta + precio + link pago MP
3. Cliente paga vÃ­a MP
4. Webhook MP confirma el pago
5. Worker manda DOS notificaciones simultÃ¡neas:

   â†’ Al local (canal operativo WA, identificado como Viti):
     "Venta confirmada
      Producto: Taladro Black & Decker BDH200V
      Cliente: MarÃ­a GonzÃ¡lez
      TelÃ©fono: +54 11 2345-6789
      PagÃ³: $45.000 vÃ­a MP
      Contactala para coordinar retiro o envÃ­o."

   â†’ Al cliente final (voz del negocio):
     "Â¡Listo! Tu pago se confirmÃ³.
      Alguien del equipo te va a contactar en breve para coordinar retiro o envÃ­o.
      Si en 2 horas no tenÃ©s novedades, escribime y reviso."

6. El local llama al cliente desde SU nÃºmero personal
   (NO consume conversaciones de Vitrina)

7. A las 2hs, Viti chequea si el local marcÃ³ "contactado" en el panel.
   Si no, alerta al local. Si pasa 4hs sin contacto, alerta a SebastiÃ¡n.
```

### Conversaciones â€” conteo Meta

**Regla:** Cuando el cliente le habla al negocio, abre una **ventana service de 24hs gratis**. Dentro de la ventana, todos los mensajes del negocio son gratis. Fuera de la ventana, el negocio paga utility ($0.0124) o marketing ($0.0625) segÃºn tipo.

| Trigger | Â¿Paga? |
|---------|--------|
| ConfirmaciÃ³n de reserva (cliente acaba de escribir) | GRATIS (ventana abierta) |
| Recordatorio 24hs antes (cliente no escribiÃ³ en 24hs) | PAGA utility |
| Recordatorio 2hs antes (si ya respondiÃ³ al de 24hs) | GRATIS (ventana renovada) |
| Reserva del mismo dÃ­a | GRATIS (ventana abierta todo el dÃ­a) |
| Pedido listo (cliente confirmÃ³ por WA antes) | GRATIS |
| Pedido listo (sin ventana abierta) | PAGA utility |
| Mesa libre/waitlist (negocio inicia) | PAGA utility |
| Cerrado por feriado (cliente pregunta) | GRATIS |

Por eso 150 utility incluidas cubre uso normal con margen amplio.

### CampaÃ±as a futuro con datos del CRM

Tres tipos activables desde el panel:

1. **ReactivaciÃ³n de clientes existentes:** trigger "no volviÃ³ en 30/60/90 dÃ­as". Mensaje promo. Max 1 vez cada 60 dÃ­as al mismo cliente. Cuenta como marketing ($0.0625).
2. **Waitlist activaciÃ³n:** cuando se cancela una reserva del horario pedido. Mensaje al primero en la lista. Cuenta como utility ($0.0124).
3. **Eventos especiales:** el dueÃ±o lanza la campaÃ±a. A toda la base con opt-in. Max 1 cada 7 dÃ­as al mismo contacto, max 3 al mismo en 30 dÃ­as.

---

## Mi CatÃ¡logo â€” gestiÃ³n de productos con descripciÃ³n doble

**Campos por producto:**

| Campo | Para quÃ© se usa | Obligatorio |
|-------|----------------|-------------|
| Nombre | QR catÃ¡logo, WA, ML, TN | SÃ­ |
| Foto cruda | Vitrina la mejora con Cloudflare AI | SÃ­ |
| **DescripciÃ³n corta** (1-2 lÃ­neas, mÃ¡x 150 chars) | QR catÃ¡logo, mensajes WA, mensajes ML rÃ¡pidos | SÃ­ |
| **DescripciÃ³n completa** (texto largo, formato libre) | PublicaciÃ³n ML, ficha tÃ©cnica TN, detalles cuando el cliente pregunta mÃ¡s en WA | SÃ­ si vende por ML/TN |
| Atributos ML (marca, modelo, color, etc.) | PublicaciÃ³n ML | SÃ­ si publica en ML |
| Peso y dimensiones | CÃ¡lculo de envÃ­o ML/TN | SÃ­ si vende con envÃ­o |
| Costo de compra, precio, stock, mÃ­nimo alerta | CÃ¡lculos internos, alertas | SÃ­ |
| SKU / cÃ³digo interno | Sync MLâ†”TN | Opcional |

**Carga por PDF o CSV:**
Cliente sube su catÃ¡logo. Claude Vision lee el PDF. La descripciÃ³n corta se llena con lo extraÃ­do; la descripciÃ³n completa la genera Viti automÃ¡ticamente a partir del nombre + atributos y el dueÃ±o la edita.

**Cuando se publica en ML:**
Viti arma la publicaciÃ³n usando descripciÃ³n completa + atributos. Si faltan datos, pregunta al dueÃ±o antes de publicar.

---

## EnvÃ­os para comercios

**DecisiÃ³n firme: Vitrina NO integra couriers directos** (Andreani, OCA, Correo). Razones: 2-3 meses de desarrollo + soporte continuo, convenios individuales por vendedor, tarifas que cambian, mantenimiento.

**Tres opciones segÃºn quÃ© tiene el local:**

### A) Local con Tienda Nube conectada
- Viti responde con stock/precio + "Si querÃ©s cerrar la compra, te dejo el carrito armado con envÃ­o incluido"
- Genera link al checkout TN con productos pre-cargados
- TN maneja envÃ­os (Andreani, OCA, Mercado EnvÃ­os, retira en local)
- Vitrina recibe la venta vÃ­a webhook TN, descuenta stock en ML si estÃ¡ sync

### B) Local con MercadoLibre conectado (sin TN)
- Viti responde y da link directo a la publicaciÃ³n en ML
- ML maneja envÃ­os (Mercado EnvÃ­os)

### C) Local SIN TN ni ML
- Viti responde + link pago MP
- Cliente paga
- NotificaciÃ³n dual: WA al local (con datos completos) + WA al cliente ("alguien del equipo te va a contactar en breve")
- Local coordina envÃ­o/retiro por su cuenta desde SU WhatsApp personal
- Sugerencia continua: banner en panel + mensaje mensual de Viti para que activen TN

**Mensaje en onboarding del local:**
> "Si vendÃ©s con envÃ­os, lo mÃ¡s simple es activar Tienda Nube â€” tiene plan gratis hasta 50 productos y resuelve envÃ­os con Andreani/OCA/Correo. Vitrina lo integra automÃ¡ticamente. Si solo vendÃ©s pickup en local o coordinÃ¡s envÃ­os vos, tambiÃ©n estÃ¡ OK â€” generamos links de pago y vos te encargÃ¡s del resto."

**ClÃ¡usula en terms.html:**
> "Para productos sin envÃ­o integrado vÃ­a Tienda Nube o Mercado Libre, el comercio se contacta directamente con el comprador para coordinar entrega o retiro. Vitrina facilita la conexiÃ³n y procesa el pago, pero no se hace responsable de la operativa de envÃ­o ni del cumplimiento del pedido por parte del comercio."

---

## Pago de mesa consolidado (restaurant only)

**Flujo:**

1. Comensal escanea QR â†’ menu.html â†’ arma pedidos
2. Banner fijo "Total acumulado de la visita: $X" se actualiza tras cada pedido
3. Cocina recibe pedidos en `cocina.html` vÃ­a Supabase Realtime
4. Comensal toca "Pedir la cuenta ðŸ’³" â†’ `pedirLaCuenta()` â†’ `POST /api/mp/crear-preferencia` â†’ redirect MP
5. Si el restaurante tiene MP OAuth conectado, usa `rest.mp_access_token` (la plata va al restaurante). Si no, fallback al token Vitrina.
6. MP confirma pago â†’ `POST /api/mp/order-webhook` â†’ Worker marca `orders.status = 'paid'`
7. Supabase Realtime â†’ `cocina.html` muestra "ðŸ’³ Pagado" + toast verde 5s
8. Aparece botÃ³n "Cobrar mesa" en cocina con total acumulado y link MP en nueva pestaÃ±a

**Setup del restaurante:** Panel â†’ AnÃ¡lisis â†’ "ðŸ’³ MercadoPago â€” Cobros de mesa" â†’ "Conectar cuenta" â†’ OAuth MP â†’ guarda tokens en `restaurants`. Vitrina no toca esos fondos.

---

## Mensajes de seguimiento WA post-pedido (restaurant only)

Feature en panel.html â†’ ConfiguraciÃ³n â†’ "ðŸ’¬ Mensajes de seguimiento durante la visita".
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
- cocina.html â†’ status `ready` â†’ `scheduleFollowup(pedido, 'first_plate')` â†’ msg1 (2 min)
- cocina.html â†’ status `delivered` â†’ `scheduleFollowup(pedido, 'all_plates')` â†’ msg2 (30 min) + msg3 (75 min)
- Msg3 consulta `menu_items WHERE category ILIKE '%postre%' LIMIT 3` e interpola `{postres}`
- Worker encola en `wa_followup_queue`; cron procesa y envÃ­a via Twilio
- **Requires:** WA configurado para el restaurante. Si no, muestra aviso en lugar del toggle.

---

## Sistema de respuestas automÃ¡ticas â€” 5 aprobaciones

Aplica a: preguntas ML, publicaciones ML desde Vitrina, respuestas IG/FB/Google, bajada de stock en TN tras venta en ML, publicaciones en redes desde Viti.

**SIEMPRE son 5 aprobaciones consecutivas para activar el modo automÃ¡tico.**

- Si el dueÃ±o rechaza una sugerencia: el contador vuelve a 0.
- Tras 5 aprobaciones seguidas: Viti pregunta "Â¿QuerÃ©s que lo haga solo de ahora en mÃ¡s?"
- En modo automÃ¡tico: actÃºa en menos de 2 minutos, manda resumen diario.
- ExcepciÃ³n: si Viti no tiene certeza, manda al dueÃ±o aunque estÃ© en modo automÃ¡tico.
- El dueÃ±o puede pausar el modo automÃ¡tico diciÃ©ndoselo a Viti: "Viti, pausÃ¡ las respuestas de Instagram."

**Canales con respuestas automÃ¡ticas:**
- Preguntas de compradores ML
- Comentarios en Instagram (feed + Reels)
- Mensajes directos Instagram (solo en planes con WA marketing)
- Comentarios en Facebook
- ReseÃ±as en Google Business Profile
- Mensajes WhatsApp (todos los planes pagos)

**Aprendizaje del estilo:** Viti analiza las Ãºltimas 50 respuestas dadas por el dueÃ±o en cada canal antes de proponer respuestas propias. Mantiene la voz del dueÃ±o.

---

## Onboarding simplificado

Flujo actual:

1. **Tipo de negocio** (restaurant / services / local / ecommerce) â€” 4 cards visuales
2. **Solo el nombre** del negocio (URL se genera automÃ¡tico) â†’ "Crear mi negocio â†’"
3. **Adentro** â†’ checklist "Primeros pasos" adaptado al tipo (7 Ã­tems segÃºn rubro)
4. ConexiÃ³n de redes (Google Business + Instagram + Facebook) â†’ anÃ¡lisis preliminar en 2-3 min antes de pagar
5. Nombre del asistente: restaurantes default "Tano" (personalizable), otros eligen nombre
6. Canales de notificaciÃ³n: gestiÃ³n (dueÃ±o) + operativo (local)
7. Carga del catÃ¡logo/menÃº
8. QR (por mesa o genÃ©rico)
9. ActivaciÃ³n del plan: cobro automÃ¡tico MP. WA Business se activa en 24hs hÃ¡biles.

---

## Sistema de alertas de costos variables

### Para SebastiÃ¡n (panel maestro)
- Cada costo variable suma al acumulado del mes en Supabase por cliente
- Al 80% del costo estimado mensual: alerta en panel maestro + WA a SebastiÃ¡n
- Al 100%: segunda alerta
- Al 120%: pausa automÃ¡tica de servicios variables (fotos, subtÃ­tulos, marketing). NUNCA se pausa: Tano, pedidos, cocina, pagos, reservas, utility WA.
- Dentro de 24hs hÃ¡biles de la pausa: Vitrina contacta al cliente

### Para el cliente
- Al 80% de fotos: aviso con opciÃ³n de extensiÃ³n
- Idem para subtÃ­tulos, publicaciones, marketing WA
- Utility WA al 80% (120 mensajes): aviso suave sin pÃ¡nico
- Utility WA NUNCA se pausa (operativo es crÃ­tico)

### ClÃ¡usula aprobada en tÃ©rminos
"Los servicios variables de Vitrina estÃ¡n dimensionados para un uso normal segÃºn el plan contratado. Vitrina se reserva el derecho de notificar al cliente y, de ser necesario, pausar temporalmente servicios variables ante un uso significativamente superior al estimado, sin afectar en ningÃºn caso los servicios operativos."

---

## Informes automÃ¡ticos (todos los planes pagos)

### Frecuencia
- Semanas 1-4: informe diario (texto WA + email, mÃ¡x 5 lÃ­neas WA)
- Inicio de semana 5: Viti pregunta "Â¿SeguÃ­s con diario o pasamos a semanal completo?"
- Siempre: semanal (configurable jueves/viernes) + mensual PDF el dÃ­a 1

### Canales
WhatsApp + email simultÃ¡neos. PDF como adjunto en email + link Supabase Storage en WA.

### Informe diario (5 lÃ­neas WA)
- Plan Solo MenÃº: pedidos del dÃ­a, facturaciÃ³n, platos mÃ¡s pedidos, reseÃ±as nuevas Google
- Planes con marketing: mÃ©tricas redes del dÃ­a, publicaciones publicadas, nuevas preguntas ML, ventas ML, stock crÃ­tico

### Informe semanal (PDF 2 pÃ¡ginas)
- MÃ©tricas semana vs semana anterior
- Top 3 publicaciones
- Alertas importantes
- Competidores: quÃ© hicieron esta semana

### Informe mensual (PDF 8-12 pÃ¡ginas)
- Logo del negocio en encabezado
- Performance vs proyecciones
- AnÃ¡lisis por canal (Google, IG, FB, ML, TN)
- QuÃ© funcionÃ³ y quÃ© no, con datos
- Estrategia ajustada para el mes siguiente
- Firma discreta al pie: "Generado por Vitrina"
- El dueÃ±o puede presentarlo como propio

DiseÃ±o: A4, mÃ¡rgenes generosos, fuente mÃ­nima 12pt, B&N friendly, grÃ¡ficos de barras/lÃ­neas (no tortas).

---

## Mails â€” firma sin datos personales

**Regla firme:** NINGÃšN mail al cliente final ni a prospects puede contener:
- "SebastiÃ¡n Medina Cantor"
- CUIT 20-36594388-6
- Camargo 327
- C1414 CABA

Solo aparecen en `terms.html` y `privacy.html` por exigencia legal. En cualquier otra parte del producto: NO.

**Firma estÃ¡ndar:**
- "Equipo de Vitrina" (default)
- "SebastiÃ¡n de Vitrina" (en mails personales como seguimiento de trial)
- "Vitrina"

**Footer estÃ¡ndar:**
```
Saludos,
[Firma segÃºn contexto]

Vitrina Â· vitrinaapp.com.ar
Si no querÃ©s recibir mÃ¡s mails como este: [Darse de baja]
[PolÃ­tica de privacidad] Â· [TÃ©rminos]
```

**ConfiguraciÃ³n antispam (Resend):**
- Dominio verificado vitrinaapp.com.ar âœ…
- SPF, DKIM, DMARC configurados
- PersonalizaciÃ³n por destinatario (no copy/paste exacto)
- Volumen gradual cuando se hagan campaÃ±as frÃ­as

---

## Panel maestro de SebastiÃ¡n

URL: `vitrinaapp.com.ar/maestro.html`
Acceso: solo emails en tabla `admins` de Supabase.

**6 tabs:**
- ðŸ“Š Vista General â€” clientes activos, nuevos, bajas, conversiÃ³n trialâ†’pago, churn
- ðŸ‘¥ Clientes â€” listado con plan, uso IA, costos acumulados, alertas
- ðŸ’° FacturaciÃ³n â€” suscripciones, extensiones, total vs mes anterior, proyecciÃ³n
- ðŸ¤ Productores â€” listado, comisiones, botÃ³n "marcar como pagado"
- ðŸ¤– Agentes IA â€” actividad, eficacia, costo en tokens/USD
- ðŸ“‰ Costos â€” Metricool fijo, variables por cliente, margen bruto

**BotÃ³n "ðŸŽ CortesÃ­a"** por fila de cliente que NO tenga plan activo. Activa `subscription_tier: 'rest-combo'`, `trialing`, +30 dÃ­as, can_take_orders, Tano ilimitado.

---

## Panel maestro de ventas (CRM de prospects)

**Estado actual:** parcialmente implementado en el backend. Endpoints `/api/sales/*` existentes:
- `/api/sales/search-restaurants` â€” busca prospects vÃ­a Google Places
- `/api/sales/generate-diagnosis` â€” genera anÃ¡lisis con Claude
- `/api/sales/create-prospect` â€” guarda en `sales_prospects`
- `/api/sales/contact` â€” envÃ­a WA
- `/api/sales/process-followups` â€” procesa seguimientos
- `/api/sales/prospects`, `/api/sales/config`, `/api/sales/metrics`

**Tablas:** `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`.

**Falta construir:**
- Vista CRM en `maestro.html`
- EnvÃ­o de mail con PDF adjunto (informe personalizado del prospect)
- Cron seguimiento 4/7/15 dÃ­as
- DistribuciÃ³n gradual de envÃ­os (50/dÃ­a semana 1 â†’ 200/dÃ­a semana 5)
- Sistema de estados (contactado/abierto/respondiÃ³/interesado/trial/cliente/baja)

**Filtros de bÃºsqueda:**
- Rubro
- Zona (default: GBA Oeste/Sur + CÃ³rdoba + Rosario)
- Estado del negocio (solo OPERATIONAL en Google Places)
- Rating mÃ­nimo
- ReseÃ±as mÃ­nimas (50+)
- Tiene sitio web / IG pÃºblico
- Ãšltima reseÃ±a reciente
- Sin contactar antes
- Excluir ya cliente

**Horarios envÃ­o:**
- Restaurantes: 12-22 ART
- Locales/Comercios: 10-17 ART
- Cron Cloudflare lo gestiona automÃ¡tico

**Efectividad esperada (200 mails/dÃ­a a rÃ©gimen):**
- Open rate: 25-35%
- Reply rate: 2-4%
- Trial activado: 0.5-1.5%
- Trial â†’ pago: 20-30%
- ProyecciÃ³n conservadora: 5-12 clientes pagos nuevos/mes

**Costos operativos del sistema de ventas/mes:** ~$12 USD total (Google Places + Claude Haiku + Resend + Twilio + Cloudflare).

---

## Metricool â€” modelo de activaciÃ³n

**DecisiÃ³n:** Metricool **NO** estÃ¡ activo todavÃ­a. La publicaciÃ³n auto a IG/FB se hace directo vÃ­a API Meta desde el worker. Metricool se contratarÃ¡ cuando SebastiÃ¡n confirme. Los endpoints del worker (`/api/metricool/*`) y los secrets (`METRICOOL_CLIENT_ID`, `METRICOOL_CLIENT_SECRET`) se mantienen para reactivarlo en cuanto se contrate.

**Plan recomendado al activar:** 15 marcas (â‚¬43/mes â‰ˆ $46 USD). Vitrina ocupa slot 1, quedan 14 para clientes. Activar con el primer cliente Marketing pago.

**CuÃ¡ndo escalar:**
| Clientes con Marketing | Plan Metricool | Costo |
|------------------------|----------------|-------|
| 0-14 | Starter 15 marcas | $46 |
| 15-24 | Advanced 25 | $73 |
| 25+ | Enterprise 50 | $138 |

**Lo que harÃ¡ Metricool cuando se contrate:**
- ProgramaciÃ³n de posts IG/FB (alternativa o redundancia a la API Meta directa)
- Analytics consolidados
- Stories e Instagram Reels programados

---

## Meta App Review â€” estado actual (23/05/2026)

| Item | Estado |
|------|--------|
| App ID `1626148071948901` namespace `vitrinaapp` | âœ… Publicada (Live) |
| Casos de uso agregados | âœ… Instagram (Vitrina-IG `1618135162776352`), Facebook Pages, WhatsApp Business |
| Permisos base | âœ… Aprobados: `instagram_business_basic`, `instagram_manage_comments`, `instagram_business_manage_messages`, `public_profile` |
| Permisos avanzados en App Review | â³ Solicitados 22/05: `instagram_manage_insights`, `instagram_manage_engagement`, `instagram_manage_messages`, `instagram_content_publish`, `business_management`, `pages_*`, `read_insights`, `whatsapp_business_messaging`, `whatsapp_business_management` |
| Business Verification | â³ Enviada 20/05 con constancia AFIP. Verificar en Business Manager â†’ Centro de seguridad |
| Video screencast | â³ Pendiente â€” script preparado (~3-4 min) |

**No bloquea operaciones:** mientras los permisos avanzados de Meta WA esperan aprobaciÃ³n, operamos WhatsApp Business vÃ­a Twilio (BSP con permisos propios ya aprobados). Esto nos permite vender desde el dÃ­a 1.

**Cuando Meta WA quede aprobado:** podemos evaluar migrar de Twilio a Meta directo si conviene econÃ³micamente. Mientras tanto, Twilio es la opciÃ³n operativa.

---

## Mercado Libre + Tienda Nube

**Mercado Libre:**
- OAuth implementado (`/api/ml/auth`, `/api/ml/callback`)
- Auto-responder de preguntas con guardrails estrictos (`/api/ml/answer-question`)
- Webhook ML (`/api/ml/webhook`) â†’ procesa auto-respuesta
- **Pendiente:** cargar credenciales de la app ML (App ID + Client Secret) en `wrangler secret put`

**Tienda Nube:**
- OAuth implementado (`/api/tn/auth`, `/api/tn/callback`)
- Sync stock bidireccional ML â†” TN

**PublicaciÃ³n desde Vitrina en ML:**
1. DueÃ±o inicia publicaciÃ³n desde Mi CatÃ¡logo
2. Viti genera tÃ­tulo, descripciÃ³n (usa descripciÃ³n_completa + atributos), fotos mejoradas, atributos, precio calculado
3. Primeras 5 publicaciones: Viti pregunta peso/dimensiones si no estÃ¡n cargados
4. Preview "asÃ­ se verÃ¡ en ML"
5. DueÃ±o aprueba â†’ publica via API
6. Tras 5 aprobaciones: modo automÃ¡tico disponible

**CÃ¡lculo de precio ML automÃ¡tico:**
Precio publicaciÃ³n = costo + margen pretendido + comisiÃ³n ML + envÃ­o estimado. Si no es competitivo contra top 10 competidores, Viti avisa.

---

## Cron jobs activos en Cloudflare

Configurados en `wrangler.json` con handler `scheduled()` en el worker:

| Cron expression (UTC) | Hora ART | Tarea |
|----------------------|----------|-------|
| `0 13 * * *` | Diario 10am | `/api/agenda/send-reminders` + `/api/sales/process-followups` + procesar `wa_followup_queue` |
| `0 14 * * *` | Diario 11am | `/api/notify/trial-followup` + aviso 3 dÃ­as antes de vencer |
| `0 13 * * 1` | Lunes 10am | `/api/exchange-rate/update` |
| `0 12 1 * *` | DÃ­a 1 9am | `/api/reports/send-monthly` |

**Deploy:** `cd C:\Users\sebas\vitrina-server-worker && npx wrangler deploy`

---

## Endpoints del worker (53 totales)

**CategorÃ­as:**
- `/api/claude` â€” proxy Anthropic (Tano + Viti)
- `/api/tipo-cambio` â€” TC oficial BCRA con cache 1h
- `/api/social/*` â€” publica/programa en IG + FB vÃ­a API Meta
- `/api/instagram/*`, `/api/facebook/*` â€” OAuth + mÃ©tricas
- `/api/ml/*`, `/api/tn/*` â€” OAuth + auto-respuestas ML
- `/api/cf-ai/*` â€” fotos con Cloudflare AI (Flux Schnell, gratis)
- `/api/mp/*` â€” suscripciones, OAuth restaurante, webhooks pagos mesa
- `/api/wa/*` â€” envÃ­o WA via Twilio, cola followup
- `/api/notify/*`, `/api/notificar-*` â€” emails y WA bienvenida, trial, alertas
- `/api/admin/*` â€” panel maestro
- `/api/sales/*` â€” CRM de prospects (8 endpoints, parcialmente implementado)
- `/api/agenda/*` â€” turnos, recordatorios
- `/api/reports/*` â€” informes
- `/api/places/*`, `/api/geocode` â€” Google Places
- `/api/whisper/transcribe` â€” Whisper OpenAI subtÃ­tulos
- `/api/delivery/extract-screenshot` â€” Claude Vision para Rappi/PedidosYa
- `/api/exchange-rate/*` â€” TC bluelytics
- `/api/health` â€” estado de todos los servicios
- `/api/landing-chat`, `/api/lead`, `/api/waitlist` â€” landing public

---

## Migraciones Supabase (27 corridas)

Ãšltima: **027_delivery_metrics.sql** (tabla mÃ©tricas Rappi/PedidosYa)

**Tablas principales:**
`restaurants`, `menu_categories`, `menu_items`, `orders`, `order_items`, `restaurant_tables`, `integrations`, `social_posts`, `appointments`, `staff_resources`, `customers`, `admins`, `subscriptions`, `subscription_payments`, `wa_followup_queue`, `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`, `executive_reports`, `marketing_projections`, `monthly_metrics_snapshots`, `exchange_rates`, `delivery_metrics`, `campanas`, `waitlist`, `leads`, `agenda_config`.

**Columnas crÃ­ticas en `restaurants`:**
- `mp_access_token`, `mp_refresh_token`, `mp_user_id`, `mp_public_key`, `mp_connected`
- `twilio_number`, `twilio_sid` (a agregar en migraciÃ³n 028 cuando se implemente modelo "nÃºmero por cliente")
- `wa_followup_config` (JSONB)
- `business_type` (restaurant/services/local/ecommerce)

---

## Secrets configurados en Cloudflare

| Secret | Estado |
|--------|--------|
| ANTHROPIC_API_KEY | âœ… |
| SUPABASE_URL, SUPABASE_SERVICE_KEY | âœ… |
| MP_ACCESS_TOKEN, MP_PUBLIC_KEY, MP_APP_ID, MP_APP_SECRET | âœ… |
| RESEND_API_KEY | âœ… |
| TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_WHATSAPP_FROM | âœ… rotados 10/05 |
| GOOGLE_PLACES_API_KEY, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET | âœ… |
| OPENAI_API_KEY | âœ… (Whisper) |
| INSTAGRAM_APP_ID, INSTAGRAM_APP_SECRET | âœ… (la app Vitrina-IG es ID `1618135162776352`) |
| ML_APP_ID, ML_CLIENT_SECRET | â³ pendiente cargar |
| TN_APP_ID, TN_CLIENT_SECRET | âœ… |
| AI binding (Cloudflare Workers AI) | âœ… |
| METRICOOL_CLIENT_ID, METRICOOL_CLIENT_SECRET | ðŸ’¤ dormido hasta contratar Metricool |
| ADMIN_WHATSAPP | âœ… telÃ©fono SebastiÃ¡n para alertas |
| REPLICATE_API_TOKEN | âœ… (legacy, ya no se usa â€” fotos van por Cloudflare AI) |

---

## PÃ¡ginas publicadas en vitrinaapp.com.ar

### PÃºblicas (sin login)
- `index.html` â€” landing principal
- `para-restaurantes.html`, `para-servicios.html`, `para-comercios.html` â€” landings verticales
- `demo.html` â€” demo Casa LucÃ­a (restaurante) + `?tipo=comercio` FerreterÃ­a El Tornillo
- `demo-servicios.html` â€” demo peluquerÃ­a
- `whatsapp-setup.html` â€” info sobre el WhatsApp incluido en el plan (modelo Twilio asignaciÃ³n)
- `meta-setup.html` â€” guÃ­a interna del trÃ¡mite Meta (documentaciÃ³n)
- `terms.html`, `privacy.html` â€” legales con CUIT, GA4, AAIP, MP, WA
- `pago-ok.html` â€” confirmaciÃ³n de pago (modo individual + consolidado por mesa)
- `status.html`, `404.html`, `oauth-callback.html`
- `manifest.json` + `sw.js` â€” PWA instalable
- `sitemap.xml`, `robots.txt`

### Con login
- `panel.html` â€” admin SPA completo (~11.000 lÃ­neas, 18 secciones)
- `cocina.html` â€” display de pedidos en tiempo real
- `menu.html` â€” menÃº pÃºblico del comensal
- `mozo.html` â€” chat Tano embebido
- `maestro.html` â€” panel maestro de SebastiÃ¡n (6 tabs)
- `login.html` â€” auth Google
- `suspended.html` â€” cuenta suspendida por falta de pago

### Utilidades temporales (no se exponen al cliente)
- `logo-export.html`, `logo-opciones.html`, `og-image-gen.html`, `qr-print.html`

---

## Costos operativos y mÃ¡rgenes (proyecciÃ³n)

**Costos fijos mensuales:**
| Componente | USD |
|-----------|-----|
| Cloudflare Workers | $5 |
| Dominio | $1.25 |
| Google Workspace | $6 |
| Claude Max (SebastiÃ¡n) | $100 |
| Resend (plan gratis hasta 3.000 mails/mes) | $0 |
| **Total fijo** | **$112.25** |

**Costos variables por cliente/mes (uso tÃ­pico):**

| Plan | Componentes | Costo | Margen | % |
|------|-------------|-------|--------|---|
| Solo MenÃº $27 | $3.58 base + $4.36 WA operativo | **$7.94** | **$19.06** | 71% |
| Marketing $57 | $15.06 + $7.74 WA + $3.30 Metricool (a 14 clientes) | **$26.10** | **$30.90** | 54% |
| Combo $70 | $15.58 + $7.74 + $3.30 | **$26.62** | **$43.38** | 62% |
| Comercio Marketing $62 | $15.06 + $7.74 + $3.30 | **$26.10** | **$35.90** | 58% |

**ProyecciÃ³n de ganancia neta mensual:**

| Clientes activos | Ingresos USD | Costos var. USD | Costos fijos USD | **Neto USD** | **Neto ARS** (Ã—1418) |
|-----------------|--------------|-----------------|------------------|--------------|----------------------|
| 5 | $260 | $50 | $112 | **$98** | **$138.964** |
| 10 | $520 | $100 | $112 | **$308** | **$436.744** |
| 15 | $780 | $150 | $112 | **$518** | **$734.524** |
| 20 | $1.040 | $200 | $112 | **$728** | **$1.032.304** |
| 30 | $1.560 | $300 | $112 | **$1.148** | **$1.627.864** |
| 50 | $2.600 | $500 | $112 | **$1.988** | **$2.818.984** |

---

## Decisiones firmes (no se negocian)

1. **Sin fee sobre ventas** del menÃº/catÃ¡logo. Precio fijo mensual sin comisiones sobre transacciones.
2. **Sin fee sobre presupuesto publicitario.** GestiÃ³n de publicidad incluida.
3. **Base de datos Supabase** desde el arranque.
4. **WhatsApp Business vÃ­a Twilio** (no Meta directo). Vitrina asigna el nÃºmero, el cliente NO trae el suyo.
5. **WhatsApp Business INCLUIDO en TODOS los planes pagos.** No hay +WA separado.
6. **Metricool dormido** â€” endpoints y secrets se mantienen pero no se usa hasta contratar.
7. **PublicaciÃ³n social directa vÃ­a API Meta** desde el worker. Sin intermediarios.
8. **Sin couriers directos.** Redirigimos a TN/ML o el local coordina por su cuenta.
9. **5 aprobaciones consecutivas** para cualquier modo automÃ¡tico (respuestas ML, publicaciones, stock sync, respuestas redes, respuestas Google).
10. **Tano default para restaurantes**, personalizable en onboarding.
11. **No gastronÃ³micos: nombre del asistente lo elige el dueÃ±o desde el inicio.**
12. **Viti/Tano se hacen pasar por staff del negocio** hacia el cliente final. Solo se identifican como Viti hacia el dueÃ±o.
13. **Sin datos personales en mails ni en cÃ³digo visible al cliente final.** Los datos legales estÃ¡n solo en terms.html y privacy.html.
14. **TÃ©rminos y privacidad publicados** antes del primer pago real y antes de solicitar aprobaciÃ³n de Meta. âœ… ya hecho.
15. **Instagram Basic Display API no existe** desde diciembre 2024. Solo Instagram Graph API. No mencionar Basic Display API nunca.
16. **Runway y videos generados con IA: eliminados** del producto. Solo subtÃ­tulos Whisper para videos que sube el dueÃ±o.
17. **SebastiÃ¡n paga plan Claude Max $100/mes** para desarrollo. La API de producciÃ³n usa su ANTHROPIC_API_KEY facturada aparte.

---

## Sistema de productores / revendedores

- SebastiÃ¡n carga productores en maestro.html
- ComisiÃ³n estÃ¡ndar: 20% primer mes + 10% recurrente
- Productor top (+10 clientes activos): 25% primer mes + 15% recurrente
- Panel: comisiÃ³n por productor + botÃ³n "marcar como pagado"
- Reporte descargable para el contador

---

## Pendientes tÃ©cnicos prioritarios

| # | Pendiente | QuiÃ©n |
|---|-----------|-------|
| 1 | Verificar Business Verification Meta en Business Manager | SebastiÃ¡n |
| 2 | Grabar video screencast para App Review (script preparado) | SebastiÃ¡n |
| 3 | Migrar cÃ³digo Twilio a modelo "nÃºmero por cliente" (asignaciÃ³n automÃ¡tica + webhook routing) | Claude |
| 4 | Implementar sistema de lÃ­mites Twilio (150 utility, 50 marketing, extensiones, tope 500) | Claude |
| 5 | Construir vista CRM en maestro.html + completar sales agent | Claude |
| 6 | Agregar columnas descripciÃ³n_corta + descripciÃ³n_completa en menu_items | Claude |
| 7 | Implementar flujo "comercio sin TN/ML" (notificaciÃ³n dual local + cliente) | Claude |
| 8 | Cargar credenciales ML (App ID + Client Secret) en wrangler secrets | SebastiÃ¡n |
| 9 | Hacer `npx wrangler deploy` para activar los crons reciÃ©n agregados | SebastiÃ¡n |
| 10 | Sincronizar este CLAUDE.md con la skill del plugin Vitrina | Claude |

---

## Arquitectura WhatsApp â€” nÃºmero dedicado por cliente vÃ­a Twilio

Cada cliente que contrata plan pago recibe su propio nÃºmero de WhatsApp Business gestionado desde la cuenta Twilio de Vitrina.

**Lo que ve el cliente final del negocio:** el NOMBRE del negocio en grande (ej: "FerreterÃ­a LÃ³pez"). El nÃºmero de EEUU aparece en segundo plano.

**Flujo tÃ©cnico:**
1. Cliente contrata plan
2. Worker compra nÃºmero Twilio (~$1 USD/mes) asignado al cliente
3. NÃºmero se registra automÃ¡ticamente en WA Business API de Meta vÃ­a Twilio (Twilio es BSP)
4. Twilio configura webhook â†’ Worker
5. Worker identifica al cliente por el nÃºmero entrante (routing)
6. Claude Haiku procesa el mensaje con contexto del negocio
7. Responde con voz del staff del negocio

**Costo real para Vitrina por nÃºmero/mes:** $4-8 USD segÃºn marketing usado.
**EstÃ¡ incluido en el precio del plan**, sin add-on extra.

---

## CÃ³mo se vende el WA por rubro

- Restaurante/Bar: "Mozo Virtual por WhatsApp"
- FerreterÃ­a/Bazar: "Asesor de Productos por WhatsApp"
- PeluquerÃ­a/EstÃ©tica: "Asistente de Turnos por WhatsApp"
- Vendedor ML/TN: "Vendedor AutomÃ¡tico por WhatsApp"
- Cualquier rubro: "Tu asistente inteligente, disponible 24/7"

---

## Flujo de pedidos QR â€” ahorro de costos Meta

Cuando el comensal confirma un pedido desde el menÃº QR:

1. El pedido se registra en Supabase `orders` â†’ la pantalla `cocina.html` lo recibe vÃ­a Realtime
2. **Acto seguido** aparece botÃ³n verde "Confirmar por WhatsApp" opcional
3. Si el comensal lo toca: se abre SU WhatsApp con un mensaje pre-escrito hacia el restaurante. **Ã‰l aprieta enviar.**
4. Ese mensaje **abre la ventana de 24hs gratuita** de Meta â€” durante esas 24hs todos los avisos del negocio son gratis
5. La cocina recibe el pedido **siempre** en cocina.html, independiente de si el cliente apretÃ³ WA

| AcciÃ³n | CÃ³mo se entera la cocina | Costo Vitrina |
|--------|--------------------------|---------------|
| Cliente confirma pedido en QR | Supabase Realtime â†’ cocina.html | $0 |
| Cliente aprieta "Confirmar por WA" (opcional) | TambiÃ©n por WA | $0 (lo inicia el cliente) |
| Cliente NO aprieta WA | Igual en cocina.html | $0 |
| Cocina aprieta "Listo" â†’ aviso al cliente | Twilio WA â†’ cliente | $0 si ventana abierta, $0.0124 utility si no |

---

## Estructura de cuentas y sucursales

- Cuenta madre con N sucursales adentro
- Login â†’ selector de sucursal o vista consolidada
- Cada sucursal: catÃ¡logo propio, QR propio, pedidos propios, anÃ¡lisis propio
- Plan y facturaciÃ³n: unificados por cuenta madre
- Sucursal adicional: 35% del plan base

**Roles:**
- Administrador: acceso completo
- Operativo: solo cocina/pedidos/catÃ¡logo del dÃ­a. Sin facturaciÃ³n, sin anÃ¡lisis, sin Viti.
- Usuarios operativos: ilimitados sin costo

---

## Competencia y diferenciadores

| Competidor | Precio | Lo que hace |
|-----------|--------|-------------|
| SoyMenu / Carta.menu | $15-25 USD/mes | Solo carta QR, sin IA ni marketing |
| Agencias de marketing | $150-400 USD/mes | Sin tecnologÃ­a propia ni integraciÃ³n con el negocio |
| Nubimetrics | $30-50 USD/mes | Solo anÃ¡lisis ML, sin presencia fÃ­sica ni redes |

**Diferenciador real:** integraciÃ³n. No se vende como "marketing digital" ni "carta QR" sino como "el primer sistema que centraliza toda la presencia digital de un comercio en un lugar."

---

## Monitoreo de novedades

En cada sesiÃ³n relevante mencionar proactivamente: nuevos modelos de IA mÃ¡s baratos, cambios en polÃ­ticas de Meta/Google/ML/TN, nuevas APIs, herramientas de automatizaciÃ³n, competidores nuevos en el mercado argentino.
