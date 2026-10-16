# Documento de Requerimientos no Funcionales

## RNF-01. Protección de contraseñas

Descripción: El sistema deberá almacenar las contraseñas mediante un algoritmo seguro de hash diseñado para contraseñas, como Argon2id, sin guardar contraseñas en texto plano.
Criterios de aceptación:

- Las contraseñas almacenadas no son legibles ni recuperables como texto original.
- Las contraseñas correctas permiten autenticarse.
- Las contraseñas incorrectas son rechazadas.

## RNF-02. Gestión segura de sesiones

Descripción: El sistema deberá finalizar la sesión después de 40 minutos consecutivos de inactividad.
Criterios de aceptación:

- La actividad válida reinicia el contador de inactividad.
- Al cumplirse los 40 minutos, las operaciones privadas requieren autenticación nuevamente.
- El cierre de sesión invalida la sesión en el servidor.

## RNF-03. Privacidad y control de acceso

Descripción: El sistema deberá proteger los datos personales y el historial de préstamos mediante permisos asociados al rol y a la identidad del usuario.
Criterios de aceptación:

- Un lector solo puede consultar sus propios préstamos.
- El bibliotecario y el administrador acceden únicamente a la información autorizada para sus roles.
- Modificar una dirección web o un identificador no permite consultar datos de otro usuario sin autorización

## RNF-04. Tiempo de respuesta

Descripción: El sistema deberá responder con rapidez a las operaciones habituales.

Criterio de aceptación propuesto: Bajo una carga de hasta 100 usuarios concurrentes y en un entorno de prueba definido, al menos el 95 % de las consultas habituales al catálogo deberá responder en un máximo de 2 segundos.
La cifra es un objetivo inicial, no una garantía de rendimiento. Se comprobará mediante pruebas de carga.

## RNF-05. Disponibilidad del sistema

Descripción: El sistema deberá estar disponible durante los horarios de servicio establecidos por la biblioteca, salvo mantenimientos programados.

Criterio de aceptación propuesto: Una vez desplegado en un entorno de producción, se buscará una disponibilidad mensual mínima del 99 %, excluyendo los mantenimientos previamente acordados.
Este objetivo dependerá del alojamiento, la infraestructura y los recursos disponibles para el proyecto

## RNF-06. Integridad del inventario y los préstamos

Descripción: El sistema deberá mantener la consistencia de los datos al registrar solicitudes, entregas y devoluciones, incluso si varias personas utilizan el sistema al mismo tiempo.
Criterios de aceptación:

- La cantidad de copias disponibles nunca puede ser negativa.
- Dos solicitudes simultáneas no pueden ocasionar que se preste una cantidad superior a las copias disponibles.
- Una misma devolución no puede contabilizarse dos veces.
- Las operaciones relacionadas se guardan de forma consistente.

## RNF-07. Copias de seguridad y recuperación

Descripción: El sistema deberá disponer de copias de seguridad para recuperar la información ante fallos o pérdida de datos.
Criterios de aceptación propuestos:

- Se realiza una copia de seguridad al menos una vez al día.
- Las copias se almacenan de forma protegida y separada del sistema principal.
- Se realiza una prueba de restauración para comprobar que los datos pueden recuperarse.
- Se documenta el procedimiento de recuperación.

## RNF-08. Facilidad de uso

Descripción: La interfaz deberá ser clara y permitir que los lectores y el personal de la biblioteca comprendan las operaciones disponibles sin conocimientos técnicos avanzados.
Criterios de aceptación:

- Los formularios identifican los campos obligatorios y explican los errores.
- Las acciones importantes muestran confirmación o mensajes de resultado.
- Los lectores pueden localizar el catálogo y sus préstamos mediante una navegación comprensible.

## RNF-09. Compatibilidad y diseño adaptable

Descripción: El sistema deberá funcionar en computadores, tabletas y teléfonos inteligentes mediante navegadores web modernos.
Criterios de aceptación:

- Las funciones principales se pueden utilizar en pantallas pequeñas y grandes.
- Los formularios, botones y tablas siguen siendo utilizables sin desplazamiento horizontal innecesario.
- Las funciones principales se prueban en navegadores modernos seleccionados para el proyecto.

## RNF-10. Accesibilidad

Descripción: La interfaz deberá facilitar el uso por personas con diferentes necesidades de acceso.
Criterios de aceptación propuestos:

- Los campos de formulario tienen etiquetas comprensibles.
- La navegación básica puede realizarse con el teclado.
- Los textos y controles tienen contraste suficiente.
- Se utiliza WCAG 2.2 nivel AA como referencia para evaluar la accesibilidad

## RNF-11. Mantenibilidad del software

Descripción: El código deberá organizarse de forma modular, legible y documentada para facilitar futuras correcciones y ampliaciones.
Criterios de aceptación:

- Las funciones principales están separadas por responsabilidades.
- Las reglas importantes del negocio están documentadas.
- Los cambios pueden probarse sin tener que ejecutar manualmente todo el sistema.
- Se mantienen pruebas para las operaciones críticas, como préstamos y devoluciones.

## RNF-12. Fiabilidad de las notificaciones

Descripción: El sistema deberá gestionar de forma controlada las notificaciones internas y los correos electrónicos relacionados con la lista de espera.
Criterios de aceptación:

- El sistema registra el estado de cada envío.
- Los errores de envío quedan identificados para su revisión o reintento.
- Un fallo en el servicio de correo no elimina ni altera los registros de préstamos o de la lista de espera.
- El sistema no informa que un correo fue entregado si únicamente se ha solicitado su envío.
