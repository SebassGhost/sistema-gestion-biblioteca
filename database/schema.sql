-- 1. Crear la tabla de usuarios
CREATE TABLE usuarios (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 2. Consultar las tablas existentes
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- 3. Insertar un usuario de prueba
INSERT INTO usuarios (nombre)
VALUES ('sebastian');

-- 4. Consultar los usuarios registrados
SELECT * FROM usuarios;

-- 5. modificar la tabla existente 
ALTER TABLE usuarios
ADD COLUMN correo VARCHAR (100);

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'usuarios'
ORDER BY ordinal_position;


-- actualizar tabla
UPDATE usuarios
SET correo = 'sebastian@gmail.com'
WHERE id = 1;


SELECT id, correo
FROM usuarios
ORDER BY id;


-- se agregaran 4 usuarios para comprobar que funcione de manera correcta

INSERT INTO usuarios (nombre, correo)
VALUES
    ('nuria', 'nurcita@example.com'),
    ('sandra', 'sandra@example.com'),
    ('emanuel','emanuel@example.com'),
    ('sara', 'sara@example.com');


SELECT * FROM usuarios
ORDER BY id;

-- busqueda de correos duplicados
SELECT correo, COUNT(*) AS cantidad

FROM usuarios 
GROUP BY correo
HAVING COUNT(*) > 1;

--Agregar la restricción UNIQUE
ALTER TABLE usuarios
ADD CONSTRAINT usuarios_correo_unique UNIQUE (correo);


--prueba de la restrincion UNIQUE
INSERT INTO usuarios (nombre, correo)
VALUES
    ('samuel', 'sara@example.com');

-- comprueba si hay correos vacios en nuestra tabla
SELECT id, nombre, correo
FROM usuarios
WHERE correo IS NULL;

-- hacer que el uso del correo sea obligatoro
ALTER TABLE usuarios
ALTER COLUMN correo SET NOT NULL;

-- comprobar la estructura
SELECT
    column_name,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name = 'usuarios'
    AND column_name = 'correo';

-- Agregar el rol predeterminado para los usuarios
ALTER TABLE usuarios
ADD COLUMN rol VARCHAR(20) NOT NULL DEFAULT 'lector';

--comprobacion rapida
SELECT id, nombre, correo, rol
FROM usuarios
ORDER BY id;

--verificar un usuario
SELECT id, nombre, correo, rol
FROM usuarios
WHERE id = 1;

--cambiar un rol del usuario

UPDATE usuarios
SET rol = 'administrador'
WHERE id = 1;

--verificacion
SELECT id, nombre, correo, rol
FROM usuarios
WHERE id = 1;

--creacion de la segunda tabla; libros
CREATE TABLE libros (
id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
titulo VARCHAR(100) NOT NULL,
autor VARCHAR(100) NOT NULL,
disponible BOOLEAN NOT NULL DEFAULT TRUE
);

--comprobacion
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
