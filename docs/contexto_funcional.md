# Vitrina — Contexto funcional del producto

**Última actualización: 2026-06-01**

---

## Qué es Vitrina

SaaS de presencia digital y operaciones para comercios y restaurantes argentinos. Dos módulos que se contratan juntos o por separado:

**Módulo 1 — Presencia Digital:**
Análisis de Google Business, Instagram, Facebook. Estrategia mensual con Viti (IA sin género). Publicación automática directa vía API Meta (sin intermediarios). Auto-respuesta de reseñas y comentarios. Análisis de competidores. Informe PDF mensual.

**Módulo 2 — Operaciones digitales:**
Menú/catálogo QR con Tano (asistente IA), sistema de pedidos, pantalla de cocina en tiempo real, pagos MercadoPago (restaurante conecta su propia cuenta MP), agenda de turnos, MercadoLibre y Tienda Nube integrados.

---

## Vitrina = el cerebro de una agencia de marketing profesional

**Principio rector del producto.** Vitrina no es "una carta QR con redes". Para el negocio, **Viti piensa y trabaja como una agencia de marketing**: conoce el negocio (rubro, menú/catálogo, precios, temporada, eventos, datos de ventas), arma la estrategia, escribe el contenido, lo programa, lo publica y mide los resultados — todo en un solo lugar, sin que el dueño tenga que saber nada de marketing.

### El Motor de Marketing (content engine)

Una **única estructura** que une generación con IA, contenido propio del dueño y publicación automática:

**1. Viti genera el plan mensual (el cerebro).**
- Viti arma un **calendario mensual** de publicaciones (default ~3-4 posts/semana, ajustable) basado en: tipo de negocio, menú/catálogo, fechas relevantes (fines de semana, feriados, efemérides del rubro), y datos de performance previos.
- Cada sugerencia incluye: **fecha sugerida**, **tema**, **copy listo** (en la voz del negocio), **categoría** (promoción / menú del día / evento / tip / detrás de escena / producto), **razón** ("por qué Viti sugiere este post" — qué objetivo cumple) y **recomendación táctica** (mejor horario, formato sugerido — foto/carrusel/reel —, y hashtags).
- Se guarda en `content_calendar_suggestions` (estado `pending`).

**2. El dueño revisa y decide (siempre valida Sebastián / el dueño).**
- Ve el calendario visual del mes. Por cada post puede: **aceptar**, **editar el copy**, **cambiar la fecha/hora**, **rechazar**, o **regenerar** con IA.
- Aplica la regla de **5 aprobaciones** (ver sección correspondiente): tras 5 aprobaciones seguidas, Viti ofrece programar el calendario solo.

**3. Las imágenes — todo bajo la misma estructura.**
Cada post puede tener su imagen por cualquiera de estas vías, intercambiables:
- **Foto propia del dueño** (sube la suya).
- **Foto propia mejorada con IA** (upscaling/calidad vía Replicate `/api/replicate/enhance-image`).
- **Foto generada por la IA de Vitrina** (las "fotos IA" del menú/catálogo, ilimitadas).
El dueño elige por post; la estructura del post (`scheduled_posts.media_urls`) es la misma sin importar el origen.

**4. Se programa y se publica solo.**
- Al aceptar, la sugerencia pasa a `scheduled_posts` (estado `scheduled`) con su fecha/hora.
- Un **cron** publica los posts cuyo horario llegó, a las redes destino (Instagram primero; Facebook/Google cuando estén conectados), vía la API correspondiente. Marca `published` o `failed` con el motivo.

**5. Se mide por post (estadísticas).**
- Tras publicar, se registran las métricas por post (likes, comentarios, alcance/engagement) leídas de la API de la red.
- Alimentan el informe y el próximo plan mensual de Viti (qué funcionó → más de eso).

### Estado de implementación del motor

| Pieza | Estado |
|-------|--------|
| Esquema BD (`scheduled_posts`, `content_templates`, `content_calendar_suggestions`) | ✅ migración 013 (+ grants 042) |
| Conexión + publicación a Instagram (Instagram Login API, app `995611043196298`) | ✅ funcionando |
| Generación del plan mensual con IA (`/api/marketing/generate-calendar`) | 🟢 en construcción |
| Cron de auto-publicación de `scheduled_posts` | 🟢 en construcción |
| Mejora de fotos con IA (`/api/replicate/enhance-image`) | ✅ existe, se integra al composer |
| Calendario visual mensual en el panel | 🟢 en construcción |
| Estadísticas por post | 🟢 en construcción |

---

## Los dos asistentes IA

### Tano
- Asistente para clientes finales del negocio.
- Nombre default para restaurantes, personalizable en onboarding.
- Responde consultas del menú/catálogo, toma pedidos, gestiona reservas.
- Se hace pasar por staff del negocio (nunca se identifica como IA).

### Viti
- Asistente estratégico del dueño del negocio.
- Sin género (siempre "Viti dice", "Viti analizó", nunca "él" ni "ella").
- Analiza datos, genera estrategia, gestiona automatizaciones, responde consultas del negocio.
- Se identifica como Viti solo hacia el dueño, nunca hacia el cliente final.

### Asistente para rubros no gastronómicos
- Cada dueño elige el nombre desde el inicio del onboarding.
- Comportamiento idéntico a Tano pero con terminología adaptada al rubro.

---

## Tipos de negocio soportados

Todo el panel, menú público y onboarding se adaptan automáticamente:

| Tipo | Sidebar muestra | Terminología |
|------|----------------|-------------|
| `restaurant` | Menú, Mesas, Reservas, Agenda, Pedidos | platos, mozo, menú, Tano |
| `services` | Servicios, Agenda, Pedidos | servicios, asistente IA, turnos |
| `local` | Catálogo, Pedidos | productos, asistente IA, catálogo |
| `ecommerce` | Catálogo, Pedidos | productos, asistente IA, tienda |

### Features exclusivas del tipo `restaurant`
- Mensajes de seguimiento automáticos WA post-pedido (`wa_followup_config`)
- Flujo de pago consolidado por mesa (banner acumulado, "Pedir la cuenta", botón "Cobrar" en cocina)
- Badge "Pagado" en cocina al confirmarse el pago

### Rubros disponibles en onboarding
Restaurante/Bar/Café · Heladería/Pastelería · Rotisería/Delivery · Dietética/Almacén natural · Ropa/Calzado/Accesorios · Ferretería/Bazar/Herramientas · Peluquería/Barbería · Estética/Spa/Uñas · Veterinaria · Librería/Papelería · Kiosco/Minimarket · Servicios profesionales · Vendedor online puro · Otro (genérico)

---

## Planes y precios DEFINITIVOS

**Todos los precios en USD, cobrados en ARS al TC oficial Banco Nación (venta).** Actualización automática lunes 10am ART. Fallback 1.418 ARS/USD si la API cae.

**WhatsApp Business incluido en TODOS los planes pagos.** Vitrina asigna el número (vía Twilio). El cliente NO trae su propio número. NO hay planes "+WA" separados. **Sin fee de transacción en ningún plan.**

### Restaurantes / Gastronomía

| Plan | USD/mes | Incluye |
|------|---------|---------|
| **Solo Menú** | **$27** | Pedidos online, cocina, pagos MP, Tano ilimitado ES/EN/PT, fotos IA. WA operativo (Tano responde consultas del menú + recordatorios de reserva + pedido listo). SIN campañas marketing por WA. |
| **Marketing** | **$57** | Viti estrategia mensual, 30 publicaciones auto/mes API Meta (IG+FB+Google), análisis competidores, informe PDF, WA con campañas (50/mes incluidas). |
| **Combo** | **$70** | Solo Menú + Marketing en un solo plan. Ahorra $14 vs separado. |

### Comercios / Locales / Servicios / Vendedores Online

| Plan | USD/mes | Incluye |
|------|---------|---------|
| **Marketing** | **$62** | Catálogo digital, asistente IA, ML + TN sync bidireccional, Viti, 30 publicaciones/mes, análisis competidores, WA con campañas. |

### Plan Free — solo para retención (no se ofrece al público)

El plan Free **NO es un plan de entrada**. No aparece en la landing ni en precios.html. Se activa automáticamente como red de seguridad cuando un cliente deja de pagar:

- **Día 4** (después de 3 días de gracia): plan pasa a Free automáticamente
- **30 días adicionales** con acceso básico (menú QR limitado, Tano 75 msg/mes, sin WA Business, sin campañas, marca de agua)
- **Pasados esos 30 días** sin renovación: cuenta suspendida

**Restricciones del Free:**
- Menú QR con marca de agua de Vitrina
- Tano: máx 75 mensajes/mes
- 1 idioma
- Máx 45 platos/productos
- Sin WA Business
- Sin publicaciones automáticas
- Sin análisis ni informes

El objetivo es no dejar al negocio completamente sin servicio de un día para el otro, dándole tiempo adicional para renovar.

### WhatsApp incluido — qué incluye por plan

| Recurso | Solo Menú $27 | Marketing/Combo/Comercio |
|---------|---------------|--------------------------|
| Número exclusivo gestionado por Vitrina | Sí | Sí |
| Conversaciones service (iniciadas por cliente final) | Ilimitadas (free tier Meta 1000/mes) | Ilimitadas (idem) |
| Mensajes operativos (utility) | 150/mes | 150/mes |
| Campañas marketing | 0 (no incluye) | 50/mes |
| Asistente IA responde 24/7 | Sí (consultas del menú/productos) | Sí |
| Bandeja de mensajes en panel | Sí | Sí |

### Extensiones (todos los planes)

| Recurso | Incluido | Extensión | Precio |
|---------|----------|-----------|--------|
| Mensajes operativos WA | 150/mes | +50 mensajes | $2 USD |
| Campañas marketing WA | 50/mes | +50 mensajes | $3 USD |
| Tope marketing por línea (anti-baneo) | 500/mes | No extendible | — |
| Fotos IA del menú | Ilimitadas | — | — |
| Subtítulos Whisper | 10 videos/mes | +10 videos | $2 USD |
| Publicaciones auto | 30/mes | +15 publicaciones | $3 USD |

### Plan cortesía
Activación manual desde maestro.html. Primer mes gratis con `subscription_tier: 'rest-combo'`. Alerta a Sebastián al terminar.

---

## Flujos completos de WhatsApp

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

### Conversaciones — conteo Meta (ventana de 24hs)

Cuando el cliente le habla al negocio, abre una **ventana service de 24hs gratis**. Dentro de la ventana, todos los mensajes del negocio son gratis. Fuera de la ventana, el negocio paga utility ($0.0124) o marketing ($0.0625) según tipo.

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

### Flujo de pedidos QR — ahorro de costos Meta

1. El pedido se registra en Supabase `orders` → `cocina.html` lo recibe vía Realtime
2. Aparece botón verde "Confirmar por WhatsApp" opcional
3. Si el comensal lo toca: se abre SU WhatsApp con un mensaje pre-escrito. Él aprieta enviar.
4. Ese mensaje abre la ventana de 24hs gratuita de Meta
5. La cocina recibe el pedido siempre en cocina.html, independiente de si el cliente apretó WA

| Acción | Cómo se entera la cocina | Costo Vitrina |
|--------|--------------------------|---------------|
| Cliente confirma pedido en QR | Supabase Realtime → cocina.html | $0 |
| Cliente aprieta "Confirmar por WA" (opcional) | También por WA | $0 (lo inicia el cliente) |
| Cliente NO aprieta WA | Igual en cocina.html | $0 |
| Cocina aprieta "Listo" → aviso al cliente | Twilio WA → cliente | $0 si ventana abierta, $0.0124 utility si no |

---

## Mensajes de seguimiento WA post-pedido (restaurant only)

Feature en panel.html → Configuración → "Mensajes de seguimiento durante la visita". Solo visible para `business_type === 'restaurant'`.

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
- cocina.html → status `ready` → msg1 (2 min)
- cocina.html → status `delivered` → msg2 (30 min) + msg3 (75 min)
- Msg3 consulta `menu_items WHERE category ILIKE '%postre%' LIMIT 3` e interpola `{postres}`
- Worker encola en `wa_followup_queue`; cron procesa y envía via Twilio
- Requires: WA configurado para el restaurante. Si no, muestra aviso en lugar del toggle.

---

## Pago de mesa consolidado (restaurant only)

1. Comensal escanea QR → menu.html → arma pedidos
2. Banner fijo "Total acumulado de la visita: $X" se actualiza tras cada pedido
3. Cocina recibe pedidos en `cocina.html` vía Supabase Realtime
4. Comensal toca "Pedir la cuenta" → `pedirLaCuenta()` → `POST /api/mp/crear-preferencia` → redirect MP
5. Si el restaurante tiene MP OAuth conectado, usa `rest.mp_access_token` (la plata va al restaurante). Si no, fallback al token Vitrina.
6. MP confirma pago → `POST /api/mp/order-webhook` → Worker marca `orders.status = 'paid'`
7. Supabase Realtime → `cocina.html` muestra "Pagado" + toast verde 5s
8. Aparece botón "Cobrar mesa" en cocina con total acumulado y link MP en nueva pestaña

Setup: Panel → Análisis → "MercadoPago — Cobros de mesa" → "Conectar cuenta" → OAuth MP → guarda tokens en `restaurants`. Vitrina no toca esos fondos.

---

## Campañas WA con datos del CRM

Tres tipos activables desde el panel:

1. **Reactivación de clientes existentes:** trigger "no volvió en 30/60/90 días". Mensaje promo. Max 1 vez cada 60 días al mismo cliente. Cuenta como marketing ($0.0625).
2. **Waitlist activación:** cuando se cancela una reserva del horario pedido. Mensaje al primero en la lista. Cuenta como utility ($0.0124).
3. **Eventos especiales:** el dueño lanza la campaña. A toda la base con opt-in. Max 1 cada 7 días al mismo contacto, max 3 al mismo en 30 días.

---

## Sistema de respuestas automáticas — 5 aprobaciones

Aplica a: preguntas ML, publicaciones ML desde Vitrina, respuestas IG/FB/Google, bajada de stock en TN tras venta en ML, publicaciones en redes desde Viti.

- **SIEMPRE son 5 aprobaciones consecutivas** para activar el modo automático.
- Si el dueño rechaza una sugerencia: el contador vuelve a 0.
- Tras 5 aprobaciones seguidas: Viti pregunta "¿Querés que lo haga solo de ahora en más?"
- En modo automático: actúa en menos de 2 minutos, manda resumen diario.
- Excepción: si Viti no tiene certeza, manda al dueño aunque esté en modo automático.
- El dueño puede pausar diciéndoselo a Viti: "Viti, pausá las respuestas de Instagram."

**Canales con respuestas automáticas:**
- Preguntas de compradores ML
- Comentarios en Instagram (feed + Reels)
- Mensajes directos Instagram (solo en planes con WA marketing)
- Comentarios en Facebook
- Reseñas en Google Business Profile
- Mensajes WhatsApp (todos los planes pagos)

**Aprendizaje del estilo:** Viti analiza las últimas 50 respuestas dadas por el dueño en cada canal antes de proponer respuestas propias.

---

## Mi Catálogo — gestión de productos

**Campos por producto:**

| Campo | Para qué se usa | Obligatorio |
|-------|----------------|-------------|
| Nombre | QR catálogo, WA, ML, TN | Sí |
| Foto cruda | Vitrina la mejora con Cloudflare AI | Sí |
| Descripción corta (máx 150 chars) | QR catálogo, mensajes WA, mensajes ML rápidos | Sí |
| Descripción completa (texto largo) | Publicación ML, ficha técnica TN, detalles WA | Sí si vende por ML/TN |
| Atributos ML (marca, modelo, color, etc.) | Publicación ML | Sí si publica en ML |
| Peso y dimensiones | Cálculo de envío ML/TN | Sí si vende con envío |
| Costo de compra, precio, stock, mínimo alerta | Cálculos internos, alertas | Sí |
| SKU / código interno | Sync ML↔TN | Opcional |

**Carga por PDF o CSV:** Claude Vision lee el PDF. La descripción corta se llena con lo extraído; la descripción completa la genera Viti automáticamente y el dueño la edita.

**Cuando se publica en ML:** Viti arma la publicación usando descripción completa + atributos. Si faltan datos, pregunta al dueño antes de publicar. Precio ML = costo + margen + comisión ML + envío estimado.

---

## Envíos para comercios

Vitrina NO integra couriers directos (Andreani, OCA, Correo).

**Tres opciones según qué tiene el local:**

- **Con Tienda Nube:** Viti genera link al checkout TN con productos pre-cargados. TN maneja envíos.
- **Con MercadoLibre (sin TN):** Viti da link directo a la publicación en ML. ML maneja envíos.
- **Sin TN ni ML:** Viti responde + link pago MP. Notificación dual: WA al local + WA al cliente. Local coordina envío/retiro por su cuenta.

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
- Diseño: A4, márgenes generosos, fuente mínima 12pt, B&N friendly, gráficos de barras/líneas (no tortas)

---

## Panel maestro de ventas (CRM de prospects)

**Estado actual:** parcialmente implementado en el backend.

**Endpoints existentes:**
- `/api/sales/search-restaurants` — busca prospects vía Google Places
- `/api/sales/generate-diagnosis` — genera análisis con Claude
- `/api/sales/create-prospect` — guarda en `sales_prospects`
- `/api/sales/contact` — envía WA
- `/api/sales/process-followups` — procesa seguimientos
- `/api/sales/prospects`, `/api/sales/config`, `/api/sales/metrics`

**Tablas:** `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`.

**Filtros de búsqueda de prospects:**
- Rubro
- Zona (default: GBA Oeste/Sur + Córdoba + Rosario)
- Estado del negocio (solo OPERATIONAL en Google Places)
- Rating mínimo
- Reseñas mínimas (50+)
- Tiene sitio web / IG público
- Última reseña reciente
- Sin contactar antes
- Excluir ya cliente

**Horarios de envío:**
- Restaurantes: 12-22 ART
- Locales/Comercios: 10-17 ART

**Efectividad esperada (200 mails/día a régimen):**
- Open rate: 25-35%
- Reply rate: 2-4%
- Trial activado: 0.5-1.5%
- Trial → pago: 20-30%
- Proyección conservadora: 5-12 clientes pagos nuevos/mes

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

## Onboarding simplificado

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

## Competencia y diferenciadores

| Competidor | Precio | Lo que hace |
|-----------|--------|-------------|
| SoyMenu / Carta.menu | $15-25 USD/mes | Solo carta QR, sin IA ni marketing |
| Agencias de marketing | $150-400 USD/mes | Sin tecnología propia ni integración con el negocio |
| Nubimetrics | $30-50 USD/mes | Solo análisis ML, sin presencia física ni redes |

**Diferenciador real:** integración. No se vende como "marketing digital" ni "carta QR" sino como "el primer sistema que centraliza toda la presencia digital de un comercio en un lugar."

---

## Cómo se vende el WA por rubro

- Restaurante/Bar: "Mozo Virtual por WhatsApp"
- Ferretería/Bazar: "Asesor de Productos por WhatsApp"
- Peluquería/Estética: "Asistente de Turnos por WhatsApp"
- Vendedor ML/TN: "Vendedor Automático por WhatsApp"
- Cualquier rubro: "Tu asistente inteligente, disponible 24/7"
