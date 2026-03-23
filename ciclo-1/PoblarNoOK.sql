/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Intentos de ingreso incorrectos para probar restricciones por tipos de datos, nulidades, claves primarias, únicas y foráneas.
   IMPORTANTE: Ejecutar sentencia por sentencia, porque  todas deben fallar intencionalmente. */

/* ERRORES POR CLAVE PRIMARIA */

/* ERROR por PRIMARY KEY duplicada en Persona */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (1, '1000000010', 'Mario', 'Rojas', '2012-01-01', '3009999999', 'mario.rojas@mail.com');

/* ERROR por PRIMARY KEY compuesta duplicada en Participante */
INSERT INTO Participante (idPersona, idEntrenamiento)
VALUES (1, 1);

/* ERROR por UNIQUE duplicada en documento */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (10, '1000000001', 'Mario', 'Rojas', '2012-01-01', '3009999999', 'mario2.rojas@mail.com');

/* ERROR por UNIQUE duplicada en correo de Persona */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (11, '1000000011', 'Sara', 'Nuñez', '2011-02-02', '3008888888', 'juan.perez@mail.com');

/* ERROR por UNIQUE duplicada en dirección de Escuela */
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (10, 'Escuela Duplicada', 'Calle 10 # 15-20', '6015555555', 'duplicada1@campeones.com');

/* ERROR por UNIQUE duplicada en correo de Escuela */
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (11, 'Escuela Correo Repetido', 'Calle 99 # 88-77', '6016666666', 'norte@campeones.com');

/* ERRORES POR CLAVE FORANEA */

/* ERROR por FOREIGN KEY inexistente en Jugador */
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (99, 'PORTERO', 1);

/* ERROR por FOREIGN KEY inexistente en Equipo.idEscuela */
INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (12, 'Leones Centro', 'ACTIVO', 99, 1);

/* ERROR por FOREIGN KEY inexistente en Equipo.idCategoria */
INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (13, 'Leones Centro', 'ACTIVO', 1, 99);

/* ERROR por FOREIGN KEY inexistente en Inscripcion.idPersona */
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (20, '2024-02-10', 'ACTIVA', 99, 1);

/* ERROR por FOREIGN KEY inexistente en Pago.idInscripcion */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, idInscripcion, metodoPago)
VALUES (20, '2024-02-12', 150000.00, 'PAGADO', 999, 'EFECTIVO');

/* ERROR por FOREIGN KEY inexistente en Entrenamiento.idEquipo */
INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (20, '2024-03-10', '10:00:00', 'Cancha Central', 'PROGRAMADO', 999);

/* ERROR por FOREIGN KEY inexistente en Participante.idPersona */
INSERT INTO Participante (idPersona, idEntrenamiento)
VALUES (999, 1);

/* ERROR por FOREIGN KEY inexistente en Participante.idEntrenamiento */
INSERT INTO Participante (idPersona, idEntrenamiento)
VALUES (1, 999);

/* ERRORES POR NULIDAD (NOT NULL) */

/* ERROR por nulidad en Persona.documento */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (30, NULL, 'Luis', 'Ramirez', '2011-01-01', '3007777777', 'luis.ramirez@mail.com');

/* ERROR por nulidad en Persona.nombres */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (31, '1000000031', NULL, 'Diaz', '2011-03-15', '3001231234', 'marta.diaz@mail.com');

/* ERROR por nulidad en Escuela.nombre */
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (30, NULL, 'Calle Falsa 123', '6019999999', 'escuela30@mail.com');

/* ERROR por nulidad en Pago.metodoPago */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, idInscripcion, metodoPago)
VALUES (30, '2024-02-15', 50000.00, 'PAGADO', 1, NULL);

/* ERRORES POR TIPO DE DATO */

/* ERROR por tipo de dato en Persona.fechaNacimiento */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (32, '1000000032', 'Marta', 'Diaz', 'texto_invalido', '3006666666', 'marta2.diaz@mail.com');

/* ERROR por tipo de dato en Pago.monto */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, idInscripcion, metodoPago)
VALUES (31, '2024-02-15', 'monto_mal', 'PAGADO', 1, 'EFECTIVO');

/* ERROR por tipo de dato en Entrenamiento.hora */
INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (31, '2024-03-12', 'hora_invalida', 'Cancha Norte', 'PROGRAMADO', 1);

/* ERRORES POR CHECK */

/* ERROR por CHECK numeroCamiseta */
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (1, 'PORTERO', 0);

/* ERROR por CHECK estadoEquipo */
INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (14, 'Leones Centro', 'SUSPENDIDO', 1, 1);

/* ERROR por CHECK estadoInscripcion */
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (21, '2024-02-10', 'EN_REVISION', 1, 1);

/* ERROR por CHECK monto */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, idInscripcion, metodoPago)
VALUES (21, '2024-02-12', -5000.00, 'PAGADO', 1, 'EFECTIVO');

/* ERROR por CHECK estadoPago */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, idInscripcion, metodoPago)
VALUES (22, '2024-02-12', 50000.00, 'EN_PROCESO', 1, 'EFECTIVO');

/* ERROR por CHECK metodoPago */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, idInscripcion, metodoPago)
VALUES (23, '2024-02-12', 50000.00, 'PAGADO', 1, 'CHEQUE');

/* ERROR por CHECK estado de entrenamiento */
INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (21, '2024-03-10', '10:00:00', 'Cancha Central', 'APLAZADO', 1);