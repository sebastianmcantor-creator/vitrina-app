# Vitrina — contexto para Claude Code

SaaS de menú digital y marketing para restaurantes en Argentina.  
Dominio: **vitrinaapp.com.ar** | Repo: `sebastianmcantor-creator/vitrina-app`

## Stack
- **Frontend:** vanilla HTML/CSS/JS con ES modules. Sin bundler, sin npm, sin frameworks.  
  Dependencias vía CDN (esm.sh para Supabase). Archivos self-contained (estilos y scripts inline).
- **Backend:** Cloudflare Workers
- **DB + Auth:** Supabase (PostgreSQL + Google OAuth)
- **Hosting:** GitHub Pages (CNAME: vitrinaapp.com.ar)

## Archivos principales
| Archivo | Rol |
|---|---|
| `index.html` | Landing page pública de Vitrina |
| `login.html` | Login con Google OAuth (Supabase Auth) |
| `panel.html` | Dashboard del dueño del restaurante |
| `menu.html` | Menú público para clientes (dinámico, multi-tenant) |
| `cocina.html` | Display de cocina — pedidos en tiempo real |
| `mozo.html` | Interfaz del mozo para tomar pedidos |
| `lib/supabase.js` | Cliente Supabase singleton |
| `lib/db.js` | Capa de acceso a datos (repositories) |
| `lib/auth.js` | Helpers de autenticación |
| `sql/schema.sql` | Schema completo con RLS, triggers e índices |

## Paleta de colores (design tokens)
```css
--terra: #B85A30   /* primario */
--gold:  #C8963C
--sage:  #5A7A5E
--cream: #F7F2EA   /* fondo */
--ink:   #1C1612   /* texto */
```
Fuentes: **Cormorant Garamond** (headings) · **Outfit** (body)

## Base de datos — tablas
`profiles` · `restaurants` · `restaurant_staff` · `menu_categories` · `menu_items` · `restaurant_tables` · `order_sessions` · `orders` · `order_items`

Supabase project ID: `zigtqvwerrtyuunayduh`

## Estado actual (mayo 2026)
- **Funciona:** login Google, schema DB, panel con info del restaurante, menú público y cocina conectados a Cloudflare Worker (La Panera Rosa).
- **Pendiente:** editor de menú en panel, gestión de mesas, pedidos en tiempo real vía Supabase Realtime, estadísticas, multi-tenant real (menu.html y cocina.html hardcodeados a La Panera Rosa).

## Convenciones
- No usar React, Vue ni bundlers. Todo vanilla.
- Preferir editar archivos existentes antes de crear nuevos.
- Los HTML son self-contained: estilos y scripts van inline en el mismo archivo.
- Sin comentarios innecesarios en el código.
