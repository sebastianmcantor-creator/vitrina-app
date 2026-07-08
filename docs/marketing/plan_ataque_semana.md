# Plan de ataque — semana del 07/07/2026

**Objetivo:** contactar los 200 candidatos de `candidatos_200.csv` (202 filas: 89 prioridad A, 101 B, 12 C) durante la semana, con publicaciones diarias en @vitrinaapp.ar como respaldo de credibilidad.

## Estado
- ✅ Lista de 202 candidatos: `docs/marketing/candidatos_200.csv`
- ✅ Mensajes de prospección: `docs/marketing/prospeccion.md` (Mensajes 1-4 + objeciones + 5 demos navegables)
- ✅ Post 1 publicado en @vitrinaapp.ar (07/07 — post 2 "Tu carta, ahora atiende sola")
- ✅ Pipeline de publicación por navegador probado (Claude lo ejecuta; ver protocolo abajo)

## Calendario de publicaciones (quedan 9)
| Día | Posts (número = archivo en docs/marketing/posts/) |
|---|---|
| Mar 07 (hecho) | 2 · qué es |
| Mié 08 | 6 · antes/después + 1 · problema |
| Jue 09 | 3 · cobros + 8 · precio |
| Vie 10 | 5 · Tano + 10 · CTA |
| Lun 13 | 4 · cocina |
| Mar 14 | 7 · idiomas |
| Mié 15 | 9 · fotos IA |

Captions: en `posts_lanzamiento_ig.md` + hashtags del encabezado (rotar 8-12).

## DMs de prospección (empezar jueves 09, con 4-5 posts ya visibles en el perfil)
**Regla anti-baneo: máx 30-40 DMs/día desde @vitrinaapp.ar, espaciados (no ráfagas), personalizados con el nombre del resto. NUNCA el mismo texto exacto dos veces seguidas.**

| Día | Lote | Fuente |
|---|---|---|
| Jue 09 | 20 DMs — prioridad A (Palermo) | Mensaje 1 personalizado |
| Vie 10 | 30 DMs — resto de A | Mensaje 1 + demo del rubro a los que respondan |
| Lun 13 | 40 DMs — B con IG (buscar handle en IG antes) | Mensaje 1 |
| Mar 14 | 40 DMs — B restantes | Mensaje 1 |
| Mié 15 | 40 DMs — B/C + seguimientos de jue/vie (Mensaje 4) | Mensajes 1 y 4 |
| Jue 16 | resto + seguimientos | Mensajes 1 y 4 |

**Tracking:** agregar columnas `estado` (sin contactar/enviado/respondió/demo/cerrado) y `fecha_contacto` al CSV a medida que se envía.

**Meta realista semana:** ~200 contactados → 15-25 respuestas → 6-10 demos → 2-4 trials.

## Protocolo de publicación (para Claude, cada día)
1. Instagram (sesión de Sebastián) → perfil @vitrinaapp.ar → Crear → Publicación.
2. Enfocar botón "Seleccionar de la computadora" por JS.
3. Correr `scratchpad/filedialog3.ps1 -FilePath <png>` (activa pestaña vía Ctrl+Shift+A, ENTER confiable, tipea ruta en diálogo #32770).
4. Siguiente → Siguiente → caption de `posts_lanzamiento_ig.md` (+hashtags) → Compartir.
5. NO apretar Escape en el composer (abre "¿Descartar publicación?").

## Bloqueado / pendiente externo
- Publicación vía API Meta: bloqueada hasta que App Review apruebe `instagram_content_publish` (solicitado 22/05). El intento devuelve "Instagram: API access blocked". Cuando aprueben, se puede programar todo vía worker (`/api/social/schedule-post` + cron 15 min).
- DMs: siempre manual-supervisado vía sesión de Sebastián. No automatizar en masa (riesgo de baneo de la cuenta).
