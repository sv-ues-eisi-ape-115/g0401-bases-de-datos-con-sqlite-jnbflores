-- Activar claves foráneas en SQLite
PRAGMA foreign_keys = ON;

-- Mostrar resultados legibles
.headers on
.mode column

-- CREACIÓN DE TABLAS

-- Tabla autores
CREATE TABLE IF NOT EXISTS autor (
    id_autor INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

-- Tabla libros
CREATE TABLE IF NOT EXISTS libro (
    id_libro INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo VARCHAR(150) NOT NULL,
    id_autor INTEGER NOT NULL,
    precio REAL NOT NULL CHECK(precio > 0),
    stock_disponible INTEGER NOT NULL DEFAULT 0 CHECK(stock_disponible >= 0),

    CONSTRAINT fk_libro_autor
        FOREIGN KEY(id_autor)
        REFERENCES autor(id_autor)
        ON DELETE RESTRICT
);

-- Tabla estudiantes
CREATE TABLE IF NOT EXISTS estudiante (
    id_estudiante INTEGER PRIMARY KEY AUTOINCREMENT,
    carnet VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    carrera VARCHAR(100) NOT NULL
);

-- Tabla prestamos
CREATE TABLE IF NOT EXISTS prestamo (
    id_prestamo INTEGER PRIMARY KEY AUTOINCREMENT,
    id_estudiante INTEGER NOT NULL,
    id_libro INTEGER NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE NOT NULL,
    estado VARCHAR(20) NOT NULL
        CHECK(estado IN ('activo','devuelto')),

    CONSTRAINT fk_prestamo_estudiante
        FOREIGN KEY(id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON DELETE RESTRICT,

    CONSTRAINT fk_prestamo_libro
        FOREIGN KEY(id_libro)
        REFERENCES libro(id_libro)
        ON DELETE RESTRICT
);

-- ÍNDICES

CREATE INDEX IF NOT EXISTS idx_libro_titulo
ON libro(titulo);

CREATE INDEX IF NOT EXISTS idx_estudiante_carnet
ON estudiante(carnet);

CREATE INDEX IF NOT EXISTS idx_prestamo_estado
ON prestamo(estado);

-- INSERTAR AUTORES

INSERT OR IGNORE INTO autor(id_autor, nombre, nacionalidad)
VALUES
(1, 'Gabriel Garcia Marquez', 'Colombia'),
(2, 'Mario Vargas Llosa', 'Peru'),
(3, 'Julio Verne', 'Francia');

-- INSERTAR LIBROS

INSERT OR IGNORE INTO libro
(id_libro, titulo, id_autor, precio, stock_disponible)
VALUES
(1, 'Cien Anos de Soledad', 1, 18.50, 5),
(2, 'El Amor en los Tiempos del Colera', 1, 16.00, 3),
(3, 'La Ciudad y los Perros', 2, 15.75, 4),
(4, 'Conversacion en la Catedral', 2, 20.00, 2),
(5, 'Viaje al Centro de la Tierra', 3, 14.25, 6),
(6, 'Veinte Mil Leguas de Viaje Submarino', 3, 19.50, 1);

-- INSERTAR ESTUDIANTES

INSERT OR IGNORE INTO estudiante
(id_estudiante, carnet, nombres, apellidos, carrera)
VALUES
(1, 'SM2026001', 'Carlos', 'Martinez', 'Ingenieria en Sistemas'),
(2, 'SM2026002', 'Ana', 'Lopez', 'Ingenieria Industrial'),
(3, 'SM2026003', 'Luis', 'Hernandez', 'Arquitectura'),
(4, 'SM2026004', 'Maria', 'Gomez', 'Ingenieria en Sistemas');

-- INSERTAR PRESTAMOS

INSERT OR IGNORE INTO prestamo
(id_prestamo, id_estudiante, id_libro, fecha_prestamo, fecha_devolucion, estado)
VALUES
(1, 1, 1, '2026-05-01', '2026-05-10', 'devuelto'),
(2, 2, 3, '2026-05-05', '2026-05-18', 'activo'),
(3, 3, 5, '2026-05-02', '2026-05-12', 'devuelto'),
(4, 4, 2, '2026-05-08', '2026-05-20', 'activo'),
(5, 1, 6, '2026-05-03', '2026-05-14', 'activo');

-- CONSULTAS DE VERIFICACIÓN

-- Mostrar autores
SELECT * FROM autor;

-- Mostrar libros
SELECT * FROM libro;

-- Mostrar estudiantes
SELECT * FROM estudiante;

-- Mostrar préstamos
SELECT * FROM prestamo;

