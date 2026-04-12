/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Probar acciones de referencia */

DELETE FROM Entrenamiento
WHERE idEntrenamiento = 1;

/* Verificacion */
SELECT * FROM Participante WHERE idEntrenamiento = 1;
SELECT * FROM Recibe WHERE idEntrenamiento = 1;

ROLLBACK;