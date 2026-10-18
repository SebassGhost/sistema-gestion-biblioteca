
# Modelo lógico de la base de datos

## Sistema de Gestión de Biblioteca

- **Versión:** 0.1 — Borrador de revisión
- **Estado:** En construcción
- **Repositorio:** `sistema-gestion-biblioteca`

## 1. Propósito

Definir las entidades, atributos, claves primarias, claves foráneas, relaciones y reglas de integridad del Sistema de Gestión de Biblioteca.

Este modelo se basa en las decisiones del proyecto y en los requisitos funcionales y no funcionales aprobados. Los elementos que aún no se han confirmado se identificarán como pendientes de revisión.

## 2. Convenciones

- **PK:** clave primaria que identifica de manera única cada registro.
- **FK:** clave foránea que relaciona una entidad con otra.
- **1:N:** una instancia puede relacionarse con varias instancias de otra entidad.
- **0..1:** relación opcional con un máximo de una instancia.
- Los nombres de atributos se presentan en `snake_case`.
- Los tipos de datos definitivos se establecerán durante el diseño físico de PostgreSQL.

## 3. Entidades y atributos propuestos

## 3. Entidades y atributos

### 3.1. Usuario

- `id_usuario` (PK)
- `nombre`
- `correo`
- `contrasena_hash`
- `rol`
- `estado_cuenta`

### 3.2. Libro

- `id_libro` (PK)
- `titulo`
- `autor`
- `isbn`
- `categoria`
- `anio_publicacion`
- `cantidad_total`
- `cantidad_disponible`

### 3.3. SolicitudPrestamo

- `id_solicitud_prestamo` (PK)
- `id_usuario` (FK)
- `id_libro` (FK)
- `cantidad_solicitada`
- `fecha_solicitud`
- `estado_solicitud`

### 3.4. Prestamo

- `id_prestamo` (PK)
- `id_solicitud_prestamo` (FK, único)
- `id_usuario` (FK)
- `id_libro` (FK)
- `cantidad_prestada`
- `cantidad_devuelta`
- `fecha_prestamo`
- `fecha_vencimiento`
- `estado_prestamo`

### 3.5. Devolucion

- `id_devolucion` (PK)
- `id_prestamo` (FK)
- `id_usuario_responsable` (FK)
- `cantidad_devuelta`
- `fecha_devolucion`

### 3.6. Renovacion

- `id_renovacion` (PK)
- `id_prestamo` (FK)
- `id_usuario_solicitante` (FK)
- `fecha_solicitud`
- `estado_renovacion`
- `fecha_vencimiento_nueva`

### 3.7. ListaEspera

- `id_lista_espera` (PK)
- `id_usuario` (FK)
- `id_libro` (FK)
- `fecha_inscripcion`
- `estado_lista_espera`

### 3.8. Notificacion

- `id_notificacion` (PK)
- `id_usuario` (FK)
- `tipo_notificacion`
- `contenido`
- `fecha_creacion`
- `estado_notificacion`

### 3.9. IntentoNotificacion

- `id_intento_notificacion` (PK)
- `id_notificacion` (FK)
- `fecha_intento`
- `resultado`
- `detalle_error`

### 3.10. SolicitudCorreccion

- `id_solicitud_correccion` (PK)
- `id_prestamo` (FK)
- `id_usuario_solicitante` (FK)
- `motivo`
- `estado_solicitud`
- `fecha_creacion`
- `fecha_resolucion`
- `fecha_retiro`
- `motivo_retiro`

### 3.11. EjecucionCorreccion

- `id_ejecucion_correccion` (PK)
- `id_solicitud_correccion` (FK)
- `id_usuario_responsable` (FK)
- `fecha_ejecucion`
- `resultado`
- `detalle_error`

### 3.12. HistorialCorreccion

- `id_historial_correccion` (PK)
- `id_solicitud_correccion` (FK)
- `id_usuario_actor` (FK)
- `tipo_evento`
- `fecha_evento`
- `detalle_evento`

## 4. Relaciones principales

- Un usuario puede realizar varias solicitudes de préstamo.
- Un libro puede aparecer en varias solicitudes y préstamos.
- Una solicitud de préstamo puede generar como máximo un préstamo.
- Un préstamo puede tener varias devoluciones y renovaciones.
- Un usuario puede inscribirse en varias listas de espera.
- Una notificación puede tener varios intentos de envío.
- Un préstamo puede tener varias solicitudes de corrección.
- Una solicitud de corrección puede tener varios intentos de ejecución y eventos históricos.

## 5. Reglas de integridad

### 5.1. Inventario

1. `cantidad_total` no puede ser negativa.
2. `cantidad_disponible` debe ser mayor o igual que cero y menor o igual que `cantidad_total`.
3. Confirmar un préstamo reduce la disponibilidad por la cantidad entregada.
4. Registrar una devolución aumenta la disponibilidad por la cantidad recibida en ese evento.
5. La cantidad acumulada devuelta no puede superar la cantidad prestada.
6. No se reducirá el inventario total por debajo de los ejemplares que continúan prestados.
7. El préstamo y la actualización del inventario deben ejecutarse dentro de una transacción.
8. Las operaciones concurrentes deben impedir que se entreguen las mismas unidades disponibles a más de un lector.

### 5.2. Solicitudes y préstamos

1. Crear una solicitud no modifica el inventario.
2. Aprobar una solicitud no reserva ejemplares automáticamente.
3. La entrega física confirmada genera el préstamo y cambia la solicitud a `atendida`.
4. Una solicitud rechazada, cancelada, atendida o cerrada no puede reabrirse.
5. Una solicitud no puede generar más de un préstamo.
6. Antes de confirmar la entrega se valida la disponibilidad, el estado de la cuenta y el límite de préstamos simultáneos.

### 5.3. Renovaciones

1. En la versión 1.0 se permite como máximo una renovación aprobada por préstamo.
2. No se autoriza una renovación si el préstamo está vencido o existe una lista de espera activa para el libro.
3. Las renovaciones rechazadas se conservan en el historial.

### 5.4. Correcciones administrativas

1. Solo el administrador aprueba o rechaza solicitudes de corrección.
2. El solicitante puede retirar su propia solicitud únicamente mientras esté pendiente.
3. Cada intento de ejecución genera un registro independiente.
4. Un fallo no elimina la aprobación ni los intentos anteriores.
5. El bibliotecario o administrador puede reintentar una corrección aprobada que haya fallado.
6. Una ejecución exitosa impide ejecutar nuevamente la misma solicitud.
7. Un problema nuevo requiere una solicitud de corrección nueva.
8. El historial de eventos se conserva independientemente del registro de ejecución.

### 5.5. Usuarios y seguridad

1. El correo normalizado debe ser único.
2. Las contraseñas nunca se almacenan en texto plano.
3. Los lectores solo consultan sus propios préstamos e información privada.
4. Las operaciones protegidas deben validar el rol y los permisos en el servidor.
5. La eliminación habitual de cuentas será lógica y deberá conservar las relaciones históricas necesarias.

## 6. Decisiones pendientes de revisión

Antes de aprobar el modelo y diseñar las tablas físicas, se deberán confirmar:

- Los tipos de datos definitivos para PostgreSQL.
- La representación de uno o varios autores.
- Las restricciones definitivas para ISBN.
- Los estados completos de préstamos, devoluciones, notificaciones y correcciones.
- La política de eliminación y modificación de registros relacionados.
- Los atributos definitivos de las solicitudes de corrección y los registros históricos.
- La relación entre lista de espera y notificaciones.
- Las restricciones de unicidad y los índices necesarios.
- Los mecanismos de concurrencia y transacciones.
- La política para préstamos excepcionales que no procedan de una solicitud.

## 7. Estado del documento

Este archivo constituye una primera consolidación del modelo lógico. No representa todavía el diseño físico definitivo ni implica que la base de datos esté implementada.

El modelo se considerará listo para pasar al diseño físico cuando las entidades, las relaciones, las claves, los estados y las reglas de integridad hayan sido revisados frente a las decisiones y los requisitos del proyecto.
