/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Pruebas incorrectas de disparadores */

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (20, '1000000020', 'Nino', 'Pequeno', DATE '2022-01-01', '3002020202', 'nino@mail.com');

INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
VALUES (20, 'DELANTERO', 11);