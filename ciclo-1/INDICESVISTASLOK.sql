/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Consultas que demuestran el uso de indices y vistas */

/*TEST 1: Búsqueda rápida de Persona por documento usando índice*/
SELECT * FROM Persona WHERE documento = '1000000001';

/*TEST 2: Consulta usando VISTA de Jugadores por Equipo*/
SELECT * FROM vw_jugadores_por_equipo WHERE equipoNombre = 'Halcones Norte';

/*TEST 3: Reporte de Recaudos por Escuela usando VISTA*/
SELECT 
    escuelaNombre,
    totalRecaudado,
    totalPendiente,
    totalInscripciones,
    ROUND((totalRecaudado / NULLIF(totalInscripciones, 0)) * 100, 2) AS porcentajeRecaudado
FROM vw_recaudos_por_escuela
WHERE totalRecaudado > 0
ORDER BY totalRecaudado DESC;

/*TEST 4: Identificar Inscripciones con Pagos Pendientes usando VISTA*/
SELECT 
    idInscripcion,
    nombres,
    apellidos,
    escuelaNombre,
    montoPendiente,
    cantidadPagosPendientes
FROM vw_inscripciones_pendientes
ORDER BY montoPendiente DESC;

/*TEST 5: Listado de Entrenamientos Programados usando VISTA*/
SELECT 
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fechaEntrenamiento,
    TO_CHAR(hora, 'HH24:MI') AS hora,
    equipoNombre,
    lugar,
    equiposParticipantes
FROM vw_entrenamientos_programados
ORDER BY fecha DESC;

/*TEST 6: Reporte de Asistencia por Entrenamiento usando VISTA*/
SELECT 
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fechaEntrenamiento,
    COUNT(*) AS totalParticipantes,
    SUM(CASE WHEN asistencia = 'S' THEN 1 ELSE 0 END) AS asistentes,
    SUM(CASE WHEN asistencia = 'N' THEN 1 ELSE 0 END) AS inasistentes,
    ROUND((SUM(CASE WHEN asistencia = 'S' THEN 1 ELSE 0 END) / 
           COUNT(*)) * 100, 2) AS porcentajeAsistencia
FROM vw_asistencia_entrenamientos
WHERE asistencia IN ('S', 'N')
GROUP BY fecha
ORDER BY fecha DESC;

/*TEST 7: Filtro optimizado de Pagos por estado usando índice*/
SELECT 
    p.idPago,
    i.idInscripcion,
    p.monto,
    p.estadoPago,
    p.metodoPago,
    TO_CHAR(p.fechaPago, 'DD/MM/YYYY') AS fechaPago
FROM Pago p
JOIN Inscripcion i ON p.idInscripcion = i.idInscripcion
WHERE p.estadoPago = 'PAGADO'
ORDER BY p.fechaPago DESC;

/*TEST 8: Búsqueda de Entrenamientos Programados usando índice*/
SELECT 
    e.idEntrenamiento,
    TO_CHAR(e.fecha, 'DD/MM/YYYY') AS fechaEntrenamiento,
    TO_CHAR(e.hora, 'HH24:MI') AS hora,
    e.lugar,
    eq.nombre AS equipoNombre
FROM Entrenamiento e
JOIN Equipo eq ON e.idEquipo = eq.idEquipo
WHERE e.estado = 'PROGRAMADO'
ORDER BY e.fecha;

/*TEST 9: Distribución de Jugadores por Categoría usando VISTA*/
SELECT 
    categoriaNombre,
    nivel,
    cantidadJugadores
FROM vw_jugadores_categoria
WHERE cantidadJugadores > 0
ORDER BY categoriaNombre;

/*TEST 10: Asistencia consolidada por Persona*/
SELECT 
    a.idPersona,
    a.nombres,
    a.apellidos,
    a.posicion,
    COUNT(*) AS totalEntrenamientos,
    SUM(CASE WHEN a.asistencia = 'S' THEN 1 ELSE 0 END) AS asistencias,
    SUM(CASE WHEN a.asistencia = 'N' THEN 1 ELSE 0 END) AS inasistencias,
    ROUND((SUM(CASE WHEN a.asistencia = 'S' THEN 1 ELSE 0 END) / 
           COUNT(*)) * 100, 2) AS porcentajeAsistencia
FROM vw_asistencia_entrenamientos a
GROUP BY a.idPersona, a.nombres, a.apellidos, a.posicion
ORDER BY porcentajeAsistencia DESC;


