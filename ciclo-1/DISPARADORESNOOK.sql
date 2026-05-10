/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Pruebas incorrectas de disparadores */

/*  ERROR TRIGGER 1  */
/* Intentar insertar jugador con edad < 5 anos (debe fallar) */

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (20, '1000000020', 'Nino', 'Pequeno', DATE '2022-01-01', '3002020202', 'nino@mail.com');

INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (20, 'DELANTERO', 11);

ROLLBACK;


/*  ERROR TRIGGER 2  */
/* Intentar insertar Participante con rol inválido (debe fallar por CHECK) */

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (1, 1, 'N', 'ROL_INVALIDO', NULL);

ROLLBACK;


/*  ERROR TRIGGER 3  */
/* Intentar insertar jugador con numero de camiseta duplicado (debe fallar) */

INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (2, 'DEFENSA', 9);

ROLLBACK;


/*  ERROR TRIGGER 4  */
/* Intentar insertar Pago con idInscripcion que no existe (debe fallar por FK) */

INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (200, DATE '2024-04-05', 120000.00, 'PAGADO', 'EFECTIVO', 9999);

ROLLBACK;


/*  ERROR TRIGGER 5  */
/* Intentar insertar Pago con monto negativo (debe fallar por CHECK) */

INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (201, DATE '2024-04-06', -50000.00, 'PAGADO', 'TRANSFERENCIA', 1);

ROLLBACK;