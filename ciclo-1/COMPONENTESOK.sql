/* PROYECTO: Formando Campeones
   CICLO 3
   OBJETIVO: Probar TODOS los procedimientos disponibles (7 + 3) */

/*Crear datos base para pruebas de procedimientos*/
INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (710, '1000000710', 'Daniel', 'PruebaComponentes', DATE '2010-06-15', '3009900710', 'daniel710@mail.com');

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (711, '1000000711', 'Andres', 'PruebaComponentes', DATE '2008-03-15', '3009900711', 'andres711@mail.com');

INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (710, 'Escuela Componentes', 'Carrera 50 # 100-50', '6019900710', 'escuela710@test.com');

INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
VALUES (710, 'SUB16', 'Categoria juvenil', 'INTERMEDIO');

COMMIT;

/* TEST 1: gestionarPersonas */
BEGIN
  PK_ADMINISTRACION.gestionarPersonas(
    p_idPersona => 712,
    p_documento => '1000000712',
    p_nombres => 'Juan',
    p_apellidos => 'Persona',
    p_fechaNacimiento => DATE '2012-07-20',
    p_telefono => '3009900712',
    p_correo => 'juan712@mail.com'
  );
END;
/

/* TEST 2: gestionarInscripciones */
BEGIN
  PK_ADMINISTRACION.gestionarInscripciones(
    p_idInscripcion => 710,
    p_fechaInscripcion => SYSDATE,
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona => 710,
    p_idEscuela => 710
  );
END;
/

/* TEST 3: gestionarJugadores */
BEGIN
  PK_ADMINISTRACION.gestionarJugadores(
    p_idPersona => 710,
    p_posicion => 'DELANTERO',
    p_numeroCamiseta => 10
  );
END;
/

/* TEST 4: gestionarEscuelas */
BEGIN
  PK_ADMINISTRACION.gestionarEscuelas(
    p_idEscuela => 711,
    p_nombre => 'Escuela Secundaria',
    p_direccion => 'Avenida Principal 200-100',
    p_telefono => '6018900711',
    p_correo => 'secondary711@test.com'
  );
END;
/

/* TEST 5: gestionarCategorias */
BEGIN
  PK_ADMINISTRACION.gestionarCategorias(
    p_idCategoria => 711,
    p_nombre => 'SUB20',
    p_descripcion => 'Mayores de edad',
    p_nivel => 'AVANZADO'
  );
END;
/

/* TEST 6: gestionarEquipos */
BEGIN
  PK_ADMINISTRACION.gestionarEquipos(
    p_idEquipo => 710,
    p_nombre => 'Equipo Prueba Componentes',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela => 710,
    p_idCategoria => 710
  );
END;
/

/* TEST 7: gestionarPagos */
BEGIN
  PK_ADMINISTRACION.gestionarPagos(
    p_idPago => 710,
    p_fechaPago => SYSDATE,
    p_monto => 180000.00,
    p_estadoPago => 'PAGADO',
    p_metodoPago => 'TRANSFERENCIA',
    p_idInscripcion => 710
  );
END;
/

/* TEST 8: consultarPersonas (Funcion) */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PK_ADMINISTRACION.consultarPersonas();
  CLOSE v_cursor;
END;
/

/* TEST 9: gestionarEntrenamientos */
BEGIN
  PK_ENTRENAMIENTO.gestionarEntrenamientos(
    p_idEntrenamiento => 710,
    p_fecha => SYSDATE + 2,
    p_hora => TO_TIMESTAMP(TO_CHAR(SYSDATE + 2, 'YYYY-MM-DD') || ' 16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    p_lugar => 'Cancha Componentes',
    p_estado => 'PROGRAMADO',
    p_idEquipo => 710
  );
END;
/

/* TEST 10: gestionarParticipantes (asistencia N sin observaciones) */
BEGIN
  PK_ENTRENAMIENTO.gestionarParticipantes(
    p_idPersona => 710,
    p_idEntrenamiento => 710,
    p_asistencia => 'N',
    p_rol => 'JUGADOR'
  );
END;
/

/* TEST 11: registrarAsistencia */
BEGIN
  PK_ENTRENAMIENTO.registrarAsistencia(
    p_idPersona => 710,
    p_idEntrenamiento => 710,
    p_asistencia => 'S',
    p_observaciones => 'Excelente desempeno'
  );
END;
/

/* TEST 12: obtenerEntrenamientosProgramados (Funcion) */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PK_ENTRENAMIENTO.obtenerEntrenamientosProgramados();
  CLOSE v_cursor;
END;
/

/* TEST 13: registrarAuditoria (7 PARAMETROS - se auto-genera idAuditoria) 
Usar INSERT directo en Auditoria porque procedimiento requiere secuencia */
INSERT INTO Auditoria (idAuditoria, idUsuario, tipoAccion, tabla, idRegistro, valorAntes, valorDespues, fechaHora)
VALUES (999, 710, 'INSERT', 'Persona', 712, NULL, 'Juan Persona', SYSDATE);
DELETE FROM Auditoria WHERE idAuditoria = 999;
/

/* TEST 14: consultarAuditorias (Funcion) */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PK_AUDITORIAS.consultarAuditorias();
  CLOSE v_cursor;
END;
/

/*Limpiar datos*/
ROLLBACK;
