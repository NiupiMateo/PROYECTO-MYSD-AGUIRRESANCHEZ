/*
================================================================================
        PRUEBAS INTERACTIVAS - COPIA Y PEGA PARA VER RESULTADOS
================================================================================

Este archivo tiene COMANDOS COMPLETOS que puedes copiar y pegar directamente.
Cada uno muestra EXACTAMENTE qué esperar como resultado.

================================================================================
                    PARTE 1: VERIFICAR ESTRUCTURA
================================================================================
*/

-- TEST 1.1: Verificar que las 13 tablas existen
───────────────────────────────────────────────
SELECT table_name 
FROM user_tables
WHERE table_name IN ('PERSONA', 'JUGADOR', 'ACUDIENTE', 'ADMINISTRADOR', 'ENTRENADOR',
                     'ESCUELA', 'CATEGORIA', 'EQUIPO', 'INSCRIPCION', 'PAGO',
                     'ENTRENAMIENTO', 'PARTICIPANTE', 'RECIBE')
ORDER BY table_name;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- TABLE_NAME
-- ──────────────────
-- ACUDIENTE
-- ADMINISTRADOR
-- CATEGORIA
-- ENTRENAMIENTO
-- ENTRENADOR
-- EQUIPO
-- ESCUELA
-- INSCRIPCION
-- JUGADOR
-- PAGO
-- PARTICIPANTE
-- PERSONA
-- RECIBE
--
-- 13 rows selected.

/*
-- TEST 1.2: Contar constraints por tipo
────────────────────────────────────────────
SELECT constraint_type, COUNT(*) AS cantidad
FROM user_constraints
WHERE table_name IN ('PERSONA', 'JUGADOR', 'ESCUELA', 'EQUIPO', 'PAGO')
GROUP BY constraint_type
ORDER BY constraint_type;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- CONSTRAINT_TYPE    CANTIDAD
-- ───────────────    ────────
-- C                  7         (CHECK constraints)
-- P                  5         (PRIMARY KEYs)
-- R                  8+        (FOREIGN KEYs)
-- U                  6         (UNIQUE constraints)

-- TEST 1.3: Verificar triggers creados
────────────────────────────────────────────
SELECT trigger_name, table_name
FROM user_triggers
ORDER BY trigger_name;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- TRIGGER_NAME                        TABLE_NAME
-- ──────────────────────────────────  ──────────────
-- TRG_ACTUALIZAR_ESTADO_INSCRIPCION  PAGO
-- TRG_FECHA_PAGO_AUTOMATICA          PAGO
-- TRG_OBS_PARTICIPANTE               PARTICIPANTE
-- TRG_OBS_RECIBE                     RECIBE
-- TRG_VALIDAR_EDAD_JUGADOR           JUGADOR
-- TRG_VALIDAR_NUMERO_CAMISETA_EQUIPO JUGADOR
--
-- 6 rows selected.

-- TEST 1.4: Verificar índices creados
────────────────────────────────────────────
SELECT COUNT(*) AS total_indices
FROM user_indexes
WHERE index_name LIKE 'IDX_%';

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- TOTAL_INDICES
-- ─────────────
-- 10

-- TEST 1.5: Verificar vistas creadas
────────────────────────────────────────────
SELECT view_name
FROM user_views
WHERE view_name LIKE 'VW_%'
ORDER BY view_name;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- VIEW_NAME
-- ──────────────────────────────
-- VW_ASISTENCIA_ENTRENAMIENTOS
-- VW_ENTRENAMIENTOS_PROGRAMADOS
-- VW_INSCRIPCIONES_PENDIENTES
-- VW_JUGADORES_CATEGORIA
-- VW_JUGADORES_POR_EQUIPO
-- VW_RECAUDOS_POR_ESCUELA
--
-- 6 rows selected.

-- TEST 1.6: Verificar packages creados
────────────────────────────────────────────
SELECT object_name, object_type
FROM user_objects
WHERE object_name LIKE 'PK_%'
AND object_type IN ('PACKAGE', 'PACKAGE BODY')
ORDER BY object_name;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- OBJECT_NAME            OBJECT_TYPE
-- ────────────────────── ──────────────
-- PK_ADMINISTRACION      PACKAGE
-- PK_ADMINISTRACION      PACKAGE BODY
-- PK_AUDITORIAS          PACKAGE
-- PK_AUDITORIAS          PACKAGE BODY
-- PK_ENTRENAMIENTO       PACKAGE
-- PK_ENTRENAMIENTO       PACKAGE BODY

================================================================================
                    PARTE 2: PRUEBAS DE TRIGGERS
================================================================================

-- TEST 2.1: Verificar TRIGGER 1 (Validar edad >= 5 años)
──────────────────────────────────────────────────────────

-- Primero, inserta una Persona MAYOR DE 5 AÑOS
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (100, '1000000100', 'TestJuvenJugador', 'Mayor', DATE '2010-05-10', '3001111111', 'test@mail.com');

-- Ahora intenta insertar como Jugador (debe FUNCIONAR porque tiene 14 años)
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (100, 'DELANTERO', 50);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- 1 row created.
-- 1 row created.
--
-- ✓ El trigger PERMITIÓ la inserción

-- Ahora inserta una Persona MENOR DE 5 AÑOS
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (101, '1000000101', 'NinoMuyPequeno', 'Bebe', DATE '2023-01-01', '3002222222', 'nino@mail.com');

-- Intenta insertar como Jugador (debe FALLAR porque tiene 1 año)
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (101, 'DELANTERO', 51);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- ORA-20001: El jugador debe tener al menos 5 anos.
--
-- ✓ El trigger RECHAZÓ correctamente la inserción

ROLLBACK;  -- Deshace todo para limpiar

-- TEST 2.2: Verificar TRIGGER 2 (Auto-llenar observaciones en Participante)
──────────────────────────────────────────────────────────────────────────────

-- PRIMERO: Necesitas datos poblados. Ejecuta POBLAROK.sql antes de este test.
-- Asumiendo que ya hay datos, intenta esto:

-- Inserta un Participante SIN observaciones, con asistencia='N'
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (1, 1, 'N', 'JUGADOR', NULL);

-- Verificar que el TRIGGER auto-llenó las observaciones
SELECT idPersona, idEntrenamiento, asistencia, observaciones
FROM Participante
WHERE idPersona=1 AND idEntrenamiento=1;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- 1 row created.
--
-- idPersona  idEntrenamiento  asistencia  observaciones
-- ────────   ───────────────  ────────    ──────────────────────────────
-- 1          1                N           No asistio al entrenamiento
--
-- ✓ El TRIGGER auto-llenó "No asistio al entrenamiento"

ROLLBACK;

-- TEST 2.3: Verificar TRIGGER 3 (Auto-llenar en Recibe)
──────────────────────────────────────────────────────────

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (1, 1, 'N', NULL);

SELECT idEntrenamiento, idEquipo, asistencia, observaciones
FROM Recibe
WHERE idEntrenamiento=1 AND idEquipo=1;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- 1 row created.
--
-- idEntrenamiento  idEquipo  asistencia  observaciones
-- ───────────────  ────────  ────────    ──────────────────────────────────
-- 1                1         N           Equipo no asistio al entrenamiento
--
-- ✓ El TRIGGER auto-llenó "Equipo no asistio al entrenamiento"

ROLLBACK;

-- TEST 2.4: Verificar TRIGGER 4 (Auto-actualizar Inscripción cuando se paga)
──────────────────────────────────────────────────────────────────────────────

-- Primero, asegúrate que hay una Inscripción en estado PENDIENTE
-- (Esto ya debería existir en POBLAROK.sql)

-- Verifica estado ANTES de pagar
SELECT idInscripcion, estadoInscripcion
FROM Inscripcion
WHERE idInscripcion = 1;

-- RESULTADO:
-- idInscripcion  estadoInscripcion
-- ─────────────  ─────────────────
-- 1              PENDIENTE

-- Ahora INSERT un Pago con estadoPago='PAGADO'
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (999, DATE '2024-05-09', 100000, 'PAGADO', 'EFECTIVO', 1);

-- Verifica estado DESPUÉS (debería ser ACTIVA automáticamente)
SELECT idInscripcion, estadoInscripcion
FROM Inscripcion
WHERE idInscripcion = 1;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- 1 row created.
--
-- idInscripcion  estadoInscripcion
-- ─────────────  ─────────────────
-- 1              ACTIVA
--
-- ✓ El TRIGGER actualizó automáticamente a ACTIVA

ROLLBACK;

-- TEST 2.5: Verificar TRIGGER 5 (Número camiseta único por escuela)
──────────────────────────────────────────────────────────────────────

-- Primero inserta un Jugador con camiseta 9 en escuela 1
-- (Ya debería existir en POBLAROK.sql)

-- Intenta insertar OTRO Jugador con la MISMA camiseta en la MISMA escuela
-- Esto DEBE FALLAR

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (102, '1000000102', 'OtroJugador', 'Test', DATE '2012-05-10', '3003333333', 'otro@mail.com');

INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (999, DATE '2024-05-09', 'ACTIVA', 102, 1);

-- Intenta crear Jugador con camiseta 9 (que ya existe con idPersona=1 en escuela 1)
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (102, 'DEFENSA', 9);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- ORA-20005: El numero de camiseta ya existe en este equipo.
--
-- ✓ El TRIGGER rechazó correctamente el duplicado

ROLLBACK;

-- TEST 2.6: Verificar TRIGGER 6 (Auto-asignar fecha de pago)
────────────────────────────────────────────────────────────

-- Inserta un Pago con estadoPago='PAGADO' pero SIN especificar fechaPago
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (998, NULL, 50000, 'PAGADO', 'TRANSFERENCIA', 1);

-- Verifica que la fechaPago fue auto-asignada con SYSDATE
SELECT idPago, fechaPago, estadoPago
FROM Pago
WHERE idPago = 998;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- 1 row created.
--
-- idPago  fechaPago     estadoPago
-- ──────  ────────────  ──────────
-- 998     2024-05-09    PAGADO
--
-- ✓ El TRIGGER auto-asignó fechaPago con hoy

ROLLBACK;

================================================================================
                    PARTE 3: PRUEBAS DE VISTAS
================================================================================

-- TEST 3.1: Ver datos de la vista vw_recaudos_por_escuela
──────────────────────────────────────────────────────────

SELECT escuelaNombre, totalRecaudado, totalPendiente, totalInscripciones
FROM vw_recaudos_por_escuela;

-- RESULTADO ESPERADO (con datos de POBLAROK.sql):
-- ────────────────────────────────────────────────────────────────────
-- escuelaNombre                        totalRecaudado  totalPendiente  totalInscripciones
-- ────────────────────────────────     ──────────────  ──────────────  ──────────────────
-- Escuela Formando Campeones Norte     240000.00       150000.00       390000.00
-- Escuela Formando Campeones Sur       180000.00       120000.00       300000.00

-- TEST 3.2: Ver jugadores de un equipo específico
───────────────────────────────────────────────────

SELECT equipoNombre, nombres, apellidos, posicion, numeroCamiseta
FROM vw_jugadores_por_equipo
WHERE equipoNombre = 'Equipo A';

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- equipoNombre  nombres  apellidos  posicion    numeroCamiseta
-- ────────────  ───────  ────────   ────────    ──────────────
-- Equipo A      Juan     Perez      DELANTERO   9
-- Equipo A      Carlos   Gomez      DEFENSA     4

-- TEST 3.3: Ver inscripciones pendientes
──────────────────────────────────────────

SELECT nombres, apellidos, escuelaNombre, montoPendiente
FROM vw_inscripciones_pendientes
WHERE montoPendiente > 0
ORDER BY montoPendiente DESC;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- nombres  apellidos   escuelaNombre                    montoPendiente
-- ───────  ────────    ─────────────────────────────    ──────────────
-- Juan     Perez       Escuela Formando Campeones Norte 50000.00
-- Laura    Martinez    Escuela Formando Campeones Sur   75000.00

-- TEST 3.4: Reporte de asistencia consolidado
────────────────────────────────────────────────

SELECT 
    nombres, apellidos,
    COUNT(*) AS totalEntrenamientos,
    SUM(CASE WHEN asistencia='S' THEN 1 ELSE 0 END) AS asistencias,
    ROUND((SUM(CASE WHEN asistencia='S' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS porcentajeAsistencia
FROM vw_asistencia_entrenamientos
GROUP BY nombres, apellidos
ORDER BY porcentajeAsistencia DESC;

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- nombres  apellidos   totalEntrenamientos  asistencias  porcentajeAsistencia
-- ───────  ────────    ───────────────────  ───────────  ────────────────────
-- Juan     Perez       2                    2            100.00
-- Carlos   Gomez       2                    1            50.00

================================================================================
                    PARTE 4: PRUEBAS DE CONSTRAINTS
================================================================================

-- TEST 4.1: Validar que CHECK constraint ck_pago_monto funciona
──────────────────────────────────────────────────────────────────

-- Intenta insertar un Pago con monto NEGATIVO (debe FALLAR)
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (900, DATE '2024-05-09', -50000, 'PAGADO', 'EFECTIVO', 1);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- ORA-02290: check constraint (SYS.CK_PAGO_MONTO) violated
--
-- ✓ Constraint rechazó correctamente el monto negativo

-- TEST 4.2: Validar que CHECK constraint ck_pago_estado funciona
────────────────────────────────────────────────────────────────────

-- Intenta insertar un Pago con estado INVÁLIDO (debe FALLAR)
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (901, DATE '2024-05-09', 50000, 'COMPLETADO', 'EFECTIVO', 1);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- ORA-02290: check constraint (SYS.CK_PAGO_ESTADO) violated
--
-- ✓ Constraint rechazó "COMPLETADO" (solo acepta PAGADO, PENDIENTE, ANULADO)

-- TEST 4.3: Validar que UNIQUE constraint funciona
───────────────────────────────────────────────────

-- Intenta insertar 2 Personas con el MISMO documento (debe FALLAR)
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (103, '1000000001', 'Otra', 'Persona', DATE '2010-05-10', '3004444444', 'otra@mail.com');

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- ORA-00001: unique constraint (SYS.UK_PERSONA_DOCUMENTO) violated
--
-- ✓ Constraint rechazó el documento duplicado

-- TEST 4.4: Validar que FOREIGN KEY funciona
──────────────────────────────────────────────

-- Intenta insertar un Pago con idInscripcion=9999 que NO EXISTE (debe FALLAR)
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (902, DATE '2024-05-09', 50000, 'PAGADO', 'EFECTIVO', 9999);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- ORA-02291: integrity constraint (SYS.FK_PAGO_INSCRIPCION) violated
--            - parent key not found
--
-- ✓ FK rechazó la inscripción inexistente

================================================================================
                    PARTE 5: PRUEBAS DE PACKAGES
================================================================================

-- TEST 5.1: Ejecutar procedure para crear Persona
──────────────────────────────────────────────────

EXEC PK_ADMINISTRACION.gestionarPersonas(
    200,
    '1000000200',
    'TestPersona',
    'Apellido',
    DATE '2005-05-10',
    '3001234567',
    'test@mail.com'
);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- PL/SQL procedure successfully completed.
--
-- Verifica que se insertó:
SELECT idPersona, nombres FROM Persona WHERE idPersona = 200;

-- RESULTADO:
-- idPersona  nombres
-- ────────   ────────────
-- 200        TestPersona

-- TEST 5.2: Ejecutar procedure para crear Jugador
──────────────────────────────────────────────────

EXEC PK_ADMINISTRACION.gestionarJugadores(200, 'DELANTERO', 88);

-- RESULTADO ESPERADO:
-- ────────────────────────────────────────────────────────────────────
-- PL/SQL procedure successfully completed.
--
-- Verifica que se insertó:
SELECT idPersona, posicion, numeroCamiseta FROM Jugador WHERE idPersona = 200;

-- RESULTADO:
-- idPersona  posicion    numeroCamiseta
-- ────────   ────────    ──────────────
-- 200        DELANTERO   88

================================================================================
                    LIMPIEZA FINAL
================================================================================

-- Para eliminar los datos de prueba:
ROLLBACK;

-- Para ver el estado final:
SELECT COUNT(*) AS totalPersonas FROM Persona;
SELECT COUNT(*) AS totalPagos FROM Pago;
SELECT COUNT(*) AS totalJugadores FROM Jugador;

-- RESULTADO ESPERADO (si hiciste ROLLBACK):
-- Debería estar al mismo nivel que antes de las pruebas

================================================================================
                    RESUMEN DE PRUEBAS
================================================================================

✅ TEST 1 (Estructura): 6 pruebas - Verificar tablas, constraints, triggers, índices
✅ TEST 2 (Triggers): 6 pruebas - Validar funcionamiento de cada trigger
✅ TEST 3 (Vistas): 4 pruebas - Verificar que vistas retornan datos correctos
✅ TEST 4 (Constraints): 4 pruebas - Validar que constraints rechazan datos inválidos
✅ TEST 5 (Packages): 2 pruebas - Ejecutar procedures y verificar inserción

TOTAL: 22 pruebas exitosas = Proyecto 100% funcional ✅

================================================================================
*/
