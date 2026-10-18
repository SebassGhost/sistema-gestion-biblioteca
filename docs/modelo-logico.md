
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

### 3.1. Usuario

Representa a lectores, bibliotecarios y administradores.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_usuario` | PK | Identificador único. |
| `nombre` | — | Nombre de la persona. |
| `correo` | UNIQUE | Correo normalizado y único. |
| `contrasena_hash` | — | Hash seguro de la contraseña. |
| `rol` | — | Lector, bibliotecario o administrador. |
| `estado_cuenta` | — | Activa, inactiva o eliminada. |
| `correo_verificado` | — | Indica si se verificó el correo. |
| `ultima_conexion` | — | Fecha y hora del último acceso exitoso. |

### 3.2. Libro

Representa un título bibliográfico en una edición determinada. El inventario se administra por cantidad, sin identificar cada ejemplar físico.

| Atributo | Clave | Descripción |

|---|---|--- |
| `id_libro` | PK | Identificador del libro. |
| `titulo` | — | Título de la obra. |
| `autor` | — | Autor o autores; representación pendiente de definir. |
| `isbn` | — | ISBN opcional almacenado como texto. |
| `editorial` | — | Editorial, opcional. |
| `anio_publicacion` | — | Año de publicación, opcional. |
| `categoria` | — | Categoría del libro, opcional. |
| `descripcion` | — | Descripción, opcional. |
| `cantidad_total` | — | Total de ejemplares registrados. |
| `cantidad_disponible` | — | Ejemplares disponibles para préstamo. |

### 3.3. SolicitudPrestamo

Registra la petición de un lector para obtener ejemplares de un libro.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_solicitud_prestamo` | PK | Identificador de la solicitud. |
| `id_usuario` | FK → Usuario | Lector que realiza la solicitud. |
| `id_libro` | FK → Libro | Libro solicitado. |
| `cantidad_solicitada` | — | Cantidad de ejemplares solicitados. |
| `fecha_solicitud` | — | Fecha y hora de creación. |
| `estado_solicitud` | — | Pendiente, aprobada, rechazada, cancelada, atendida o cerrada. |
| `motivo_rechazo` | — | Motivo del rechazo, cuando corresponda. |
| `fecha_cancelacion` | — | Fecha de cancelación, si corresponde. |
| `fecha_cierre` | — | Fecha de cierre administrativo, si corresponde. |
| `motivo_cierre` | — | Motivo del cierre, si corresponde. |
| `id_responsable_cierre` | FK → Usuario | Personal que cerró la solicitud, si corresponde. |

### 3.4. Prestamo

Registra la entrega física confirmada de ejemplares al lector.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_prestamo` | PK | Identificador del préstamo. |
| `id_solicitud_prestamo` | FK → SolicitudPrestamo, UNIQUE | Solicitud que originó el préstamo. |
| `id_usuario_lector` | FK → Usuario | Lector responsable. |
| `id_libro` | FK → Libro | Libro entregado. |
| `id_responsable_entrega` | FK → Usuario | Bibliotecario o administrador que confirma la entrega. |
| `cantidad_prestada` | — | Ejemplares entregados. |
| `cantidad_devuelta` | — | Total acumulado de ejemplares devueltos. |
| `fecha_prestamo` | — | Fecha y hora de entrega. |
| `fecha_vencimiento` | — | Fecha límite de devolución. |
| `estado_prestamo` | — | Estado del préstamo. |

La restricción `UNIQUE` propuesta en `id_solicitud_prestamo` impide que una misma solicitud genere varios préstamos. Se deberá revisar cómo se representan las entregas excepcionales que no provengan de una solicitud.

### 3.5. Devolucion

Registra cada evento de devolución, permitiendo devoluciones parciales.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_devolucion` | PK | Identificador de la devolución. |
| `id_prestamo` | FK → Prestamo | Préstamo al que corresponde. |
| `id_responsable_devolucion` | FK → Usuario | Usuario del personal que registra la devolución. |
| `cantidad_devuelta` | — | Ejemplares recibidos en este evento. |
| `fecha_devolucion` | — | Fecha y hora del registro. |

### 3.6. Renovacion

Registra las solicitudes de ampliación del plazo de un préstamo.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_renovacion` | PK | Identificador de la renovación. |
| `id_prestamo` | FK → Prestamo | Préstamo que se desea renovar. |
| `id_usuario_solicitante` | FK → Usuario | Lector que solicita la renovación. |
| `fecha_solicitud` | — | Fecha de la solicitud. |
| `estado_renovacion` | — | Pendiente, aprobada o rechazada. |
| `fecha_vencimiento_anterior` | — | Vencimiento antes de la decisión. |
| `fecha_vencimiento_nueva` | — | Nuevo vencimiento si se aprueba. |
| `id_usuario_responsable` | FK → Usuario | Personal que decide la solicitud, si corresponde. |
| `fecha_resolucion` | — | Fecha de aprobación o rechazo. |

### 3.7. ListaEspera

Registra la inscripción voluntaria de lectores que esperan por un libro.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_lista_espera` | PK | Identificador de la inscripción. |
| `id_usuario` | FK → Usuario | Lector inscrito. |
| `id_libro` | FK → Libro | Libro esperado. |
| `fecha_inscripcion` | — | Fecha y hora de ingreso. |
| `estado_lista_espera` | — | Estado de la inscripción. |
| `fecha_notificacion` | — | Fecha de notificación aceptada, si corresponde. |
| `fecha_limite_recogida` | — | Fecha límite para recoger el ejemplar, si corresponde. |

Solo se permitirá una inscripción activa por lector y libro. La regla exacta para liberar el turno y avanzar al siguiente lector se detallará en la implementación.

### 3.8. Notificacion

Registra los mensajes que el sistema debe enviar a los usuarios.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_notificacion` | PK | Identificador de la notificación. |
| `id_usuario_destinatario` | FK → Usuario | Usuario al que se dirige. |
| `tipo_notificacion` | — | Tipo de evento que genera el mensaje. |
| `contenido` | — | Contenido o referencia al mensaje. |
| `fecha_creacion` | — | Fecha y hora de creación. |
| `estado_notificacion` | — | Estado del proceso de envío. |

### 3.9. IntentoNotificacion

Conserva los intentos de envío y sus resultados.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_intento_notificacion` | PK | Identificador del intento. |
| `id_notificacion` | FK → Notificacion | Notificación enviada o pendiente de envío. |
| `fecha_intento` | — | Fecha y hora del intento. |
| `resultado` | — | Resultado del envío. |
| `detalle_error` | — | Información del error, si ocurrió. |

### 3.10. SolicitudCorreccion

Registra la petición para corregir información de un préstamo.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_solicitud_correccion` | PK | Identificador de la solicitud. |
| `id_prestamo` | FK → Prestamo | Préstamo cuya información se solicita corregir. |
| `id_usuario_solicitante` | FK → Usuario | Usuario que presenta la solicitud. |
| `motivo` | — | Justificación de la corrección. |
| `estado_solicitud` | — | Estado de la solicitud. |
| `fecha_creacion` | — | Fecha de presentación. |
| `id_administrador_responsable` | FK → Usuario | Administrador que revisa la solicitud, si corresponde. |
| `fecha_resolucion` | — | Fecha de aprobación o rechazo, si corresponde. |
| `motivo_resolucion` | — | Justificación de la decisión, si corresponde. |
| `fecha_retiro` | — | Fecha de retiro por el solicitante, si corresponde. |
| `motivo_retiro` | — | Motivo del retiro, si corresponde. |

El solicitante solo podrá retirar su propia solicitud mientras permanezca pendiente. La aprobación o el rechazo corresponden al administrador.

### 3.11. EjecucionCorreccion

Registra cada intento de ejecutar una corrección aprobada. Los intentos anteriores se conservan aunque una ejecución falle.

| Atributo | Clave | Descripción |

|---|---|---|
| `id_ejecucion_correccion` | PK | Identificador del intento. |
| `id_solicitud_correccion` | FK → SolicitudCorreccion | Solicitud aprobada que se ejecuta. |
| `id_usuario_responsable` | FK → Usuario | Bibliotecario o administrador que realiza el intento. |
| `fecha_ejecucion` | — | Fecha y hora del intento. |
| `resultado` | — | Resultado de la ejecución. |
| `detalle_error` | — | Detalle del fallo, si ocurrió. |

Solo se ejecutarán correcciones aprobadas. Si un intento falla, el personal autorizado podrá reintentarlo. Después de una ejecución exitosa, la misma solicitud no podrá ejecutarse otra vez.

### 3.12. HistorialCorreccion

Conserva la secuencia de eventos de una solicitud de corrección, independientemente de sus intentos de ejecución.

| Atributo | Clave | Descripción |

|---|---|--- |
| `id_historial_correccion` | PK | Identificador del evento histórico. |
| `id_solicitud_correccion` | FK → SolicitudCorreccion | Solicitud a la que pertenece el evento. |
| `id_usuario_actor` | FK → Usuario | Usuario que realizó la acción, cuando corresponda. |
| `tipo_evento` | — | Creación, aprobación, rechazo, retiro, ejecución u otro evento. |
| `fecha_evento` | — | Fecha y hora del evento. |
| `detalle_evento` | — | Descripción de la acción. |

Los registros del historial deben conservarse para mantener la trazabilidad de las decisiones y los cambios.

## 4. Relaciones y cardinalidades

| Entidad principal | Entidad relacionada | Cardinalidad |

|---|---|--- |
| Usuario | SolicitudPrestamo | 1:N |
| Libro | SolicitudPrestamo | 1:N |
| SolicitudPrestamo | Prestamo | 1:0..1 |
| Usuario | Prestamo como lector | 1:N |
| Usuario | Prestamo como responsable de entrega | 1:N |
| Libro | Prestamo | 1:N |
| Prestamo | Devolucion | 1:N |
| Prestamo | Renovacion | 1:N |
| Usuario | Renovacion como solicitante | 1:N |
| Usuario | ListaEspera | 1:N |
| Libro | ListaEspera | 1:N |
| Usuario | Notificacion | 1:N |
| Notificacion | IntentoNotificacion | 1:N |
| Prestamo | SolicitudCorreccion | 1:N |
| Usuario | SolicitudCorreccion como solicitante | 1:N |
| SolicitudCorreccion | EjecucionCorreccion | 1:N |
| SolicitudCorreccion | HistorialCorreccion | 1:N |
| Usuario | EjecucionCorreccion como responsable | 1:N |
| Usuario | HistorialCorreccion como actor | 1:N |

Las relaciones con `Usuario` dependen del papel desempeñado. Por ejemplo, una persona puede ser responsable de registrar una devolución o de revisar una solicitud administrativa, según sus permisos.

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
