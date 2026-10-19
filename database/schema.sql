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