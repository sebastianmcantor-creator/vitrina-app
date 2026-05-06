# Vitrina App

SaaS para restaurantes con dos servicios: **Posicionamiento Digital** y **Menú Digital Inteligente**.

## 📦 Stack Técnico

- **Frontend**: HTML/JS vanilla → GitHub Pages (`vitrinaapp.com.ar`)
- **Backend**: Cloudflare Workers (`vitrina-tano.vitrinaapp.workers.dev`)
- **Base de datos**: Supabase (PostgreSQL)
- **IA**: Claude Haiku 4.5 via Anthropic API
- **Emails**: Resend API
- **Pagos**: MercadoPago
- **WhatsApp**: Twilio API
- **Hosting**: GitHub Pages + Cloudflare Workers

## 🗂️ Estructura del Proyecto

```
vitrina-app/
├── index.html              # Landing page
├── login.html              # Login con Google
├── panel.html              # Panel principal del restaurante
├── maestro.html            # Panel maestro (solo Sebastián)
├── menu.html               # Menú digital para clientes
├── mozo.html               # Tano - asistente IA
├── cocina.html             # Pantalla de cocina
├── lib/
│   ├── auth.js             # Autenticación Google + Supabase
│   ├── db.js               # Capa de abstracción Supabase
│   └── supabase.js         # Cliente Supabase
├── migrations/             # Migraciones SQL (001-017)
└── CLAUDE.md               # Contexto maestro del proyecto

vitrina-server-worker/
└── src/
    └── index.js            # Cloudflare Worker con todos los endpoints
```

## 🚀 Bloques Implementados

### ✅ Bloque 1-7: Core completo
- Login Google + Supabase + roles
- Menú digital + Tano (mozo IA) + QR + cocina + pedidos
- MercadoPago suscripciones + planes
- Google Business API + Instagram + Viti (asistente marketing)
- Metricool para publicación automática
- Replicate para mejorar fotos + historial de precios
- Landing page con estética gastronómica

### ✅ Bloque 8: Agente de Ventas
- Prospección automática con Google Places API
- Diagnóstico preliminar + fit score (0-100)
- Contacto WhatsApp automático via Twilio
- Seguimientos a 3 días
- Panel completo en panel.html

### ✅ Bloque 9: Panel Maestro
- Dashboard para Sebastián con métricas globales
- Clientes, facturación, costos, margen
- Sistema de productores con comisiones
- Alertas de churn (7+ días inactivos)
- Cache de métricas con TTL 1 hora

### ✅ Bloque 10: Informes Ejecutivos
- Proyecciones mensuales (3 escenarios)
- Snapshots de métricas inicio/fin mes
- Generación de informes con análisis de Viti
- Comparación real vs proyectado
- Envío automático por email (cron)

### 🔧 Bloque 11: Testing + Documentación (en progreso)
- Documentación técnica
- Checklist de testing
- Onboarding mejorado
- Preparación para primeros clientes

## 📊 Migraciones Pendientes

Ejecutar en Supabase Dashboard (SQL Editor):

1. `migrations/014_sales_agent.sql` - Agente de ventas
2. `migrations/015_producers.sql` - Sistema de productores
3. `migrations/016_exchange_rate.sql` - Tipo de cambio USD/ARS
4. `migrations/017_executive_reports.sql` - Informes ejecutivos

## ⚙️ Secrets de Cloudflare Workers

Configurar con `wrangler secret put <NAME>`:

```bash
# Core
ANTHROPIC_API_KEY
RESEND_API_KEY
SUPABASE_URL
SUPABASE_SERVICE_KEY

# Pagos
MP_ACCESS_TOKEN
MP_PUBLIC_KEY

# Social Media
GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET
GOOGLE_PLACES_API_KEY
INSTAGRAM_APP_ID
INSTAGRAM_APP_SECRET
METRICOOL_CLIENT_ID
METRICOOL_CLIENT_SECRET

# WhatsApp
TWILIO_ACCOUNT_SID
TWILIO_AUTH_TOKEN
TWILIO_WHATSAPP_FROM

# Otros
REPLICATE_API_TOKEN
```

## 🔄 Cron Jobs (Cloudflare Workers)

Configurar en `wrangler.toml` o Cloudflare Dashboard:

```toml
[[triggers.crons]]
# Tipo de cambio: cada lunes 10 AM
- cron = "0 10 * * 1"
  endpoint = "/api/exchange-rate/update"

# Seguimientos ventas: diario 10 AM
- cron = "0 10 * * *"
  endpoint = "/api/sales/process-followups"

# Informes mensuales: día 1 de cada mes 9 AM
- cron = "0 9 1 * *"
  endpoint = "/api/reports/send-monthly"
```

## 🎯 Planes y Precios

**Solo Menú:**
- Free: $0 (45 platos, 75 Tano/mes)
- Básico: $12 USD
- Pro: $22 USD (pedidos + cocina, fee 1%)
- Full: $35 USD (3 sucursales, fee 0.8%)

**Solo Marketing:**
- Starter: $20 USD (4 posts/mes)
- Pro: $42 USD (12 posts, hasta $60 publicidad)
- Full: $72 USD (30 posts, hasta $180 publicidad)

**Combo:**
- Starter: $28 USD
- Pro: $58 USD (2 sucursales)
- Full: $95 USD (5 sucursales)

**Precios en ARS** pesificados al tipo de cambio oficial Banco Nación (actualizado cada lunes).

## 📱 Contacto y Soporte

- **Email**: contacto@vitrinaapp.com.ar
- **Web**: vitrinaapp.com.ar
- **Creador**: Sebastián Cantor (sebastianmcantor@gmail.com)

## 📝 Licencia

Propietario - Vitrina 2026
