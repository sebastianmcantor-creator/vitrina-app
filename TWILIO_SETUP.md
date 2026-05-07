# 📱 Configuración de Twilio WhatsApp — Vitrina App

Guía completa para configurar las notificaciones WhatsApp automáticas.

---

## 🎯 Notificaciones Implementadas

### 1. **Nuevo Pedido → Dueño del Restaurante**
Cuando un cliente confirma un pedido, el dueño recibe en WhatsApp:
```
🆕 Nuevo pedido | Mesa 5
• Bife de chorizo x2
• Ensalada mixta x1
💰 Total: ARS 15,400
```

### 2. **Pedido Listo → Cliente**
Cuando la cocina marca el pedido como listo, el cliente recibe:
```
✅ ¡Tu pedido está listo!

Mesa 5
• Bife de chorizo x2
• Ensalada mixta x1

🍽️ Podés pasar a retirarlo.

Gracias por elegir El Parrillón!
```

### 3. **Créditos Tano Bajos → Dueño del Restaurante**
Cuando quedan 15 mensajes de Tano en plan Free:
```
⚠️ Tano — aviso de límite
A Tano le quedan 15 respuestas este mes en El Parrillón.
Actualizá el plan para no interrumpir el servicio: https://vitrinaapp.com.ar/panel.html
```

### 4. **Agente de Ventas → Prospectos**
Cuando el agente contacta un nuevo prospecto (automático):
```
Hola {nombre} 👋

Vi que tenés {nombre_restaurante} y quería contarte sobre Vitrina...
```

### 5. **Tipo de Cambio → Restaurantes Activos**
Cuando el dólar varía >2% o >5% (automático lunes):
```
💱 Actualización de precios

El tipo de cambio varió un 3.2% esta semana.
Tus precios en el menú se actualizaron automáticamente.
```

---

## 🚀 Configuración Paso a Paso

### Paso 1: Crear Cuenta en Twilio

1. Ir a [console.twilio.com](https://console.twilio.com)
2. **Sign up** (crear cuenta nueva)
3. Completar verificación de email y teléfono
4. **Importante:** Twilio pedirá verificar tu teléfono personal

### Paso 2: Activar WhatsApp Sandbox

**¿Qué es el Sandbox?**
Twilio tiene un sandbox gratuito para WhatsApp que te permite testear sin aprobar tu cuenta. Sirve perfecto para desarrollo y primeros clientes.

**Cómo activarlo:**

1. En Twilio Console → **Messaging** → **Try it out** → **Send a WhatsApp message**
2. Vas a ver un número de WhatsApp de Twilio (ej: `+1 415 523 8886`)
3. **Importante:** Para que funcione, cada cliente debe enviar primero un mensaje al número de Twilio con un código específico

**Ejemplo:**
- Número de Twilio: `+1 415 523 8886`
- Código único: `join <tu-codigo-sandbox>`
- El cliente envía por WhatsApp: `join happy-tiger-1234`

**Limitaciones del Sandbox:**
- ✅ Gratis ilimitado
- ✅ Perfecto para testing
- ⚠️ Cada número que quiera recibir mensajes debe "unirse" primero enviando el código
- ⚠️ No es profesional para producción (los clientes ven que viene de un número de Twilio)

### Paso 3: Obtener Credenciales

En Twilio Console → **Account** → **Account Info** (panel derecho):

**1. Account SID**
```
Ejemplo: ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
Copiá esto → necesitás configurarlo en Cloudflare como `TWILIO_ACCOUNT_SID`

**2. Auth Token**
```
Clic en "Show" para verlo
Ejemplo: 1234567890abcdef1234567890abcdef
```
Copiá esto → necesitás configurarlo en Cloudflare como `TWILIO_AUTH_TOKEN`

**3. WhatsApp Number (Sandbox)**
```
En "Messaging" → "Try WhatsApp" → aparece el número
Ejemplo: whatsapp:+14155238886
```
**Importante:** El formato debe ser `whatsapp:+14155238886` (con el prefijo `whatsapp:`)

Copiá esto → necesitás configurarlo en Cloudflare como `TWILIO_WHATSAPP_FROM`

### Paso 4: Configurar Secrets en Cloudflare Workers

```bash
cd C:\Users\sebas\vitrina-server-worker

# 1. Account SID
wrangler secret put TWILIO_ACCOUNT_SID
# Pegar: ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# 2. Auth Token
wrangler secret put TWILIO_AUTH_TOKEN
# Pegar: 1234567890abcdef1234567890abcdef

# 3. WhatsApp Number (con prefijo whatsapp:)
wrangler secret put TWILIO_WHATSAPP_FROM
# Pegar: whatsapp:+14155238886
```

**Verificar que se configuraron:**
```bash
wrangler secret list
```

Deberías ver:
```
TWILIO_ACCOUNT_SID
TWILIO_AUTH_TOKEN
TWILIO_WHATSAPP_FROM
```

---

## ✅ Testing

### Test 1: Unir tu número al Sandbox

1. Guardá el número de Twilio en tu celular: `+1 415 523 8886`
2. Enviá por WhatsApp: `join <tu-codigo>` (el código que te dio Twilio)
3. Deberías recibir: `"You are all set!"`

### Test 2: Notificación de Nuevo Pedido

1. En Supabase, agregar tu número de WhatsApp al restaurante:
```sql
UPDATE restaurants 
SET whatsapp_operativo = '+5491161234567'  -- tu número
WHERE id = '<restaurant-id>';
```

2. Hacer un pedido desde el menú (menu.html)
3. Deberías recibir WhatsApp con el detalle del pedido

### Test 3: Notificación de Pedido Listo

1. En el menú, al hacer el pedido, ingresar tu número en el campo "Tu teléfono"
2. Formato: `+5491161234567` o `11 6123 4567` (se autoformatea)
3. En cocina (cocina.html), marcar el pedido como listo
4. Deberías recibir WhatsApp: "¡Tu pedido está listo!"

### Test 4: Alerta de Créditos Tano

1. En Supabase:
```sql
UPDATE restaurants 
SET tano_month_count = 60, tano_month = '2026-05'
WHERE id = '<restaurant-id>';
```

2. Desde el menú, hacer 1 pregunta a Tano (mozo.html)
3. El contador llegará a 61 (quedan 14, no 15)
4. Hacer otra pregunta → contador llegará a 62 (quedan 13)

**Bug detectado:** La alerta se envía cuando quedan **exactamente 15**. Si saltás de 16 a 14, no se envía.

**Fix recomendado:** Cambiar en worker de `=== 15` a `<= 15 && tanoRemaining > 10`

---

## 📊 Monitoreo

### Ver logs en tiempo real:
```bash
cd C:\Users\sebas\vitrina-server-worker
wrangler tail
```

Luego hacer un test (ej: crear pedido) y vas a ver en la terminal:
```
[2026-05-07 15:30:12] POST /api/notificar-pedido
[2026-05-07 15:30:13] sendWhatsApp to +5491161234567: success, sid: SM1234...
```

### Ver mensajes enviados en Twilio Console:
1. Ir a **Monitor** → **Logs** → **Messaging**
2. Ver todos los WhatsApp enviados, entregados, fallidos
3. **Costo:** $0.005 USD por mensaje (medio centavo)

---

## 💰 Costos

### Sandbox (Gratis)
- ✅ Mensajes ilimitados
- ✅ Sin costo de setup
- ⚠️ Solo para testing

### Producción (Número Propio)

**Opción A — Número de Twilio:**
- Comprar número: $1 USD/mes
- WhatsApp Business API: $0.005 USD/mensaje (~200 mensajes = $1 USD)
- **Requiere:** Aprobación de Meta (2-4 semanas)

**Opción B — Número Propio:**
- Si ya tenés WhatsApp Business: gratis
- Conectar a Twilio vía API: mismo costo por mensaje

**Estimado para restaurante promedio:**
- 50 pedidos/día = 100 WhatsApp/día (pedido nuevo + listo)
- 100 msg/día × 30 días = 3,000 msg/mes
- 3,000 × $0.005 = **$15 USD/mes** por restaurante

---

## 🔄 De Sandbox a Producción

Cuando quieras pasar a producción (número propio):

### 1. Solicitar Número de WhatsApp Business

En Twilio Console → **Messaging** → **WhatsApp** → **Senders** → **Request to add a WhatsApp sender**

Necesitás:
- ✅ Nombre del negocio verificado
- ✅ Perfil de WhatsApp Business completo
- ✅ Descripción del uso (notificaciones a clientes)
- ⏱️ Aprobación: 2-4 semanas por Meta

### 2. Actualizar TWILIO_WHATSAPP_FROM

Una vez aprobado, actualizar el secret:
```bash
wrangler secret put TWILIO_WHATSAPP_FROM
# Pegar: whatsapp:+5491161234567  (tu número aprobado)
```

### 3. Re-deploy Worker
```bash
wrangler deploy
```

**Listo!** Los clientes ya no necesitan unirse al sandbox.

---

## 🐛 Troubleshooting

### Error: "Twilio no configurado"
**Causa:** Falta alguno de los 3 secrets.

**Solución:**
```bash
wrangler secret list
# Ver cuál falta
wrangler secret put TWILIO_ACCOUNT_SID  # o el que falte
```

### Error: "The number +5491161234567 is not a WhatsApp user"
**Causa:** El cliente no unió su número al sandbox.

**Solución:**
- Si es sandbox: el cliente debe enviar `join <codigo>` al número de Twilio
- Si es producción: verificar que el número esté activo en WhatsApp

### Error: "Authentication failed"
**Causa:** TWILIO_AUTH_TOKEN incorrecto.

**Solución:**
1. Ir a Twilio Console → Account → Settings
2. Copiar Auth Token (hacer clic en "Show")
3. Re-configurar: `wrangler secret put TWILIO_AUTH_TOKEN`

### WhatsApp llega pero con error "Failed"
**Causa:** Número de destino mal formateado.

**Solución:**
- Formato correcto: `+5491161234567` (código país + código área SIN 0 + número)
- Argentina: `+549` + área sin 0 + número
- Ejemplo: `+5491161234567` (Buenos Aires: 11 sin 0)

### Mensaje no llega al cliente
**Verificar:**
1. El cliente ingresó su teléfono en el checkout?
2. El número se guardó correctamente en orders.customer_phone?
```sql
SELECT customer_phone FROM orders WHERE id = '<order-id>';
```
3. El cliente unió su número al sandbox? (solo si es sandbox)

---

## 📝 Datos que Necesitás Configurar Manualmente

**YA CONFIGURADO en secrets (según confirmaste):**
- ✅ TWILIO_ACCOUNT_SID
- ✅ TWILIO_AUTH_TOKEN
- ✅ TWILIO_WHATSAPP_FROM

**PENDIENTE:**

### 1. Ejecutar Migración 019 en Supabase

Agregar columna `customer_phone` a tabla `orders`:

```sql
-- Copiar de: migrations/019_customer_phone.sql
ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_phone TEXT;
CREATE INDEX IF NOT EXISTS idx_orders_customer_phone ON orders(customer_phone);
COMMENT ON COLUMN orders.customer_phone IS 'Teléfono del cliente para notificaciones WhatsApp (formato: +549XXXXXXXXXX)';
```

### 2. Agregar WhatsApp del Restaurante en Supabase

Para recibir notificaciones de nuevos pedidos:

```sql
UPDATE restaurants 
SET whatsapp_operativo = '+5491161234567'  -- número del dueño/cocina
WHERE id = '<restaurant-id>';
```

**Formato:** `+54` (Argentina) + código área SIN 0 + número

**Ejemplos:**
- Buenos Aires: `+5491161234567` (11 sin 0)
- Córdoba: `+543511234567` (351 sin 0)
- Rosario: `+543411234567` (341 sin 0)

### 3. Unir Números al Sandbox (Testing)

Cada número que quiera recibir WhatsApp debe:
1. Guardar el número de Twilio: `+1 415 523 8886` (ejemplo)
2. Enviar por WhatsApp: `join <codigo-unico>`
3. Recibir confirmación: "You are all set!"

**Tu código de sandbox:**
Ver en Twilio Console → Messaging → Try WhatsApp → "To use your sandbox..."

---

## 🎯 Próximos Pasos

1. ✅ Secrets configurados (confirmado)
2. ⏳ Ejecutar migración 019 en Supabase
3. ⏳ Agregar whatsapp_operativo a restaurante de prueba
4. ⏳ Unir tu número al sandbox de Twilio
5. ⏳ Testing: hacer pedido y verificar que llega WhatsApp

**Documentación oficial:** [Twilio WhatsApp Sandbox](https://www.twilio.com/docs/whatsapp/sandbox)
