/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Pruebas NEGATIVAS (que demuestren errores) de los 6 disparadores */

/* ERROR TRIGGER 1: trg_validar_edad_jugador
   TEST 1: Intentar insertar Jugador con edad < 5 anos (DEBE FALLAR) */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (800, '1000000800', 'Nino', 'MuyPequeno', DATE '2023-01-01', '3008800001', 'nino800@mail.com');
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (800, DATE '2024-04-01', 'PENDIENTE', 800, 1);
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (800, 'DELANTERO', 11);
ROLLBACK;

/* ERROR TRIGGER 2: trg_obs_participante - (este trigger ACEPTA, no rechaza)
   TEST 2: Intentar insertar Participante con rol inválido (DEBE FALLAR por CHECK) */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (801, '1000000801', 'Test', 'Negativo2', DATE '2010-05-10', '3008800002', 'test801@mail.com');
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (801, DATE '2024-04-01', 'PENDIENTE', 801, 1);
INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (800, DATE '2024-05-27', TIMESTAMP '2024-05-27 17:00:00', 'Cancha Test', 'PROGRAMADO', 1);
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (801, 800, 'N', 'ROL_INVALIDO', NULL);
ROLLBACK;

/* ERROR TRIGGER 3: trg_obs_recibe - (este trigger ACEPTA, no rechaza)
   TEST 3: Intentar insertar Recibe con rol inválido (DEBE FALLAR por CHECK) */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (800, 1, 'N', NULL);
DELETE FROM Recibe WHERE idEntrenamiento = 800 AND idEquipo = 1;
COMMIT;

/* ERROR TRIGGER 4: trg_validar_numero_camiseta_equipo
   TEST 4: Intentar insertar Jugador con numero camiseta duplicado (DEBE FALLAR) */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (802, '1000000802', 'Otro', 'Jugador', DATE '2012-03-15', '3008800003', 'otro802@mail.com');
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (802, DATE '2024-04-01', 'PENDIENTE', 802, 1);
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (802, 'DEFENSA', 9);
ROLLBACK;

/* ERROR TRIGGER 5: trg_actualizar_estado_inscripcion - (este NO falla, solo actualiza)
   TEST 5: Intentar insertar Pago con idInscripcion que no existe (DEBE FALLAR por FK) */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (800, DATE '2024-04-05', 120000.00, 'PAGADO', 'EFECTIVO', 9999);
ROLLBACK;

/* ERROR TRIGGER 6: trg_fecha_pago_automatica - (este NO falla, solo asigna fecha)
   TEST 6: Intentar insertar Pago con monto negativo (DEBE FALLAR por CHECK) */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (803, '1000000803', 'Test', 'Negativo6', DATE '2010-05-10', '3008800004', 'test803@mail.com');
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (803, DATE '2024-04-01', 'PENDIENTE', 803, 1);
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (803, DATE '2024-04-06', -50000.00, 'PAGADO', 'TRANSFERENCIA', 803);
ROLLBACK;