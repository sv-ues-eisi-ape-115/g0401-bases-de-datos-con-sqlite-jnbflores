-- Activar claves foráneas
PRAGMA foreign_keys = ON;

-- Mostrar resultados legibles
.headers on
.mode column

-- R02.1
-- Todos los libros disponibles con nombre del autor

SELECT l.titulo,
       a.nombre AS autor,
       l.stock_disponible
FROM libro l
INNER JOIN autor a
    ON l.id_autor = a.id_autor
WHERE l.stock_disponible > 0
ORDER BY l.titulo;

-- R02.2
-- Estudiantes con préstamos activos

SELECT e.nombres || ' ' || e.apellidos AS nombre_completo,
       e.carnet,
       l.titulo,
       p.fecha_devolucion
FROM prestamo p
INNER JOIN estudiante e
    ON p.id_estudiante = e.id_estudiante
INNER JOIN libro l
    ON p.id_libro = l.id_libro
WHERE p.estado = 'activo'
ORDER BY p.fecha_devolucion ASC;

-- R02.3
-- Top 3 libros con más préstamos históricos

SELECT l.titulo,
       COUNT(p.id_prestamo) AS total_prestamos
FROM libro l
INNER JOIN prestamo p
    ON l.id_libro = p.id_libro
GROUP BY l.id_libro, l.titulo
ORDER BY total_prestamos DESC
LIMIT 3;

-- R02.4
-- Préstamos vencidos

SELECT e.nombres || ' ' || e.apellidos AS estudiante,
       l.titulo,
       p.fecha_devolucion,
       julianday(date('now')) - julianday(p.fecha_devolucion)
       AS dias_retraso
FROM prestamo p
INNER JOIN estudiante e
    ON p.id_estudiante = e.id_estudiante
INNER JOIN libro l
    ON p.id_libro = l.id_libro
WHERE p.estado = 'activo'
AND p.fecha_devolucion < date('now');

-- R02.5
-- Estadísticas por carrera

SELECT e.carrera,
       COUNT(DISTINCT e.id_estudiante) AS total_estudiantes,

       COUNT(CASE
           WHEN p.estado = 'activo'
           THEN 1
       END) AS prestamos_activos,

       COUNT(CASE
           WHEN p.estado = 'devuelto'
           THEN 1
       END) AS prestamos_devueltos

FROM estudiante e
LEFT JOIN prestamo p
    ON e.id_estudiante = p.id_estudiante

GROUP BY e.carrera;

-- R02.6
-- Libros que nunca han sido prestados

SELECT l.titulo
FROM libro l
LEFT JOIN prestamo p
    ON l.id_libro = p.id_libro
WHERE p.id_prestamo IS NULL;
