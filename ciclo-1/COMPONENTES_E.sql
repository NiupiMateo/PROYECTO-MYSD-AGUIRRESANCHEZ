/* PROYECTO: Formando Campeones
   CICLO 3
   OBJETIVO: Especificación de paquetes componentes */

/*ESPECIFICACION PK_ADMINISTRACION*/
CREATE OR REPLACE PACKAGE PK_ADMINISTRACION AS

  /*Inserta una nueva persona en la base de datos*/
  PROCEDURE gestionarPersonas(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  );

  /*Registra un jugador asociado a una persona*/
  PROCEDURE gestionarJugadores(
    p_idPersona IN NUMBER,
    p_posicion IN VARCHAR2,
    p_numeroCamiseta IN NUMBER
  );

  /*Crea un nuevo equipo*/
  PROCEDURE gestionarEquipos(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  );

  /*Registra una nueva escuela deportiva*/
  PROCEDURE gestionarEscuelas(
    p_idEscuela IN NUMBER,
    p_nombre IN VARCHAR2,
    p_direccion IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  );

  /*Define una categoría de competencia*/
  PROCEDURE gestionarCategorias(
    p_idCategoria IN NUMBER,
    p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_nivel IN VARCHAR2
  );

  /*Registra la inscripción de una persona en una escuela*/
  PROCEDURE gestionarInscripciones(
    p_idInscripcion IN NUMBER,
    p_fechaInscripcion IN DATE,
    p_estadoInscripcion IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEscuela IN NUMBER
  );

  /*Registra pagos de inscripción*/
  PROCEDURE gestionarPagos(
    p_idPago IN NUMBER,
    p_fechaPago IN DATE,
    p_monto IN NUMBER,
    p_estadoPago IN VARCHAR2,
    p_metodoPago IN VARCHAR2,
    p_idInscripcion IN NUMBER
  );

  /*Retorna todas las personas registradas*/
  FUNCTION consultarPersonas RETURN SYS_REFCURSOR;

  /*Retorna todos los equipos registrados*/
  FUNCTION consultarEquipos RETURN SYS_REFCURSOR;

  /*Retorna todos los pagos registrados*/
  FUNCTION consultarPagos RETURN SYS_REFCURSOR;

  /*Obtiene el recaudo total por escuela*/
  FUNCTION obtenerRecaudoEscuelas RETURN SYS_REFCURSOR;

END PK_ADMINISTRACION;
/

/*ESPECIFICACION PK_ENTRENAMIENTO*/
CREATE OR REPLACE PACKAGE PK_ENTRENAMIENTO AS

  /*Crea un nuevo entrenamiento*/
  PROCEDURE gestionarEntrenamientos(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  );

  /*Registra participantes en entrenamientos*/
  PROCEDURE gestionarParticipantes(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_rol IN VARCHAR2
  );

  /*Actualiza la asistencia de un participante*/
  PROCEDURE registrarAsistencia(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_observaciones IN VARCHAR2
  );

  /*Retorna todos los entrenamientos*/
  FUNCTION consultarEntrenamientos RETURN SYS_REFCURSOR;

  /*Retorna todos los participantes*/
  FUNCTION consultarParticipantes RETURN SYS_REFCURSOR;

  /*Retorna información de asistencia*/
  FUNCTION consultarAsistencia RETURN SYS_REFCURSOR;

  /*Obtiene entrenamientos programados*/
  FUNCTION obtenerEntrenamientosProgramados RETURN SYS_REFCURSOR;

  /*Obtiene jugadores asociados a un equipo*/
  FUNCTION obtenerJugadoresPorEquipo(p_idEquipo IN NUMBER) RETURN SYS_REFCURSOR;

END PK_ENTRENAMIENTO;
/

/*ESPECIFICACION PK_AUDITORIAS*/
CREATE OR REPLACE PACKAGE PK_AUDITORIAS AS

  /*Registra acciones realizadas en la base de datos*/
  PROCEDURE registrarAuditoria(
    p_idUsuario IN NUMBER,
    p_tipoAccion IN VARCHAR2,
    p_tabla IN VARCHAR2,
    p_idRegistro IN NUMBER,
    p_valorAntes IN VARCHAR2,
    p_valorDespues IN VARCHAR2,
    p_fechaHora IN TIMESTAMP
  );

  /*Retorna todos los registros de auditoría*/
  FUNCTION consultarAuditorias RETURN SYS_REFCURSOR;

  /*Consulta auditorías realizadas por un usuario*/
  FUNCTION consultarPorUsuario(p_idUsuario IN NUMBER) RETURN SYS_REFCURSOR;

  /*Consulta auditorías de una tabla específica*/
  FUNCTION consultarPorTabla(p_tabla IN VARCHAR2) RETURN SYS_REFCURSOR;

  /*Consulta auditorías dentro de un rango de fechas*/
  FUNCTION consultarRangoFechas(
    p_fechaInicio IN DATE,
    p_fechaFin IN DATE
  ) RETURN SYS_REFCURSOR;

END PK_AUDITORIAS;
/