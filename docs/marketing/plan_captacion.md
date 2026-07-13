# Plan de Captación de Clientes — Vitrina

**Decisiones tomadas (13/07/2026):**
- Oferta de fundador: **3 meses gratis a cambio de testimonio**.
- Publicidad paga: **sí, US$5-10/día de prueba** (acelerador principal, porque no hay contactos tibios).
- Contactos tibios: **ninguno** → todo en frío.

---

## El diagnóstico en una línea
El producto está listo. Lo que falta es la **máquina de conseguir clientes**. Tres huecos, en orden:

1. **No hay prueba social** (arranque en frío) → lo rompe el **Programa Fundadores**.
2. **Outreach de bajo volumen y frágil** → lo rompen **volumen + seguimiento + ads**.
3. **Fugas de conversión** (perfil nuevo, cierre lento) → lo rompen **glow-up de perfil + onboarding en 3 pasos**.

## La matemática del embudo (para tener expectativas reales)
En frío, la conversión ronda **1-3%** con seguimiento. Para **3 clientes** hay que **hablar con ~150-300 prospectos bien apuntados**, tocando 2-3 veces cada uno. Por eso: volumen constante + seguimiento + ads que traigan consultas "más tibias".

```
Prospectos contactados (150-300)
      → responden (~15-30, o sea 10%)
          → ven la demo (~10-20)
              → activan trial (~5-10)
                  → pagan al mes 4 (~3-5)   ← primeros clientes pagos
```

---

## 🏆 Programa Fundadores (el desbloqueo #1)

**Qué es:** los **primeros 10 restaurantes** entran **3 meses gratis, sin tarjeta**. A cambio:
1. Un **testimonio corto** (texto o video de 20 seg) al final del mes 1.
2. Permiso para **mostrar el caso** (nombre del local + captura del menú funcionando) en redes y web.

**Por qué:** un solo local real usándolo vale más que 200 DMs. Genera el Reel "así lo usa un local", los logos de "ya confían en Vitrina", y la prueba que hoy falta para que el frío convierta.

**Cómo se implementa (operativo, sin código nuevo):** cuando un fundador se da de alta, le **extendemos el trial a 90 días** en Supabase (o lo dejamos `subscription_status=active` sin cobro), igual que hicimos con las 5 demos. Al mes 3 se les ofrece seguir a US$27.

**Gancho para el cierre / ads:**
> 🚀 Sos de los primeros: **Programa Fundadores** — 3 meses gratis, sin tarjeta. Solo te pido un testimonio si te gusta. Cupos limitados a los primeros 10 locales.

---

## 🔁 Programa de Referidos (para después del primer cliente)
Cada restaurante conoce a otros dueños. Cuando tengas 2-3 clientes:
> Traé otro local que se sume y **los dos ganan un mes gratis**.
Convierte 1 cliente en una cadena. No lo lanzamos aún — se activa cuando haya con quién.

---

## 📅 La cadencia semanal (la rutina que trae clientes)
Constancia > ráfagas. Objetivo por día hábil:

| Canal | Meta diaria | Quién | Notas |
|---|---|---|---|
| **WhatsApp** (frío, desde tu celu) | 8-12 | Vos | Mejor canal en frío: alta entrega, cero riesgo de baneo de marca. |
| **Instagram DM** | 5-10 | Claude (cuando Chrome coopere) | Cuenta chica: ir de a poco. Sube a medida que crezca. |
| **Ads** | corren solas | Claude arma / vos lanzás | Traen consultas entrantes (las más tibias). |
| **Seguimiento** | a los 2-3 días sin respuesta | Vos + Claude | Acá se cierra la mayoría. No saltearlo. |

**Regla de oro:** nadie se contacta una sola vez. El 2º y 3º toque cierran más que el 1º.

---

## Secuencia de prioridades (qué hacemos y en qué orden)
1. **[HECHO/EN CURSO]** Material de outreach (60 DM + 15 WhatsApp + demos vivas).
2. **[NUEVO]** Lanzar **ads** (kit listo en `ads_kit.md`) → trae consultas entrantes ya.
3. **[NUEVO]** **Glow-up del perfil** de IG (bio + destacadas + 8-9 posts) → sube conversión de todo el tráfico.
4. **[NUEVO]** **Tracker de prospección** → no perder ningún hilo + disparar seguimientos.
5. **Cerrar los primeros 3 Fundadores** → prueba social → Reel de caso real → el frío empieza a convertir.
6. **Referidos** cuando haya clientes.

## Guion de cierre en 3 pasos (cuando alguien dice "me interesa")
1. **Demo:** "Te dejo la demo para que la veas andando 👉 [link del rubro]. Entrá como cliente: mirá el menú, 'pedí' algo y preguntale al asistente."
2. **Oferta fundador:** "Estás entre los primeros: 3 meses gratis, sin tarjeta, a cambio de un testimonio si te gusta. Te lo armo yo con tu carta (mandámela en PDF o fotos)."
3. **Activación:** cargás su carta, le pasás su link + QR, trial de 90 días activo. Listo.
