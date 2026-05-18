/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Probar TODOS los 6 disparadores */

/*SETUP: Crear datos de prueba para los procedimientos*/INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (600, '1000000600', 'Test', 'Disparador1', DATE '2015-05-10', '3009900020', 'test600@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (601, '1000000601', 'Test', 'Disparador2', DATE '2014-03-22', '3009900021', 'test601@mail.com');

INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (600, DATE '2024-04-01', 'PENDIENTE', 600, 1);

INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (601, DATE '2024-04-01', 'PENDIENTE', 601, 1);

INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (600, DATE '2024-05-27', TIMESTAMP '2024-05-27 17:00:00', 'Cancha Test', 'PROGRAMADO', 1);

COMMIT;

/* TRIGGER 1: trg_validar_edad_jugador
   Valida que edad >= 5 años
   TEST 1: Crear Jugador con edad >= 5 (DEBE PASAR)*/
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (600, 'DELANTERO', 77);
SELECT * FROM Jugador WHERE idPersona = 600;
DELETE FROM Jugador WHERE idPersona = 600;
COMMIT;

/* TRIGGER 2: trg_obs_participante
   Auto-completa observaciones si asistencia='N'
   TEST 2: Participante con asistencia=N auto-completa observaciones */
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (600, 600, 'N', 'JUGADOR', NULL);
SELECT observaciones FROM Participante WHERE idPersona = 600 AND idEntrenamiento = 600;
DELETE FROM Participante WHERE idPersona = 600 AND idEntrenamiento = 600;
COMMIT;

/* TRIGGER 3: trg_obs_recibe
   Auto-completa observaciones si asistencia='N'
   TEST 3: Recibe con asistencia=N auto-completa observaciones */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (600, 1, 'N', NULL);
SELECT observaciones FROM Recibe WHERE idEntrenamiento = 600 AND idEquipo = 1;
DELETE FROM Recibe WHERE idEntrenamiento = 600 AND idEquipo = 1;
COMMIT;

/* TRIGGER 4: trg_actualizar_estado_inscripcion
   Actualiza Inscripcion a ACTIVA cuando Pago=PAGADO
   TEST 4: Crear Pago PAGADO actualiza Inscripcion a ACTIVA */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (600, SYSDATE, 120000.00, 'PAGADO', 'EFECTIVO', 600);
COMMIT;
SELECT estadoInscripcion FROM Inscripcion WHERE idInscripcion = 600;
DELETE FROM Pago WHERE idPago = 600;
UPDATE Inscripcion SET estadoInscripcion = 'PENDIENTE' WHERE idInscripcion = 600;
COMMIT;

/* TRIGGER 5: trg_validar_numero_camiseta_equipo
   Valida unicidad de numero de camiseta por escuela
   TEST 5: Crear Jugador con numero camiseta unico en escuela */
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (601, 'DEFENSA', 88);
SELECT * FROM Jugador WHERE idPersona = 601;
DELETE FROM Jugador WHERE idPersona = 601;
COMMIT;

/* TRIGGER 6: trg_fecha_pago_automatica
   Autoasigna SYSDATE si fechaPago es NULL y estado=PAGADO
   TEST 6: Crear Pago sin fechaPago auto-completa con SYSDATE */
INSERT INTO Pago (idPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (601, 150000.00, 'PAGADO', 'TRANSFERENCIA', 601);
SELECT fechaPago FROM Pago WHERE idPago = 601;
DELETE FROM Pago WHERE idPago = 601;
COMMIT;

/* Limpiar */
DELETE FROM Pago WHERE idPago IN (600, 601);
DELETE FROM Entrenamiento WHERE idEntrenamiento = 600;
DELETE FROM Inscripcion WHERE idInscripcion IN (600, 601);
DELETE FROM Persona WHERE idPersona IN (600, 601);
COMMIT;