-- Activar claves foráneas
PRAGMA foreign_keys = ON;

-- Mostrar resultados legibles
.headers on
.mode column

-- R03.1
-- Estudiantes que han tomado más libros que el promedio

SELECT e.nombres || ' ' || e.apellidos AS estudiante,
       COUNT(p.id_prestamo) AS total_prestamos
FROM estudiante e
INNER JOIN prestamo p
    ON e.id_estudiante = p.id_estudiante
GROUP BY e.id_estudiante
HAVING COUNT(p.id_prestamo) >
(
    SELECT COUNT(*) * 1.0 /
           COUNT(DISTINCT id_estudiante)
    FROM prestamo
);

-- R03.2
-- Libros cuyo precio es mayor al promedio de libros
-- del mismo autor

SELECT l1.titulo,
       l1.precio,
       l1.id_autor
FROM libro l1
WHERE l1.precio >
(
    SELECT AVG(l2.precio)
    FROM libro l2
    WHERE l2.id_autor = l1.id_autor
);

-- R03.3
-- Estudiantes sin préstamos activos actualmente

SELECT e.nombres || ' ' || e.apellidos AS estudiante
FROM estudiante e
WHERE e.id_estudiante NOT IN
(
    SELECT p.id_estudiante
    FROM prestamo p
    WHERE p.estado = 'activo'
);

-- R03.4
-- Libro más caro por autor

SELECT a.nombre AS autor,
       l.titulo,
       l.precio
FROM autor a
INNER JOIN libro l
    ON a.id_autor = l.id_autor
WHERE l.precio =
(
    SELECT MAX(l2.precio)
    FROM libro l2
    WHERE l2.id_autor = a.id_autor
);

-- R03.5
-- Libros prestados al menos 2 veces usando HAVING

SELECT l.titulo,
       COUNT(p.id_prestamo) AS total_prestamos
FROM libro l
INNER JOIN prestamo p
    ON l.id_libro = p.id_libro
GROUP BY l.id_libro
HAVING COUNT(p.id_prestamo) >= 2;

-- R03.5
-- Libros prestados al menos 2 veces 

SELECT l.titulo
FROM libro l
WHERE l.id_libro IN
(
    SELECT p.id_libro
    FROM prestamo p
    GROUP BY p.id_libro
    HAVING COUNT(*) >= 2
);
