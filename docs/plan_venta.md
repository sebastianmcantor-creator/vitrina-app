# Vitrina — Plan de venta y contenido (lanzamiento restaurantes)

**Creado: 2026-06-12 · Estado: activo**

---

## La oferta (lo que se vende desde hoy)

**"El restaurante que atiende solo."** Menú QR con mozo IA + pedidos a cocina en
tiempo real + marketing automático. **Desde USD 27/mes, sin comisiones, 14 días
gratis sin tarjeta.** Solo restaurantes/gastronomía — los demás rubros quedan
ocultos hasta tener tracción.

Estado de los planes:
- **Solo Menú ($27)** — 100% operativo, se puede vender sin restricciones.
- **Marketing ($57) y Combo ($70)** — vendibles en **beta privada**: Google
  Business y WhatsApp funcionan para todos; Instagram/Facebook requieren
  invitación de tester de Meta (proceso de 24hs por cliente) hasta que se
  apruebe el App Review. El panel ya tiene el flujo de pedido de acceso.

---

## Canal 1 — Chikpi (HOY): primer cliente beta y caso real

Es la prioridad número 1 porque destraba todo lo demás (caso real, screencast
del App Review, contenido para redes).

Checklist:
1. [ ] Sebastián: developers.facebook.com → app Vitrina → Roles → Testers → invitar al Facebook del dueño de Chikpi
2. [ ] Chikpi: aceptar invitación (Facebook → Configuración → Apps y sitios web)
3. [ ] Chikpi: IG en modo Business vinculado a su Página de Facebook
4. [ ] Onboarding completo en Vitrina (menú cargado, QR impreso, plan cortesía desde maestro.html)
5. [ ] Conectar IG/FB desde Panel → Análisis → "Ya me habilitaron"
6. [ ] Primera publicación automática aprobada → **grabar todo para el screencast de Meta y para contenido**
7. [ ] A los 30 días: pedir testimonio con números reales → primera prueba social de la landing

## Canal 2 — CRM de prospección propio (ya construido, activarlo)

El backend ya existe (`/api/sales/*` + tablas `sales_*`, vista en maestro.html):
busca restaurantes reales en Google Places (rating, reseñas, zona), genera
diagnóstico con Claude y manda mails con seguimiento automático a 4/7/15 días.

- Arranque: **50 mails/día** (semana 1) → subir gradual a 200/día (semana 5)
- Zonas: GBA Oeste/Sur + Córdoba + Rosario (ya configurado en el agente)
- Esperable a régimen: 5-12 clientes pagos nuevos/mes (open 25-35%, reply 2-4%)
- Requisito previo: revisar los templates de mail en maestro.html → Agente de Ventas
- Firma: "Sebastián de Vitrina" (sin datos personales, regla permanente)

## Canal 3 — Instagram/Facebook orgánico (el "agente" honesto)

**Importante:** un bot que mande DMs o genere contactos automáticos en IG/FB
**viola los términos de Meta** → riesgo de baneo de la cuenta @vitrinaapp y de
la app que está esperando el App Review. Justo lo que no podemos arriesgar.

Lo que SÍ se puede automatizar (y ya tenemos):
- **Generación de la lista de prospects**: el agente de Google Places arma la
  lista de restaurantes target con su IG público (campo ya capturado).
- **Generación de los mensajes**: Viti/Claude redacta el DM personalizado por
  prospect (gancho: algo concreto de SU perfil).
- **El envío es manual**: Sebastián manda 30-50 DMs/día desde @vitrinaapp.
  A ritmo humano, desde la app oficial. Eso no es baneable y convierte mejor.

Template DM frío (ajustar por prospect):
> Hola! Vi la carta de [restaurante] y me encantó [algo concreto]. Les hice una
> demo de cómo se vería con pedidos por QR y un mozo IA que responde solo:
> [link demo]. Si te copa, te lo dejo 14 días gratis para probarlo con tus mesas.

## Canal 4 — Meta Ads (cuando haya 3-5 clientes pagando)

No antes. Primero validar el funnel orgánico; después escalar con pauta
(audiencia: dueños de restaurantes AR, lookalike de seguidores).

---

## Plan de contenido @vitrinaapp — 4 semanas

**Pilares** (rotar): ① Producto en acción ② Dolor→solución ③ Educación rápida
④ Construcción en público. **Frecuencia:** 3 Reels/semana + stories diarias.
**Todos los assets salen del producto real** (El Fogón de Marta como demo +
Chikpi cuando esté): screen recordings de menú QR, cocina en tiempo real,
foto IA generándose, Tano respondiendo.

### Semana 1 — "Existe esto"
1. **Reel** (Pilar ①): pantalla dividida — celular pidiendo en el QR / ticket
   cayendo en cocina con la campanita. Texto: "Tu cocina se entera ANTES que
   el mozo." CTA: link demo en bio.
2. **Reel** (Pilar ②): "Las apps de delivery te cobran hasta 30% por pedido.
   Esto cobra $0 de comisión. Para siempre." Mostrar el pedido llegando.
3. **Carrusel** (Pilar ③): "Qué es un mozo IA" — 5 placas con la conversación
   real de Tano (la del bife y el sin TACC).

### Semana 2 — "Mirá lo que hace"
4. **Reel** (①): cargar un plato CON foto IA en 45 segundos, cronómetro en
   pantalla. "¿Tu fotógrafo cobra cuánto?"
5. **Reel** (③): el menú cambiando de idioma ES→EN→PT en vivo. "Turistas que
   piden sin llamar al mozo."
6. **Story serie** (④): "Estamos armando el sistema de reservas por WhatsApp —
   ¿qué le pedirías?" (engagement + research gratis)

### Semana 3 — "El precio es el gancho"
7. **Reel** (②): el sello "DESDE USD 27/MES" estampándose (capturar de la
   landing). "Una agencia: $400. Una carta QR muda: $20. Todo junto y vivo: $27."
8. **Reel** (①): flujo completo en 30s: QR → pedido → cocina → "pedido listo"
   por WhatsApp.
9. **Carrusel** (③): "5 cosas que tu carta QR no hace (y debería)".

### Semana 4 — "Caso real" (con Chikpi andando)
10. **Reel**: detrás de escena en Chikpi — el QR en la mesa, la tablet en cocina.
11. **Reel**: las publicaciones automáticas de Viti saliendo en el IG de Chikpi.
12. **Carrusel**: primeros números reales de Chikpi (con permiso).

**Regla de honestidad:** nada de métricas inventadas ni testimonios falsos.
Hasta tener casos reales, el contenido muestra EL PRODUCTO, que es suficiente
porque nadie más en el mercado puede mostrar esto funcionando.

---

## Metas del primer mes

| Métrica | Meta |
|---------|------|
| Chikpi operativo end-to-end | Semana 1 |
| DMs manuales enviados | 30-50/día desde semana 1 |
| Mails CRM | 50/día desde semana 2 |
| Demos agendadas | 10 |
| Trials activados | 3-5 |
| Primer cliente PAGO | Antes del día 30 |

## Pendientes que bloquean escala (no bloquean el arranque)

- App Review de Meta (screencast con Chikpi + Business Verification Yatay 241)
- E2E de pago real con tarjeta sandbox MP antes del primer cobro
- Modelo Twilio número-por-cliente (hoy número compartido alcanza para betas)
