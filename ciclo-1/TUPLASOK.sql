/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Probar TODAS las 3 restricciones de tupla */

/Crear datos de prueba para procedimientos*/
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (500, '1000000500', 'Test', 'Tuplas1', DATE '2010-05-10', '3009900010', 'test500@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (501, '1000000501', 'Test', 'Tuplas2', DATE '2011-03-22', '3009900011', 'test501@mail.com');

INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (500, DATE '2024-05-26', TIMESTAMP '2024-05-26 16:00:00', 'Cancha Test', 'PROGRAMADO', 1);

COMMIT;

/* TEST 1.1: Participante con asistencia=S y observaciones (pasa) */
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (500, 500, 'S', 'JUGADOR', 'Excelente asistencia');
SELECT * FROM Participante WHERE idPersona = 500 AND idEntrenamiento = 500;
DELETE FROM Participante WHERE idPersona = 500 AND idEntrenamiento = 500;
COMMIT;

/* TEST 1.2: Participante con asistencia=N y observaciones NULL (pasa) */
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (501, 500, 'N', 'JUGADOR', NULL);
SELECT observaciones FROM Participante WHERE idPersona = 501 AND idEntrenamiento = 500;
DELETE FROM Participante WHERE idPersona = 501 AND idEntrenamiento = 500;
COMMIT;

/* TEST 2.1: Recibe con asistencia=S y observaciones (pasa) */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (500, 1, 'S', 'Equipo asistio correctamente');
SELECT * FROM Recibe WHERE idEntrenamiento = 500 AND idEquipo = 1;
DELETE FROM Recibe WHERE idEntrenamiento = 500 AND idEquipo = 1;
COMMIT;

/* TEST 2.2: Recibe con asistencia=N y observaciones NULL (pasa) */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (500, 1, 'N', NULL);
SELECT observaciones FROM Recibe WHERE idEntrenamiento = 500 AND idEquipo = 1;
DELETE FROM Recibe WHERE idEntrenamiento = 500 AND idEquipo = 1;
COMMIT;

/* TEST 3.1: Pago con estadoPago=PAGADO y monto > 0 (pasa) */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (500, SYSDATE, 150000.00, 'PAGADO', 'TRANSFERENCIA', 1);
SELECT * FROM Pago WHERE idPago = 500;
DELETE FROM Pago WHERE idPago = 500;
COMMIT;

/* TEST 3.2: Pago con estadoPago=PENDIENTE y monto > 0 (pasa) */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (501, SYSDATE, 100000.00, 'PENDIENTE', 'EFECTIVO', 1);
SELECT * FROM Pago WHERE idPago = 501;
DELETE FROM Pago WHERE idPago = 501;
COMMIT;

/* TEST 3.3: Pago con estadoPago=ANULADO y monto > 0 (pasa) */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (502, SYSDATE, 50000.00, 'ANULADO', 'TARJETA', 1);
SELECT * FROM Pago WHERE idPago = 502;
DELETE FROM Pago WHERE idPago = 502;
COMMIT;

/* Limpiar */
DELETE FROM Entrenamiento WHERE idEntrenamiento = 500;
DELETE FROM Persona WHERE idPersona IN (500, 501);
COMMIT;
