# Solicitud de acceso — Google Business Profile API

**Objetivo:** que Google nos habilite la API de Business Profile para gestionar reseñas y publicaciones de los clientes de Vitrina de forma automática (hoy solo podemos hacerlo a mano como administradores).

## ✅ ENVIADA — 2026-07-07
- **Caso de soporte:** `8-6242000040908` · revisión estimada **7 a 10 días hábiles**.
- Enviada desde **contacto@vitrinaapp.com.ar** (ya administrador de la ficha verificada de **Chikpi Hummus & Pita Bar** — la invitación del 29/6 estaba sin aceptar; se aceptó hoy).
- Perfil seleccionado en el formulario: **Chikpi Hummus & Pita Bar** (Verificado).
- Datos enviados: Nº proyecto Cloud **496787959423** · sitio **https://www.vitrinaapp.com.ar** · motivo = gestión de reseñas/publicaciones/info de clientes desde el panel, con acceso de admin que otorga cada restaurante.
- **Cómo chequear aprobación:** Cloud Console (proyecto 496787959423) → APIs → cuotas de las Business Profile APIs. **0 QPM = pendiente · 300 QPM = aprobado.** También llega mail al caso.
- **Al aprobar:** habilitar en Cloud Console "My Business Business Information API", "My Business Account Management API" y "Google My Business API" → probar `/api/google/reviews?restaurant_id=<chikpi>` (debería devolver reseñas en vez de `connected:false`).
- **Ojo (aparte):** Google muestra un banner "Se requiere verificación para contacto@" en la ficha de Chikpi; es re-verificación del perfil, no bloquea la solicitud de API. Verlo con Chikpi si pide acción.

## Estado real verificado (2026-07-06)
- ❌ **BLOQUEANTE — Perfil de Negocio administrado:** ninguna cuenta de Google de Vitrina administra hoy una ficha. En el Business Profile Manager, tanto `sebastianmcantor@gmail.com` como `contacto@vitrinaapp.com.ar` muestran **"0 empresas"**. Google exige que el correo que envía la solicitud sea **propietario o administrador de un Perfil verificado y activo +60 días** → hoy NO se cumple.
- ❌ **Chikpi NO está conectado en Vitrina:** `/api/google/reviews?restaurant_id=<chikpi>` devuelve `connected:false` (no hay token OAuth guardado, provider `google_business` vacío). Lo que Chikpi haya hecho la semana pasada no quedó registrado.
- ✅ **Proyecto en Google Cloud con OAuth:** "My First Project" — **número 496787959423** (ID `project-7cec6073-9540-4adc-80a`), bajo la org de **`sebastianmcantor@gmail.com`** (NO contacto@). Scope pedido: `business.manage`.
- ✅ Sitio web propio: `https://www.vitrinaapp.com.ar`.

## Qué falta para poder enviar (en orden)
1. **Chikpi agrega nuestro correo de Vitrina como Administrador de su ficha** (business.google.com → su Perfil → Configuración/Usuarios → Añadir → rol Administrador). Al aceptar, esa cuenta pasa a "administrar un Perfil verificado" y se cumple el requisito.
2. **Decidir cuál es el correo Google oficial de Vitrina.** El proyecto Cloud está en el Gmail personal; para marca conviene `contacto@`. Opciones: (a) agregar `contacto@` como propietario del proyecto 496787959423 y usarlo en todo; (b) usar el Gmail personal para la ficha + el formulario. **Lo decide Sebastián.**
3. Recién ahí: enviar el formulario (project number 496787959423) desde el correo elegido.

## Pasos (los hace Sebastián — 10 min)

1. Entrá logueado con **contacto@vitrinaapp.com.ar** a:
   **https://developers.google.com/my-business/content/prereqs** → link "request access to the API" (formulario oficial "GBP API access request").
2. Completá el formulario con las respuestas de abajo (copiar/pegar).
3. **Project ID:** está en Google Cloud Console → arriba a la izquierda, selector de proyecto → columna "ID". Pegalo donde lo pida.
4. Enviá. Google suele responder por email en **días a ~2 semanas**. Si piden más detalle, responder con la sección "Descripción larga".
5. Cuando aprueben: Cloud Console → APIs & Services → habilitar "My Business Business Information API", "My Business Account Management API" y "Google My Business API" → avisame y activo la gestión automática de reseñas.

## Respuestas para el formulario (copiar/pegar, en inglés)

**Company name:** Vitrina

**Company website:** https://www.vitrinaapp.com.ar

**Contact email:** contacto@vitrinaapp.com.ar

**Business type / What best describes your company:** Software provider (SaaS) for restaurants

**Countries of operation:** Argentina

**Do you manage Business Profiles on behalf of other businesses?** Yes — our restaurant customers grant us manager access to their Business Profiles.

**Approximate number of locations managed:** Fewer than 100 (growing SaaS, currently onboarding our first restaurant customers).

**Use case description (short):**
> Vitrina is a SaaS platform for restaurants in Argentina (digital menu with QR ordering, payments and an AI assistant). We need the Business Profile APIs to help our restaurant customers manage their Google presence from our dashboard: read and reply to customer reviews (with AI-suggested replies that the owner approves), publish posts/updates, and keep business information (hours, phone, menu link) up to date. Each restaurant explicitly grants Vitrina manager access to its profile. We do not scrape data or contact consumers; all actions are initiated by the business owner from our dashboard.

**Descripción larga (si piden más detalle):**
> Vitrina (https://www.vitrinaapp.com.ar) provides restaurants with a digital menu (QR), online ordering, payments via MercadoPago, and an AI assistant. Restaurant owners connect their Google Business Profile to Vitrina through OAuth and/or by granting our service account manager access. From the Vitrina dashboard the owner can: (1) view recent reviews and reply to them — our AI drafts a suggested reply, the owner edits/approves before it is published; (2) publish updates and offers; (3) keep core business information consistent (hours, phone, website/menu URL). API usage is low volume (a few requests per restaurant per day), strictly on behalf of the authenticated business, and compliant with Google Business Profile API policies. Requested APIs: My Business Account Management, My Business Business Information, Reviews (legacy Google My Business API v4 where applicable).

## Mientras esperamos la aprobación
No estamos bloqueados: con `contacto@vitrinaapp.com.ar` como **administrador** de la ficha de cada cliente (modal "Cómo dar acceso" del panel) podemos responder reseñas y publicar **a mano** desde business.google.com. La API solo automatiza lo que ya podemos hacer.

## Nota sobre verificación OAuth (aparte)
Si más adelante Google pide verificar la app OAuth por el scope `business.manage` (pantalla de consentimiento), va a pedir un **video demo** mostrando: login en Vitrina → conectar Google → ver reseñas → aprobar una respuesta. Ese guion está en `docs/marketing/` (lo armamos cuando llegue el pedido — no demora esta solicitud).
