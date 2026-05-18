/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Consultas SQL del proyecto */


/* Consulta 1
   Objetivo: Consultar total recaudado por escuela
   Rol: Administrador */
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
   Objetivo: Consultar jugadores por equipo
   Rol: Administrador */
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
   Objetivo: Consultar jugadores por categoría
   Rol: Administrador */
SELECT DISTINCT
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    c.nombre AS categoria,
    eq.nombre AS equipo,
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
ORDER BY c.nombre, eq.nombre, pe.apellidos, pe.nombres;


/* Consulta 4
   Objetivo: Consultar inscripciones con pagos pendientes
   Rol: Administrador */
SELECT
    i.idInscripcion,
    i.idPersona,
    pe.nombres,
    pe.apellidos,
    i.estadoInscripcion,
    NVL(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) AS montoPendiente
FROM Inscripcion i
JOIN Persona pe
    ON i.idPersona = pe.idPersona
LEFT JOIN Pago p
    ON i.idInscripcion = p.idInscripcion
GROUP BY i.idInscripcion, i.idPersona, pe.nombres, pe.apellidos, i.estadoInscripcion
HAVING NVL(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) > 0
ORDER BY i.idInscripcion;


/* Consulta 5
   Objetivo: Consultar entrenamientos programados por equipo
   Rol: Entrenador */
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


/* Consulta 6
   Objetivo: Consultar jugadores de mi equipo
   Rol: Entrenador */
SELECT DISTINCT
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    j.posicion,
    j.numeroCamiseta,
    eq.nombre AS nombreEquipo
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
ORDER BY pe.apellidos, pe.nombres;