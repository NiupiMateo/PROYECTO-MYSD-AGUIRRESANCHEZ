/* PROYECTO: Formando Campeones
   CICLO 4 - SEGURIDAD OK
   OBJETIVO: Verificar acceso correcto via paquetes actores (WRAPPERS)
   TESTS: 6 esenciales (PA_ADMINISTRADOR x3, PA_ENTRENADOR x2, PA_GERENTE x1)
*/

/* LIMPIEZA PREVIA */
BEGIN
  DELETE FROM Participante WHERE idEntrenamiento IN (SELECT idEntrenamiento FROM Entrenamiento WHERE lugar = 'Cancha Seguridad 800');
  DELETE FROM Entrenamiento WHERE lugar = 'Cancha Seguridad 800';
  DELETE FROM Inscripcion   WHERE idInscripcion = 800;
  DELETE FROM Equipo        WHERE idEquipo = 800;
  DELETE FROM Persona       WHERE idPersona = 800;
  DELETE FROM Escuela       WHERE idEscuela = 800;
  DELETE FROM Categoria     WHERE idCategoria = 800;
  COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

/* DATOS BASE NECESARIOS */

EXECUTE PA_ADMINISTRADOR.escuelasAdd(800, 'Escuela Seguridad 800', 'Calle 80 # 10-20', '6018880800', 'esc800@test.com');
EXECUTE PA_ADMINISTRADOR.categoriasAdd(800, 'SUB18', 'Categoria seguridad test', 'AVANZADO');
EXECUTE PA_ADMINISTRADOR.equiposAd('Equipo Seguridad 800', 800, 800);

/* 
   TEST 1: PA_ADMINISTRADOR - INSERT via wrapper */
EXECUTE PA_ADMINISTRADOR.personasAd(800, '1000000800', 'Laura', 'Seguridad', DATE '2009-04-10', '3001110800', 'laura800@test.com');

/* TEST 2: PA_ADMINISTRADOR - UPDATE via wrapper */
EXECUTE PA_ADMINISTRADOR.personasMod(800, '1000000800', 'Laura', 'Seguridad Mod', '3111110800', 'laura.mod800@test.com');
/

/* TEST 3: PA_ADMINISTRADOR - SELECT via wrapper */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PA_ADMINISTRADOR.personasC();
  CLOSE v_cursor;
END;
/

/* TEST 4: PA_ENTRENADOR - INSERT via wrapper */
BEGIN
  DECLARE v_idEquipo NUMBER;
  BEGIN
    SELECT MAX(idEquipo) INTO v_idEquipo FROM Equipo WHERE nombre = 'Equipo Seguridad 800';
    PA_ENTRENADOR.entrenamientosAd(
      TRUNC(SYSDATE)+2,
      TO_TIMESTAMP(TO_CHAR(TRUNC(SYSDATE)+2,'YYYY-MM-DD')||' 16:00:00','YYYY-MM-DD HH24:MI:SS'),
      'Cancha Seguridad 800',
      v_idEquipo
    );
  END;
END;
/

/* TEST 5: PA_ENTRENADOR - SELECT via wrapper */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PA_ENTRENADOR.entrenamientosC();
  CLOSE v_cursor;
END;
/

/* TEST 6: PA_GERENTE - SELECT solo lectura via wrapped */
DECLARE
  v_cursor SYS_REFCURSOR;
BEGIN
  v_cursor := PA_GERENTE.pagosPorEstado();
  CLOSE v_cursor;
END;
/

/* LIMPIEZA FINAL */
BEGIN
  DELETE FROM Participante WHERE idEntrenamiento IN (SELECT idEntrenamiento FROM Entrenamiento WHERE lugar = 'Cancha Seguridad 800');
  DELETE FROM Entrenamiento WHERE lugar = 'Cancha Seguridad 800';
  DELETE FROM Inscripcion   WHERE idInscripcion = 800;
  DELETE FROM Equipo        WHERE idEquipo IN (SELECT idEquipo FROM Equipo WHERE nombre IN ('Equipo Seguridad 800','Equipo Seguridad Mod'));
  DELETE FROM Persona       WHERE idPersona = 800;
  DELETE FROM Escuela       WHERE idEscuela = 800;
  DELETE FROM Categoria     WHERE idCategoria = 800;
  COMMIT;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

COMMIT;