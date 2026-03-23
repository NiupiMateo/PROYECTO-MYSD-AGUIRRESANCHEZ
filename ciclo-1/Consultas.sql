/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Consultas SQL del proyecto */

/* Consulta 1
   Objetivo: Consultar total recaudado por escuela */

SELECT
    e.idEscuela,
    e.nombre AS nombreEscuela,
    COALESCE(SUM(p.monto), 0) AS totalRecaudado
FROM Escuela e
LEFT JOIN Inscripcion i
    ON e.idEscuela = i.idEscuela
LEFT JOIN Pago p
    ON i.idInscripcion = p.idInscripcion
   AND p.estadoPago = 'PAGADO'
GROUP BY e.idEscuela, e.nombre
ORDER BY e.idEscuela;

/* Consulta 2
   Objetivo: Consultar jugadores por equipo */

SELECT DISTINCT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
    p.idPersona,
    p.nombres,
    p.apellidos,
    j.posicion,
    j.numeroCamiseta
FROM Equipo eq
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona p
    ON pa.idPersona = p.idPersona
JOIN Jugador j
    ON p.idPersona = j.idPersona
ORDER BY eq.idEquipo, p.apellidos, p.nombres;

/* Consulta 3
   Objetivo: Consultar jugadores por categoría */

SELECT DISTINCT
    c.idCategoria,
    c.nombre AS nombreCategoria,
    p.idPersona,
    p.nombres,
    p.apellidos,
    j.posicion
FROM Categoria c
JOIN Equipo eq
    ON c.idCategoria = eq.idCategoria
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona p
    ON pa.idPersona = p.idPersona
JOIN Jugador j
    ON p.idPersona = j.idPersona
ORDER BY c.idCategoria, p.apellidos, p.nombres;

/* Consulta 4
   Objetivo: Consultar pagos pendientes */

SELECT
    p.idPago,
    p.fechaPago,
    p.monto,
    p.estadoPago,
    i.idInscripcion,
    per.nombres,
    per.apellidos,
    e.nombre AS escuela
FROM Pago p
JOIN Inscripcion i
    ON p.idInscripcion = i.idInscripcion
JOIN Persona per
    ON i.idPersona = per.idPersona
JOIN Escuela e
    ON i.idEscuela = e.idEscuela
WHERE p.estadoPago = 'PENDIENTE'
ORDER BY p.idPago;

/* Consulta 5
   Objetivo: Consultar entrenamientos programados por equipo */
   
SELECT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
    en.idEntrenamiento,
    en.fecha,
    en.hora,
    en.lugar,
    en.estado
FROM Equipo eq
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
WHERE en.estado = 'PROGRAMADO'
ORDER BY eq.idEquipo, en.fecha, en.hora;