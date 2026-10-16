
# Documento de Requerimientos Funcionales

## RF-01

Registro de lectores
Descripción: El sistema permitirá que los lectores creen una cuenta mediante un formulario de registro. Una vez registrado correctamente, el lector podrá acceder a su cuenta sin esperar una aprobación manual.
Criterio de aceptación: Al ingresar datos válidos y únicos, el sistema crea la cuenta y permite iniciar sesión. Si los datos son inválidos o el correo ya está registrado, informa el error.

## RF-02

Inicio y cierre de sesión
Descripción: El sistema permitirá a los usuarios autenticarse y cerrar su sesión según su rol: lector, bibliotecario o administrador.
Criterio de aceptación: Las credenciales válidas permiten acceder a las funciones autorizadas para el rol correspondiente; las credenciales incorrectas no permiten el acceso.

## RF-03

Consulta del catálogo
Descripción: El sistema permitirá consultar los libros registrados y conocer su disponibilidad.
Criterio de aceptación: El lector puede consultar un libro y ver sus datos principales y si está disponible o prestado.

## RF-04

Gestión del catálogo
Descripción: El administrador podrá registrar, modificar y eliminar libros del catálogo.
Criterio de aceptación: Las operaciones autorizadas guardan los cambios correctamente. El sistema impide que usuarios sin permisos administren el catálogo.

## RF-05

Solicitud de préstamos
Descripción: El lector podrá solicitar en línea un libro disponible, siempre que no haya alcanzado el límite de préstamos establecido por el administrador.
Criterio de aceptación: El sistema registra la solicitud cuando se cumplen las condiciones. Si el libro no está disponible o se supera el límite, informa el motivo y no registra una solicitud de préstamo válida.

## RF-06

Lista de espera
Descripción: Cuando un libro no esté disponible, el lector podrá inscribirse en una lista de espera para ese título.
Criterio de aceptación: El sistema registra al lector en la lista correspondiente y evita inscripciones duplicadas del mismo lector para el mismo libro mientras su inscripción siga activa.

## RF-07

Confirmación de entrega
Descripción: El bibliotecario podrá revisar las solicitudes y confirmar la entrega física de los libros.
Criterio de aceptación: Al confirmar una entrega válida, el sistema registra el préstamo, relaciona el libro con el lector y actualiza la disponibilidad del ejemplar.

## RF-08

Registro de devoluciones
Descripción: El bibliotecario registrará la devolución física de los libros prestados.
Criterio de aceptación: Al registrar la devolución de un préstamo activo, el sistema guarda la fecha de devolución y actualiza la disponibilidad del ejemplar.

## RF-09

Consulta de préstamos personales
Descripción: Cada lector podrá consultar sus préstamos actuales y su historial.
Criterio de aceptación: El lector visualiza únicamente los préstamos asociados a su propia cuenta.

## RF-10

Configuración del límite de préstamos
Descripción: El administrador podrá establecer y modificar la cantidad máxima de préstamos simultáneos permitidos por lector.
Criterio de aceptación: El sistema guarda el límite configurado y lo aplica al evaluar nuevas solicitudes. No permite configurar un límite inválido, como un número negativo.

## RF-11

Gestión de lectores
Descripción: El administrador podrá consultar, actualizar y eliminar cuentas de lectores, respetando las restricciones asociadas a préstamos activos y al historial.
Criterio de aceptación: Solo el administrador puede realizar estas operaciones. El sistema evita eliminar una cuenta si existen préstamos activos que requieren resolución
