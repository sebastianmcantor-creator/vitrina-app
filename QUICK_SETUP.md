# 🚀 Quick Setup — Vitrina App

Guía rápida para tener Vitrina funcionando con el primer cliente.

---

## ✅ Ya está deployado

- **Frontend:** GitHub Pages en `vitrinaapp.com.ar` ✅
- **Backend:** Cloudflare Workers en `vitrina-tano.vitrinaapp.workers.dev` ✅
- **Landing:** Logo SVG, chat IA, demo funcionando ✅

---

## 📝 Paso 1: Ejecutar Migraciones en Supabase

**Ir a:** [Supabase Dashboard](https://supabase.com) → Tu proyecto → SQL Editor

**Ejecutar en orden:**

```bash
# Migraciones pendientes (en C:\Users\sebas\vitrina-app\migrations\):
014_sales_agent.sql
015_producers.sql
016_exchange_rate.sql
017_executive_reports.sql
018_waitlist_leads.sql
```

**Cómo:**
1. Abrir SQL Editor en Supabase
2. Copiar contenido de cada archivo `.sql`
3. Pegar y ejecutar (botón "Run")
4. Verificar que no haya errores (debajo del editor)
5. Repetir con siguiente archivo

**Verificación:**
```sql
-- Ver todas las tablas creadas
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

Deberías ver: `waitlist`, `leads`, `sales_prospects`, `producers`, `exchange_rates`, etc.

---

## 🔑 Paso 2: Configurar Secrets en Cloudflare Workers

**Ir a:** [Cloudflare Dashboard](https://dash.cloudflare.com) → Workers & Pages → vitrina-tano → Settings → Variables

**O por CLI:**

```bash
cd C:\Users\sebas\vitrina-server-worker

# Core (CRÍTICO - sin esto no funciona nada)
wrangler secret put ANTHROPIC_API_KEY
wrangler secret put RESEND_API_KEY
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_SERVICE_KEY

# MercadoPago (CRÍTICO - sin esto no hay facturación)
wrangler secret put MP_ACCESS_TOKEN
wrangler secret put MP_PUBLIC_KEY

# WhatsApp (IMPORTANTE - sin esto no hay notificaciones)
wrangler secret put TWILIO_ACCOUNT_SID
wrangler secret put TWILIO_AUTH_TOKEN
wrangler secret put TWILIO_WHATSAPP_FROM

# Google OAuth + Places (para Marketing)
wrangler secret put GOOGLE_CLIENT_ID
wrangler secret put GOOGLE_CLIENT_SECRET
wrangler secret put GOOGLE_PLACES_API_KEY

# Instagram OAuth (para Marketing)
wrangler secret put INSTAGRAM_APP_ID
wrangler secret put INSTAGRAM_APP_SECRET

# Metricool (para Marketing)
wrangler secret put METRICOOL_CLIENT_ID
wrangler secret put METRICOOL_CLIENT_SECRET

# Replicate (opcional - para mejorar fotos)
wrangler secret put REPLICATE_API_TOKEN
```

**¿Dónde conseguir cada secret?**
Ver `SETUP.md` sección 2 (líneas 44-121)

---

## ⏰ Paso 3: Configurar Cron Jobs

**Opción A: Cloudflare Dashboard**

1. Ir a Workers & Pages → vitrina-tano → Triggers → Cron Triggers
2. Agregar:
   - `0 10 * * 1` → Lunes 10 AM (tipo de cambio)
   - `0 10 * * *` → Diario 10 AM (seguimientos ventas)
   - `0 9 1 * *` → Día 1 mes 9 AM (informes)

**Opción B: wrangler.toml** (recomendado)

Crear `C:\Users\sebas\vitrina-server-worker\wrangler.toml`:

```toml
name = "vitrina-tano"
main = "src/index.js"
compatibility_date = "2026-04-24"

[[triggers.crons]]
crons = ["0 10 * * 1", "0 10 * * *", "0 9 1 * *"]
```

Luego: `wrangler deploy`

---

## 🔗 Paso 4: Configurar Webhook de MercadoPago

**Ir a:** [MercadoPago Developers](https://www.mercadopago.com.ar/developers/panel/webhooks)

1. Crear webhook
2. URL: `https://vitrina-tano.vitrinaapp.workers.dev/api/mp/webhook`
3. Eventos: **Subscriptions** y **Payments**
4. Guardar y activar

**Verificar:**
MercadoPago enviará una notificación de prueba. Ver logs en Cloudflare Workers.

---

## 🧪 Paso 5: Testing Básico

### Test 1: Landing + Chat IA

1. Ir a `https://vitrinaapp.com.ar`
2. Hacer clic en botón de chat (abajo derecha)
3. Escribir: "Cuánto cuesta el plan básico?"
4. Debería responder con info de planes
5. Escribir tu email cuando lo pida
6. Verificar que llegue email a `contacto@vitrinaapp.com.ar`

### Test 2: Demo del Menú

1. Ir a `https://vitrinaapp.com.ar/demo.html`
2. Verificar que se vean todos los platos
3. Hacer clic en un plato (debería mostrar alert)

### Test 3: Panel (requiere login Google)

1. Ir a `https://vitrinaapp.com.ar/panel.html`
2. Login con Google
3. Crear restaurante de prueba
4. Agregar 1 categoría y 2 platos
5. Ir a QR y generar código
6. Escanear QR → debería abrir el menú

### Test 4: Tano (mozo IA)

1. Desde el menú generado, abrir chat de Tano
2. Preguntar sobre un plato
3. Verificar que responde correctamente

---

## ✅ Checklist Pre-Lanzamiento

**Crítico (sin esto no funciona):**
- [ ] Migraciones 014-018 ejecutadas
- [ ] ANTHROPIC_API_KEY configurada
- [ ] SUPABASE_URL + SERVICE_KEY configuradas
- [ ] MP_ACCESS_TOKEN + PUBLIC_KEY configuradas
- [ ] Webhook MP configurado y funcionando

**Importante (funcionalidad limitada sin esto):**
- [ ] RESEND_API_KEY (emails de confirmación)
- [ ] TWILIO secrets (notificaciones WhatsApp)
- [ ] Cron jobs configurados
- [ ] Testing básico completo

**Opcional (para Marketing):**
- [ ] Google OAuth configurado
- [ ] Instagram OAuth configurado
- [ ] Metricool configurado
- [ ] Replicate API configurado

---

## 🆘 Troubleshooting Rápido

### "Error: ANTHROPIC_API_KEY no configurada"
```bash
wrangler secret put ANTHROPIC_API_KEY
# Pegar API key de console.anthropic.com
```

### "Error: relation 'waitlist' does not exist"
Falta ejecutar migración 018 en Supabase SQL Editor

### Chat IA no responde
1. Verificar logs en Cloudflare Workers Dashboard
2. Ver si llegó al rate limit (10 req/min)
3. Verificar que ANTHROPIC_API_KEY tiene créditos

### Emails no llegan
1. Verificar RESEND_API_KEY configurada
2. Ver logs de Resend Dashboard
3. Verificar que dominio está verificado en Resend

### Webhook MP no funciona
1. Verificar URL correcta en MP Dashboard
2. Ver logs en Cloudflare Workers
3. Testear con `curl -X POST https://vitrina-tano.vitrinaapp.workers.dev/api/mp/webhook`

---

## 📞 Siguiente Paso

Una vez completados pasos 1-4, estás listo para:

1. **Invitar primer cliente piloto**
2. **Ejecutar checklist de `TESTING_CHECKLIST.md`**
3. **Iterar basado en feedback**

¿Problemas? Revisar `SETUP.md` (guía completa) o `TEST_RESULTS.md` (security audit).
