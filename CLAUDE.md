# CLAUDE.md — Vitrina App

> Este archivo es el contexto maestro del proyecto. Leerlo completo antes de cualquier acción.

---

## Quién es Sebastián (el dueño del proyecto)

Trabaja solo, sin programadores. No sabe programar — construye Vitrina con Claude Code. Experiencia en banca y finanzas (8 años). Respuestas directas, sin frases condescendientes. Cuando no hay contexto específico, mostrar estado actual y sugerir próximo paso lógico.

---

## Qué es Vitrina

SaaS para restaurantes con dos servicios contratables juntos o por separado:

**Servicio 1 — Posicionamiento Digital:** análisis de presencia online + estrategia de marketing mensual. Google, Instagram, TikTok, Facebook. Datos reales, comparativas con competidores, plan de acción, publicación automática, gestión de publicidad paga. El asistente de este módulo se llama **Viti** (sin género — siempre "Viti dice", "Viti analizó", nunca "él" ni "ella").

**Servicio 2 — Menú Digital Inteligente:** menú QR con **Tano** (mozo IA, tono cálido e informal, suena humano), sistema de pedidos, pantalla de cocina en tiempo real, pagos MercadoPago, analytics del restaurante.

---

## Stack técnico

- **Dominio**: `www.vitrinaapp.com.ar` (DNS Cloudflare — nameservers apollo + eleanor)
- **Frontend**: HTML/JS → GitHub Pages (`github.com/sebastianmcantor-creator/vitrina-app`)
- **Backend**: Cloudflare Workers (`vitrina-worker.vitrinaapp.workers.dev`)
- **Base de datos**: Supabase (migración desde D1 — decisión firme)
- **Email**: Google Workspace (`contacto@vitrinaapp.com.ar`)
- **IA**: Claude Haiku 4.5 vía API Anthropic (cuenta separada en console.anthropic.com)
- **Local**: Node.js v24.15.0, Wrangler 4.85.0 autenticado
- **Carpetas locales**: `C:\Users\sebas\vitrina-app` y `C:\Users\sebas\vitrina-server-worker`

---

## Estado actual (06/05/2026)

### ✅ Bloques completos
**Bloque 1 — Login + Supabase + BD + Panel + Roles** (100%)
- Login Google + gestión de sesión
- Supabase completo con capa de abstracción (lib/db.js)
- Estructura BD completa: profiles, restaurants, restaurant_staff, menu_categories, menu_items, orders, order_items, order_sessions, restaurant_tables
- Sistema de roles (owner | admin | staff) implementado
- panel.html con selector de restaurantes

**Bloque 2 — Menú + Tano + QR + Cocina + Pedidos + Idiomas** (100%)
- `menu.html` — menú responsive con categorías, filtros dietarios, destacados, idiomas (ES/EN/PT)
- `mozo.html` — Tano (Claude Haiku) con detección de idioma, tono configurable, límite de mensajes
- `cocina.html` — tiempo real vía Supabase, agrupación por mesa, filtros por estado, botón deshacer individual, botón "Todo listo" por mesa
- Sistema de pedidos completo: carrito → checkout → cocina → notificación cliente
- Seguimiento múltiples pedidos por mesa con overlay de estado en tiempo real
- Reseteo automático de sesión (>3h en menu, >4h en mozo) + botones manuales
- Notificación cliente cuando pedido listo (toast + notificación sistema + sonido)
- QR por mesa implementado
- Confirmación de pedido por email (cliente)
- Notificación WhatsApp operativo (Twilio) al recibir pedido

**Features adicionales implementadas:**
- Upload logo y portada del restaurante
- Platos destacados con sección especial en menú
- Horarios de apertura configurables con estado en vivo
- Historial de pedidos con filtros
- Configuración de Tano (tono, mensaje bienvenida, límite mensajes)
- Tipo de cambio dinámico (BCRA API) para precios en ARS
- Panel maestro con stats y exportación CSV

**Bloque 3 — MercadoPago suscripciones + lógica de planes + prueba gratis** (100%) ✅
- Migración 011: tablas `subscriptions`, `subscription_payments` + columnas en `restaurants`
- Worker actualizado con endpoints `/api/mp/crear-suscripcion` y webhook `/api/mp/webhook`
- Lógica de planes: Free (45 platos, 75 Tano/mes) | Básico (ilimitado, sin pedidos) | Pro (pedidos + cocina) | Full (3 sucursales)
- `lib/plans.js`: funciones para validar límites por plan
- Panel de facturación: plan actual, estado trial, uso de Tano, historial de pagos
- Modal de upgrade con tarjetas de planes y checkout MercadoPago
- Trial de 14 días automático
- Worker deployado: `https://vitrina-tano.vitrinaapp.workers.dev`
- Validación `can_take_orders` en menu.html antes de confirmar pedidos

**Pendiente manual (ver SETUP_SUBSCRIPTIONS.md):**
- Ejecutar migración SQL en Supabase Dashboard
- Configurar webhook en MercadoPago Dashboard
- Testing con credenciales sandbox de MP

**Bloque 4 — Google Business API + Instagram básica + análisis + Viti** (100%) ✅
- Migración 012: tablas `integrations`, `analytics_cache`, `competitors`
- OAuth Google Business Profile: endpoints `/api/google/auth`, `/api/google/callback`, `/api/google/business-data`
- OAuth Instagram Basic Display: endpoints `/api/instagram/auth`, `/api/instagram/callback`, `/api/instagram/metrics`
- Endpoint `/api/places/nearby-competitors` para búsqueda automática de competidores
- Dashboard de análisis en panel.html: cards de Google Business, Instagram y Competidores
- Viti: drawer lateral con chat, contexto enriquecido (menú, precios, pedidos, stats), endpoint `/api/claude`
- Funciones `loadAnalisis()`, `renderGoogleBusinessData()`, `renderInstagramData()`, `loadCompetitors()`
- Manejo de callbacks OAuth con navegación automática y toasts
- Worker deployado con todos los endpoints nuevos

**Pendiente manual (ver migración 012_integrations.sql):**
- Ejecutar migración SQL en Supabase Dashboard
- Configurar secrets en Cloudflare: `INSTAGRAM_APP_ID`, `INSTAGRAM_APP_SECRET`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GOOGLE_PLACES_API_KEY`
- Crear app de Instagram en Meta Developers
- Crear proyecto OAuth en Google Cloud Console

**Bloque 5 — Publicación automática vía Metricool + calendario de contenido** (100%) ✅
- Migración 013: tablas `scheduled_posts`, `content_templates`, `content_calendar_suggestions`
- Módulos en lib/db.js: scheduledPosts, contentTemplates, contentCalendarSuggestions
- OAuth Metricool: endpoints `/api/metricool/auth`, `/callback`, `/schedule-post`, `/posts`
- Sección Marketing en panel: calendario de contenido con filtros por estado
- Modales para crear posts programados y guardar templates
- Sistema de templates reutilizables con categorías
- Integración completa con Metricool API para publicación en Instagram, Facebook, Google Business
- Renderizado de posts con estados (programadas, publicadas, fallidas, canceladas)
- Worker deployado con todos los endpoints

**Pendiente manual:**
- Ejecutar migración 013 en Supabase Dashboard
- Configurar secrets en Cloudflare: `METRICOOL_CLIENT_ID`, `METRICOOL_CLIENT_SECRET`
- Crear cuenta en Metricool y obtener credenciales de API

**Bloque 6 — Replicate fotos + historial precios + competidores automático** (100%) ✅
- Integración Replicate API (modelo real-esrgan) para mejorar fotos de platos con upscaling 2x
- Botón "✨ Mejorar" en modal de platos con polling automático de resultados
- Endpoints `/api/replicate/enhance-image` y `/api/replicate/prediction/:id`
- Historial de precios ya estaba implementado: se muestra al editar plato, registra cambios automáticamente
- Endpoint `/api/competitors/update-metrics` para actualizar ratings y reviews desde Google Places
- Botón "🔄 Actualizar métricas" en sección de competidores (se muestra cuando hay competidores)
- Muestra fecha de última actualización en cada competidor
- Worker deployado con todos los endpoints nuevos

**Pendiente manual:**
- Configurar secret en Cloudflare: `REPLICATE_API_TOKEN`
- Crear cuenta en Replicate (https://replicate.com) y generar API token

**Bloque 7 — Landing page con estética gastronómica** (100%) ✅
- Landing page completa en index.html con paleta de colores tierra (terracota, beige, crema, marrón)
- Hero con animación de partículas flotantes en fondo (CSS keyframes)
- Secciones: Hero + demo visual, Servicios (Menú Digital y Marketing), Cómo funciona, Pricing, Diferenciadores, FAQ, CTA
- Tabla de precios con toggle mensual/anual y descuento del 20% en plan anual
- FAQ accordion con 6 preguntas frecuentes
- Animaciones de scroll con Intersection Observer API
- Diseño mobile-first responsive (breakpoint 768px)
- Botón de WhatsApp flotante
- Tipografía: Cormorant Garamond para títulos, Outfit para cuerpo
- Idioma: español únicamente
- Todo en un solo archivo para GitHub Pages

**Bloque 8 — Agente de ventas + Twilio WhatsApp** (100%) ✅
- Migración 014: tablas `sales_prospects`, `sales_contacts`, `sales_agent_config`, `sales_metrics`
- Módulos en lib/db.js: salesProspects, salesContacts, salesAgentConfig, salesMetrics
- Worker con endpoints completos: `/api/sales/search-restaurants`, `/generate-diagnosis`, `/create-prospect`, `/contact`, `/process-followups`, `/prospects`, `/config`, `/metrics`
- Búsqueda automática de restaurantes con Google Places API (por ubicación y radio)
- Generación de diagnóstico preliminar automático: análisis de presencia online, fit score, pain points
- Envío de WhatsApp personalizado vía Twilio con templates configurables
- Sistema de seguimiento automático a 3 días con endpoint cron `/process-followups`
- Sección completa en panel.html: métricas del agente, lista de prospectos con filtros, configuración, búsqueda manual
- Estados de prospectos: discovered → contacted → interested/not_interested → converted
- Modales para detalle de prospecto y búsqueda manual de restaurantes
- Métricas: prospectos encontrados, contactados, interesados, convertidos, costo total
- Toggle para activar/desactivar el agente, configuración de templates y límites diarios
- Worker deployado con todos los endpoints nuevos

**Pendiente manual:**
- Ejecutar migración 014 en Supabase Dashboard
- Configurar cron job en Cloudflare Workers para `/api/sales/process-followups` (diario a las 10 AM)
- Testing del flujo completo con prospectos reales

### 🔧 Próximo bloque sugerido
**Bloque 9 — Panel maestro completo + sistema de productores** (0%)
- Dashboard maestro para Sebastián con todos los clientes
- Métricas globales: facturación, fees, costos, margen
- Sistema de productores con comisiones
- Alertas de churn y problemas
- Exportación de reportes

---

## Decisiones firmes — NO negociar

- **Base de datos: Supabase.** Gratuito hasta ~100 restaurantes, $25 USD/mes después. Tiempo real nativo elimina el polling. Código con capa de abstracción (`db.guardarPedido()`) para que cambios futuros no rompan nada.
- **Google Business Profile API desde el arranque.** Sin esto el análisis no tiene valor real.
- **Meta API básica primero, avanzada en paralelo.**
- **Publicación automática vía Metricool** mientras no hay credenciales propias de Meta aprobadas.
- **Todas las fases se construyen completas.**
- **Términos de servicio y política de privacidad** necesarios antes del primer pago real y antes de solicitar aprobación de Meta.

---

## Tano — mozo IA

- Tono: cálido, informal, humano. Nunca suena a bot.
- Responde solo sobre el menú: ingredientes, alergias, recomendaciones, platos del día, opciones veganas/vegetarianas/celíacas.
- Fuera del menú: "Eso no te lo puedo contestar yo, pero el equipo te ayuda."
- El dueño configura el tono en el onboarding.
- **Idiomas:** detección automática por navegador + opción de cambio manual. Iniciales: español, inglés, portugués. Escalable a italiano y francés.
- Al subir un plato en español, botón "traducir automáticamente" genera versiones con Claude — el dueño revisa y aprueba.

**Cuando Tano se queda sin créditos (plan free):**
- A 15 mensajes restantes: alerta WhatsApp al dueño.
- Al agotarse: las nuevas mesas ven a Tano con cartel "No disponible por ahora — el equipo te atiende en persona."

---

## Viti — asistente IA del dueño

- Sin género — siempre "Viti dice", "Viti analizó", "Viti sugiere". Nunca "él" ni "ella".
- Asesora sobre marketing, análisis, estrategia, competidores, publicidad, datos de ventas.
- Solo responde sobre temas del restaurante y el negocio.
- Usa todos los datos disponibles: análisis de Google/redes, historial de pedidos, precios históricos, competidores, campañas anteriores.

---

## Estructura de cuentas

- **Cuenta madre** (marca) con N sucursales adentro.
- Login → selector de sucursal o vista consolidada.
- Cada sucursal: menú propio, QR propio, cocina propia, pedidos propios, análisis propio.
- **Roles:**
  - **Administrador:** acceso completo.
  - **Operativo:** solo cocina, estado de pedidos y menú del día.
- Usuarios operativos: **ilimitados en todos los planes**, sin costo adicional.
- **Sucursal adicional**: 35% del plan base por cada una más allá del límite.

---

## Cliente final (quien escanea el QR)

- Email se pide al **confirmar el pedido** (no al entrar).
- Con email: historial guardado durante la sesión, confirmación automática por mail.
- Sin email: nombre y apellido, pierde historial al cerrar.
- Los emails pertenecen al restaurante. Vitrina no los usa sin permiso explícito del cliente.

---

## Historial de datos

- **Platos borrados:** quedan en historial con nombre, precio y descripción exactos al momento del pedido. Etiqueta discreta "plato descontinuado".
- **Historial de precios:** cada modificación queda registrada con fecha y precio anterior. Viti usa ese historial para sugerencias.

---

## Notificaciones

**Canal de gestión** (dueño): alertas de créditos, vencimientos, rendimiento de campañas, reseñas Google, resumen semanal. WhatsApp o email.

**Canal operativo** (local): nuevos pedidos, pedido listo, alertas de mesa. WhatsApp obligatorio. Puede ser número distinto al del dueño.

**Implementación:** Twilio API. ~$1-3 USD/restaurante/mes.

---

## Análisis de competidores

- **Grupo base (automático):** 5 competidores más cercanos geográficamente con Google Places API. Se actualizan automáticamente cada mes.
- **Seguimiento manual:** hasta 2 adicionales elegidos por el restaurante.
- **Alerta:** si algún competidor crece más del 20% en seguidores o tiene pico de reseñas, Vitrina genera una alerta especial.

---

## Medición del éxito del plan

Al generar la estrategia mensual, Vitrina registra proyecciones en tres escenarios (optimista, moderado, pesimista). Al inicio del mes siguiente, Viti hace el cierre: compara métricas reales vs proyecciones, qué funcionó, qué no, qué ajusta el mes siguiente. La nueva estrategia evoluciona con el restaurante — no es plantilla repetida.

---

## Tipo de cambio

- Planes denominados en USD, cobrados en pesos al tipo de cambio oficial Banco Nación (venta).
- Referencia actual: **$1.410 ARS por USD** (mayo 2026).
- El sistema consulta API del BCRA o bluelytics.com.ar todos los lunes.
- Variación >2%: recalcula + notifica con 7 días de anticipación.
- Variación >5%: recalcula + notifica con 15 días de anticipación.

---

## Planes y precios

### Solo Menú

| Plan | Precio/mes | Fee | Tano | Pedidos | Cocina | Pagos | Sucursales |
|------|-----------|-----|------|---------|--------|-------|-----------|
| Free | $0 | — | 75/mes | ❌ | ❌ | ❌ | 1 (máx 45 platos) |
| Básico | USD 12 | — | Ilimitado | ❌ | ❌ | ❌ | 1 |
| Pro | USD 22 | 1% | Ilimitado | ✅ | ✅ | ✅ | 1 |
| Full | USD 35 | 0.8% | Ilimitado | ✅ | ✅ | ✅ | 3 |

### Solo Marketing

| Plan | Precio/mes | Publicaciones auto/mes | Publicidad gestionada | Sucursales |
|------|-----------|----------------------|-------------------|-----------|
| Starter | USD 20 | 4 vía Metricool | ❌ | 1 |
| Pro | USD 42 | 12 vía Metricool | Hasta $60 USD | 1 |
| Full | USD 72 | 30 | Hasta $180 USD | 2 |

### Combo (Menú + Marketing)

| Plan | Precio/mes | Fee | Sucursales |
|------|-----------|-----|-----------|
| Combo Starter | USD 28 | 0.8% | 1 |
| Combo Pro | USD 58 | 0.6% | 2 |
| Combo Full | USD 95 | 0.5% | 5 |

### Fee de transacción escalonado

| Facturación mensual | Fee |
|--------------------|-----|
| Hasta $1.000.000 ARS | Fee del plan |
| $1.000.001 a $3.000.000 ARS | 0.4% |
| $3.000.001 a $6.000.000 ARS | 0.25% |
| Más de $6.000.000 ARS | 0.15% |

---

## APIs — mapa definitivo

| API | Uso | Costo aprox |
|-----|-----|-------------|
| Metricool | Publicación automática (hasta tener Meta directo) | $15-22 USD/restaurante/mes |
| Google Business Profile API | Análisis de presencia local | Gratis |
| Google Places API | Competidores + prospección | ~$2 USD/restaurante/mes |
| Instagram Basic Display API | Métricas básicas (1-5 días aprobación) | Gratis |
| Instagram Graph API | Métricas privadas (2-8 semanas aprobación) | Gratis |
| Claude Haiku 4.5 | Tano, Viti, análisis | ~$1-8 USD/restaurante/mes |
| Replicate | Mejora de fotos | ~$2-8 USD/restaurante/mes |
| Runway ML | Video IA | ~$8-10 USD/restaurante/mes |
| Twilio | WhatsApp Business | $0.05-0.08 USD/mensaje |
| MercadoPago | Suscripciones + pagos clientes | 3.99% por transacción |
| Whisper (OpenAI) | Subtítulos automáticos en videos | $0.006 USD/minuto |

---

## Costos operativos fijos mensuales

| Componente | USD |
|-----------|-----|
| Cloudflare | $10 |
| Dominio | $1.25 |
| Google Workspace | $6 |
| Claude Pro Sebastián | $20 |
| **Total** | **$37.25** |

---

## Bloques de desarrollo

| Bloque | Contenido | Horas est. |
|--------|-----------|-----------|
| 1 | Login Google + Supabase + estructura BD + panel básico + roles | 12-15h |
| 2 | Menú + Tano + QR + cocina + pedidos + idiomas | 10-12h |
| 3 | MercadoPago suscripciones + lógica de planes + prueba gratis | 6-8h |
| 4 | Google Business API + Instagram básica + análisis + Viti | 10-12h |
| 5 | Publicación automática vía Metricool + calendario de contenido | 6-8h |
| 6 | Replicate fotos + historial precios + competidores | 6-8h |
| 7 | Landing page con animaciones + videos IA | 8-10h |
| → **Agente programador entra acá** | Configuración | 3-4h |
| 8 | Agente de ventas + Twilio WhatsApp | 5-6h |
| 9 | Panel maestro completo + sistema de productores | 6-8h |
| 10 | Informe ejecutivo PDF + medición de éxito del plan | 4-6h |
| 11 | Testing, bugs, onboarding, primeros clientes reales | 8-10h |
| **Total** | | **84-107h** |

---

## Agentes

### Agente programador (este agente)
- Entra después de login + Supabase funcionando (Bloque 1 completo).
- **Hace solo:** features completas, deploy a prueba, corrección de errores, iteración.
- **Consulta a Sebastián:** deploy a producción, cambios de precios/planes, features nuevas no definidas, errores sin resolver en 2 intentos.
- **Trabaja de noche:** computadora prendida + pantalla bloqueada (no hibernando).

### Agente de ventas
- Entra cuando menú funciona con cliente real y landing está publicada.
- Busca restaurantes con Google Places API, genera diagnóstico preliminar, manda WhatsApp + email personalizado, seguimiento a los 3 días.
- Avisa a Sebastián cuando alguien muestra interés real.

**Todos los agentes se conectan vía Supabase.** Un agente detecta algo → lo escribe en Supabase → otro agente lo toma.

---

## Panel maestro de Sebastián

- **Clientes:** total activos, nuevos este mes, bajas, por plan, conversión, alertas churn (sin actividad 7+ días).
- **Facturación:** suscripciones, fees transacción, fees publicidad, total vs mes anterior, proyección del mes.
- **Agentes:** actividad, eficacia, costo en tokens/USD por agente.
- **Costos:** fijos discriminados, variables por cliente, margen bruto del mes.
- **Productores:** clientes por productor, comisión generada, "marcar como pagado", reporte descargable.
- **Por cliente:** plan activo, productor asignado, plan cortesía on/off, sucursales, uso de IA este mes.

---

## Sistema de productores / revendedores

- Comisión estándar: 20% primer mes + 10% recurrente.
- Productor top (+10 clientes activos): 25% primer mes + 15% recurrente.
- El panel muestra comisión generada por productor ese mes y botón "marcar como pagado".

---

## Competencia

- **SoyMenu**: $20.000 ARS/mes, 384 clientes, solo carta QR sin cocina ni IA.
- **Carta.menu**: $15.000-25.000 ARS/mes, similar.
- **Agencias de marketing**: $150.000-400.000 ARS/mes, sin tecnología propia.
- Nadie hace menú + marketing + IA integrado para restaurantes chicos en Argentina.

---

## Comentarios en platos

### Cómo funciona
- **Por plato individual:** cada ítem del carrito tiene sus opciones de personalización.
- **Comentario general al final:** campo adicional antes de confirmar el pedido para aclaraciones globales.

### Opciones predefinidas generadas por IA
Al cargar o editar un plato, Claude Haiku analiza nombre, descripción, ingredientes y categoría, y genera automáticamente las opciones de personalización que tienen sentido para ese plato. El dueño las ve, puede aprobarlas, editarlas o eliminarlas — quedan guardadas para ese plato.

**Lógica de generación:**
- Platos ya preparados (empanadas, sushi, pizza al corte): Haiku no sugiere opciones si no hay nada modificable.
- Carnes y proteínas: punto de cocción (jugoso / a punto / bien cocido).
- Sándwiches y hamburguesas: sin ingredientes específicos (sin tomate, sin cebolla, sin mayonesa), extras.
- Bebidas: con/sin azúcar, con/sin hielo, variantes de leche.
- Pastas: salsa aparte, sin queso rallado.
- Si el dueño no cargó descripción, Haiku infiere del nombre + categoría.

**Siempre disponible:** campo de texto libre para aclaraciones que no entran en ninguna opción predefinida.

### Dónde llegan los comentarios
- **Pantalla de cocina:** visible junto a cada ítem del pedido.
- **Tano:** tiene acceso al pedido completo con comentarios para poder confirmar aclaraciones al cliente. Ejemplo: si el cliente pregunta "¿anotaron que quiero el bife jugoso?", Tano puede confirmar.

---

## Diseño del menú

### Personalización por restaurante
Cada restaurante tiene su propio diseño de menú. Elementos personalizables: color de fondo, colores de acento, tipografía, logo, foto de portada, estilo de tarjetas de platos.

### Generación de propuestas con IA
Durante el onboarding, cuando el restaurante conecta Instagram y Google Business, Haiku analiza las imágenes y paleta de colores predominante, y genera **3 propuestas de diseño** para el menú. El dueño elige una.

**Plan B — sin redes conectadas:** se ofrecen 3 propuestas genéricas prediseñadas (clara, oscura, neutra) que el dueño puede personalizar después.

### Reglas
- El dueño puede cambiar el diseño en cualquier momento desde el panel.
- También puede subir su propio diseño (imagen o paleta personalizada).
- El diseño se aplica a todo el menú: header, categorías, tarjetas de platos, carrito, pantalla de confirmación.

---

## Generación y gestión de QR

### Tipos de QR
- **QR genérico:** un solo código para todo el restaurante. Sirve para locales sin mesas asignadas o para usar en redes sociales.
- **QR por mesa numerada:** un código distinto por mesa. El pedido llega a cocina identificado con el número de mesa.
- Ambos disponibles para el dueño desde el panel.

### Estética
- Logo del restaurante en el centro del QR.
- Si no tiene logo cargado, usa las iniciales del restaurante.

### Descarga
- PDF listo para imprimir (tamaño de mesa, con nombre del restaurante y número de mesa).
- PNG del QR individual.
- Envío automático por email al dueño al generarlos.

---

## Onboarding del restaurante

### Pasos obligatorios (mínimo para funcionar)
1. Registro (Google login o datos manuales).
2. Nombre del restaurante + dirección.
3. Cargar al menos un plato.
4. Generar QR.

### Pasos opcionales (completan la experiencia)
- Conectar Instagram y Google Business → activa análisis y propuestas de diseño.
- Configurar tono de Tano (informal/cálido, neutro/profesional, sofisticado).
- Configurar canales de notificación (gestión y operativo).
- Elegir diseño del menú (si no elige, va con propuesta genérica clara).
- Subir foto de portada y logo.

### Experiencia de carga
- **Barra de progreso** siempre visible (Paso 2 de 4, etc.) — diferencia pasos obligatorios de opcionales.
- **Preview en tiempo real del menú** mientras el dueño carga los datos — ve cómo va quedando su menú a medida que completa cada paso.

---

## Dashboard del dueño (panel principal)

### Estructura de la pantalla principal
1. **Alertas arriba:** notificaciones pendientes (créditos bajos, reseñas nuevas, pedidos con problema, etc.).
2. **Resumen de hoy en grande:** pedidos del día, ventas del día, platos más pedidos, mesas activas.
3. **Métricas del mes abajo:** ventas acumuladas, nuevos seguidores, campañas activas, comparativa con mes anterior.
4. **Accesos directos:** Menú, Cocina, QR, Tano, Viti, Publicaciones.

### Navegación
- **Barra inferior tipo app móvil** con las secciones principales: Inicio, Menú, Marketing, Configuración, Viti.
- Diseñada para uso desde celular — el dueño gestiona todo desde el teléfono.

---

## Carrito y confirmación del pedido

### Cómo ve el cliente el carrito
- **Barra fija en la parte inferior** de la pantalla mientras navega el menú.
- Muestra: cantidad de ítems, total acumulado y botón "Confirmar pedido".
- Al tocar un plato se abre la tarjeta con opciones de personalización (comentarios predefinidos + texto libre) antes de agregar al carrito.

### Dos flujos de confirmación

**Flujo A — Clásico:**
Barra inferior → pantalla de resumen del pedido → datos del cliente (nombre + email opcional) → confirmación → pedido va a cocina.

**Flujo B — Con Tano:**
El cliente le dice a Tano lo que quiere. Tano arma el pedido conversacionalmente, confirma los ítems y las aclaraciones, pide nombre y email, y confirma el envío a cocina.

Ambos flujos generan el mismo objeto de pedido en Supabase y aparecen igual en la pantalla de cocina.

### Modificaciones post-confirmación
- Mientras el pedido está en estado **Recibido**: el cliente puede agregar ítems al pedido existente (no eliminar — solo sumar).
- Una vez que pasa a **Preparando**: el pedido queda cerrado, no se puede modificar.
- Si quiere algo más después de Preparando: genera un nuevo pedido.

---

## Reglas de autonomía para el agente programador

1. Implementar features definidas en este documento sin pedir confirmación.
2. Deployar a entorno de prueba sin pedir confirmación.
3. Corregir bugs sin pedir confirmación.
4. Si un problema no se resuelve en 2 intentos, detener y escribir un resumen claro del problema para Sebastián.
5. **NO deployar a producción sin confirmación explícita de Sebastián.**
6. **NO modificar precios, planes ni lógica comercial sin confirmación.**
7. **NO crear nuevas features no definidas en este documento sin confirmación.**
8. Para acceder a Supabase, Cloudflare o GitHub: usar CLI y variables de entorno. No abrir navegador.
9. Usar Sonnet 4.6 para implementación. Usar Opus solo para problemas de arquitectura difíciles.
10. Al terminar la noche o la sesión, escribir un resumen de qué se hizo, qué quedó pendiente y cuál es el próximo paso sugerido.
