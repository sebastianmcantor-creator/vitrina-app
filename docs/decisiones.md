# Vitrina — Decisiones de negocio y producto ya tomadas

**Última actualización: 2026-06-01**

---

## Modelo WhatsApp: Twilio BSP, número por cliente, precio incluido en plan

### La decisión
Vitrina opera WhatsApp Business vía Twilio como BSP (Business Solution Provider). Cada cliente que contrata un plan pago recibe su propio número de WhatsApp Business, gestionado desde la cuenta Twilio de Vitrina. No hay planes "+WA" separados: está incluido en el precio.

### Por qué Twilio y no Meta directo
Twilio tiene sus propios permisos Meta aprobados. Vitrina puede operar desde el día 1 sin esperar la aprobación del App Review de Meta WA. Cuando Meta WA quede aprobado para Vitrina, se evaluará migrar si conviene económicamente.

### Lo que el cliente del negocio NO necesita hacer
- Comprar chip nuevo
- Crear cuenta Meta Business Manager
- Cargar nada en developers.facebook.com
- Verificar su identidad con Meta
- Tener WhatsApp instalado en un celular

### Costos reales para Vitrina por número/cliente/mes

| Concepto | USD |
|----------|-----|
| Línea Twilio | $1.00 |
| 150 utility × $0.0124 | $1.86 |
| Twilio fee mensajes (~300 in+out) | $1.50 |
| 50 marketing × $0.0625 | $3.13 |
| Twilio fee marketing | $0.25 |
| **Total con marketing (planes Marketing/Combo/Comercio)** | **$7.74** |
| **Total solo operativo (Solo Menú)** | **$4.36** |

---

## Precios definitivos y por qué esos números

### Restaurantes / Gastronomía

| Plan | USD/mes | Razonamiento |
|------|---------|-------------|
| Free | $0 | Tracción, conversión a pago |
| Solo Menú | $27 | Costo ~$7.94, margen $19 (71%). Compite contra menú QR básico ($15-25) con mucho más valor. |
| Marketing | $57 | Costo ~$26.10, margen $31 (54%). Incluye todo lo que una agencia cobra $150-400. |
| Combo | $70 | Solo Menú + Marketing. Ahorra $14 vs separado. Costo ~$26.62, margen $43 (62%). |

### Comercios / Locales / Servicios / Vendedores Online

| Plan | USD/mes | Razonamiento |
|------|---------|-------------|
| Free | $0 | Tracción |
| Marketing | $62 | Idéntico en costos a Marketing restaurante, $5 más porque incluye ML + TN sync. |

**Nota:** precios en USD cobrados en ARS al TC oficial Banco Nación (venta). Actualización automática lunes 10am ART. Fallback 1.418 ARS/USD si la API cae.

---

## Sin fee sobre ventas ni sobre presupuesto publicitario

**Decisión firme.**

Vitrina cobra precio fijo mensual. No hay:
- Porcentaje sobre ventas del menú/catálogo/ML/TN
- Porcentaje sobre presupuesto publicitario gestionado por Viti
- Comisión sobre pedidos

Razón: es más simple de vender, más predecible para el cliente y más escalable para Vitrina. El modelo de fee variable incentiva el cliente a no escalar.

---

## Metricool dormido hasta primer cliente Marketing

Metricool NO está activo. La publicación auto a IG/FB se hace directo vía API Meta desde el worker. Los endpoints (`/api/metricool/*`) y secrets se mantienen para reactivarlo en cuanto se contrate.

**Cuándo activar:** con el primer cliente Marketing pago. Plan Starter 15 marcas (€43/mes ≈ $46 USD).

**Por qué no se activó antes:** activar Metricool sin clientes que lo usen es costo fijo innecesario. La API Meta directa resuelve las publicaciones básicas mientras tanto.

---

## Sin couriers directos

Vitrina NO integra Andreani, OCA ni Correo Argentino. Razones:
- 2-3 meses de desarrollo + soporte continuo
- Convenios individuales por vendedor (cada PyME tiene condiciones distintas)
- Tarifas que cambian constantemente
- Mantenimiento permanente

**Solución:** redirigir a Tienda Nube (que ya tiene integración nativa) o al comercio para que coordine por su cuenta.

---

## 5 aprobaciones para modo automático

Para cualquier modo automático (respuestas ML, publicaciones, stock sync, respuestas redes, respuestas Google), se requieren 5 aprobaciones consecutivas del dueño.

**Por qué:** construye confianza gradualmente. El dueño entiende lo que Viti hace antes de darle autonomía. Si en algún momento Viti "se equivoca", el dueño rechaza y el contador vuelve a 0.

---

## Modelo de prospección

### Zona inicial
GBA Oeste/Sur + Córdoba + Rosario. Estas zonas tienen alta densidad de PyMEs con bajo nivel de presencia digital, son competitivas en precio y tienen menos cobertura de agencias digitales que CABA.

### Horarios de envío
- Restaurantes: 12-22 ART (cuando están operativos o con tiempo entre servicios)
- Locales/Comercios: 10-17 ART (horario comercial)
- Cron Cloudflare lo gestiona automáticamente

### Filtros de búsqueda de prospects
- Solo negocios OPERATIONAL en Google Places
- Rating mínimo configurable
- Reseñas mínimas (50+) — indica negocio activo
- Con sitio web o IG público (indica predisposición digital)
- Sin contactar antes
- Excluir ya clientes

### Efectividad esperada (200 mails/día a régimen)
- Open rate: 25-35%
- Reply rate: 2-4%
- Trial activado: 0.5-1.5%
- Trial → pago: 20-30%
- Proyección conservadora: 5-12 clientes pagos nuevos/mes
- Costo operativo del sistema: ~$12 USD/mes

---

## Modelo de firma en mails

Ningún mail al cliente final ni a prospects puede contener datos personales de Sebastián (nombre completo, CUIT, dirección). Solo aparecen en `terms.html` y `privacy.html` por exigencia legal.

**Firmas permitidas:**
- "Equipo de Vitrina" (default para comunicaciones del producto)
- "Sebastián de Vitrina" (en mails personales como seguimiento de trial)
- "Vitrina"

---

## Plan cortesía

Activación manual desde maestro.html, botón "Cortesía" en la fila del cliente que no tenga plan activo.

**Lo que activa:**
- `subscription_tier: 'rest-combo'`
- Estado: `trialing`
- +30 días desde activación
- `can_take_orders`: habilitado
- Tano: ilimitado

**Al terminar:** alerta automática a Sebastián para hacer seguimiento y convertir a plan pago.

---

## Productores/revendedores — comisiones

Sebastián carga productores desde maestro.html.

| Tipo | Comisión mes 1 | Comisión recurrente |
|------|---------------|---------------------|
| Estándar | 20% | 10% |
| Top (+10 clientes activos) | 25% | 15% |

Panel muestra comisión por productor + botón "marcar como pagado". Hay reporte descargable para el contador.

---

## Costos operativos y márgenes

### Costos fijos mensuales

| Componente | USD |
|-----------|-----|
| Cloudflare Workers | $5 |
| Dominio | $1.25 |
| Google Workspace | $6 |
| Claude Max (Sebastián) | $100 |
| Resend (gratis hasta 3.000 mails/mes) | $0 |
| **Total fijo** | **$112.25** |

### Costos variables por cliente/mes (uso típico)

| Plan | Componentes | Costo | Margen | % |
|------|-------------|-------|--------|---|
| Solo Menú $27 | $3.58 base + $4.36 WA operativo | **$7.94** | **$19.06** | 71% |
| Marketing $57 | $15.06 + $7.74 WA + $3.30 Metricool | **$26.10** | **$30.90** | 54% |
| Combo $70 | $15.58 + $7.74 + $3.30 | **$26.62** | **$43.38** | 62% |
| Comercio Marketing $62 | $15.06 + $7.74 + $3.30 | **$26.10** | **$35.90** | 58% |

*Nota: costo Metricool se aplica a partir del primer cliente Marketing. Antes de ese punto el costo es menor y el margen mayor.*

### Proyección de ganancia neta mensual

| Clientes activos | Ingresos USD | Costos var. USD | Costos fijos USD | Neto USD | Neto ARS (×1418) |
|-----------------|--------------|-----------------|------------------|----------|------------------|
| 5 | $260 | $50 | $112 | **$98** | **$138.964** |
| 10 | $520 | $100 | $112 | **$308** | **$436.744** |
| 15 | $780 | $150 | $112 | **$518** | **$734.524** |
| 20 | $1.040 | $200 | $112 | **$728** | **$1.032.304** |
| 30 | $1.560 | $300 | $112 | **$1.148** | **$1.627.864** |
| 50 | $2.600 | $500 | $112 | **$1.988** | **$2.818.984** |
