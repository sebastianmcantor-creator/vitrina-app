# ✅ Testing Checklist - Vitrina App

Checklist completo para testing antes del lanzamiento con clientes reales.

---

## 🔐 Autenticación y Usuarios

### Login y Registro
- [ ] Login con Google funciona correctamente
- [ ] Redirige a `/panel.html` después del login
- [ ] Perfil del usuario se carga correctamente
- [ ] Logout funciona y limpia la sesión
- [ ] Protección de rutas: sin login no se puede acceder a panel

### Gestión de Restaurantes
- [ ] Crear restaurante por primera vez
- [ ] Selector de restaurantes funciona (si hay múltiples)
- [ ] Cambiar entre restaurantes mantiene el contexto
- [ ] Usuarios operativos pueden ser invitados
- [ ] Roles (owner/admin/staff) funcionan correctamente

---

## 🍽️ Menú Digital

### Gestión de Menú (Panel)
- [ ] Crear categoría nueva
- [ ] Editar categoría existente
- [ ] Eliminar categoría (con confirmación)
- [ ] Crear plato con todos los campos
- [ ] Subir imagen de plato
- [ ] Editar plato existente
- [ ] Ver historial de precios al editar
- [ ] Marcar plato como destacado
- [ ] Marcar plato como no disponible
- [ ] Eliminar plato
- [ ] Ordenar categorías (drag & drop si aplica)
- [ ] Filtros dietarios funcionan (vegano, vegetariano, etc.)
- [ ] Precios se muestran en ARS correctamente

### Menú Cliente (menu.html)
- [ ] Escanear QR abre el menú correctamente
- [ ] Identificación de mesa funciona
- [ ] Todas las categorías se muestran
- [ ] Scroll spy en featured funciona
- [ ] Filtros dietarios funcionan
- [ ] Cambio de idioma funciona (ES/EN/PT)
- [ ] Imágenes de platos cargan correctamente
- [ ] Platos no disponibles se muestran correctamente
- [ ] Horarios de apertura se muestran si corresponde

### Carrito y Pedidos
- [ ] Agregar plato al carrito
- [ ] Modificar cantidad en carrito
- [ ] Eliminar del carrito
- [ ] Comentarios por plato funcionan
- [ ] Comentario general funciona
- [ ] Total se calcula correctamente
- [ ] Confirmar pedido pide nombre/email
- [ ] Pedido se envía correctamente
- [ ] Confirmación por email llega (si tiene email)
- [ ] Notificación WhatsApp al operativo llega
- [ ] Múltiples pedidos en misma mesa funcionan
- [ ] Seguimiento de estado en tiempo real funciona

---

## 👨‍🍳 Cocina

### Pantalla de Cocina (cocina.html)
- [ ] Pedidos nuevos aparecen en tiempo real
- [ ] Agrupación por mesa funciona
- [ ] Filtros por estado funcionan (todos/recibido/preparando/listo)
- [ ] Cambiar estado de pedido individual
- [ ] Botón "Todo listo" por mesa funciona
- [ ] Botón deshacer individual funciona
- [ ] Tiempo transcurrido se actualiza
- [ ] Notificación al cliente cuando está listo
- [ ] Sonido/vibración al recibir nuevo pedido (opcional)

---

## 🤖 Tano (Mozo IA)

### Chat de Tano (mozo.html)
- [ ] Chat se abre correctamente
- [ ] Detección de idioma funciona
- [ ] Responde preguntas sobre el menú
- [ ] Conoce platos destacados
- [ ] Recomienda platos según filtros
- [ ] No responde fuera del menú correctamente
- [ ] Límite de mensajes (plan free) funciona
- [ ] Mensaje de límite alcanzado se muestra
- [ ] Sesión se resetea después de 4 horas
- [ ] Botón de nueva sesión funciona

### Configuración de Tano
- [ ] Cambiar tono de Tano en panel
- [ ] Cambiar mensaje de bienvenida
- [ ] Cambiar mensaje de límite
- [ ] Límite de mensajes se configura por plan
- [ ] Contador de mensajes del mes correcto

---

## 💳 Facturación y Planes

### Suscripciones
- [ ] Modal de planes muestra precios correctos en ARS
- [ ] Tipo de cambio se actualiza correctamente
- [ ] Checkout de MercadoPago se abre
- [ ] Pago se procesa correctamente
- [ ] Webhook actualiza plan en Supabase
- [ ] Período de prueba de 14 días funciona
- [ ] Upgrade de plan funciona
- [ ] Downgrade de plan funciona
- [ ] Cancelación de plan funciona
- [ ] Historial de pagos se muestra correctamente

### Validaciones de Plan
- [ ] Free: límite 45 platos se valida
- [ ] Free: límite 75 Tano/mes se valida
- [ ] Básico: platos ilimitados
- [ ] Pro: pedidos habilitados
- [ ] Full: múltiples sucursales habilitadas
- [ ] can_take_orders se valida antes de confirmar pedido

---

## 📱 Marketing y Redes

### Integraciones
- [ ] OAuth Google Business funciona
- [ ] Datos de Google Business se muestran
- [ ] OAuth Instagram funciona
- [ ] Métricas de Instagram se muestran
- [ ] Búsqueda de competidores funciona
- [ ] Actualización de métricas de competidores funciona

### Viti (Asistente Marketing)
- [ ] Chat de Viti se abre
- [ ] Contexto completo disponible (menú, stats, etc.)
- [ ] Responde consultas de marketing
- [ ] Análisis de competencia funciona

### Calendario de Contenido
- [ ] Crear post programado
- [ ] Filtros por estado funcionan
- [ ] Estados se actualizan correctamente
- [ ] Cancelar post funciona
- [ ] Templates se guardan correctamente
- [ ] Templates se reutilizan correctamente

---

## 🤖 Agente de Ventas

### Prospección
- [ ] Búsqueda manual de restaurantes funciona
- [ ] Diagnóstico automático se genera
- [ ] Fit score se calcula correctamente
- [ ] Prospectos se guardan en BD
- [ ] Filtros de prospectos funcionan

### Contacto y Seguimiento
- [ ] Envío de WhatsApp inicial funciona
- [ ] Templates se personalizan correctamente
- [ ] Seguimiento a 3 días se programa
- [ ] Estado de prospecto se actualiza
- [ ] Marcar como interesado/convertido funciona

### Configuración
- [ ] Toggle on/off del agente funciona
- [ ] Límite diario de contactos se respeta
- [ ] Templates se guardan correctamente
- [ ] Métricas se muestran correctamente

---

## 🎯 Panel Maestro (Solo Sebastián)

### Acceso
- [ ] Solo sebastianmcantor@gmail.com puede acceder
- [ ] Otros usuarios son redirigidos

### Vista General
- [ ] Métricas principales se muestran
- [ ] Distribución por plan correcta
- [ ] Alertas de churn funcionan
- [ ] Cache de 1 hora funciona
- [ ] Botón actualizar fuerza recalculo

### Otras Pestañas
- [ ] Clientes: lista completa, filtros
- [ ] Facturación: métricas correctas
- [ ] Productores: comisiones correctas, marcar pagado funciona
- [ ] Agentes IA: métricas de uso y costos
- [ ] Costos: desglose correcto

---

## 📊 Informes Ejecutivos

### Proyecciones
- [ ] Crear proyección del mes funciona
- [ ] 3 escenarios se guardan correctamente
- [ ] Estrategia y acciones se registran

### Snapshots
- [ ] Snapshot inicio de mes se crea
- [ ] Snapshot fin de mes se crea
- [ ] Métricas capturadas son correctas

### Generación de Informes
- [ ] Informe se genera con Viti
- [ ] Comparación vs proyección correcta
- [ ] Escenario alcanzado se determina bien
- [ ] Análisis de Viti es coherente
- [ ] Recomendaciones son accionables

---

## 💱 Tipo de Cambio

### Actualización
- [ ] Endpoint manual `/api/exchange-rate/update` funciona
- [ ] Tipo de cambio se obtiene de bluelytics
- [ ] Se guarda en BD correctamente
- [ ] Variación porcentual se calcula bien

### Notificaciones
- [ ] Variación >2%: notifica con 7 días
- [ ] Variación >5%: notifica con 15 días
- [ ] WhatsApp se envía a restaurantes activos
- [ ] Registro de notificación se crea

---

## 🎨 UI/UX

### Responsividad
- [ ] Landing funciona en mobile
- [ ] Panel funciona en mobile
- [ ] Menú funciona en mobile
- [ ] Cocina funciona en tablet
- [ ] Todas las animaciones son suaves
- [ ] No hay scroll horizontal no deseado

### Performance
- [ ] Landing carga rápido
- [ ] Panel carga rápido
- [ ] Menú carga rápido
- [ ] Imágenes optimizadas
- [ ] No hay memory leaks en sesiones largas

### Accesibilidad
- [ ] Colores tienen suficiente contraste
- [ ] Textos son legibles
- [ ] Botones tienen tamaño adecuado para touch

---

## 🐛 Edge Cases y Errores

### Manejo de Errores
- [ ] Error de red se maneja gracefully
- [ ] Timeouts se manejan correctamente
- [ ] 404 muestra mensaje apropiado
- [ ] 500 muestra mensaje apropiado
- [ ] Validaciones de formulario funcionan

### Edge Cases
- [ ] Mesa sin pedidos
- [ ] Restaurante sin platos
- [ ] Cliente sin email
- [ ] Plan agotado (Tano límite)
- [ ] Internet lento/intermitente
- [ ] Múltiples tabs abiertas

---

## 🔄 Integraciones Externas

### APIs
- [ ] Anthropic API funciona (Tano, Viti)
- [ ] Google Places API funciona
- [ ] Instagram API funciona
- [ ] MercadoPago API funciona
- [ ] Twilio WhatsApp funciona
- [ ] Resend email funciona
- [ ] Replicate funciona (opcional)
- [ ] Bluelytics funciona (tipo de cambio)

### Webhooks
- [ ] MercadoPago webhook recibe notificaciones
- [ ] Webhook actualiza suscripciones correctamente
- [ ] Webhook maneja errores y retries

---

## 📝 Logging y Monitoreo

### Logs
- [ ] Errores se loggean en Cloudflare Workers
- [ ] Supabase logs son accesibles
- [ ] Información sensible NO se loggea

### Métricas
- [ ] Uso de Anthropic se trackea
- [ ] Uso de APIs se trackea
- [ ] Costos estimados son correctos

---

## ✅ Resultado Final

**Total items:** ~170+

**Pasaron:** _____ / _____

**Bugs críticos encontrados:** _____

**Bugs menores encontrados:** _____

**Fecha de testing:** ___________

**Testeado por:** ___________

---

## 🚀 Ready for Launch

Antes de lanzar con clientes reales, todos los items críticos deben pasar:
- ✅ Autenticación
- ✅ Menú + Pedidos + Cocina
- ✅ Tano
- ✅ Facturación
- ✅ Integraciones core

Items nice-to-have pueden tener bugs menores pero deben estar documentados.
