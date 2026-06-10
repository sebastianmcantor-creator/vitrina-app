# Vitrina — Fases de implementación y pendientes

**Última actualización: 2026-06-10**

---

## ESTADO ACTUAL (10/06/2026) — dónde estamos parados

### Prioridad inmediata
1. **Arreglar los 9 bugs del QA ronda 2** (ver /docs/pruebas.md sección "QA ronda 2") — 4 críticos de BD/permisos
2. **Completar revisión de /docs/**: Sebastián aprobó REGLAS.md y contexto_funcional.md (con corrección: plan Free es solo retención interna, ya quitado de páginas públicas). arquitectura.md mostrado pero falta aprobar (tiene dato viejo: dice 27 migraciones, van 38). Faltan revisar: fases_implementacion.md, decisiones.md, pruebas.md.
3. **Instagram OAuth de Vitrina**: scopes corregidos a los válidos de Facebook Login (`pages_show_list,pages_read_engagement,pages_manage_posts,instagram_manage_insights,instagram_content_publish,instagram_manage_comments`), worker deployado. Sebastián necesita: cuenta IG Business + Página de Facebook vinculada. Iba a probar con la cuenta de Chikpi (negocio conocido). El login SIEMPRE pasa por Facebook (es el flujo de Meta, no hay alternativa).
4. **Callback de Instagram**: verificar que `/api/instagram/callback` intercambie el code vía `graph.facebook.com/oauth/access_token` (puede estar usando el endpoint viejo de Basic Display).

### Hecho recientemente (commits e3474b1, 144a175, c30b903, 6c16061, 469cf16)
- Sistema de documentación /docs + CLAUDE.md nuevo
- Plan Free quitado de precios.html, index.html (solo retención interna)
- Migración 038 opening_hours + slug opcional con auto-convert y preview
- Subtítulos: precio interno oculto + cards Instagram/FB clickeables
- Mi Marketing en maestro.html + Rappi/PY en rentabilidad
- Features Kiboo: etiquetas barcode, arqueo caja, proveedores/OC, rentabilidad
- Twilio: número +14482315343 comprado y registrado como sender WA "Vitrina" (Online)
- Vitrina como restaurante propio en Supabase (ID 779d4db8-66b0-44f9-b6c8-639932a41400, plan combo)
- Seguridad: JWT admin, CORS allowlist, firma Twilio, rate limiting

### Pendientes que dependen de Sebastián
| Pendiente | Estado |
|-----------|--------|
| Business Verification Meta (constancia nueva Yatay 241 lista) | Retomar trámite |
| Video screencast App Review Meta | Grabar cuando esté listo |
| Chip AR para WA prospección de Vitrina | Comprar en estos días |
| Cuenta Calendly para demos | Crear cuenta |
| Credenciales ML en wrangler secrets | Cargar |
| Activar campaña de mails del CRM de ventas | Después de conectar Instagram |

---

## Pendientes técnicos históricos

| # | Pendiente | Quién | Estado |
|---|-----------|-------|--------|
| 1 | Verificar Business Verification Meta en Business Manager | Sebastián | Pendiente |
| 2 | Grabar video screencast para App Review (script preparado) | Sebastián | Pendiente |
| 3 | Migrar código Twilio a modelo "número por cliente" | Claude | ✅ Hecho |
| 4 | Implementar sistema de límites Twilio | Claude | ✅ Hecho |
| 5 | Construir vista CRM en maestro.html + completar sales agent | Claude | ✅ Hecho |
| 6 | Agregar descripción corta + completa en menu_items | Claude | ✅ Hecho |
| 7 | Implementar flujo "comercio sin TN/ML" | Claude | ✅ Hecho |
| 8 | Cargar credenciales ML en wrangler secrets | Sebastián | Pendiente |
| 9 | `npx wrangler deploy` para crons | Sebastián | ✅ Hecho |
| 10 | Sincronizar CLAUDE.md con skill del plugin | Claude | ✅ Hecho |

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
