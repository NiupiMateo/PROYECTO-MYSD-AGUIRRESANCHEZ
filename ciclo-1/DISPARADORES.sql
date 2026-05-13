/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Disparadores */

/*Valida que un jugador tenga mínimo 5 años antes de registrarse*/
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

/*Agrega automáticamente una observación cuando un participante no asiste*/
CREATE OR REPLACE TRIGGER trg_obs_participante
BEFORE INSERT ON Participante
FOR EACH ROW
BEGIN
    IF :NEW.asistencia = 'N' AND :NEW.observaciones IS NULL THEN
        :NEW.observaciones := 'No asistio al entrenamiento';
    END IF;
END;
/

/*Agrega automáticamente una observación cuando un equipo no asiste*/
CREATE OR REPLACE TRIGGER trg_obs_recibe
BEFORE INSERT ON Recibe
FOR EACH ROW
BEGIN
    IF :NEW.asistencia = 'N' AND :NEW.observaciones IS NULL THEN
        :NEW.observaciones := 'Equipo no asistio al entrenamiento';
    END IF;
END;
/

/*Actualiza automáticamente el estado de inscripción cuando un pago es PAGADO*/
CREATE OR REPLACE TRIGGER trg_actualizar_estado_inscripcion
AFTER INSERT ON Pago
FOR EACH ROW
BEGIN
    IF :NEW.estadoPago = 'PAGADO' THEN
        UPDATE Inscripcion
        SET estadoInscripcion = 'ACTIVA'
        WHERE idInscripcion = :NEW.idInscripcion;
    END IF;
END;
/

/*Valida que el número de camiseta sea único dentro de una escuela*/
CREATE OR REPLACE TRIGGER trg_validar_numero_camiseta_equipo
BEFORE INSERT ON Jugador
FOR EACH ROW
DECLARE
    v_existe NUMBER;
    v_id_escuela NUMBER;
BEGIN
    /*Obtiene la escuela asociada al jugador*/
    SELECT idEscuela INTO v_id_escuela
    FROM Inscripcion
    WHERE idPersona = :NEW.idPersona
    AND ROWNUM = 1;
    
    /*verifica que el número de camiseta no esté repetido*/
    SELECT COUNT(*) INTO v_existe
    FROM Jugador j
    JOIN Inscripcion i ON j.idPersona = i.idPersona
    WHERE j.numeroCamiseta = :NEW.numeroCamiseta
    AND i.idEscuela = v_id_escuela
    AND j.idPersona != :NEW.idPersona;
    
    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El numero de camiseta ya existe en esta equipo.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'El jugador debe tener una inscripcion antes de ser registrado como jugador.');
END;
/

/*Asigna automáticamente la fecha actual cuando un pago PAGADO no tiene fecha*/
CREATE OR REPLACE TRIGGER trg_fecha_pago_automatica
BEFORE INSERT ON Pago
FOR EACH ROW
BEGIN
    IF :NEW.estadoPago = 'PAGADO' AND :NEW.fechaPago IS NULL THEN
        :NEW.fechaPago := SYSDATE;
    END IF;
END;
/