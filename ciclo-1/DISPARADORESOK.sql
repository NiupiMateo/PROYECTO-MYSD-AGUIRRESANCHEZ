/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Pruebas correctas de disparadores */

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (2, 1, 'N', 'JUGADOR', NULL);

SELECT *
FROM Participante
WHERE idPersona = 2
  AND idEntrenamiento = 1;

ROLLBACK;