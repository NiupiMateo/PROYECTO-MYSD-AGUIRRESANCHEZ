/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Ingreso de datos correctos */

/* PERSONAS */
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (1, '1000000001', 'Juan', 'Perez', DATE '2010-05-10', '3001111111', 'juan.perez@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (2, '1000000002', 'Carlos', 'Gomez', DATE '2011-03-22', '3002222222', 'carlos.gomez@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (3, '1000000003', 'Laura', 'Martinez', DATE '1985-08-18', '3003333333', 'laura.martinez@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (4, '1000000004', 'Ana', 'Rodriguez', DATE '1978-11-02', '3004444444', 'ana.rodriguez@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (5, '1000000005', 'Pedro', 'Lopez', DATE '1980-07-14', '3005555555', 'pedro.lopez@mail.com');


/* SUBTIPOS */
INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (1, 'DELANTERO', 9);

INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (2, 'DEFENSA', 4);

INSERT INTO Acudiente (idPersona, parentesco)
VALUES (3, 'MADRE');

INSERT INTO Administrador (idPersona, fechaRegistro)
VALUES (4, DATE '2024-01-10');

INSERT INTO Entrenador (idPersona, experiencia, especialidad)
VALUES (5, '8 anos dirigiendo procesos formativos', 'TACTICA');


/* ESCUELAS */
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (1, 'Escuela Formando Campeones Norte', 'Calle 10 # 15-20', '6011111111', 'norte@campeones.com');

INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (2, 'Escuela Formando Campeones Sur', 'Carrera 20 # 30-40', '6012222222', 'sur@campeones.com');


/* CATEGORIAS */
INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
VALUES (1, 'SUB12', 'Categoria infantil menores de 12', 'BASICO');

INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
VALUES (2, 'SUB14', 'Categoria juvenil menores de 14', 'INTERMEDIO');


/* EQUIPOS */
INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (1, 'Halcones Norte', 'ACTIVO', 1, 1);

INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (2, 'Tigres Sur', 'ACTIVO', 2, 2);


/* INSCRIPCIONES */
INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (1, DATE '2024-02-01', 'ACTIVA', 1, 1);

INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (2, DATE '2024-02-03', 'ACTIVA', 2, 2);


/* PAGOS */
INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (1, DATE '2024-02-05', 120000.00, 'PAGADO', 'EFECTIVO', 1);

INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (2, DATE '2024-02-06', 120000.00, 'PENDIENTE', 'TRANSFERENCIA', 2);


/* ENTRENAMIENTOS */
INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (
    1,
    DATE '2024-03-01',
    TO_TIMESTAMP('2024-03-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'Cancha Norte',
    'PROGRAMADO',
    1
);

INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (
    2,
    DATE '2024-03-02',
    TO_TIMESTAMP('2024-03-02 09:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    'Cancha Sur',
    'PROGRAMADO',
    2
);


/* PARTICIPANTES */
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (1, 1, 'S', 'JUGADOR', 'Asistio al entrenamiento');

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (2, 2, 'S', 'JUGADOR', 'Asistio al entrenamiento');

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (5, 1, 'S', 'ENTRENADOR', 'Dirigio la sesion');

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (5, 2, 'S', 'ENTRENADOR', 'Dirigio la sesion');


/* RECIBE */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (1, 1, 'S', 'El equipo asistio al entrenamiento');

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (2, 2, 'S', 'El equipo asistio al entrenamiento');
