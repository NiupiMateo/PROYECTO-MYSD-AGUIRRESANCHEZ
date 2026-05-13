/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Restricciones de tupla */

/* Si el participante asistio, debe registrar observacion */
ALTER TABLE Participante
ADD CONSTRAINT ck_participante_asistencia_obs
CHECK (
    (asistencia = 'S' AND observaciones IS NOT NULL)
    OR
    (asistencia = 'N')
);

/* Si el equipo asistio al entrenamiento, debe registrar observacion */
ALTER TABLE Recibe
ADD CONSTRAINT ck_recibe_asistencia_obs
CHECK (
    (asistencia = 'S' AND observaciones IS NOT NULL)
    OR
    (asistencia = 'N')
);

/* Si el pago esta anulado, el monto debe ser mayor que 0 igualmente
   y el estado debe ser uno de los definidos */
ALTER TABLE Pago
ADD CONSTRAINT ck_pago_estado_monto
CHECK (
    (estadoPago IN ('PAGADO', 'PENDIENTE', 'ANULADO'))
    AND monto > 0
);