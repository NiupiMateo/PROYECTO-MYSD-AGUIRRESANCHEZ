/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Definición de vistas para simplificar consultas complejas frecuentes */

/*VISTA 1: Jugadores por Equipo con datos completos*/
CREATE OR REPLACE VIEW vw_jugadores_por_equipo AS
SELECT 
    eq.idEquipo,
    eq.nombre AS equipoNombre,
    p.idPersona,
    p.nombres,
    p.apellidos,
    p.documento,
    j.posicion,
    j.numeroCamiseta
FROM Equipo eq
JOIN Escuela e ON eq.idEscuela = e.idEscuela
JOIN Inscripcion i ON e.idEscuela = i.idEscuela
JOIN Persona p ON i.idPersona = p.idPersona
LEFT JOIN Jugador j ON p.idPersona = j.idPersona
WHERE j.idPersona IS NOT NULL;
/

/*VISTA 2: Recaudos totales por Escuela*/
CREATE OR REPLACE VIEW vw_recaudos_por_escuela AS
SELECT 
    e.idEscuela,
    e.nombre AS escuelaNombre,
    COUNT(DISTINCT p.idPago) AS totalPagos,
    SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END) AS totalRecaudado,
    SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END) AS totalPendiente,
    SUM(p.monto) AS totalInscripciones
FROM Escuela e
LEFT JOIN Inscripcion i ON e.idEscuela = i.idEscuela
LEFT JOIN Pago p ON i.idInscripcion = p.idInscripcion
GROUP BY e.idEscuela, e.nombre;
/

/*VISTA 3: Inscripciones con pagos pendientes*/
CREATE OR REPLACE VIEW vw_inscripciones_pendientes AS
SELECT 
    i.idInscripcion,
    i.fechaInscripcion,
    p.idPersona,
    p.nombres,
    p.apellidos,
    p.documento,
    e.nombre AS escuelaNombre,
    i.estadoInscripcion,
    SUM(CASE WHEN pg.estadoPago = 'PENDIENTE' THEN pg.monto ELSE 0 END) AS montoPendiente,
    COUNT(CASE WHEN pg.estadoPago = 'PENDIENTE' THEN 1 END) AS cantidadPagosPendientes
FROM Inscripcion i
JOIN Persona p ON i.idPersona = p.idPersona
JOIN Escuela e ON i.idEscuela = e.idEscuela
LEFT JOIN Pago pg ON i.idInscripcion = pg.idInscripcion
WHERE pg.estadoPago = 'PENDIENTE' OR (pg.idPago IS NULL)
GROUP BY i.idInscripcion, i.fechaInscripcion, p.idPersona, p.nombres, p.apellidos, 
         p.documento, e.nombre, i.estadoInscripcion;
/

/*VISTA 4: Entrenamientos programados con equipos*/
CREATE OR REPLACE VIEW vw_entrenamientos_programados AS
SELECT 
    ent.idEntrenamiento,
    ent.fecha,
    ent.hora,
    ent.estado,
    ent.lugar,
    eq.idEquipo,
    eq.nombre AS equipoNombre,
    COUNT(DISTINCT r.idEquipo) AS equiposParticipantes
FROM Entrenamiento ent
JOIN Equipo eq ON ent.idEquipo = eq.idEquipo
LEFT JOIN Recibe r ON ent.idEntrenamiento = r.idEntrenamiento
WHERE ent.estado = 'PROGRAMADO'
GROUP BY ent.idEntrenamiento, ent.fecha, ent.hora, ent.estado, 
         ent.lugar, eq.idEquipo, eq.nombre;
/

/*VISTA 5: Asistencia de jugadores a entrenamientos*/
CREATE OR REPLACE VIEW vw_asistencia_entrenamientos AS
SELECT 
    ent.idEntrenamiento,
    ent.fecha,
    ent.hora,
    p.idPersona,
    p.nombres,
    p.apellidos,
    j.posicion,
    j.numeroCamiseta,
    part.asistencia,
    part.rol,
    part.observaciones
FROM Entrenamiento ent
JOIN Participante part ON ent.idEntrenamiento = part.idEntrenamiento
JOIN Persona p ON part.idPersona = p.idPersona
LEFT JOIN Jugador j ON p.idPersona = j.idPersona;
/

/*VISTA 6: Jugadores activos por categoría*/
CREATE OR REPLACE VIEW vw_jugadores_categoria AS
SELECT 
    c.idCategoria,
    c.nombre AS categoriaNombre,
    c.nivel,
    COUNT(DISTINCT i.idPersona) AS cantidadJugadores
FROM Categoria c
LEFT JOIN Equipo eq ON c.idCategoria = eq.idCategoria
LEFT JOIN Escuela e ON eq.idEscuela = e.idEscuela
LEFT JOIN Inscripcion i ON e.idEscuela = i.idEscuela
LEFT JOIN Jugador j ON i.idPersona = j.idPersona
GROUP BY c.idCategoria, c.nombre, c.nivel;
/
