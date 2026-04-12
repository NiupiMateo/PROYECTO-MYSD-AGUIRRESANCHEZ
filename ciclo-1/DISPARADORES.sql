/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Disparadores */

CREATE OR REPLACE TRIGGER trg_validar_edad_jugador
BEFORE INSERT ON Jugador
FOR EACH ROW
DECLARE
    v_fecha DATE;
    v_edad NUMBER;
BEGIN
    SELECT fechaNacimiento
    INTO v_fecha
    FROM Persona
    WHERE idPersona = :NEW.idPersona;

    v_edad := FLOOR(MONTHS_BETWEEN(SYSDATE, v_fecha) / 12);

    IF v_edad < 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El jugador debe tener al menos 5 anos.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_obs_participante
BEFORE INSERT ON Participante
FOR EACH ROW
BEGIN
    IF :NEW.asistencia = 'N' AND :NEW.observaciones IS NULL THEN
        :NEW.observaciones := 'No asistio al entrenamiento';
    END IF;
END;
/