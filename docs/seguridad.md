# Seguridad de Vitrina — postura y controles

**Última revisión: 2026-07-02.** Este doc lista qué protege al sistema, qué se arregló y qué mantener. Actualizarlo cuando se toque auth, endpoints o RLS.

## Capas activas

| Capa | Qué protege | Estado |
|---|---|---|
| **HTTPS en todo** (GitHub Pages, Cloudflare, Supabase) | Nadie intercepta datos en tránsito | ✅ |
| **Supabase Auth + RLS** | Cada dueño solo ve/edita SUS datos (policies por `owner_id = auth.uid()`); el comensal anónimo solo puede INSERTAR pedidos, no leer los de otros | ✅ |
| **Secrets en Cloudflare** (Anthropic, Twilio, MP, Resend, service key) | Ninguna clave viaja al navegador ni está en el código público | ✅ |
| **Admin con firma verificada** | `isAdminRequest` valida el JWT contra Supabase Auth (`/auth/v1/user`) y chequea la tabla `admins` | ✅ arreglado 2026-07-02 (antes se podía forjar el token) |
| **Guard de Origin en endpoints con costo** | `/api/claude`, `/api/send-email`, `/api/notificar-pedido-listo`, `/api/replicate/enhance-image`, `/api/cf-ai/generate-image`, `/api/marketing/import-from-web` rechazan llamadas que no vengan de nuestros frontends (403) — corta scripts/curl/otros sitios que quemarían crédito | ✅ 2026-07-02 |
| **Rate limit por IP** | 30 req/min en el worker — frena fuerza bruta y spam | ✅ |
| **Firma de webhooks** | Twilio: HMAC-SHA1 (`X-Twilio-Signature`); MercadoPago: se consulta el pago real a la API de MP (no se confía en el body) | ✅ |
| **Escapado de HTML** (`escHtml`/`esc`/`escapeHtml`) | Nombres/notas de clientes no pueden inyectar código en el panel/cocina (XSS) | ✅ 2 casos corregidos 2026-07-02 (nombre de cliente en cocina y en recordatorios) |
| **Endpoints admin** (`/api/sales/*`, `/api/wa/provision|release|twilio-status|setup-sender|create-templates`) | Solo cuentas de la tabla `admins` | ✅ |

## Qué probamos (2026-07-02)
- Todos los endpoints devuelven 4xx correcto, ninguno tira 500.
- Sin `Origin` (curl): endpoints con costo → 403. Con Origin legítimo → pasan a su validación normal.
- Un JWT inventado ya no pasa el guard admin.

## Honestidad: qué NO existe (y por qué está bien por ahora)
- **"100% seguro" no existe** en ningún sistema. Lo que hay son capas: para vulnerar algo hoy hace falta comprometer una cuenta de Google del dueño, o una clave guardada en Cloudflare/Supabase — no alcanza con "probar URLs".
- El guard de Origin **no** frena a un atacante dedicado (el header se puede falsificar fuera del navegador) — para eso están el rate limit, los límites de uso por plan y que nada destructivo dependa solo del Origin.
- No hay WAF/Turnstile (captcha). Si algún día hay abuso real de pedidos falsos, el paso siguiente es Cloudflare Turnstile en el checkout del menú (sin fricción visible).

## Reglas para el futuro (mantener)
1. **Endpoint nuevo en el worker** → decidir SIEMPRE su guard: `isAdminRequest` (admin), `verifyOwnsRestaurant`/token de Supabase (dueño), `isTrustedBrowserOrigin` (público con costo) o abierto (solo lecturas inocuas).
2. **Todo dato que escribe un usuario** (nombres, notas, direcciones) se renderiza con `escHtml`/`esc`/`escapeHtml`, sin excepción.
3. **Jamás** poner claves en el HTML/JS del sitio; solo `wrangler secret put`.
4. Los diagnósticos temporales con `?key=` se **borran en la misma sesión** en que se usan.
5. La `service key` de Supabase no sale del worker.
