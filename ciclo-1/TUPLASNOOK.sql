/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Ingreso incorrecto respecto a restricciones de tupla */

/* ERROR TEST 1: Participante con asistencia=S pero sin observaciones (debe fallar) */
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (2, 2, 'S', 'JUGADOR', NULL);

/* ERROR TEST 2: Recibe con asistencia=S pero sin observaciones (debe fallar) */
INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (1, 1, 'S', NULL);