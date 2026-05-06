# 🛠️ Setup de Vitrina - Guía Completa

Esta guía te lleva paso a paso desde cero hasta tener Vitrina funcionando en producción.

---

## 1️⃣ Supabase (Base de Datos)

### Crear proyecto
1. Ir a [supabase.com](https://supabase.com)
2. Crear cuenta / login
3. Crear nuevo proyecto:
   - Nombre: `vitrina-app`
   - Database Password: generar uno seguro y guardarlo
   - Region: South America (São Paulo) o más cercana

### Configurar autenticación Google
1. En Supabase Dashboard → Authentication → Providers → Google
2. Habilitar Google provider
3. Crear credenciales OAuth en [Google Cloud Console](https://console.cloud.google.com):
   - Ir a APIs & Services → Credentials
   - Create OAuth 2.0 Client ID
   - Authorized redirect URIs: agregar la URL de callback de Supabase (la encontrás en el provider de Google)
4. Copiar Client ID y Client Secret a Supabase

### Ejecutar migraciones
1. En Supabase Dashboard → SQL Editor
2. Ejecutar en orden las migraciones de la carpeta `/migrations`:
   - `001_initial_schema.sql`
   - `002_menu_improvements.sql`
   - ... (todas en orden numérico hasta 017)
3. Verificar que se crearon todas las tablas en Database → Tables

### Obtener credenciales
- Project URL: Settings → API → Project URL
- Service Key: Settings → API → service_role secret (⚠️ nunca exponerlo en frontend)

---

## 2️⃣ Cloudflare Workers (Backend)

### Instalar Wrangler
```bash
npm install -g wrangler
wrangler login
```

### Configurar proyecto
```bash
cd vitrina-server-worker
wrangler deploy  # Primera vez crea el worker
```

### Configurar secrets
```bash
# Core
wrangler secret put ANTHROPIC_API_KEY
# Obtener en: https://console.anthropic.com → API Keys
# Necesita Claude Haiku 4.5

wrangler secret put RESEND_API_KEY
# Obtener en: https://resend.com → API Keys

wrangler secret put SUPABASE_URL
# La Project URL de Supabase

wrangler secret put SUPABASE_SERVICE_KEY
# La service_role key de Supabase

# MercadoPago
wrangler secret put MP_ACCESS_TOKEN
# Obtener en: https://www.mercadopago.com.ar/developers/panel/app
# Crear aplicación → Credenciales → Access Token

wrangler secret put MP_PUBLIC_KEY
# La Public Key de la misma app

# Google (OAuth + Places)
wrangler secret put GOOGLE_CLIENT_ID
# Del OAuth 2.0 Client creado en paso anterior

wrangler secret put GOOGLE_CLIENT_SECRET
# Del mismo client

wrangler secret put GOOGLE_PLACES_API_KEY
# Crear en Google Cloud Console → APIs & Services → Credentials
# Create credentials → API key
# Restringir a: Places API, Geocoding API

# Instagram
wrangler secret put INSTAGRAM_APP_ID
wrangler secret put INSTAGRAM_APP_SECRET
# Crear en: https://developers.facebook.com/apps
# Create App → Business → Instagram Basic Display
# Copiar App ID y App Secret
# En Settings → Basic → Add Platform → Website
# Site URL: https://vitrinaapp.com.ar
# En Products → Instagram Basic Display → Basic Display
# Add Valid OAuth Redirect URIs: https://vitrina-tano.vitrinaapp.workers.dev/api/instagram/callback

# Metricool (opcional - requiere plan Advanced)
wrangler secret put METRICOOL_CLIENT_ID
wrangler secret put METRICOOL_CLIENT_SECRET
# Contactar a Metricool para obtener credenciales API

# Twilio WhatsApp
wrangler secret put TWILIO_ACCOUNT_SID
# Obtener en: https://console.twilio.com
# Account SID del dashboard

wrangler secret put TWILIO_AUTH_TOKEN
# Auth Token del dashboard

wrangler secret put TWILIO_WHATSAPP_FROM
# Formato: whatsapp:+14155238886
# Usar Twilio Sandbox for WhatsApp para testing

# Replicate (opcional)
wrangler secret put REPLICATE_API_TOKEN
# Obtener en: https://replicate.com/account/api-tokens
```

### Configurar cron jobs
Editar `wrangler.toml`:

```toml
[triggers]
crons = [
  "0 10 * * 1",    # Lunes 10 AM - tipo de cambio
  "0 10 * * *",    # Diario 10 AM - seguimientos ventas
  "0 9 1 * *"      # Día 1 mes 9 AM - informes mensuales
]
```

Luego:
```bash
wrangler deploy
```

### Configurar webhook de MercadoPago
1. Ir a [MercadoPago Developers](https://www.mercadopago.com.ar/developers/panel/webhooks)
2. Crear webhook:
   - URL: `https://vitrina-tano.vitrinaapp.workers.dev/api/mp/webhook`
   - Eventos: Subscriptions, Payments
3. Guardar y activar

---

## 3️⃣ GitHub Pages (Frontend)

### Configurar repositorio
```bash
cd vitrina-app
git init
git remote add origin https://github.com/tu-usuario/vitrina-app
git add .
git commit -m "Initial commit"
git push -u origin main
```

### Habilitar GitHub Pages
1. Ir a Settings → Pages
2. Source: Deploy from a branch
3. Branch: main → / (root)
4. Save

### Configurar dominio personalizado (opcional)
1. En Cloudflare DNS, agregar registros:
   ```
   CNAME  www           tu-usuario.github.io
   CNAME  vitrinaapp    tu-usuario.github.io
   ```
2. En GitHub → Settings → Pages → Custom domain
3. Ingresar: `vitrinaapp.com.ar`
4. Esperar verificación DNS

---

## 4️⃣ Testing Inicial

### Test de autenticación
1. Ir a `https://vitrinaapp.com.ar/login.html`
2. Login con Google
3. Debe redirigir a `/panel.html`

### Test de menú
1. En panel, crear restaurante
2. Agregar categorías y platos
3. Generar QR de una mesa
4. Escanear QR → debe abrir el menú
5. Hacer un pedido de prueba
6. Verificar que llega a cocina

### Test de Tano
1. En el menú, abrir chat de Tano
2. Preguntar sobre un plato
3. Verificar que responde correctamente

### Test de pagos (sandbox)
1. Configurar MercadoPago en modo sandbox
2. En panel → Facturación → Actualizar plan
3. Usar tarjetas de prueba de MP
4. Verificar que se crea la suscripción

---

## 5️⃣ Configuración de Producción

### Cambiar a credenciales de producción
- MercadoPago: cambiar de sandbox a producción
- Instagram: enviar app a revisión de Facebook
- Google: verificar dominio y aumentar quotas

### Monitoreo
- Supabase: revisar uso de storage y queries
- Cloudflare: revisar requests y errores en Workers
- Anthropic: monitorear uso de tokens

### Backups
- Supabase hace backups automáticos (plan gratuito: 7 días)
- Considerar backups adicionales para producción

---

## 6️⃣ Checklist Final

### Pre-lanzamiento
- [ ] Todas las migraciones ejecutadas
- [ ] Todos los secrets configurados
- [ ] Cron jobs activados
- [ ] Webhook de MercadoPago configurado
- [ ] Testing completo de flujos principales
- [ ] Dominio personalizado configurado
- [ ] SSL/HTTPS funcionando
- [ ] Google Analytics (opcional)

### Post-lanzamiento
- [ ] Monitoreo de errores
- [ ] Soporte al primer cliente
- [ ] Ajustes basados en feedback
- [ ] Documentación de usuario

---

## 🆘 Troubleshooting

### Error: "ANTHROPIC_API_KEY no configurada"
- Verificar que el secret está configurado: `wrangler secret list`
- Re-configurar: `wrangler secret put ANTHROPIC_API_KEY`

### Error: "CORS policy"
- Verificar que el worker tiene headers CORS correctos
- En el frontend, usar la URL completa del worker

### Tano no responde
- Verificar créditos de Anthropic
- Revisar logs en Cloudflare Workers
- Verificar que el restaurante no superó el límite de mensajes

### Pagos no funcionan
- Verificar webhook de MercadoPago está recibiendo notificaciones
- Revisar logs del webhook en Cloudflare Workers
- Confirmar que MP_ACCESS_TOKEN es de producción (no sandbox)

---

## 📞 Soporte

Si encontrás problemas:
1. Revisar logs en Cloudflare Workers
2. Revisar logs en Supabase (Database → Logs)
3. Contactar: sebastianmcantor@gmail.com
