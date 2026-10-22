# Registro de decisiones del proyecto

## 1. Propósito

Este documento registra las decisiones funcionales y técnicas adoptadas durante el análisis y diseño del Sistema de Gestión de Biblioteca. Su finalidad es mantener la coherencia del proyecto, explicar el razonamiento detrás de las decisiones y dejar constancia de los aspectos pendientes.

Las decisiones podrán revisarse si aparecen nuevas necesidades o si las pruebas demuestran que es necesario modificarlas.

## 2. Estado general

- Requisitos funcionales: 11 aprobados.
- Requisitos no funcionales: 12 aprobados.
- Entidad `Libro`, versión 1.0: aprobada.
- Diseño completo del modelo de datos: en proceso.
- Arquitectura técnica y selección de tecnologías: pendientes.

## 3. Decisiones funcionales

### DF-01. Registro de lectores

Los lectores podrán registrarse por sí mismos. El sistema validará los datos y rechazará registros inválidos o duplicados según las reglas definidas.

### DF-02. Roles y permisos

El sistema distinguirá entre lectores, bibliotecarios y administradores. Las operaciones protegidas deberán validar los permisos correspondientes.

### DF-03. Gestión del inventario

El sistema gestionará el inventario por título y edición, controlando las cantidades de ejemplares sin identificar individualmente cada ejemplar físico.

El sistema tendrá dos modalidades de operación: **préstamo de libros y venta de libros**. Para ello, diferenciará los ejemplares asignados a préstamos, los asignados a ventas y los que permanezcan temporalmente sin asignación.

Se cumplirán las siguientes reglas:

1. La cantidad total registrada deberá corresponder a la suma de los ejemplares asignados a préstamos, los asignados a ventas y los que permanezcan sin asignación.
2. Un ejemplar no podrá contabilizarse simultáneamente en más de una categoría.
3. La disponibilidad para préstamos se calculará teniendo en cuenta los ejemplares asignados a préstamos y los préstamos activos.
4. La disponibilidad para ventas se calculará teniendo en cuenta los ejemplares asignados a ventas y las unidades vendidas.
5. El sistema impedirá registrar préstamos o ventas cuando no existan ejemplares disponibles para la modalidad correspondiente.
6. La recepción y reasignación de ejemplares deberá conservar la coherencia de las cantidades del inventario.

Las reglas se establecen a nivel funcional. Su implementación y validación en la base de datos se realizarán durante el desarrollo.

### DF-04. Solicitud y préstamo

La solicitud realizada por un lector será independiente del préstamo confirmado. El préstamo se registrará cuando el bibliotecario confirme la entrega física.

### DF-05. Devoluciones

El bibliotecario registrará las devoluciones. El sistema actualizará el estado del préstamo y la disponibilidad, evitando registrar dos veces la misma devolución.

### DF-06. Lista de espera

Los lectores podrán inscribirse en listas de espera para títulos sin ejemplares disponibles. Se evitarán inscripciones activas duplicadas del mismo lector para el mismo título.

### DF-07. Notificaciones

El sistema conservará registros de notificaciones y sus estados de envío para facilitar la consulta, la identificación de errores y los reintentos.

### DF-08. Historial personal

Cada lector podrá consultar sus propios préstamos activos y anteriores, sin acceder a los historiales privados de otros lectores.

### DF-09. Administración de cuentas

El administrador podrá gestionar cuentas y configurar el límite de préstamos simultáneos. No se permitirá eliminar una cuenta que tenga préstamos activos sin resolver.

## 4. Decisiones no funcionales

### DNF-01. Seguridad de contraseñas

Las contraseñas se almacenarán mediante un algoritmo seguro de hash específico para contraseñas. Nunca se guardarán en texto plano.

### DNF-02. Tiempo de inactividad

La sesión se cerrará automáticamente después de 40 minutos consecutivos de inactividad. La invalidación de la sesión deberá aplicarse también en el servidor.

### DNF-03. Protección de información

El sistema verificará los permisos en las operaciones protegidas y evitará accesos no autorizados mediante la modificación de identificadores o direcciones.

### DNF-04. Rendimiento

Objetivo propuesto: con hasta 100 usuarios concurrentes, al menos el 95 % de las consultas habituales del catálogo deberán responder en menos de 2 segundos. Este objetivo deberá validarse mediante pruebas.

### DNF-05. Disponibilidad

Objetivo propuesto: disponibilidad mensual del 99 %, excluyendo los periodos de mantenimiento programado acordados.

### DNF-06. Integridad

Las operaciones de inventario, solicitudes, préstamos y devoluciones deberán conservar la coherencia de los datos, incluso ante solicitudes simultáneas.

### DNF-07. Copias de seguridad

Se prevén copias de seguridad diarias, protegidas y separadas del sistema principal, junto con pruebas de restauración.

### DNF-08. Usabilidad y compatibilidad

La interfaz deberá ser comprensible, adaptable a escritorio, tableta y móvil, y compatible con los navegadores modernos seleccionados.

### DNF-09. Accesibilidad

Se utilizará WCAG 2.2 nivel AA como referencia de accesibilidad.

### DNF-10. Mantenibilidad

El código deberá organizarse en módulos comprensibles, con documentación y pruebas de las operaciones críticas.

### DNF-11. Fiabilidad de notificaciones

Los fallos del servicio de correo no deberán corromper los datos de préstamos o listas de espera. Se deberá poder identificar y gestionar los errores de envío.

## 5. Diseño de la entidad Libro

**Estado:** Aprobada, versión 1.0.

### 5.1. Propósito

Representar un título bibliográfico en una edición determinada y gestionar su inventario de ejemplares.

### 5.2. Atributos definidos

- `id_libro`: identificador único y obligatorio.
- `titulo`: título de la obra; obligatorio.
- `autor`: autor o autores; obligatoriedad y representación pendientes de precisar.
- `isbn`: opcional.
- `editorial`: opcional.
- `año_publicacion`: opcional.
- `categoria`: opcional.
- `descripcion`: opcional.
- `cantidad_total`: cantidad total de ejemplares.
- `cantidad_disponible`: cantidad de ejemplares disponibles.

### 5.3. Reglas acordadas

1. Cada registro tendrá un identificador único.
2. El título no será único por sí solo.
3. Dos ediciones de una misma obra podrán registrarse por separado.
4. El inventario se gestionará por título y edición, sin identificar cada ejemplar físico.
5. La cantidad disponible no podrá ser negativa ni superar la cantidad total.
6. Los cambios de inventario deberán ser coherentes con los préstamos existentes.
7. El ISBN será opcional y se almacenará como texto.

### 5.4. Aspectos pendientes

- Definir cómo se representan uno o varios autores.
- Precisar la validación del ISBN y el tratamiento de duplicados.
- Definir cómo se calculan o actualizan las cantidades disponibles.
- Establecer las reglas para modificar inventarios cuando existan préstamos activos.

## 6. Diseño de la entidad Usuario

**Estado:** Versión preliminar 1.0; pendiente de revisión final.

### 6.1. Propósito

La entidad `Usuario` representa a las personas que utilizan el sistema de gestión de biblioteca. Permite identificar a cada persona, gestionar su acceso, asignar permisos según su rol y registrar su último inicio de sesión exitoso.

Se utilizará una única entidad para lectores, bibliotecarios y administradores. Las diferencias entre estos perfiles se establecerán mediante el atributo `rol`.

### 6.2. Atributos definidos

#### `id_usuario`

- **Descripción:** identificador único del usuario.
- **Reglas:** generado automáticamente, único e inmutable. Formato propuesto: `ABC00A`.

#### `nombre`

- **Descripción:** nombre de la persona.
- **Reglas:** obligatorio, entre 2 y 50 caracteres. Admite espacios, tildes y caracteres legítimos de nombres.

#### `correo`

- **Descripción:** dirección de correo electrónico.
- **Reglas:** obligatorio, único y con formato válido. Debe verificarse antes de permitir el inicio de sesión.

#### `contrasena_hash`

- **Descripción:** hash de la contraseña del usuario.
- **Reglas:** nunca se almacena la contraseña original. Se utilizará un algoritmo especializado, como Argon2id.

#### `rol`

- **Descripción:** perfil de acceso del usuario.
- **Reglas:** valores preliminares: `lector`, `bibliotecario` y `administrador`.

#### `estado_cuenta`

- **Descripción:** indica la situación de la cuenta dentro del sistema.
- **Valores:** `activa`, `inactiva` y `eliminada`.
- **Reglas:** solo las cuentas activas podrán iniciar sesión, siempre que cumplan las demás condiciones de autenticación. Las cuentas inactivas o eliminadas no podrán acceder. La eliminación será lógica y conservará las relaciones históricas necesarias.

#### `ultima_conexion`

- **Descripción:** fecha y hora del último inicio de sesión exitoso.
- **Reglas:** puede estar vacío si el usuario nunca ha iniciado sesión. Los intentos fallidos no modifican este valor.

#### `correo_verificado`

- **Descripción:** indica si el usuario ha confirmado que tiene acceso a la dirección de correo registrada.
- **Reglas:** será un valor booleano. Comenzará en `falso` y cambiará a `verdadero` cuando el usuario complete correctamente la verificación. No se permitirá iniciar sesión mientras permanezca en `falso`.

### 6.3. Reglas del identificador

1. El sistema generará automáticamente el identificador de cada usuario.
2. El formato propuesto contiene tres letras iniciales, dos dígitos y una letra final: `ABC00A`.
3. Los números avanzarán de `00` a `99`. Al alcanzar `99`, se reiniciarán a `00` y avanzará la tercera letra inicial. Ejemplo: `ABC99A` → `ABD00A`.
4. El identificador no podrá modificarse manualmente después de su asignación.
5. La base de datos deberá garantizar que no existan identificadores duplicados, incluso cuando se produzcan registros simultáneos.
6. La secuencia completa de letras, los límites y el comportamiento al agotar las combinaciones disponibles quedan pendientes de definición.

### 6.4. Reglas del correo electrónico

1. Todo usuario deberá proporcionar una dirección de correo.
2. Una misma dirección normalizada no podrá asociarse a dos cuentas diferentes.
3. El sistema validará el formato del correo, sin asumir que dicha validación confirma su existencia.
4. La verificación se realizará mediante un mecanismo de confirmación enviado a la dirección proporcionada.
5. No se permitirá iniciar sesión mientras el correo no esté verificado.
6. Si el usuario cambia su correo, deberá verificarse la nueva dirección antes de considerarla confirmada.
7. el estado de verificacion del correo se guardara en: #### `correo_verificado`

- **Descripción:** indica si el usuario ha confirmado que tiene acceso a la dirección de correo registrada.
- **Reglas:** será un valor booleano. Comenzará en `falso` y cambiará a `verdadero` cuando el usuario complete correctamente la verificación. No se permitirá iniciar sesión mientras permanezca en `falso`.
**Pendiente:** definir cómo se almacenará y administrará el estado de verificación del correo, mediante un atributo adicional o una entidad separada.

### 6.5. Reglas de las contraseñas

1. La contraseña elegida por el usuario deberá tener al menos 12 caracteres.
2. No se exigirá una combinación artificial de mayúsculas, números y símbolos.
3. Se comprobará que la contraseña no sea común o conocida por estar comprometida.
4. El sistema almacenará únicamente el hash de la contraseña, nunca la contraseña original.
5. Se utilizará un algoritmo especializado, como Argon2id, con parámetros seguros.
6. Al cambiar la contraseña, se generará un nuevo hash y se reemplazará el anterior.
7. La recuperación del acceso deberá realizarse mediante un procedimiento seguro.

### Recuperación de contraseña

1. El usuario podrá solicitar la recuperación de su contraseña mediante un enlace enviado a su correo verificado.
2. El enlace tendrá un tiempo de validez limitado y solo podrá utilizarse una vez.
3. El sistema no enviará ni revelará la contraseña original.
4. La nueva contraseña deberá cumplir las reglas de seguridad definidas para el registro.
5. Después de restablecer la contraseña, se invalidarán las sesiones existentes del usuario.
6. La recuperación no activará cuentas inactivas ni verificará automáticamente direcciones de correo pendientes de confirmación.

7. Los mensajes de respuesta no revelarán si el correo introducido corresponde a una cuenta registrada.

### Decisión técnica pendiente

La selección definitiva del algoritmo de hash para las contraseñas y la configuración de sus parámetros se realizará cuando se definan las tecnologías del sistema. Se mantendrá el requisito de utilizar un algoritmo especializado para contraseñas, con una configuración segura y actualizada

### 6.6. Reglas de los roles

Los roles son preliminares y sus permisos exactos se definirán durante el diseño de las funcionalidades.

- **Lector:** consulta el catálogo, solicita préstamos y consulta su historial personal.
- **Bibliotecario:** confirma las entregas físicas y registra las devoluciones.
- **Administrador:** gestiona libros, cuentas de usuario y configuraciones del sistema.

El usuario no podrá asignarse privilegios superiores por sí mismo. El servidor deberá verificar los permisos antes de ejecutar operaciones protegidas.

### Matriz de permisos

Los permisos se organizarán según el rol asignado a cada usuario.

- **Lector:** podrá consultar el catálogo público, solicitar préstamos, inscribirse en listas de espera y consultar su propio historial.
- **Bibliotecario:** podrá realizar las operaciones del lector relacionadas con la consulta de información necesaria para su trabajo, confirmar entregas físicas y registrar devoluciones.
- **Administrador:** tendrá los permisos del bibliotecario y, adicionalmente, podrá gestionar libros e inventario, administrar cuentas de usuario y configurar los parámetros del sistema.

El acceso a las operaciones protegidas se validará en el servidor. Ningún usuario podrá obtener permisos superiores modificando la interfaz, una dirección URL o los datos enviados al sistema.

Los permisos no eliminarán las restricciones de privacidad: cada lector solo podrá consultar su propio historial y la información personal de otros usuarios estará protegida.

### 6.7. Reglas del estado de la cuenta

1. Una cuenta `activa` podrá acceder si cumple las demás condiciones de autenticación.
2. Una cuenta `inactiva` no podrá iniciar sesión.
3. Cuando se desactive una cuenta, las sesiones abiertas deberán invalidarse y el acceso deberá revocarse inmediatamente.
4. Desactivar una cuenta no equivale a eliminarla. La eliminación deberá respetar las reglas del sistema, especialmente cuando existan préstamos sin resolver.

### Eliminación lógica de cuentas

1. La eliminación de una cuenta será lógica: el registro no se borrará físicamente de la base de datos durante la operación habitual.
2. La cuenta eliminada no podrá iniciar sesión y sus sesiones activas deberán invalidarse.
3. Los préstamos históricos conservarán la relación con el usuario correspondiente.
4. No se permitirá eliminar una cuenta que tenga préstamos sin resolver.
5. Las operaciones administrativas de eliminación deberán registrarse para permitir su auditoría cuando corresponda.
6. La conservación o eliminación posterior de datos personales se ajustará a las obligaciones legales y a la política de retención del sistema.

### 6.8. Reglas de la última conexión

1. `ultima_conexion` registrará la fecha y hora del último inicio de sesión exitoso.
2. Podrá permanecer vacío hasta que ocurra el primer inicio de sesión exitoso.
3. Los intentos fallidos no modificarán el registro.
4. Este atributo no sustituye el mecanismo de control de inactividad de las sesiones, cuyo tiempo máximo es de 40 minutos.

### 6.9. Aspectos pendientes

- Definir la secuencia completa de generación de identificadores.
- Definir cómo se representa y administra la verificación del correo.
- Precisar los permisos de cada rol.
- Definir el procedimiento de recuperación de contraseñas y la revocación de sesiones.
- Revisar las reglas de conservación y eliminación de cuentas.

## 7. Decisiones pendientes

- Definir la política de asignación de ejemplares a los lectores en espera.
- Determinar cuánto tiempo se mantendrá una oportunidad de préstamo para un lector notificado.
- Completar el diseño de los atributos y las relaciones de las entidades restantes.
- Definir la arquitectura del sistema y seleccionar las tecnologías.
- Precisar los procedimientos de pruebas, despliegue y mantenimiento.
- Resolver los aspectos pendientes de las entidades `Libro` y `Usuario` documentados en las secciones anteriores.

### Diseño de la entidad SolicitudPrestamo

**Estado:** diseño en curso.

#### Reglas acordadas

1. Una solicitud representa la intención de un lector de obtener un libro.
2. Crear una solicitud no modifica la cantidad de ejemplares disponibles.
3. Las solicitudes se atenderán por orden de llegada, utilizando su fecha y hora de creación.
4. La aprobación de una solicitud no equivale a registrar un préstamo ni a entregar un ejemplar.
5. Antes de confirmar la entrega física, el sistema deberá comprobar nuevamente la disponibilidad y las condiciones del préstamo.
6. La disponibilidad deberá actualizarse de forma consistente para evitar que dos entregas consuman el mismo ejemplar disponible.

## Registro de cancelación

- El lector puede cancelar únicamente sus propias solicitudes que estén en estado `pendiente`.
- Al cancelar, el sistema actualizará `estado_solicitud` a `cancelada` y registrará la fecha y hora en `fecha_cancelacion`.
- La operación se atribuye al lector propietario de la solicitud, cuya identidad se verifica mediante su sesión autenticada.
- Si la solicitud no está pendiente o no pertenece al lector, el sistema rechazará la operación.
- Una solicitud cancelada no puede reabrirse ni aprobarse.

## 8. Historial de cambios

### Versión 1.0 — Diseño inicial

- Se aprobaron los requisitos funcionales y no funcionales.
- Se aprobó la primera versión de la entidad `Libro`.
- Se registraron las principales reglas de inventario, préstamos, usuarios y notificaciones.

### Versión 1.1 — Diseño preliminar de Usuario

- Se definieron los siete atributos iniciales de la entidad `Usuario`.
- Se establecieron reglas preliminares para el identificador, el nombre, el correo, las contraseñas, los roles, el estado de la cuenta y la última conexión.
- Se documentaron las decisiones pendientes para continuar el diseño.

Este documento continuará actualizándose a medida que avance el diseño del sistema.

### Versión 1.2 — Revisión funcional de Usuario

- Se revisaron los atributos y las reglas de la entidad `Usuario`.
- Se definió la verificación del correo mediante el atributo `correo_verificado`.
- Se establecieron las reglas de recuperación de contraseña, permisos por rol y eliminación lógica.
- Se dejó pendiente la selección técnica del algoritmo de hash y su configuración.

- **2026-10-17:** Cierre funcional de las fases 2 y 3 para la versión 1.0. Se documentaron las reglas de solicitudes, lista de espera, préstamos, devoluciones, renovaciones y notificaciones.

## 9. Solicitudes de préstamo

**Estado:** Aprobado funcionalmente para la versión 1.0.

## 9.1. Reglas generales

- El lector puede crear solicitudes de préstamo si su cuenta está activa.
- La creación de una solicitud no modifica la disponibilidad de los libros.
- Una solicitud aprobada no reserva automáticamente un ejemplar.
- El bibliotecario o administrador puede aprobar o rechazar solicitudes.
- Antes de aprobar una solicitud, el sistema verifica que el lector tenga una cuenta activa, no supere el límite de préstamos simultáneos y que existan ejemplares disponibles.
- Si no hay ejemplares disponibles al intentar aprobar, la solicitud se rechaza con el motivo `SIN_EJEMPLARES_DISPONIBLES` y se ofrece al lector inscribirse manualmente en la lista de espera.
- Antes de entregar un libro, el sistema vuelve a verificar la disponibilidad, el estado de la cuenta y el límite de préstamos simultáneos.

## 9.2. Estados de la solicitud

- `pendiente`: solicitud creada y aún sin resolver.
- `aprobada`: solicitud autorizada, pendiente de entrega física.
- `rechazada`: solicitud denegada.
- `cancelada`: solicitud cancelada por el lector.
- `atendida`: solicitud que generó un préstamo mediante una entrega física confirmada.
- `cerrada`: solicitud aprobada que el personal cerró sin realizar la entrega.

Los estados `rechazada`, `cancelada`, `atendida` y `cerrada` son terminales. No se permite reabrir estas solicitudes ni generar otro préstamo a partir de ellas.

## 9.3. Cancelación y cierre

- El lector solo puede cancelar sus propias solicitudes mientras estén en estado `pendiente`.
- Una solicitud cancelada registra su fecha de cancelación.
- El bibliotecario o administrador puede cerrar manualmente una solicitud aprobada cuando no se vaya a realizar la entrega.
- El cierre registra la fecha, el motivo y el responsable.
- Una solicitud cerrada no puede utilizarse para registrar una entrega posterior.
- Después de un rechazo, cancelación o cierre, el lector puede crear una nueva solicitud si cumple las condiciones.

## 9.4. Duplicados y orden de atención

- No se permiten dos solicitudes activas del mismo lector para el mismo libro. Se consideran activas las solicitudes `pendiente` y `aprobada`.
- Las solicitudes pendientes se ordenan por fecha de creación ascendente y, en caso de empate, por identificador ascendente.
- El sistema debe impedir que una misma solicitud genere más de un préstamo, incluso si ocurren operaciones simultáneas.

## 9.5. Relación con los préstamos

Cuando se confirma la entrega física:

1. El sistema crea el préstamo.
2. Guarda la relación entre la solicitud y el préstamo generado.
3. Cambia la solicitud a `atendida`.
4. Impide que esa solicitud vuelva a generar otro préstamo.

La relación debe permitir consultar el préstamo que se originó a partir de una solicitud.

## 10. Lista de espera

**Estado:** Aprobado funcionalmente para la versión 1.0.

## 10.1. Inscripción y prioridad

- La inscripción en la lista de espera es voluntaria y manual.
- No se inscribe automáticamente al lector cuando su solicitud es rechazada.
- Solo se permite una inscripción activa por lector y libro.
- Si el lector intenta inscribirse nuevamente, el sistema informa que ya está en la lista y conserva su posición original.
- El orden se determina por fecha de inscripción ascendente y, en caso de empate, por identificador ascendente.

## 10.2. Notificación y recogida

- Cuando un ejemplar queda disponible para atender una lista de espera, el sistema comienza por el primer lector de la fila.
- Se notifica únicamente al lector que ocupa el primer turno.
- El plazo para recoger el ejemplar es de tres días naturales desde que el servicio de notificación acepta correctamente el envío.
- La aceptación del envío no garantiza que el mensaje llegue a la bandeja de entrada ni que el lector lo lea.
- La notificación no crea un préstamo. El préstamo solo se registra cuando se confirma la entrega física.
- Si el lector no recoge el ejemplar dentro del plazo, el sistema continúa con el siguiente turno, de acuerdo con las reglas de asignación.

## 10.3. Errores de notificación

- El sistema registra los intentos de envío y sus resultados.
- Se realizan como máximo tres intentos automáticos, incluido el primero.
- Si los tres intentos fallan, se registra el caso para revisión del personal.
- Mientras el problema no se resuelva, el lector conserva su prioridad y el ejemplar no se ofrece al siguiente turno.
- El bibliotecario o administrador puede revisar el error, reintentar manualmente el envío y registrar la resolución.
- Los reintentos deben evitar notificaciones duplicadas y no deben iniciar el plazo de recogida mientras el envío siga fallando.

## 10.4. Disponibilidad y prioridad

- El sistema verifica el inventario antes de asignar un ejemplar a un turno.
- La prioridad de la lista no crea ejemplares ni permite entregar una copia inexistente.
- Si no hay ejemplares disponibles, el lector conserva su posición y el sistema vuelve a comprobar la disponibilidad cuando corresponda.
- Un ejemplar en proceso de asignación a un lector en espera no puede entregarse mediante otra operación simultánea.

## 11. Préstamos y devoluciones

**Estado:** Aprobado funcionalmente para la versión 1.0.

## 11.1. Creación del préstamo

- El préstamo se crea únicamente cuando el bibliotecario o administrador confirma la entrega física.
- El sistema registra el lector responsable, el libro, la fecha de entrega y la fecha límite de devolución.
- Se registra el responsable que confirma la entrega.
- Una solicitud aprobada no equivale a un préstamo.
- El sistema verifica nuevamente las condiciones de entrega antes de crear el préstamo.
- El sistema debe impedir que se registre dos veces la misma entrega.

## 11.2. Plazo de devolución

- La fecha límite se calcula utilizando un plazo configurable.
- El administrador puede configurar el plazo de préstamo y el máximo de préstamos simultáneos permitidos por lector.
- El sistema valida que el lector no supere el límite establecido.

## 11.3. Devolución

- El bibliotecario o administrador registra la devolución.
- El sistema guarda la fecha de devolución y el responsable que la registra.
- La devolución actualiza la disponibilidad del inventario una sola vez.
- Si existe una lista de espera para el libro, se inicia el proceso de asignación establecido en la sección 10.
- El sistema impide registrar dos veces la misma devolución.

## 11.4. Préstamos vencidos

- El sistema identifica los préstamos cuya fecha límite ha pasado y que todavía no tienen una devolución registrada.
- Se notifica al lector sobre los préstamos vencidos.
- En la versión 1.0 no se calculan ni aplican multas automáticas.

## 11.5. Renovaciones

- El lector puede solicitar una renovación.
- La renovación requiere autorización del bibliotecario o administrador.
- Se permite como máximo una renovación por préstamo en la versión 1.0.
- No se autoriza una renovación si el préstamo está vencido o existe una lista de espera activa para ese libro.
- Si se autoriza, el sistema actualiza la fecha límite y conserva el registro de la operación.

## 12. Notificaciones

**Estado:** Aprobado funcionalmente para la versión 1.0.

## 12.1. Eventos que generan notificaciones

El sistema contempla notificaciones al lector cuando:

- Se aproxima la fecha límite de devolución.
- Un préstamo está vencido.
- Se registra la devolución de un préstamo.
- Se requiere recoger un ejemplar asignado mediante la lista de espera.
- Una solicitud de préstamo es rechazada, indicando el motivo correspondiente.

## 12.2. Registro y errores

- El sistema registra los intentos de envío y sus resultados.
- Cuando un envío falla, se registra el error para permitir su revisión.
- El sistema diferencia entre un envío aceptado por el servicio y la confirmación de que el lector recibió o leyó el mensaje.
- Las reglas específicas de reintento para la lista de espera se establecen en la sección 10.
- El canal de envío y los detalles técnicos del proveedor se definirán durante la implementación.

## 13. Pendientes para la implementación

Los siguientes aspectos no impiden cerrar las reglas funcionales de las fases 2 y 3:

- Definir el diseño físico definitivo de las tablas, claves y restricciones.
- Definir el algoritmo concreto de almacenamiento seguro de contraseñas.
- Configurar con precisión cuánto tiempo antes del vencimiento se envía el primer aviso.
- Seleccionar el proveedor y canal de notificaciones.
- Implementar controles de concurrencia para proteger el inventario.
- Definir los detalles técnicos de auditoría, registros de errores y recuperación ante fallos.
- Verificar mediante pruebas que las transiciones de estado y las operaciones de inventario no permitan duplicados.

Estos pendientes se resolverán durante el diseño técnico, la programación y las pruebas, sin reabrir las reglas funcionales ya aprobadas salvo que se detecte una contradicción.

## 14. Cierre funcional de las fases 2 y 3

Se consideran aprobadas para la versión 1.0 las reglas funcionales de solicitudes de préstamo, lista de espera, préstamos, devoluciones, renovaciones y notificaciones.

Este cierre corresponde a las reglas funcionales. No implica que el sistema esté programado, probado o listo para producción.
