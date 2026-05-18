/* PROYECTO: Formando Campeones CRUDI
   CICLO 1 - IMPLEMENTACIÓN SEGÚN UML
   OBJETIVO: Implementación de 6 packages de componentes + 2 de apoyo
*/

/* PACKAGE BODY: PC_PERSONA */
CREATE OR REPLACE PACKAGE BODY PC_PERSONA AS

  PROCEDURE AD_PERSONA(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Persona WHERE documento = p_documento;
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20014, 'Documento ya existe: ' || p_documento);
    END IF;
    INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
    VALUES (p_idPersona, p_documento, p_nombres, p_apellidos, p_fechaNacimiento, p_telefono, p_correo);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20017, 'ID Persona duplicado: ' || p_idPersona);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20018, 'Error en AD_PERSONA: ' || SQLERRM);
  END AD_PERSONA;

  PROCEDURE MO_PERSONA(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  ) IS
  BEGIN
    UPDATE Persona
    SET documento = p_documento,
        nombres = p_nombres,
        apellidos = p_apellidos,
        fechaNacimiento = p_fechaNacimiento,
        telefono = p_telefono,
        correo = p_correo
    WHERE idPersona = p_idPersona;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20021, 'Persona no encontrada: ' || p_idPersona);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20022, 'Error en MO_PERSONA: ' || SQLERRM);
  END MO_PERSONA;

  PROCEDURE EL_PERSONA(p_idPersona IN NUMBER) IS
  BEGIN
    DELETE FROM Persona WHERE idPersona = p_idPersona;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20024, 'Persona no encontrada: ' || p_idPersona);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20025, 'Error en EL_PERSONA: ' || SQLERRM);
  END EL_PERSONA;

  FUNCTION CO_PERSONA RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo
    FROM Persona
    ORDER BY nombres, apellidos;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20026, 'Error en CO_PERSONA: ' || SQLERRM);
  END CO_PERSONA;

END PC_PERSONA;
/

/* PACKAGE BODY: PC_EQUIPO */
CREATE OR REPLACE PACKAGE BODY PC_EQUIPO AS

  PROCEDURE AD_EQUIPO(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Escuela WHERE idEscuela = p_idEscuela;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20027, 'Escuela no existe: ' || p_idEscuela);
    END IF;
    SELECT COUNT(*) INTO v_count FROM Categoria WHERE idCategoria = p_idCategoria;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20028, 'Categoría no existe: ' || p_idCategoria);
    END IF;

    INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
    VALUES (p_idEquipo, p_nombre, p_estadoEquipo, p_idEscuela, p_idCategoria);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20030, 'ID Equipo duplicado: ' || p_idEquipo);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20031, 'Error en AD_EQUIPO: ' || SQLERRM);
  END AD_EQUIPO;

  PROCEDURE MO_EQUIPO(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  ) IS
  BEGIN
    UPDATE Equipo
    SET nombre = p_nombre,
        estadoEquipo = p_estadoEquipo,
        idEscuela = p_idEscuela,
        idCategoria = p_idCategoria
    WHERE idEquipo = p_idEquipo;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20035, 'Equipo no encontrado: ' || p_idEquipo);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20036, 'Error en MO_EQUIPO: ' || SQLERRM);
  END MO_EQUIPO;

  PROCEDURE EL_EQUIPO(p_idEquipo IN NUMBER) IS
  BEGIN
    DELETE FROM Equipo WHERE idEquipo = p_idEquipo;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20038, 'Equipo no encontrado: ' || p_idEquipo);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20039, 'Error en EL_EQUIPO: ' || SQLERRM);
  END EL_EQUIPO;

  FUNCTION CO_EQUIPO RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT eq.idEquipo, eq.nombre, eq.estadoEquipo, e.nombre AS escuela, c.nombre AS categoria
    FROM Equipo eq
    JOIN Escuela e ON eq.idEscuela = e.idEscuela
    JOIN Categoria c ON eq.idCategoria = c.idCategoria
    ORDER BY e.nombre, eq.nombre;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20040, 'Error en CO_EQUIPO: ' || SQLERRM);
  END CO_EQUIPO;

END PC_EQUIPO;
/

/* PACKAGE BODY: PC_INSCRIPCION */
CREATE OR REPLACE PACKAGE BODY PC_INSCRIPCION AS

  PROCEDURE AD_INSCRIPCION(
    p_idInscripcion IN NUMBER,
    p_fechaInscripcion IN DATE,
    p_estadoInscripcion IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEscuela IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    IF p_fechaInscripcion > TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20041, 'Fecha de inscripción no puede ser futura');
    END IF;
    SELECT COUNT(*) INTO v_count FROM Inscripcion
    WHERE idPersona = p_idPersona AND idEscuela = p_idEscuela 
          AND estadoInscripcion = 'ACTIVA';
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20042, 'Persona ya tiene inscripción activa en esta escuela');
    END IF;

    INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
    VALUES (p_idInscripcion, p_fechaInscripcion, p_estadoInscripcion, p_idPersona, p_idEscuela);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20043, 'ID Inscripción duplicado: ' || p_idInscripcion);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20044, 'Error en AD_INSCRIPCION: ' || SQLERRM);
  END AD_INSCRIPCION;

  PROCEDURE EL_INSCRIPCION(p_idInscripcion IN NUMBER) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Pago WHERE idInscripcion = p_idInscripcion;
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20045, 'No puede eliminar inscripción con pagos registrados');
    END IF;

    DELETE FROM Inscripcion WHERE idInscripcion = p_idInscripcion;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20046, 'Inscripción no encontrada: ' || p_idInscripcion);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20047, 'Error en EL_INSCRIPCION: ' || SQLERRM);
  END EL_INSCRIPCION;

  FUNCTION CO_INSCRIPCION RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT i.idInscripcion, i.fechaInscripcion, i.estadoInscripcion, 
           pe.nombres, pe.apellidos, e.nombre AS escuela
    FROM Inscripcion i
    JOIN Persona pe ON i.idPersona = pe.idPersona
    JOIN Escuela e ON i.idEscuela = e.idEscuela
    ORDER BY i.fechaInscripcion DESC;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20048, 'Error en CO_INSCRIPCION: ' || SQLERRM);
  END CO_INSCRIPCION;

END PC_INSCRIPCION;
/

/* PACKAGE BODY: PC_PAGO */
CREATE OR REPLACE PACKAGE BODY PC_PAGO AS

  PROCEDURE AD_PAGO(
    p_idPago IN NUMBER,
    p_fechaPago IN DATE,
    p_monto IN NUMBER,
    p_estadoPago IN VARCHAR2,
    p_metodoPago IN VARCHAR2,
    p_idInscripcion IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Inscripcion WHERE idInscripcion = p_idInscripcion;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20049, 'Inscripción no existe: ' || p_idInscripcion);
    END IF;
    IF p_monto <= 0 THEN
      RAISE_APPLICATION_ERROR(-20050, 'Monto debe ser mayor a 0');
    END IF;
    IF p_metodoPago NOT IN ('EFECTIVO', 'TRANSFERENCIA', 'TARJETA') THEN
      RAISE_APPLICATION_ERROR(-20051, 'Método de pago inválido. Use: EFECTIVO, TRANSFERENCIA, TARJETA');
    END IF;

    INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
    VALUES (p_idPago, p_fechaPago, p_monto, p_estadoPago, p_metodoPago, p_idInscripcion);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20052, 'ID Pago duplicado: ' || p_idPago);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20053, 'Error en AD_PAGO: ' || SQLERRM);
  END AD_PAGO;

  PROCEDURE EL_PAGO(p_idPago IN NUMBER) IS
    v_estadoActual VARCHAR2(20);
  BEGIN
    SELECT estadoPago INTO v_estadoActual FROM Pago WHERE idPago = p_idPago;
    IF v_estadoActual = 'PAGADO' THEN
      RAISE_APPLICATION_ERROR(-20054, 'No puede eliminar un pago confirmado');
    END IF;

    DELETE FROM Pago WHERE idPago = p_idPago;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20055, 'Pago no encontrado: ' || p_idPago);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20056, 'Error en EL_PAGO: ' || SQLERRM);
  END EL_PAGO;

  FUNCTION CO_PAGO RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT p.idPago, p.fechaPago, p.monto, p.estadoPago, p.metodoPago, i.idInscripcion
    FROM Pago p
    JOIN Inscripcion i ON p.idInscripcion = i.idInscripcion
    ORDER BY p.fechaPago DESC;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20057, 'Error en CO_PAGO: ' || SQLERRM);
  END CO_PAGO;

END PC_PAGO;
/

/* PACKAGE BODY: PC_ASISTENCIA */
CREATE OR REPLACE PACKAGE BODY PC_ASISTENCIA AS

  PROCEDURE AD_ASISTENCIA(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_rol IN VARCHAR2,
    p_observaciones IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
    VALUES (p_idPersona, p_idEntrenamiento, p_asistencia, p_rol, p_observaciones);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20058, 'Participante ya existe en este entrenamiento');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20059, 'Error en AD_ASISTENCIA: ' || SQLERRM);
  END AD_ASISTENCIA;

  PROCEDURE MO_ASISTENCIA(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_observaciones IN VARCHAR2
  ) IS
  BEGIN
    UPDATE Participante
    SET asistencia = p_asistencia,
        observaciones = p_observaciones
    WHERE idPersona = p_idPersona AND idEntrenamiento = p_idEntrenamiento;
    
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20060, 'Participante no encontrado');
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20061, 'Error en MO_ASISTENCIA: ' || SQLERRM);
  END MO_ASISTENCIA;

  FUNCTION CO_ASISTENCIA RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT p.idPersona, p.idEntrenamiento, p.asistencia, p.rol, p.observaciones, pe.nombres
    FROM Participante p
    JOIN Persona pe ON p.idPersona = pe.idPersona
    ORDER BY p.idEntrenamiento, pe.nombres;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20062, 'Error en CO_ASISTENCIA: ' || SQLERRM);
  END CO_ASISTENCIA;

END PC_ASISTENCIA;
/

/* PACKAGE BODY: PC_ENTRENAMIENTO */
CREATE OR REPLACE PACKAGE BODY PC_ENTRENAMIENTO AS

  PROCEDURE AD_ENTRENAMIENTO(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Equipo WHERE idEquipo = p_idEquipo;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20063, 'Equipo no existe: ' || p_idEquipo);
    END IF;

    INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
    VALUES (p_idEntrenamiento, p_fecha, p_hora, p_lugar, p_estado, p_idEquipo);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20066, 'ID Entrenamiento duplicado: ' || p_idEntrenamiento);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20067, 'Error en AD_ENTRENAMIENTO: ' || SQLERRM);
  END AD_ENTRENAMIENTO;

  PROCEDURE MO_ENTRENAMIENTO(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  ) IS
  BEGIN
    UPDATE Entrenamiento
    SET fecha = p_fecha,
        hora = p_hora,
        lugar = p_lugar,
        estado = p_estado,
        idEquipo = p_idEquipo
    WHERE idEntrenamiento = p_idEntrenamiento;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20069, 'Entrenamiento no encontrado: ' || p_idEntrenamiento);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20070, 'Error en MO_ENTRENAMIENTO: ' || SQLERRM);
  END MO_ENTRENAMIENTO;

  PROCEDURE EL_ENTRENAMIENTO(p_idEntrenamiento IN NUMBER) IS
  BEGIN
    DELETE FROM Entrenamiento WHERE idEntrenamiento = p_idEntrenamiento;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20073, 'Entrenamiento no encontrado: ' || p_idEntrenamiento);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20074, 'Error en EL_ENTRENAMIENTO: ' || SQLERRM);
  END EL_ENTRENAMIENTO;

  FUNCTION CO_ENTRENAMIENTO RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT e.idEntrenamiento, e.fecha, e.hora, e.lugar, e.estado, eq.nombre AS equipo
    FROM Entrenamiento e
    JOIN Equipo eq ON e.idEquipo = eq.idEquipo
    ORDER BY e.fecha DESC;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20075, 'Error en CO_ENTRENAMIENTO: ' || SQLERRM);
  END CO_ENTRENAMIENTO;

END PC_ENTRENAMIENTO;
/



