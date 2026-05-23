# Vitrina

SaaS de presencia digital y operaciones para comercios y restaurantes argentinos.

**Web:** [vitrinaapp.com.ar](https://vitrinaapp.com.ar)
**Soporte:** contacto@vitrinaapp.com.ar

---

## Documentación

**Fuente única de verdad: [`CLAUDE.md`](./CLAUDE.md)**

Todo el contexto del producto, decisiones de negocio, planes, precios, arquitectura, endpoints, migraciones, secrets, decisiones firmes y pendientes están en ese único archivo. Cualquier otro `.md` que aparezca en este repo está obsoleto y será eliminado.

---

## Stack

- **Frontend:** HTML+JS vanilla (sin bundler) → GitHub Pages
- **Backend:** Cloudflare Workers (en `../vitrina-server-worker`)
- **Base de datos:** Supabase (PostgreSQL)
- **IA:** Claude Haiku 4.5 vía Anthropic API
- **Email:** Resend API
- **Pagos:** MercadoPago
- **WhatsApp:** Twilio (Vitrina asigna número, modelo BSP)

---

## Estructura del repo

```
vitrina-app/
├── CLAUDE.md           # Skill maestro — fuente única de verdad
├── index.html          # Landing principal
├── panel.html          # Panel admin del cliente
├── maestro.html        # Panel maestro (solo Sebastián)
├── menu.html           # Menú QR del comensal
├── cocina.html         # Display de pedidos en tiempo real
├── mozo.html           # Chat Tano para el comensal
├── demo.html           # Demo restaurante + comercio
├── terms.html          # Términos legales
├── privacy.html        # Política de privacidad
├── migrations/         # 27 migraciones SQL
└── sw.js + manifest.json  # PWA
```

## Deploy

- **Frontend:** push a `main` → GitHub Pages publica en ~2 minutos
- **Worker:** `cd ../vitrina-server-worker && npx wrangler deploy`

---

## Licencia

Propietaria · Vitrina 2026
