/* PROYECTO: Formando Campeones CRUDOK
   CICLO 4 - INGRESO DE DATOS CORRECTOS
   OBJETIVO: Probar los procedimientos con datos válidos (casos exitosos)
   IDs usados: +900 para evitar conflictos con datos existentes
   NOTA: Este script es autosuficiente. Inserta todos los datos base
         necesarios directamente en las tablas antes de usar los packages.
*/

-- ============================================================
-- PASO 1: LIMPIEZA PREVIA
-- Elimina datos de prueba anteriores si existieran,
-- respetando el orden de las llaves foráneas
-- ============================================================

DELETE FROM Participante
  WHERE idPersona IN (901, 902, 903)
     OR idEntrenamiento IN (901, 902);

DELETE FROM Recibe
  WHERE idEntrenamiento IN (901, 902)
     OR idEquipo IN (901, 902);

DELETE FROM Pago
  WHERE idPago IN (901, 902, 903);

DELETE FROM Inscripcion
  WHERE idInscripcion IN (901, 902, 903);

DELETE FROM Entrenamiento
  WHERE idEntrenamiento IN (901, 902);

DELETE FROM Equipo
  WHERE idEquipo IN (901, 902);

DELETE FROM Acudiente
  WHERE idPersona IN (901, 902, 903);

DELETE FROM Jugador
  WHERE idPersona IN (901, 902, 903);

DELETE FROM Entrenador
  WHERE idPersona IN (901, 902, 903);

DELETE FROM Administrador
  WHERE idPersona IN (901, 902, 903);

DELETE FROM Persona
  WHERE idPersona IN (901, 902, 903);

DELETE FROM Categoria
  WHERE idCategoria IN (901, 902);

DELETE FROM Escuela
  WHERE idEscuela IN (901, 902);

COMMIT;

/*PASO 2: DATOS BASE (INSERT DIRECTO EN TABLAS)*/
/*Escuelas*/
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
  VALUES (901, 'Escuela Campeones Norte CRUD', 'Calle 80 # 12-45', '6017001001', 'nortecrud@campeones.com');

INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
  VALUES (902, 'Escuela Campeones Sur CRUD', 'Carrera 30 # 5-60', '6017002002', 'surcrud@campeones.com');

/*Categorias*/
INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
  VALUES (901, 'Sub-12', 'Categoría para niños de 8 a 12 años', 'BASICO');

INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
  VALUES (902, 'Sub-15', 'Categoría para jóvenes de 13 a 15 años', 'INTERMEDIO');

COMMIT;

/*PASO 3: PC_PERSONA Agregar y modificar personas*/


/*Agregar persona 901*/
BEGIN
  PC_PERSONA.AD_PERSONA(
    p_idPersona       => 901,
    p_documento       => '1020304059',
    p_nombres         => 'Andrés',
    p_apellidos       => 'Torres',
    p_fechaNacimiento => DATE '2012-03-15',
    p_telefono        => '3194259389',
    p_correo          => 'carlosramirez20012@mail.com'
  );
END;
/

/*Agregar persona 902*/
BEGIN
  PC_PERSONA.AD_PERSONA(
    p_idPersona       => 999,
    p_documento       => '1020304055',
    p_nombres         => 'Laura',
    p_apellidos       => 'Morroso',
    p_fechaNacimiento => DATE '2013-07-22',
    p_telefono        => '3044133100',
    p_correo          => 'laura.mendoza2013@mail.com'
  );
END;
/

/*Agregar persona 903*/
BEGIN
  PC_PERSONA.AD_PERSONA(
    p_idPersona       => 998,
    p_documento       => '1020304052',
    p_nombres         => 'Sebastián',
    p_apellidos       => 'Pintonares',
    p_fechaNacimiento => DATE '2011-11-08',
    p_telefono        => '3144003286',
    p_correo          => 'sebastianvargas2011a@mail.com'
  );
END;
/

/*Modificar persona 901 (actualizar teléfono y correo)*/
BEGIN
  PC_PERSONA.MO_PERSONA(
    p_idPersona       => 997,
    p_documento       => '1020304050',
    p_nombres         => 'Jose',
    p_apellidos       => 'Cruyff ',
    p_fechaNacimiento => DATE '2012-03-15',
    p_telefono        => '3101112283',
    p_correo          => 'cramire20011@mail.com'
  );
END;
/

/*Consultar personas*/
DECLARE
  v_cur             SYS_REFCURSOR;
  v_idPersona       NUMBER;
  v_documento       VARCHAR2(10);
  v_nombres         VARCHAR2(50);
  v_apellidos       VARCHAR2(50);
  v_fechaNacimiento DATE;
  v_telefono        VARCHAR2(20);
  v_correo          VARCHAR2(100);
BEGIN
  v_cur := PC_PERSONA.CO_PERSONA();
  LOOP
    FETCH v_cur INTO v_idPersona, v_documento, v_nombres, v_apellidos,
                     v_fechaNacimiento, v_telefono, v_correo;
    EXIT WHEN v_cur%NOTFOUND;
  END LOOP;
  CLOSE v_cur;
END;
/

/*PASO 4: PC_EQUIPO - Agregar y modificar equipos*/
/*Depende de: Escuela (901, 902) y Categoria (901, 902)*/

/*Agregar equipo 901*/
BEGIN
  PC_EQUIPO.AD_EQUIPO(
    p_idEquipo     => 901,
    p_nombre       => 'Leones FC',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela    => 901,
    p_idCategoria  => 901
  );
END;
/

/*Agregar equipo 902*/
BEGIN
  PC_EQUIPO.AD_EQUIPO(
    p_idEquipo     => 902,
    p_nombre       => 'Águilas FC',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela    => 902,
    p_idCategoria  => 902
  );
END;
/

/*Modificar equipo 902 (cambiar estado a INACTIVO)*/
BEGIN
  PC_EQUIPO.MO_EQUIPO(
    p_idEquipo     => 902,
    p_nombre       => 'Águilas FC',
    p_estadoEquipo => 'INACTIVO',
    p_idEscuela    => 902,
    p_idCategoria  => 902
  );
END;
/

/*Consultar equipos*/
DECLARE
  v_cur          SYS_REFCURSOR;
  v_idEquipo     NUMBER;
  v_nombre       VARCHAR2(30);
  v_estadoEquipo VARCHAR2(30);
  v_escuela      VARCHAR2(120);
  v_categoria    VARCHAR2(10);
BEGIN
  v_cur := PC_EQUIPO.CO_EQUIPO();
  LOOP
    FETCH v_cur INTO v_idEquipo, v_nombre, v_estadoEquipo, v_escuela, v_categoria;
    EXIT WHEN v_cur%NOTFOUND;
  END LOOP;
  CLOSE v_cur;
END;
/


/*PASO 5: PC_INSCRIPCION - Agregar inscripciones
Depende de: Persona (901, 902, 903) y Escuela (901, 902)*/


/*Inscripción 901: persona 901 en escuela 901*/
BEGIN
  PC_INSCRIPCION.AD_INSCRIPCION(
    p_idInscripcion     => 901,
    p_fechaInscripcion  => DATE '2025-01-10',
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona         => 901,
    p_idEscuela         => 901
  );
END;
/

/*Inscripción 902: persona 999 en escuela 902*/
BEGIN
  PC_INSCRIPCION.AD_INSCRIPCION(
    p_idInscripcion     => 902,
    p_fechaInscripcion  => DATE '2025-01-15',
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona         => 999,
    p_idEscuela         => 902
  );
END;
/

/*Inscripción 903: persona 998 en escuela 901*/
BEGIN
  PC_INSCRIPCION.AD_INSCRIPCION(
    p_idInscripcion     => 903,
    p_fechaInscripcion  => DATE '2025-01-20',
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona         => 998,
    p_idEscuela         => 901
  );
END;
/

/*Consultar inscripciones*/
DECLARE
  v_cur               SYS_REFCURSOR;
  v_idInscripcion     NUMBER;
  v_fechaInscripcion  DATE;
  v_estadoInscripcion VARCHAR2(30);
  v_nombres           VARCHAR2(50);
  v_apellidos         VARCHAR2(50);
  v_escuela           VARCHAR2(120);
BEGIN
  v_cur := PC_INSCRIPCION.CO_INSCRIPCION();
  LOOP
    FETCH v_cur INTO v_idInscripcion, v_fechaInscripcion, v_estadoInscripcion,
                     v_nombres, v_apellidos, v_escuela;
    EXIT WHEN v_cur%NOTFOUND;
  END LOOP;
  CLOSE v_cur;
END;
/

/*PASO 6: PC_PAGO - Registrar pagos*/
/*Depende de: Inscripcion (901, 902, 903)*/

/*Pago 901: sobre inscripción 901, EFECTIVO, PAGADO*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 901,
    p_fechaPago     => DATE '2025-01-12',
    p_monto         => 150000.00,
    p_estadoPago    => 'PAGADO',
    p_metodoPago    => 'EFECTIVO',
    p_idInscripcion => 901
  );
END;
/

/*Pago 902: sobre inscripción 902, TRANSFERENCIA, PENDIENTE*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 902,
    p_fechaPago     => DATE '2025-01-18',
    p_monto         => 150000.00,
    p_estadoPago    => 'PENDIENTE',
    p_metodoPago    => 'TRANSFERENCIA',
    p_idInscripcion => 902
  );
END;
/

/*Pago 903: sobre inscripción 903, TARJETA, PENDIENTE*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 903,
    p_fechaPago     => DATE '2025-01-22',
    p_monto         => 150000.00,
    p_estadoPago    => 'PENDIENTE',
    p_metodoPago    => 'TARJETA',
    p_idInscripcion => 903
  );
END;
/

/*Consultar pagos*/
DECLARE
  v_cur           SYS_REFCURSOR;
  v_idPago        NUMBER;
  v_fechaPago     DATE;
  v_monto         NUMBER(10,2);
  v_estadoPago    VARCHAR2(30);
  v_metodoPago    VARCHAR2(30);
  v_idInscripcion NUMBER;
BEGIN
  v_cur := PC_PAGO.CO_PAGO();
  LOOP
    FETCH v_cur INTO v_idPago, v_fechaPago, v_monto, v_estadoPago,
                     v_metodoPago, v_idInscripcion;
    EXIT WHEN v_cur%NOTFOUND;
  END LOOP;
  CLOSE v_cur;
END;
/


/*PASO 7: PC_ENTRENAMIENTO - Agregar y modificar entrenamientos*/
/*Depende de: Equipo (901)*/

/*Entrenamiento 901*/
BEGIN
  PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
    p_idEntrenamiento => 901,
    p_fecha           => DATE '2025-02-10',
    p_hora            => TIMESTAMP '2025-02-10 08:00:00',
    p_lugar           => 'Cancha Principal Escuela Norte',
    p_estado          => 'PROGRAMADO',
    p_idEquipo        => 901
  );
END;
/

/*Entrenamiento 902*/
BEGIN
  PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
    p_idEntrenamiento => 902,
    p_fecha           => DATE '2025-02-12',
    p_hora            => TIMESTAMP '2025-02-12 10:00:00',
    p_lugar           => 'Cancha Auxiliar Escuela Sur',
    p_estado          => 'PROGRAMADO',
    p_idEquipo        => 901
  );
END;
/

/*Modificar entrenamiento 901 (marcar como REALIZADO, ajustar hora)*/
BEGIN
  PC_ENTRENAMIENTO.MO_ENTRENAMIENTO(
    p_idEntrenamiento => 901,
    p_fecha           => DATE '2025-02-10',
    p_hora            => TIMESTAMP '2025-02-10 09:00:00',
    p_lugar           => 'Cancha Principal Escuela Norte',
    p_estado          => 'REALIZADO',
    p_idEquipo        => 901
  );
END;
/

/*Consultar entrenamientos*/
DECLARE
  v_cur             SYS_REFCURSOR;
  v_idEntrenamiento NUMBER;
  v_fecha           DATE;
  v_hora            TIMESTAMP;
  v_lugar           VARCHAR2(200);
  v_estado          VARCHAR2(30);
  v_equipo          VARCHAR2(30);
BEGIN
  v_cur := PC_ENTRENAMIENTO.CO_ENTRENAMIENTO();
  LOOP
    FETCH v_cur INTO v_idEntrenamiento, v_fecha, v_hora, v_lugar, v_estado, v_equipo;
    EXIT WHEN v_cur%NOTFOUND;
  END LOOP;
  CLOSE v_cur;
END;
/

/*PASO 8: PC_ASISTENCIA - Registrar y modificar asistencias*/
/*Depende de: Persona (901, 902, 903) y Entrenamiento (901)*/

/*Persona 901 asistió al entrenamiento 901*/
BEGIN
  PC_ASISTENCIA.AD_ASISTENCIA(
    p_idPersona       => 901,
    p_idEntrenamiento => 901,
    p_asistencia      => 'S',
    p_rol             => 'JUGADOR',
    p_observaciones   => 'Excelente rendimiento'
  );
END;
/

/*Persona 999 asistió al entrenamiento 901*/
BEGIN
  PC_ASISTENCIA.AD_ASISTENCIA(
    p_idPersona       => 999,
    p_idEntrenamiento => 901,
    p_asistencia      => 'S',
    p_rol             => 'JUGADOR',
    p_observaciones   => 'Excelente Rendimiento'
  );
END;
/

/*Persona 998 no asistió al entrenamiento 901*/
BEGIN
  PC_ASISTENCIA.AD_ASISTENCIA(
    p_idPersona       => 998,
    p_idEntrenamiento => 901,
    p_asistencia      => 'N',
    p_rol             => 'JUGADOR',
    p_observaciones   => 'Ausencia justificada'
  );
END;
/

/*Modificar asistencia de persona 903 (corregir a que sí asistió)*/
BEGIN
  PC_ASISTENCIA.MO_ASISTENCIA(
    p_idPersona       => 998,
    p_idEntrenamiento => 901,
    p_asistencia      => 'S',
    p_observaciones   => 'Llegó tarde pero asistió'
  );
END;
/

/*Consultar asistencias*/
DECLARE
  v_cur             SYS_REFCURSOR;
  v_idPersona       NUMBER;
  v_idEntrenamiento NUMBER;
  v_asistencia      CHAR(1);
  v_rol             VARCHAR2(20);
  v_observaciones   VARCHAR2(100);
  v_nombres         VARCHAR2(50);
BEGIN
  v_cur := PC_ASISTENCIA.CO_ASISTENCIA();
  LOOP
    FETCH v_cur INTO v_idPersona, v_idEntrenamiento, v_asistencia,
                     v_rol, v_observaciones, v_nombres;
    EXIT WHEN v_cur%NOTFOUND;
  END LOOP;
  CLOSE v_cur;
END;
/


/*PASO 9: Eliminaciones válidas*/

/*Eliminar pago 902 (PENDIENTE, válido eliminar)*/
BEGIN
  PC_PAGO.EL_PAGO(p_idPago => 902);
END;
/

/*Eliminar pago 903 (PENDIENTE, válido eliminar)*/
BEGIN
  PC_PAGO.EL_PAGO(p_idPago => 903);
END;
/

/*Eliminar entrenamiento 902 (sin participantes, válido eliminar)*/
BEGIN
  PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(p_idEntrenamiento => 902);
END;
/
