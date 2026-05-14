/* PROYECTO: Formando Campeones
   CICLO 3
   OBJETIVO: Implementación de paquetes componentes */

/* CREAR SECUENCIA PARA AUDITORIA */
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_auditoria';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE SEQUENCE seq_auditoria
  START WITH 1
  INCREMENT BY 1
  NOMAXVALUE;

/*PACKAGE: PK_ADMINISTRACION
Gestiona todas las operaciones CRUD de administración (personas, equipos, pagos, etc)*/
CREATE OR REPLACE PACKAGE BODY PK_ADMINISTRACION AS

  /*Inserta una nueva persona en la base de datos
  Parámetros: idPersona, documento (único), nombres, apellidos, fechaNacimiento, telefono, correo (único)*/
  PROCEDURE gestionarPersonas(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
    VALUES (p_idPersona, p_documento, p_nombres, p_apellidos, p_fechaNacimiento, p_telefono, p_correo);
    COMMIT;
  END gestionarPersonas;

  /*Registra un jugador (persona ya debe existir)
    Valida que tenga >= 5 años y que el número de camiseta sea único por escuela*/
  PROCEDURE gestionarJugadores(
    p_idPersona IN NUMBER,
    p_posicion IN VARCHAR2,
    p_numeroCamiseta IN NUMBER
  ) IS
  BEGIN
    INSERT INTO Jugador (idPersona, posicion, numeroCamiseta)
    VALUES (p_idPersona, p_posicion, p_numeroCamiseta);
    COMMIT;
  END gestionarJugadores;

  /*Crea un nuevo equipo con su escuela y categoría*/
  PROCEDURE gestionarEquipos(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  ) IS
  BEGIN
    INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
    VALUES (p_idEquipo, p_nombre, p_estadoEquipo, p_idEscuela, p_idCategoria);
    COMMIT;
  END gestionarEquipos;

  /*Registra una nueva escuela
  Dirección, teléfono y correo deben ser únicos*/
  PROCEDURE gestionarEscuelas(
    p_idEscuela IN NUMBER,
    p_nombre IN VARCHAR2,
    p_direccion IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
    VALUES (p_idEscuela, p_nombre, p_direccion, p_telefono, p_correo);
    COMMIT;
  END gestionarEscuelas;

  /*Define una nueva categoría de competencia (SUB8, SUB10, SUB12, etc)*/
  PROCEDURE gestionarCategorias(
    p_idCategoria IN NUMBER,
    p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_nivel IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
    VALUES (p_idCategoria, p_nombre, p_descripcion, p_nivel);
    COMMIT;
  END gestionarCategorias;

  /*Inscribe una persona en una escuela*/
  PROCEDURE gestionarInscripciones(
    p_idInscripcion IN NUMBER,
    p_fechaInscripcion IN DATE,
    p_estadoInscripcion IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEscuela IN NUMBER
  ) IS
  BEGIN
    INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
    VALUES (p_idInscripcion, p_fechaInscripcion, p_estadoInscripcion, p_idPersona, p_idEscuela);
    COMMIT;
  END gestionarInscripciones;

  /*Registra un pago de inscripción
  Si estadoPago=PAGADO, automáticamente actualiza la inscripción a ACTIVA*/
  PROCEDURE gestionarPagos(
    p_idPago IN NUMBER,
    p_fechaPago IN DATE,
    p_monto IN NUMBER,
    p_estadoPago IN VARCHAR2,
    p_metodoPago IN VARCHAR2,
    p_idInscripcion IN NUMBER
  ) IS
  BEGIN
    INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
    VALUES (p_idPago, p_fechaPago, p_monto, p_estadoPago, p_metodoPago, p_idInscripcion);
    COMMIT;
  END gestionarPagos;

  /*Retorna todas las personas*/
  FUNCTION consultarPersonas RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Persona;
    RETURN v_cursor;
  END consultarPersonas;

  /*Retorna todos los equipos*/
  FUNCTION consultarEquipos RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Equipo;
    RETURN v_cursor;
  END consultarEquipos;

  /*Retorna todos los pagos registrados*/
  FUNCTION consultarPagos RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Pago;
    RETURN v_cursor;
  END consultarPagos;

  /*Retorna el dinero recaudado por cada escuela (suma de pagos PAGADO)*/
  FUNCTION obtenerRecaudoEscuelas RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT e.idEscuela, e.nombre, NVL(SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END), 0) AS totalRecaudado
    FROM Escuela e
    LEFT JOIN Inscripcion i ON e.idEscuela = i.idEscuela
    LEFT JOIN Pago p ON i.idInscripcion = p.idInscripcion
    GROUP BY e.idEscuela, e.nombre;
    RETURN v_cursor;
  END obtenerRecaudoEscuelas;

END PK_ADMINISTRACION;
/

/*PACKAGE: PK_ENTRENAMIENTO
 Maneja entrenamientos, participantes y asistencia*/
CREATE OR REPLACE PACKAGE BODY PK_ENTRENAMIENTO AS

  /*Crea un nuevo entrenamiento para un equipo*/
  PROCEDURE gestionarEntrenamientos(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  ) IS
  BEGIN
    INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
    VALUES (p_idEntrenamiento, p_fecha, p_hora, p_lugar, p_estado, p_idEquipo);
    COMMIT;
  END gestionarEntrenamientos;

  /*Registra que una persona participó en un entrenamiento
  Si no asistió (N), se auto-llena la observación*/
  PROCEDURE gestionarParticipantes(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_rol IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol)
    VALUES (p_idPersona, p_idEntrenamiento, p_asistencia, p_rol);
    COMMIT;
  END gestionarParticipantes;

  /*Actualiza la asistencia y observaciones de una persona*/
  PROCEDURE registrarAsistencia(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_observaciones IN VARCHAR2
  ) IS
  BEGIN
    UPDATE Participante
    SET asistencia = p_asistencia, observaciones = p_observaciones
    WHERE idPersona = p_idPersona AND idEntrenamiento = p_idEntrenamiento;
    COMMIT;
  END registrarAsistencia;

  /*Retorna todos los entrenamientos*/
  FUNCTION consultarEntrenamientos RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Entrenamiento;
    RETURN v_cursor;
  END consultarEntrenamientos;

  /*Retorna todos los participantes en entrenamientos*/
  FUNCTION consultarParticipantes RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Participante;
    RETURN v_cursor;
  END consultarParticipantes;

  /*Retorna asistencia (columnas: idPersona, idEntrenamiento, asistencia, observaciones)*/
  FUNCTION consultarAsistencia RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT idPersona, idEntrenamiento, asistencia, observaciones FROM Participante;
    RETURN v_cursor;
  END consultarAsistencia;

  /*Retorna entrenamientos que aún no se han realizado (estado=PROGRAMADO)*/
  FUNCTION obtenerEntrenamientosProgramados RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Entrenamiento WHERE estado = 'PROGRAMADO';
    RETURN v_cursor;
  END obtenerEntrenamientosProgramados;

  /*Retorna los jugadores de un equipo (nombres, posiciones, números de camiseta)*/
  FUNCTION obtenerJugadoresPorEquipo(p_idEquipo IN NUMBER) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT DISTINCT pe.idPersona, pe.nombres, pe.apellidos, j.posicion, j.numeroCamiseta
    FROM Equipo eq
    JOIN Entrenamiento en ON eq.idEquipo = en.idEquipo
    JOIN Participante pa ON en.idEntrenamiento = pa.idEntrenamiento
    JOIN Persona pe ON pa.idPersona = pe.idPersona
    JOIN Jugador j ON pe.idPersona = j.idPersona
    WHERE eq.idEquipo = p_idEquipo AND pa.rol = 'JUGADOR';
    RETURN v_cursor;
  END obtenerJugadoresPorEquipo;

END PK_ENTRENAMIENTO;
/

/*PACKAGE: PK_AUDITORIAS
 Mantiene un historial de quién cambió qué y cuándo*/
CREATE OR REPLACE PACKAGE BODY PK_AUDITORIAS AS

  /* Registra un cambio en auditoría (INSERT, UPDATE, DELETE) */
  PROCEDURE registrarAuditoria(
    p_idUsuario IN NUMBER,
    p_tipoAccion IN VARCHAR2,
    p_tabla IN VARCHAR2,
    p_idRegistro IN NUMBER,
    p_valorAntes IN VARCHAR2,
    p_valorDespues IN VARCHAR2,
    p_fechaHora IN TIMESTAMP
  ) IS
  BEGIN
    INSERT INTO Auditoria (idAuditoria, idUsuario, tipoAccion, tabla, idRegistro, valorAntes, valorDespues, fechaHora)
    VALUES (seq_auditoria.nextval, p_idUsuario, p_tipoAccion, p_tabla, p_idRegistro, p_valorAntes, p_valorDespues, p_fechaHora);
    COMMIT;
  END registrarAuditoria;

  /* Retorna todo el historial de auditoría */
  FUNCTION consultarAuditorias RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Auditoria;
    RETURN v_cursor;
  END consultarAuditorias;

  /* Retorna cambios de un usuario específico */
  FUNCTION consultarPorUsuario(p_idUsuario IN NUMBER) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Auditoria WHERE idUsuario = p_idUsuario;
    RETURN v_cursor;
  END consultarPorUsuario;

  /* Retorna cambios en una tabla específica */
  FUNCTION consultarPorTabla(p_tabla IN VARCHAR2) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Auditoria WHERE tabla = p_tabla;
    RETURN v_cursor;
  END consultarPorTabla;

  /* Retorna cambios en un rango de fechas */
  FUNCTION consultarRangoFechas(p_fechaInicio IN DATE, p_fechaFin IN DATE) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR SELECT * FROM Auditoria WHERE fechaHora BETWEEN p_fechaInicio AND p_fechaFin;
    RETURN v_cursor;
  END consultarRangoFechas;

END PK_AUDITORIAS;
/
