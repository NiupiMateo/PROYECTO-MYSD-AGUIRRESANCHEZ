/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Consultas SQL del proyecto */


/* Consulta 1
   Objetivo: Consultar total recaudado por escuela */

SELECT
    e.idEscuela,
    e.nombre AS nombreEscuela,
    NVL(SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END), 0) AS totalRecaudado
FROM Escuela e
LEFT JOIN Inscripcion i
    ON e.idEscuela = i.idEscuela
LEFT JOIN Pago p
    ON i.idInscripcion = p.idInscripcion
GROUP BY e.idEscuela, e.nombre
ORDER BY e.idEscuela;


/* Consulta 2
   Objetivo: Consultar jugadores por equipo */

SELECT DISTINCT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    j.posicion,
    j.numeroCamiseta
FROM Equipo eq
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona pe
    ON pa.idPersona = pe.idPersona
JOIN Jugador j
    ON pe.idPersona = j.idPersona
WHERE pa.rol = 'JUGADOR'
ORDER BY eq.idEquipo, pe.apellidos, pe.nombres;


/* Consulta 3
   Objetivo: Consultar jugadores por categoria */

SELECT DISTINCT
    c.idCategoria,
    c.nombre AS nombreCategoria,
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    j.posicion,
    j.numeroCamiseta
FROM Categoria c
JOIN Equipo eq
    ON c.idCategoria = eq.idCategoria
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona pe
    ON pa.idPersona = pe.idPersona
JOIN Jugador j
    ON pe.idPersona = j.idPersona
WHERE pa.rol = 'JUGADOR'
ORDER BY c.idCategoria, pe.apellidos, pe.nombres;


/* Consulta 4
   Objetivo: Consultar pagos pendientes */

SELECT
    p.idPago,
    p.fechaPago,
    p.monto,
    p.estadoPago,
    i.idInscripcion,
    pe.nombres,
    pe.apellidos,
    e.nombre AS escuela
FROM Pago p
JOIN Inscripcion i
    ON p.idInscripcion = i.idInscripcion
JOIN Persona pe
    ON i.idPersona = pe.idPersona
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