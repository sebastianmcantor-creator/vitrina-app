# Setup de suscripciones — Instrucciones

## ✅ Completado automáticamente

- ✅ Worker deployado a `https://vitrina-tano.vitrinaapp.workers.dev`
- ✅ Código del panel actualizado con modal de upgrade
- ✅ Integración MercadoPago implementada

## 🔧 Requiere acción manual

### 1. Ejecutar migración SQL en Supabase

1. Abrí [Supabase Dashboard](https://supabase.com/dashboard/project/zigtqvwerrtyuunayduh)
2. Andá a **SQL Editor** (menú izquierdo)
3. Click en **+ New Query**
4. Copiá y pegá todo el contenido de `migrations/011_subscriptions.sql`
5. Click en **Run** (o Ctrl+Enter)

La migración crea:
- Tabla `subscriptions` para trackear suscripciones activas
- Tabla `subscription_payments` para historial de pagos
- Columnas nuevas en `restaurants`: `subscription_status`, `subscription_tier`, `trial_ends_at`, `can_take_orders`, `tano_messages_used/limit/reset_at`
- Índices para performance
- Trigger `updated_at` para subscriptions
- Función `reset_tano_messages()` para resetear contador mensual de Tano

### 2. Configurar webhook de MercadoPago

1. Andá a [MercadoPago Developers](https://www.mercadopago.com.ar/developers/panel/notifications/webhooks)
2. Click en **Crear webhook**
3. Configurá:
   - **URL**: `https://vitrina-tano.vitrinaapp.workers.dev/api/mp/webhook`
   - **Eventos**: Seleccionar:
     - `subscription_preapproval` (cambios de estado de suscripción)
     - `subscription_authorized_payment` (pagos automáticos)
     - `payment` (pagos puntuales)
4. Guardar

### 3. Verificar secrets del worker

Verificar que estos secrets estén configurados en Cloudflare Workers:

```bash
wrangler secret list
```

Deben estar:
- `ANTHROPIC_API_KEY`
- `RESEND_API_KEY`
- `MP_ACCESS_TOKEN` ← **Importante para suscripciones**
- `MP_PUBLIC_KEY`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY` ← **Importante para webhook**
- `TWILIO_ACCOUNT_SID` (opcional)
- `TWILIO_AUTH_TOKEN` (opcional)
- `TWILIO_WHATSAPP_FROM` (opcional)

Si falta alguno, agregarlo con:
```bash
wrangler secret put SECRET_NAME
```

### 4. Testing del flujo

Una vez ejecutada la migración y configurado el webhook:

1. Abrir `https://vitrinaapp.com.ar/panel.html`
2. Ir a **Facturación** en el sidebar
3. Click en **✨ Actualizar plan**
4. Seleccionar un plan (usar credenciales de prueba de MP)
5. Verificar que se cree el registro en `subscriptions`
6. Completar el pago en MercadoPago sandbox
7. Verificar que el webhook actualice el estado

## 🧪 Testing con MercadoPago Sandbox

Para testing, usar estas credenciales de prueba de MercadoPago:

**Comprador de prueba:**
- Email: test_user_123456@testuser.com
- Contraseña: qatest123

**Tarjeta aprobada:**
- Número: 5031 7557 3453 0604
- CVV: 123
- Fecha: 11/25

Ver más en: https://www.mercadopago.com.ar/developers/es/docs/checkout-pro/additional-content/test-integration

## 📋 Verificación post-setup

✅ Migración ejecutada sin errores
✅ Webhook configurado en MercadoPago
✅ Worker respondiendo en `/api/mp/webhook`
✅ Panel muestra sección de Facturación
✅ Modal de upgrade abre correctamente
✅ Trial de 14 días se crea automáticamente
✅ Estados de suscripción se sincronizan correctamente
