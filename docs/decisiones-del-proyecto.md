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

- **Descripción:** indica si la cuenta está habilitada.
- **Reglas:** valores permitidos: `activa` e `inactiva`.

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

**Pendiente:** definir cómo se almacenará y administrará el estado de verificación del correo, mediante un atributo adicional o una entidad separada.

### 6.5. Reglas de las contraseñas

1. La contraseña elegida por el usuario deberá tener al menos 12 caracteres.
2. No se exigirá una combinación artificial de mayúsculas, números y símbolos.
3. Se comprobará que la contraseña no sea común o conocida por estar comprometida.
4. El sistema almacenará únicamente el hash de la contraseña, nunca la contraseña original.
5. Se utilizará un algoritmo especializado, como Argon2id, con parámetros seguros.
6. Al cambiar la contraseña, se generará un nuevo hash y se reemplazará el anterior.
7. La recuperación del acceso deberá realizarse mediante un procedimiento seguro.

### 6.6. Reglas de los roles

Los roles son preliminares y sus permisos exactos se definirán durante el diseño de las funcionalidades.

- **Lector:** consulta el catálogo, solicita préstamos y consulta su historial personal.
- **Bibliotecario:** confirma las entregas físicas y registra las devoluciones.
- **Administrador:** gestiona libros, cuentas de usuario y configuraciones del sistema.

El usuario no podrá asignarse privilegios superiores por sí mismo. El servidor deberá verificar los permisos antes de ejecutar operaciones protegidas.

### 6.7. Reglas del estado de la cuenta

1. Una cuenta `activa` podrá acceder si cumple las demás condiciones de autenticación.
2. Una cuenta `inactiva` no podrá iniciar sesión.
3. Cuando se desactive una cuenta, las sesiones abiertas deberán invalidarse y el acceso deberá revocarse inmediatamente.
4. Desactivar una cuenta no equivale a eliminarla. La eliminación deberá respetar las reglas del sistema, especialmente cuando existan préstamos sin resolver.

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
