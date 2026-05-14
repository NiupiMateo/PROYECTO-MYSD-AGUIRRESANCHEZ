/* PROYECTO: Formando Campeones
   CICLO 4
   OBJETIVO: Pruebas de seguridad - Acceso a paquetes por roles
   
   TESTS ESENCIALES (6 pruebas):
   - TEST 1-3: Verificar INSERT/CREATE (PK_ADMINISTRACION, PK_ENTRENAMIENTO)
   - TEST 4-5: Verificar SELECT/READ (PK_ADMINISTRACION, PK_ENTRENAMIENTO)
   - TEST 6: Verificar AUDITORIA (PK_AUDITORIAS)
*/

/* LIMPIAR DATOS DE PRUEBAS ANTERIORES */
BEGIN
  EXECUTE IMMEDIATE 'DELETE FROM Auditoria WHERE idUsuario = 900';
  EXECUTE IMMEDIATE 'DELETE FROM Pago WHERE idPago = 900';
  EXECUTE IMMEDIATE 'DELETE FROM Participante WHERE idPersona = 900 AND idEntrenamiento = 900';
  EXECUTE IMMEDIATE 'DELETE FROM Inscripcion WHERE idInscripcion = 900';
  EXECUTE IMMEDIATE 'DELETE FROM Entrenamiento WHERE idEntrenamiento = 900';
  EXECUTE IMMEDIATE 'DELETE FROM Equipo WHERE idEquipo = 900';
  EXECUTE IMMEDIATE 'DELETE FROM Persona WHERE idPersona = 900';
  COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

COMMIT;

/* TEST 1: PK_ADMINISTRACION - gestionarPersonas (INSERT)
   Rol: ADMINISTRADOR
   Objetivo: Verificar que puede crear personas */
BEGIN
  PK_ADMINISTRACION.gestionarPersonas(
    p_idPersona => 900,
    p_documento => '1000000900',
    p_nombres => 'Carlos',
    p_apellidos => 'Admin Test',
    p_fechaNacimiento => DATE '2010-07-20',
    p_telefono => '3009999900',
    p_correo => 'carlos.admin900@mail.com'
  );
  COMMIT;
END;
/

/* TEST 2: PK_ADMINISTRACION - gestionarEquipos (INSERT)
   Rol: ADMINISTRADOR
   Objetivo: Verificar que puede crear equipos */
BEGIN
  PK_ADMINISTRACION.gestionarEquipos(
    p_idEquipo => 900,
    p_nombre => 'Aguilas Test',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela => 1,
    p_idCategoria => 1
  );
  COMMIT;
END;
/

/* TEST 3: PK_ENTRENAMIENTO - gestionarEntrenamientos (INSERT)
   Rol: ADMINISTRADOR
   Objetivo: Verificar que puede crear entrenamientos */
BEGIN
  PK_ENTRENAMIENTO.gestionarEntrenamientos(
    p_idEntrenamiento => 900,
    p_fecha => SYSDATE,
    p_hora => SYSDATE + INTERVAL '5' HOUR,
    p_lugar => 'Cancha Sur',    p_estado => 'PROGRAMADO',    p_idEquipo => 900
  );
  COMMIT;
END;
/

/* TEST 4: PK_ADMINISTRACION - consultarPersonas (SELECT)
   Rol: ADMINISTRADOR
   Objetivo: Verificar que puede consultar personas */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PK_ADMINISTRACION.consultarPersonas();
  CLOSE v_cursor;
END;
/

/* TEST 5: PK_ENTRENAMIENTO - consultarEntrenamientos (SELECT)
   Rol: ENTRENADOR (acceso limitado)
   Objetivo: Verificar que ENTRENADOR puede consultar entrenamientos */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PK_ENTRENAMIENTO.consultarEntrenamientos();
  CLOSE v_cursor;
END;
/

/* TEST 6: PK_AUDITORIAS - registrarAuditoria (INSERT)
   Rol: ADMINISTRADOR
   Objetivo: Verificar que puede registrar auditorias */
BEGIN
  PK_AUDITORIAS.registrarAuditoria(
    p_idUsuario => 900,
    p_tipoAccion => 'INSERT',
    p_tabla => 'Equipos',
    p_idRegistro => 900,
    p_valorAntes => NULL,
    p_valorDespues => 'Aguilas Test',
    p_fechaHora => SYSDATE
  );
  COMMIT;
END;
/

/* LIMPIAR DATOS DE PRUEBA */
BEGIN
  DELETE FROM Auditoria WHERE idUsuario = 900;
  DELETE FROM Pago WHERE idPago = 900;
  DELETE FROM Participante WHERE idPersona = 900 AND idEntrenamiento = 900;
  DELETE FROM Inscripcion WHERE idInscripcion = 900;
  DELETE FROM Entrenamiento WHERE idEntrenamiento = 900;
  DELETE FROM Equipo WHERE idEquipo = 900;
  DELETE FROM Persona WHERE idPersona = 900;
  COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
