/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Ingreso incorrecto respecto a restricciones de tupla (3 tests) */

/* ERROR TEST 1: Participante con asistencia=S pero sin observaciones (DEBE FALLAR) */
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (2, 2, 'S', 'JUGADOR', NULL);
ROLLBACK;

/* ERROR TEST 2: Recibe con asistencia=S pero sin observaciones (DEBE FALLAR) */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (1, 1, 'S', NULL);
ROLLBACK;

/* ERROR TEST 3: Pago con monto negativo (DEBE FALLAR por ck_pago_estado_monto) */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (999, DATE '2024-04-01', -50000.00, 'PAGADO', 'EFECTIVO', 1);
ROLLBACK;