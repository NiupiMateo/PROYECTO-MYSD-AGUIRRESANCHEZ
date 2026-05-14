/* PROYECTO: Formando Campeones
   CICLO 3
   OBJETIVO: Pruebas de error en componentes */

/* ERROR TEST 1: gestionarPersonas - documento duplicado (debe fallar por UNIQUE) */
BEGIN
  PK_ADMINISTRACION.gestionarPersonas(
    p_idPersona => 101,
    p_documento => '1000000001',
    p_nombres => 'Juan',
    p_apellidos => 'Duplicate',
    p_fechaNacimiento => DATE '2010-05-10',
    p_telefono => '3007777777',
    p_correo => 'juan.dup@mail.com'
  );
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/

/* ERROR TEST 2: gestionarJugadores - edad menor a 5 años (trigger debe rechazar) */
BEGIN
  INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
  VALUES (102, '1000000102', 'Baby', 'Futbol', DATE '2022-05-10', '3008888888', 'baby@mail.com');
  
  PK_ADMINISTRACION.gestionarJugadores(
    p_idPersona => 102,
    p_posicion => 'DELANTERO',
    p_numeroCamiseta => 7
  );
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
/

/* ERROR TEST 3: gestionarPagos - estado inválido (CHECK constraint) */
BEGIN
  PK_ADMINISTRACION.gestionarPagos(
    p_idPago => 11,
    p_fechaPago => SYSDATE,
    p_monto => 150000.00,
    p_estadoPago => 'INVALIDO',
    p_metodoPago => 'EFECTIVO',
    p_idInscripcion => 1
  );
EXCEPTION
  WHEN OTHERS THEN
    NULL;
/

/* ERROR TEST 4: gestionarEquipos - FK a escuela inexistente (debe fallar) */
BEGIN
  PK_ADMINISTRACION.gestionarEquipos(
    p_idEquipo => 11,
    p_nombre => 'Team Error',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela => 9999,
    p_idCategoria => 1
  );
EXCEPTION
  WHEN OTHERS THEN
    NULL;

/* ERROR TEST 5: gestionarParticipantes - rol inválido (CHECK constraint) */
BEGIN
  PK_ENTRENAMIENTO.gestionarParticipantes(
    p_idPersona => 1,
    p_idEntrenamiento => 1,
    p_asistencia => 'S',
    p_rol => 'ADMIN'
  );
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;
ROLLBACK;
