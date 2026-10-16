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

El inventario se controlará por título y cantidad de ejemplares, sin registrar individualmente cada ejemplar físico.

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

**Estado:** aprobada, versión 1.0.

### Propósito

Representar un título bibliográfico en una edición determinada y gestionar su inventario de ejemplares.

### Atributos definidos

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

### Reglas acordadas

1. Cada registro tendrá un identificador único.
2. El título no será único por sí solo.
3. Dos ediciones de una misma obra podrán registrarse por separado.
4. El inventario se gestionará por título y edición, sin identificar cada ejemplar físico.
5. La cantidad disponible no podrá ser negativa ni superar la cantidad total.
6. Los cambios de inventario deberán ser coherentes con los préstamos existentes.
7. El ISBN será opcional y se almacenará como texto.

### Aspectos pendientes

- Definir cómo se representan uno o varios autores.
- Precisar la validación del ISBN y el tratamiento de duplicados.
- Definir cómo se calculan o actualizan las cantidades disponibles.
- Establecer las reglas para modificar inventarios cuando existan préstamos activos.

## 6. Decisiones pendientes

- Definir la política de asignación de ejemplares a los lectores en espera.
- Determinar cuánto tiempo se mantendrá una oportunidad de préstamo para un lector notificado.
- Diseñar los atributos y las relaciones de las entidades restantes.
- Definir la arquitectura del sistema y seleccionar las tecnologías.
- Precisar los procedimientos de pruebas, despliegue y mantenimiento.

## 7. Historial de cambios

### Versión 1.0 — Diseño inicial

- Se aprobaron los requisitos funcionales y no funcionales.
- Se aprobó la primera versión de la entidad `Libro`.
- Se registraron las principales reglas de inventario, préstamos, usuarios y notificaciones.

Este documento continuará actualizándose a medida que avance el diseño del sistema
