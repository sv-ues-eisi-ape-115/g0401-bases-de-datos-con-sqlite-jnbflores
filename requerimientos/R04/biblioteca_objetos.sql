-- Activar claves foráneas
PRAGMA foreign_keys = ON;

-- Mostrar resultados legibles
.headers on
.mode column

-- ELIMINAR OBJETOS SI EXISTEN

DROP VIEW IF EXISTS vw_prestamo_activo;
DROP VIEW IF EXISTS vw_libro_disponibilidad;

DROP TRIGGER IF EXISTS trg_prestamo_nuevo;
DROP TRIGGER IF EXISTS trg_prestamo_devuelto;

-- VISTA 1
-- Préstamos activos

CREATE VIEW vw_prestamo_activo AS
SELECT p.id_prestamo,
       e.nombres || ' ' || e.apellidos AS estudiante,
       l.titulo,
       p.fecha_prestamo,
       p.fecha_devolucion,
       julianday(p.fecha_devolucion) -
       julianday(date('now')) AS dias_restantes
FROM prestamo p
INNER JOIN estudiante e
    ON p.id_estudiante = e.id_estudiante
INNER JOIN libro l
    ON p.id_libro = l.id_libro
WHERE p.estado = 'activo';

-- VISTA 2
-- Disponibilidad de libros

CREATE VIEW vw_libro_disponibilidad AS
SELECT titulo,
       stock_disponible
FROM libro;

-- TRIGGER 1
-- Validar stock antes de préstamo

CREATE TRIGGER trg_prestamo_nuevo
BEFORE INSERT ON prestamo
FOR EACH ROW
WHEN (
    SELECT stock_disponible
    FROM libro
    WHERE id_libro = NEW.id_libro
) <= 0

BEGIN
    SELECT RAISE(ROLLBACK,'No hay stock disponible para este libro');
END;

-- TRIGGER 2
-- Actualizar stock al devolver libro

CREATE TRIGGER trg_prestamo_devuelto
AFTER UPDATE OF estado ON prestamo
FOR EACH ROW
WHEN NEW.estado = 'devuelto'

BEGIN
    UPDATE libro
    SET stock_disponible = stock_disponible + 1
    WHERE id_libro = NEW.id_libro;
END;

-- PRUEBA DEL FLUJO COMPLETO

-- Insertar nuevo préstamo
INSERT OR IGNORE INTO prestamo
(id_prestamo, id_estudiante, id_libro,
 fecha_prestamo, fecha_devolucion, estado)
VALUES
(11, 2, 2, date('now'),
 date('now','+7 day'), 'activo');

-- Consultar vista de préstamos activos
SELECT * FROM vw_prestamo_activo;

-- Devolver préstamo
UPDATE prestamo
SET estado = 'devuelto'
WHERE id_prestamo = 11;

-- Consultar disponibilidad de libros
SELECT * FROM vw_libro_disponibilidad;
