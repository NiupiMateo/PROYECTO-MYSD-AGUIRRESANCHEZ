/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: VERIFICACIÓN AUTOMÁTICA DEL PROYECTO COMPLETO */

SET ECHO ON;
SET FEEDBACK ON;
SET PAGESIZE 0;
SET LINESIZE 200;

SPOOL c:\Users\Multimedia\Documents\PROYECTOBASES\REPORTE_VALIDACION.log;

-- ============================================================================
--                    VERIFICACIÓN 1: TABLAS
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 1: TABLAS CREADAS
PROMPT ================================================================================
SELECT table_name FROM user_tables 
WHERE table_name IN ('PERSONA', 'JUGADOR', 'ACUDIENTE', 'ADMINISTRADOR', 'ENTRENADOR',
                     'ESCUELA', 'CATEGORIA', 'EQUIPO', 'INSCRIPCION', 'PAGO',
                     'ENTRENAMIENTO', 'PARTICIPANTE', 'RECIBE')
ORDER BY table_name;

SELECT COUNT(*) AS total_tablas FROM user_tables 
WHERE table_name IN ('PERSONA', 'JUGADOR', 'ACUDIENTE', 'ADMINISTRADOR', 'ENTRENADOR',
                     'ESCUELA', 'CATEGORIA', 'EQUIPO', 'INSCRIPCION', 'PAGO',
                     'ENTRENAMIENTO', 'PARTICIPANTE', 'RECIBE');

-- ============================================================================
--                    VERIFICACIÓN 2: CONSTRAINTS
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 2: CONSTRAINTS
PROMPT ================================================================================
SELECT constraint_type, COUNT(*) AS cantidad FROM user_constraints
GROUP BY constraint_type
ORDER BY constraint_type;

SELECT COUNT(*) AS total_constraints FROM user_constraints;

-- ============================================================================
--                    VERIFICACIÓN 3: TRIGGERS
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 3: TRIGGERS
PROMPT ================================================================================
SELECT trigger_name, table_name, triggering_event FROM user_triggers
ORDER BY trigger_name;

SELECT COUNT(*) AS total_triggers FROM user_triggers;

-- ============================================================================
--                    VERIFICACIÓN 4: INDICES
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 4: INDICES
PROMPT ================================================================================
SELECT index_name, table_name, column_name FROM user_ind_columns
WHERE index_name LIKE 'IDX_%'
ORDER BY index_name, column_position;

SELECT COUNT(DISTINCT index_name) AS total_indices FROM user_ind_columns
WHERE index_name LIKE 'IDX_%';

-- ============================================================================
--                    VERIFICACIÓN 5: VISTAS
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 5: VISTAS
PROMPT ================================================================================
SELECT view_name FROM user_views
WHERE view_name LIKE 'VW_%'
ORDER BY view_name;

SELECT COUNT(*) AS total_vistas FROM user_views
WHERE view_name LIKE 'VW_%';

-- ============================================================================
--                    VERIFICACIÓN 6: PACKAGES
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 6: PACKAGES
PROMPT ================================================================================
SELECT object_name FROM user_objects
WHERE object_type = 'PACKAGE' AND object_name LIKE 'PK_%'
ORDER BY object_name;

SELECT COUNT(*) AS total_packages FROM user_objects
WHERE object_type = 'PACKAGE' AND object_name LIKE 'PK_%';

-- ============================================================================
--                    VERIFICACIÓN 7: DATOS POBLADOS
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 7: DATOS POBLADOS
PROMPT ================================================================================
SELECT 'Persona' AS tabla, COUNT(*) AS registros FROM Persona
UNION ALL
SELECT 'Jugador', COUNT(*) FROM Jugador
UNION ALL
SELECT 'Acudiente', COUNT(*) FROM Acudiente
UNION ALL
SELECT 'Administrador', COUNT(*) FROM Administrador
UNION ALL
SELECT 'Entrenador', COUNT(*) FROM Entrenador
UNION ALL
SELECT 'Escuela', COUNT(*) FROM Escuela
UNION ALL
SELECT 'Categoria', COUNT(*) FROM Categoria
UNION ALL
SELECT 'Equipo', COUNT(*) FROM Equipo
UNION ALL
SELECT 'Inscripcion', COUNT(*) FROM Inscripcion
UNION ALL
SELECT 'Pago', COUNT(*) FROM Pago
UNION ALL
SELECT 'Entrenamiento', COUNT(*) FROM Entrenamiento
UNION ALL
SELECT 'Participante', COUNT(*) FROM Participante
UNION ALL
SELECT 'Recibe', COUNT(*) FROM Recibe
ORDER BY tabla;

-- ============================================================================
--                    VERIFICACIÓN 8: ROLES
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 8: ROLES
PROMPT ================================================================================
SELECT role FROM dba_roles WHERE role IN ('ADMINISTRADOR', 'ENTRENADOR');

-- ============================================================================
--                    VERIFICACIÓN 9: VISTA - Recaudos por Escuela
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 9: VISTA - Recaudos por Escuela
PROMPT ================================================================================
SELECT * FROM vw_recaudos_por_escuela;

-- ============================================================================
--                    VERIFICACIÓN 10: VISTA - Jugadores por Equipo
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 10: VISTA - Jugadores por Equipo (primeras 10 filas)
PROMPT ================================================================================
SELECT * FROM vw_jugadores_por_equipo WHERE ROWNUM <= 10;

-- ============================================================================
--                    VERIFICACIÓN 11: VISTA - Inscripciones Pendientes
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 11: VISTA - Inscripciones Pendientes
PROMPT ================================================================================
SELECT * FROM vw_inscripciones_pendientes;

-- ============================================================================
--                    VERIFICACIÓN 12: VISTA - Entrenamientos Programados
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 12: VISTA - Entrenamientos Programados
PROMPT ================================================================================
SELECT * FROM vw_entrenamientos_programados;

-- ============================================================================
--                    VERIFICACIÓN 13: CONSULTA NEGOCIO - Recaudos Totales
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 13: Recaudos Totales por Escuela
PROMPT ================================================================================
SELECT 
    e.nombre AS escuela,
    COUNT(DISTINCT p.idPago) AS totalPagos,
    SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END) AS totalRecaudado,
    SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END) AS totalPendiente
FROM Escuela e
LEFT JOIN Inscripcion i ON e.idEscuela = i.idEscuela
LEFT JOIN Pago p ON i.idInscripcion = p.idInscripcion
GROUP BY e.nombre;

-- ============================================================================
--                    VERIFICACIÓN 14: CONSULTA NEGOCIO - Pago por Estado
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN 14: Resumen de Pagos por Estado
PROMPT ================================================================================
SELECT 
    estadoPago AS estado,
    COUNT(*) AS cantidad,
    SUM(monto) AS total
FROM Pago
GROUP BY estadoPago
ORDER BY estadoPago;

-- ============================================================================
--                    FIN DE VERIFICACIÓN
-- ============================================================================
PROMPT ================================================================================
PROMPT VERIFICACIÓN COMPLETADA
PROMPT ================================================================================

SPOOL OFF;

-- Mostrar confirmación
PROMPT
PROMPT ✓ Reporte guardado en: c:\Users\Multimedia\Documents\PROYECTOBASES\REPORTE_VALIDACION.log
PROMPT ✓ Verificación completada exitosamente
PROMPT
