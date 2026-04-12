/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Acciones de referencia */

ALTER TABLE Participante DROP CONSTRAINT fk_participante_entrenamiento;
ALTER TABLE Recibe DROP CONSTRAINT fk_recibe_entrenamiento;

ALTER TABLE Participante
ADD CONSTRAINT fk_participante_entrenamiento
FOREIGN KEY (idEntrenamiento)
REFERENCES Entrenamiento(idEntrenamiento)
ON DELETE CASCADE;

ALTER TABLE Recibe
ADD CONSTRAINT fk_recibe_entrenamiento
FOREIGN KEY (idEntrenamiento)
REFERENCES Entrenamiento(idEntrenamiento)
ON DELETE CASCADE;