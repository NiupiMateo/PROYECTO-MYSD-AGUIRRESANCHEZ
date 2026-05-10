/* PROYECTO: Formando Campeones
   CICLO 4
   OBJETIVO: Pruebas de seguridad - Acceso a paquetes por roles */

/* TEST 1: PK_ADMINISTRACION - gestionarPersonas (Administrador) */
BEGIN
  PK_ADMINISTRACION.gestionarPersonas(
    p_idPersona => 200,
    p_documento => '1000000200',
    p_nombres => 'Carlos',
    p_apellidos => 'Admin',
    p_fechaNacimiento => DATE '2010-07-20',
    p_telefono => '3009999999',
    p_correo => 'carlos.admin@mail.com'
  );
END;
/

/* TEST 2: PK_ADMINISTRACION - gestionarEquipos (Administrador) */
BEGIN
  PK_ADMINISTRACION.gestionarEquipos(
    p_idEquipo => 10,
    p_nombre => 'Aguilas Occidente',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela => 1,
    p_idCategoria => 1
  );
END;
/

/* TEST 3: PK_ADMINISTRACION - gestionarPagos (Administrador) */
BEGIN
  PK_ADMINISTRACION.gestionarPagos(
    p_idPago => 20,
    p_fechaPago => SYSDATE,
    p_monto => 200000.00,
    p_estadoPago => 'PAGADO',
    p_metodoPago => 'TARJETA',
    p_idInscripcion => 1
  );
END;
/

/* TEST 4: PK_ADMINISTRACION - gestionarInscripciones (Admnsitrador) */
BEGIN
  PK_ADMINISTRACION.gestionarInscripciones(
    p_idInscripcion => 20,
    p_fechaInscripcion => SYSDATE,
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona => 200,
    p_idEscuela => 1
  );
END;
/

/* TEST 5: PK_ADMINISTRACION - consultarPersonas (Administrador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idPersona NUMBER;
BEGIN
  v_cursor := PK_ADMINISTRACION.consultarPersonas();
  FETCH v_cursor INTO v_idPersona;
  CLOSE v_cursor;
END;
/

/* TEST 6: PK_ADMINISTRACION - obtenerRecaudoEscuelas (Administrador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idEscuela NUMBER;
BEGIN
  v_cursor := PK_ADMINISTRACION.obtenerRecaudoEscuelas();
  FETCH v_cursor INTO v_idEscuela;
  CLOSE v_cursor;
END;
/

/* TEST 7: PK_ADMINISTRACION - consultarPagos (Administrador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idPago NUMBER;
BEGIN
  v_cursor := PK_ADMINISTRACION.consultarPagos();
  FETCH v_cursor INTO v_idPago;
  CLOSE v_cursor;
END;
/

/* TEST 8: PK_ENTRENAMIENTO - gestionarEntrenamientos (Administrador) */
BEGIN
  PK_ENTRENAMIENTO.gestionarEntrenamientos(
    p_idEntrenamiento => 10,
    p_fecha => SYSDATE,
    p_hora => TO_TIMESTAMP('2024-05-10 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_lugar => 'Cancha Sur',
    p_idEquipo => 1
  );
END;
/

/* TEST 9: PK_ENTRENAMIENTO - gestionarParticipantes (Administrador) */
BEGIN
  PK_ENTRENAMIENTO.gestionarParticipantes(
    p_idPersona => 2,
    p_idEntrenamiento => 2,
    p_asistencia => 'S',
    p_rol => 'JUGADOR'
  );
END;
/

/* TEST 10: PK_ENTRENAMIENTO - registrarAsistencia (Entrenador) */
BEGIN
  PK_ENTRENAMIENTO.registrarAsistencia(
    p_idPersona => 2,
    p_idEntrenamiento => 2,
    p_asistencia => 'S',
    p_observaciones => 'Buen desempeño en el partido'
  );
END;
/

/* TEST 11: PK_ENTRENAMIENTO - consultarEntrenamientos (Entrenador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idEntrenamiento NUMBER;
BEGIN
  v_cursor := PK_ENTRENAMIENTO.consultarEntrenamientos();
  FETCH v_cursor INTO v_idEntrenamiento;
  CLOSE v_cursor;
END;
/

/* TEST 12: PK_ENTRENAMIENTO - obtenerEntrenamientosProgramados (Entrenador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idEntrenamiento NUMBER;
BEGIN
  v_cursor := PK_ENTRENAMIENTO.obtenerEntrenamientosProgramados();
  FETCH v_cursor INTO v_idEntrenamiento;
  CLOSE v_cursor;
END;
/

/* TEST 13: PK_ENTRENAMIENTO - consultarParticipantes (Entrenador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idPersona NUMBER;
BEGIN
  v_cursor := PK_ENTRENAMIENTO.consultarParticipantes();
  FETCH v_cursor INTO v_idPersona;
  CLOSE v_cursor;
END;
/

/* TEST 14: PK_ENTRENAMIENTO - jugadoresEquipoC (Entrenador) */
DECLARE
  v_cursor SYS_REFCURSOR;
  v_idPersona NUMBER;
BEGIN
  v_cursor := PK_ENTRENAMIENTO.obtenerJugadoresPorEquipo(1);
  FETCH v_cursor INTO v_idPersona;
  CLOSE v_cursor;
END;
/

/* TEST 15: PK_AUDITORIAS - registrarAuditoria (Administrador) */
BEGIN
  PK_AUDITORIAS.registrarAuditoria(
    p_idUsuario => 4,
    p_tipoAccion => 'INSERT',
    p_tabla => 'Pago',
    p_idRegistro => 20,
    p_valorAntes => NULL,
    p_valorDespues => '200000',
    p_fechaHora => TO_TIMESTAMP(SYSDATE, 'DD/MM/YYYY HH24:MI:SS')
  );
END;
/

ROLLBACK;
