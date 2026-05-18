/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Probar TODAS las 5 acciones de referencia */

/*Crear datos de prueba para los procedimientos*/
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (400, 'Escuela Acciones Test', 'Calle Test Acciones 1', '3009900401', 'test400@acciones.com');

INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
VALUES (400, 'SUB14', 'Categoria Test Acciones', 'BASICO');

INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (400, 'Equipo Acciones 400', 'ACTIVO', 400, 400);

INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (400, DATE '2024-05-25', TIMESTAMP '2024-05-25 18:00:00', 'Cancha Test', 'PROGRAMADO', 400);

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (400, '1000000400', 'Test', 'Acciones', DATE '2010-05-10', '3009900402', 'test400@mail.com');

INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (400, DATE '2024-04-01', 'ACTIVA', 400, 400);

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (400, 400, 'S', 'JUGADOR', 'Test participante');

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (400, 400, 'S', 'Test recibe');

INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (400, DATE '2024-04-01', 120000.00, 'PAGADO', 'EFECTIVO', 400);

COMMIT;

/* ACCION 1: Participante a Entrenamiento (CASCADE) 
TEST 1: DELETE Entrenamiento 400 borra Participante en CASCADE*/
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
SELECT COUNT(*) AS "Participantes tras delete" FROM Participante WHERE idEntrenamiento = 400;
ROLLBACK;

/* ACCION 2: Recibe a Entrenamiento (CASCADE)
TEST 2: DELETE Entrenamiento borra Recibe en CASCADE */
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
SELECT COUNT(*) AS "Recibe tras delete" FROM Recibe WHERE idEntrenamiento = 400;
ROLLBACK;

/* ACCION 3: Entrenamiento a Equipo (CASCADE) 
TEST 3: DELETE Equipo borra Entrenamiento en CASCADE*/
DELETE FROM Equipo WHERE idEquipo = 400;
SELECT COUNT(*) AS "Entrenamientos tras delete" FROM Entrenamiento WHERE idEquipo = 400;
ROLLBACK;

/* ACCION 4: Equipo a Escuela (ON DELETE CASCADE)
TEST 4: DELETE Escuela elimina automaticamente Equipo en CASCADE*/
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
DELETE FROM Pago WHERE idPago = 400;
DELETE FROM Inscripcion WHERE idInscripcion = 400;
DELETE FROM Escuela WHERE idEscuela = 400;
SELECT COUNT(*) AS "Equipos tras delete" FROM Equipo WHERE idEscuela = 400;
ROLLBACK;

/* ACCION 5: Pago a Inscripcion (SET NULL)
TEST 5: DELETE Inscripcion deja idInscripcion en NULL en Pago */
/* Verificar que el pago tiene la inscripcion */
SELECT idPago, idInscripcion FROM Pago WHERE idPago = 400;
/* Borrar la inscripcion padre (activa ON DELETE SET NULL) */
DELETE FROM Inscripcion WHERE idInscripcion = 400;
/* Verificar que el pago sigue existiendo pero con idInscripcion en NULL*/
SELECT idPago, idInscripcion FROM Pago WHERE idPago = 400;
ROLLBACK;

/* Limpiar */
DELETE FROM Pago WHERE idPago = 400;
DELETE FROM Participante WHERE idPersona = 400;
DELETE FROM Recibe WHERE idEquipo = 400;
DELETE FROM Inscripcion WHERE idInscripcion = 400;
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
DELETE FROM Persona WHERE idPersona = 400;
DELETE FROM Equipo WHERE idEquipo = 400;
DELETE FROM Escuela WHERE idEscuela = 400;
DELETE FROM Categoria WHERE idCategoria = 400;
COMMIT;