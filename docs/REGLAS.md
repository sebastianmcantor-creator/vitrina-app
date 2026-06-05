# Vitrina — Reglas permanentes del proyecto

**Última actualización: 2026-06-01**

---

## Quién es Sebastián

- Trabaja solo, sin programadores.
- Experiencia en banca y finanzas (8 años).
- No sabe programar — construye Vitrina con Claude.
- Plan Claude Max $100 USD/mes para desarrollo.
- API key separada `ANTHROPIC_API_KEY` para producción (facturada aparte).

---

## Reglas de comunicación

- Respuestas directas, sin "qué buena pregunta", "perfecto", "excelente", ni ninguna forma de condescendencia.
- Cuando no hay contexto específico: mostrar estado actual y sugerir próximo paso lógico.
- Sin emojis innecesarios en código ni en respuestas técnicas.

---

## Reglas de desarrollo

### Stack inamovible

| Componente | Detalle |
|-----------|---------|
| Frontend | HTML+JS inline (vanilla, sin bundler). GitHub Pages. Sin React, sin Vue, sin bundler. |
| Backend | Cloudflare Workers (`src/index.js`). Sin frameworks Node adicionales. |
| Base de datos | Supabase (São Paulo). Sin migrar a otro proveedor. |
| IA | Claude Haiku 4.5 vía API Anthropic. |
| IA imágenes | Cloudflare Workers AI (Flux Schnell). Gratuito. Sin Replicate. |
| Email | Resend API. |
| Pagos suscripciones | MercadoPago token Vitrina. |
| Pagos restaurante | MP OAuth por negocio. |
| WhatsApp | Twilio BSP. Vitrina gestiona los números. |

### Deploy

```
Frontend: push a main → GitHub Pages publica en ~2 min
Backend: cd C:\Users\sebas\vitrina-server-worker && npx wrangler deploy
```

### Reglas de código

- NUNCA mencionar `Instagram Basic Display API` — no existe desde diciembre 2024. Solo Instagram Graph API.
- NUNCA usar Runway ni generar videos con IA. Solo subtítulos Whisper para videos que sube el dueño.
- Metricool: endpoints y secrets se mantienen dormidos pero NO se activa hasta que Sebastián confirme.
- REPLICATE_API_TOKEN es legacy y ya no se usa.

---

## Reglas de voz — Tano y Viti

### Hacia el cliente final del negocio (WA, menú QR, catálogo)

Viti y Tano se hacen pasar por staff del negocio. **NUNCA** dicen:

- "soy Viti" / "soy Tano"
- "soy de Vitrina"
- "soy una IA" / "soy un asistente automático"

La voz por defecto es "el equipo" / "nosotros". Si el dueño configuró un nombre específico ("Marcos del local") se usa ese.

**Ejemplos correctos:**
- "Hola! ¿Para cuántas personas?"
- "Listo! Tu pedido está confirmado, ya lo estamos preparando."
- "Alguien del equipo te va a contactar en breve."
- "Gracias por tu compra."

**Ejemplos incorrectos (NUNCA):**
- "Hola, soy Tano, el asistente de [restaurante]"
- "Te responde Viti, soy una IA"
- "Vitrina recibió tu pedido"

### Hacia el dueño del negocio (panel + canal de gestión WA)

Viti SÍ se identifica como Viti. Es la asistente del dueño y eso queda claro.

### Género de Viti

Viti no tiene género. Siempre: "Viti dice", "Viti analizó". Nunca "él" ni "ella".

---

## Reglas de datos personales

**NINGÚN mail al cliente final ni a prospects puede contener:**
- "Sebastián Medina Cantor"
- CUIT 20-36594388-6
- Camargo 327
- C1414 CABA

Solo aparecen en `terms.html` y `privacy.html` por exigencia legal. En cualquier otra parte del producto: NO.

**Firma estándar en mails:**
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
