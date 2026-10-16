
# Documento de Requerimientos Funcionales

## RF-01

Registro de lectores
Descripción: El sistema permitirá que los lectores creen una cuenta mediante un formulario de registro. Una vez registrado correctamente, el lector podrá acceder a su cuenta sin esperar una aprobación manual.

Criterio de aceptación: Al completar correctamente los campos obligatorios y utilizar un correo no registrado, el sistema crea la cuenta y permite iniciar sesión. Si los datos son inválidos o el correo ya existe, informa el error sin crear una cuenta duplicada.

## RF-02

Inicio y cierre de sesión
Descripción: El sistema permitirá a los usuarios autenticarse y cerrar su sesión según su rol: lector, bibliotecario o administrador.

Criterio de aceptación: Las credenciales válidas permiten acceder a las funciones autorizadas para el rol del usuario. Las credenciales incorrectas no permiten el acceso.

## RF-03

Consulta del catálogo
Descripción: El sistema permitirá consultar los libros registrados y conocer su disponibilidad.

Criterio de aceptación: El lector puede buscar y consultar un título y visualizar si existen copias disponibles o si debe inscribirse en una lista de espera.

## RF-04

Gestión del catálogo
Descripción: El administrador podrá registrar, modificar y eliminar libros del catálogo.

Criterio de aceptación: Los cambios autorizados se guardan correctamente y se reflejan en el catálogo. Los usuarios sin permisos administrativos no pueden modificarlo. El sistema impide registrar cantidades negativas de copias

## RF-05

Solicitud de préstamos
Descripción: El lector podrá solicitar en línea un libro disponible, siempre que no haya alcanzado el límite de préstamos establecido por el administrador.

Criterio de aceptación: El sistema registra la solicitud válida para revisión del bibliotecario. Si no hay copias disponibles, ofrece la opción de inscribirse en la lista de espera. Si el lector supera el límite, no permite una nueva solicitud de préstamo.
Nota: una solicitud no equivale a un préstamo confirmado; el bibliotecario debe registrar la entrega física.

## RF-06

Lista de espera
Descripción: Cuando un libro no esté disponible, el lector podrá inscribirse en una lista de espera para ese título.

Criterio de aceptación: El sistema registra la inscripción asociada al lector y al título, conserva el orden de espera y evita que el mismo lector tenga inscripciones activas duplicadas para ese título.

## RF-07

Confirmación de entrega
Descripción: El bibliotecario podrá revisar las solicitudes y confirmar la entrega física de los libros.

Criterio de aceptación: Cuando se registre una devolución o se actualice el inventario y haya disponibilidad, el sistema genera las notificaciones correspondientes y registra su estado de envío. La notificación no debe presentarse como una reserva confirmada del libro.
La política para asignar turnos y el tiempo durante el cual se mantiene una oportunidad de préstamo se definirán posteriormente

## RF-08

Registro de devoluciones
Descripción: El bibliotecario registrará la devolución física de los libros prestados.

Criterio de aceptación: Al confirmar una entrega válida, el sistema registra el préstamo, asocia el lector con el título, actualiza las copias disponibles y establece el estado del préstamo como activo. No permite confirmar una entrega si no hay una copia disponible.

## RF-09

Consulta de préstamos personales
Descripción: Cada lector podrá consultar sus préstamos actuales y su historial.

Criterio de aceptación: Al registrar la devolución de un préstamo activo, el sistema guarda la fecha, actualiza el estado del préstamo y aumenta la cantidad de copias disponibles. No permite registrar dos veces la devolución del mismo préstamo

## RF-10

Configuración del límite de préstamos
Descripción: El administrador podrá establecer y modificar la cantidad máxima de préstamos simultáneos permitidos por lector.

Criterio de aceptación: El lector visualiza únicamente los registros vinculados a su cuenta. El sistema no permite consultar el historial privado de otro lector sin los permisos correspondientes.

## RF-11

Gestión de lectores
Descripción: El administrador podrá consultar, actualizar y eliminar cuentas de lectores, respetando las restricciones asociadas a préstamos activos y al historial.

Criterio de aceptación: Solo el administrador puede realizar estas operaciones. El límite configurado se aplica a las nuevas solicitudes. Si se reduce y un lector ya supera el nuevo límite, conserva sus préstamos activos, pero no puede solicitar nuevos hasta volver a estar dentro del límite. El sistema impide eliminar cuentas con préstamos activos pendientes de resolución.
