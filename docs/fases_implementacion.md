# Vitrina — Fases de implementación y pendientes

**Última actualización: 2026-06-01**

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
| 10 | Sincronizar CLAUDE.md con la skill del plugin Vitrina | Claude |

---

## Twilio — lo que está stubeado y necesita conectar a API real

### Estado actual
El modelo actual de Twilio usa un único número compartido (`TWILIO_WHATSAPP_FROM`). Esto es un stub funcional que permite testear el flujo, pero no es el modelo definitivo.

### Modelo definitivo: número por cliente
Cada cliente que contrata un plan pago debe recibir su propio número de WhatsApp Business. Esto requiere:

1. **Migración 028 en Supabase:** agregar columnas `twilio_number` y `twilio_sid` en la tabla `restaurants`.
2. **Lógica de compra automática:** cuando un cliente paga, el worker debe:
   - Comprar un número disponible en Twilio (~$1 USD/mes)
   - Registrarlo como número WA Business en la cuenta Meta de Twilio
   - Guardarlo en `restaurants.twilio_number` y `restaurants.twilio_sid`
3. **Webhook routing:** el webhook de Twilio llega al worker con el número destino. El worker debe identificar a qué restaurante corresponde ese número y procesar el mensaje con el contexto correcto.
4. **Liberación de número:** cuando un cliente cancela, el número debe liberarse en Twilio.

### Sistema de límites (pendiente 4)
Una vez activo el modelo número-por-cliente, implementar contadores en Supabase:
- 150 utility/mes por cliente (con aviso al 80% = 120 mensajes)
- 50 campañas marketing/mes (con aviso al 80% = 40 campañas)
- Tope total marketing por línea: 500/mes (no extendible, anti-baneo)
- Extensiones: +50 utility por $2 USD, +50 marketing por $3 USD

---

## Panel maestro de ventas (CRM de prospects) — lo que falta construir

### Backend ya implementado
- `/api/sales/search-restaurants` — busca prospects vía Google Places
- `/api/sales/generate-diagnosis` — genera análisis con Claude
- `/api/sales/create-prospect` — guarda en `sales_prospects`
- `/api/sales/contact` — envía WA
- `/api/sales/process-followups` — procesa seguimientos
- `/api/sales/prospects`, `/api/sales/config`, `/api/sales/metrics`

### Frontend pendiente (en maestro.html)
- Vista CRM con lista de prospects y estados
- Filtros: rubro, zona, rating, reseñas, estado del negocio
- Acciones por prospect: contactar, ver historial, marcar estado
- Envío de mail con PDF adjunto (informe personalizado del prospect)
- Dashboard de métricas del agente de ventas

### Lógica pendiente
- Cron seguimiento 4/7/15 días tras primer contacto
- Distribución gradual de envíos (50/día semana 1 → 200/día semana 5)
- Sistema de estados: contactado / abierto / respondió / interesado / trial / cliente / baja
- Generación automática del PDF diagnóstico personalizado por prospect

---

## Metricool — plan de activación cuando se contrate

### Estado actual
Metricool NO está activo. La publicación auto a IG/FB se hace directo vía API Meta desde el worker. Los endpoints del worker (`/api/metricool/*`) y los secrets (`METRICOOL_CLIENT_ID`, `METRICOOL_CLIENT_SECRET`) se mantienen dormidos.

### Cuándo activar
Con el primer cliente Marketing pago. Sebastián confirma manualmente.

### Plan recomendado al activar
15 marcas (€43/mes ≈ $46 USD). Vitrina ocupa slot 1, quedan 14 para clientes.

### Escala según clientes Marketing

| Clientes con Marketing | Plan Metricool | Costo |
|------------------------|----------------|-------|
| 0-14 | Starter 15 marcas | $46 USD |
| 15-24 | Advanced 25 marcas | $73 USD |
| 25+ | Enterprise 50 marcas | $138 USD |

### Lo que hará Metricool cuando se contrate
- Programación de posts IG/FB (alternativa o redundancia a la API Meta directa)
- Analytics consolidados
- Stories e Instagram Reels programados

---

## Business Verification Meta — estado y pasos pendientes

### Estado actual (al 23/05/2026)
- Verificación enviada el 20/05 con constancia AFIP
- Pendiente: verificar resultado en Business Manager → Centro de seguridad

### Qué desbloquea la verificación
La Business Verification es requisito previo para que Meta apruebe los permisos avanzados solicitados el 22/05:
- `instagram_manage_insights`
- `instagram_manage_engagement`
- `instagram_content_publish`
- `whatsapp_business_messaging`
- `whatsapp_business_management`
- `pages_*`, `read_insights`, `business_management`

### Impacto en operaciones
No bloquea nada actualmente. WhatsApp Business opera vía Twilio BSP (ya aprobado). Cuando se aprueben los permisos avanzados de Meta, se puede evaluar migrar de Twilio a Meta directo.

---

## Video screencast para App Review — pendiente de grabar

### Estado
Script preparado (~3-4 minutos). Pendiente de grabar por Sebastián.

### Qué debe mostrar el video
El screencast debe demostrar el uso de cada permiso solicitado en el contexto real de la app:
- Publicar en Instagram desde el panel (instagram_content_publish)
- Ver métricas de Instagram (instagram_manage_insights)
- Responder comentarios (instagram_manage_engagement)
- Enviar mensajes WA a clientes (whatsapp_business_messaging)
- El flujo completo de onboarding de un negocio

### Por qué es necesario
Meta App Review exige este video para aprobar permisos avanzados. Sin aprobación, los permisos de producción quedan limitados a los básicos ya aprobados.

---

## Calendly para demos — TODO

El sistema de CRM de prospects incluirá links de agenda para que prospects interesados puedan agendar una demo con Sebastián. Pendiente crear cuenta en Calendly o herramienta equivalente.

---

## Testimonios reales — TODO

Para la landing (`index.html`) y las landings verticales se necesitan testimonios de clientes reales. Actualmente las demos usan negocios ficticios (Casa Lucía, Ferretería El Tornillo). Pendiente conseguir los primeros clientes reales y solicitar testimonios.

---

## Chip AR para WA de Vitrina — TODO

Para el canal de gestión/soporte de Vitrina con sus clientes, se evalúa usar un chip argentino en lugar del número Twilio de EEUU. Esto mejora la percepción de cercanía. Pendiente evaluar opciones (Twilio local, número propio, otro BSP).
