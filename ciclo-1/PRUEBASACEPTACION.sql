/* PROYECTO: Formando Campeones */


/* PRUEBA DE ACEPTACION 1
   Nombre: El primer jugador de la escuela Norte

   Somos la Escuela Formando Campeones Norte, ubicada en el norte
   de la ciudad. Llevamos varios anos formando ninos y jovenes en
   el futbol. Hoy es un dia especial: Andres Camacho, un nino de
   11 anos con mucho talento, llega por primera vez a inscribirse.
   Su mama lo trajo desde temprano y el administrador del sistema,
   Ana Rodriguez, lo recibe en la oficina para registrarlo. */


/* - Ana abre el sistema y registra a Andres como nueva persona.
    Es la primera vez que el niño aparece en la base de datos. */

BEGIN
    PK_ADMINISTRACION.gestionarPersonas(
        p_idPersona       => 70,
        p_documento       => '1000000070',
        p_nombres         => 'Andres',
        p_apellidos       => 'Camacho',
        p_fechaNacimiento => DATE '2013-08-15',
        p_telefono        => '3010000070',
        p_correo          => 'andres.camacho@mail.com'
    );
END;
/

SELECT * FROM Persona WHERE idPersona = 70;


/* - El entrenador Pedro Lopez ha visto al niño en la cancha y lo
    recomienda como mediocampista con el numero 8. Ana lo registra
    como jugador oficial de la escuela. El sistema verifica
    automaticamente que Andres tiene mas de 5 años, condicion
    minima para inscribirse como jugador. */

BEGIN
    PK_ADMINISTRACION.gestionarJugadores(
        p_idPersona      => 70,
        p_posicion       => 'MEDIOCAMPISTA',
        p_numeroCamiseta => 8
    );
END;
/

SELECT * FROM Jugador WHERE idPersona = 70;


/* - Con el jugador registrado, Ana procede a crear la inscripcion
    formal de Andres en la Escuela Norte. Por ahora queda en estado
    PENDIENTE porque el pago aun no se ha realizado. */

BEGIN
    PK_ADMINISTRACION.gestionarInscripciones(
        p_idInscripcion     => 70,
        p_fechaInscripcion  => SYSDATE,
        p_estadoInscripcion => 'PENDIENTE',
        p_idPersona         => 70,
        p_idEscuela         => 1
    );
END;
/

/* Ana revisa el panel de inscripciones pendientes y ve a Andres
    en la lista, confirmando que el registro fue exitoso. */

SELECT * FROM VW_INSCRIPCIONES_PENDIENTES WHERE idPersona = 70;


/* La mama de Andres saca el dinero en efectivo y paga la mensualidad
    de 120.000 pesos. Ana registra el pago como PAGADO.
    En ese momento dos cosas ocurren automaticamente:
    el sistema le asigna la fecha de hoy al pago,
    y la inscripcion de Andres pasa de PENDIENTE a ACTIVA. */
    
INSERT INTO Pago (idPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (70, 120000.00, 'PAGADO', 'EFECTIVO', 70);

/* Ana verifica que la fecha fue asignada y que la inscripcion ya esta activa. */

SELECT idPago, fechaPago, estadoPago FROM Pago WHERE idPago = 70;
SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 70;

/* El recaudo de la Escuela Norte refleja el nuevo pago. */

SELECT * FROM VW_RECAUDO_POR_ESCUELA WHERE idEscuela = 1;


/* Tres dias despues, Andres asiste a su primer entrenamiento
    con los Halcones Norte. Pedro Lopez, su entrenador, lo registra
    como presente y deja una observacion del desempeño del niño. */

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (70, 1, 'S', 'JUGADOR', 'Primera sesion del jugador, muy buena actitud');

/*  Pedro consulta la asistencia del dia para verificar que quedo bien. */

SELECT * FROM VW_ASISTENCIA_PARTICIPANTES
WHERE idPersona = 70 AND idEntrenamiento = 1;

/* Andres ya aparece en el listado oficial de jugadores del equipo. */

SELECT * FROM VW_JUGADORES_POR_EQUIPO WHERE idPersona = 70;

/* Dos semanas despues, hay un segundo entrenamiento programado.
    Pedro lo registra en el sistema. */

INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (
    70,
    DATE '2024-07-10',
    TO_TIMESTAMP('2024-07-10 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    'Cancha Norte',
    'PROGRAMADO',
    1
);

/* Ese dia Andres no pudo asistir por enfermedad. Pedro lo registra
    como ausente y no escribe ninguna observacion porque no tiene
    mas detalles. El sistema detecta la ausencia sin observacion
    y automaticamente escribe: "No asistio al entrenamiento". */

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (70, 70, 'N', 'JUGADOR', NULL);

/* Pedro verifica que la observacion fue completada por el sistema. */

SELECT asistencia, observaciones
FROM Participante
WHERE idPersona = 70 AND idEntrenamiento = 70;


/* Finalmente, Ana deja registro en la auditoria de que Andres
    fue inscrito correctamente como jugador de la escuela. */

BEGIN
    PK_AUDITORIAS.registrarAuditoria(
        p_idUsuario     => 4,
        p_tipoAccion    => 'INSERT',
        p_tabla         => 'Jugador',
        p_idRegistro    => 70,
        p_valorAntes    => NULL,
        p_valorDespues  => 'idPersona=70, posicion=MEDIOCAMPISTA, numeroCamiseta=8',
        p_fechaHora     => SYSTIMESTAMP
    );
END;
/

SELECT * FROM Auditoria WHERE idRegistro = 70 AND tabla = 'Jugador';


/* Antes de cerrar el dia, Ana intenta por error registrar un pago
    con monto negativo. El sistema lo rechaza inmediatamente. */

BEGIN
    INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
    VALUES (71, SYSDATE, -50000.00, 'PAGADO', 'EFECTIVO', 70);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Monto negativo rechazado: ' || SQLERRM);
END;
/

/* Un practicante intenta registrar un estado de pago que no existe
    en el sistema. El sistema lo bloquea con el CHECK constraint. */

BEGIN
    INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
    VALUES (72, SYSDATE, 50000.00, 'EN_PROCESO', 'EFECTIVO', 70);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Estado de pago invalido rechazado: ' || SQLERRM);
END;
/

/* El mismo practicante intenta marcar asistencia con un valor
    diferente a S o N. El sistema tampoco lo permite. */

BEGIN
    INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
    VALUES (70, 70, 'X', 'JUGADOR', 'Valor invalido');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Asistencia invalida rechazada: ' || SQLERRM);
END;
/

/* Alguien intenta marcar asistencia como S pero sin escribir
    ninguna observacion. La restriccion de tupla lo impide,
    porque si el jugador asistio, debe quedar una observacion. */

BEGIN
    INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
    VALUES (70, 70, 'S', 'JUGADOR', NULL);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Asistencia S sin observacion rechazada: ' || SQLERRM);
END;
/

/* Al final del dia, Ana hace un ultimo repaso general del estado
    de Andres en el sistema. Todo esta en orden. */

SELECT * FROM VW_RECAUDO_POR_ESCUELA WHERE idEscuela = 1;
SELECT * FROM VW_JUGADORES_POR_EQUIPO WHERE idPersona = 70;
SELECT * FROM VW_ASISTENCIA_PARTICIPANTES WHERE idPersona = 70 ORDER BY idEntrenamiento;
SELECT * FROM VW_ENTRENAMIENTOS_PROGRAMADOS WHERE idEquipo = 1;

ROLLBACK;


/* PRUEBA DE ACEPTACION 2
   Nombre: Una nueva sede llega a Occidente

   La escuela Formando Campeones ha crecido tanto que decide
   abrir una nueva sede en el occidente de la ciudad.
   El director general le encarga a Ana Rodriguez gestionar
   toda la creacion de la nueva sede en el sistema: la escuela,
   la categoria, el equipo, los primeros jugadores, sus pagos
   y los primeros entrenamientos de la temporada.
   Al final, por una decision administrativa, la sede debe
   cerrarse y el sistema debe limpiar toda su informacion
   de forma automatica en cascada. */


/* Ana comienza creando la nueva sede en el sistema.
    La escuela queda registrada con su direccion, telefono y correo. */

BEGIN
    PK_ADMINISTRACION.gestionarEscuelas(
        p_idEscuela  => 80,
        p_nombre     => 'Escuela Formando Campeones Occidente',
        p_direccion  => 'Avenida 68 # 20-15',
        p_telefono   => '6014000080',
        p_correo     => 'occidente@campeones.com'
    );
END;
/

/* La nueva sede trabajara con la categoria SUB10, niños
menores de 10 anos en nivel basico. */

BEGIN
    PK_ADMINISTRACION.gestionarCategorias(
        p_idCategoria  => 80,
        p_nombre       => 'SUB10',
        p_descripcion  => 'Categoria pre-infantil menores de 10',
        p_nivel        => 'BASICO'
    );
END;
/

/* El equipo de la nueva sede se llamara Panteras Occidente
    y queda activo desde el primer dia. */
    
BEGIN
    PK_ADMINISTRACION.gestionarEquipos(
        p_idEquipo     => 80,
        p_nombre       => 'Panteras Occidente',
        p_estadoEquipo => 'ACTIVO',
        p_idEscuela    => 80,
        p_idCategoria  => 80
    );
END;
/

SELECT * FROM Escuela WHERE idEscuela = 80;
SELECT * FROM Categoria WHERE idCategoria = 80;
SELECT * FROM Equipo WHERE idEquipo = 80;


/* Los primeros dos jugadores en inscribirse son Miguel Ospina
    y Valeria Rios. Miguel llega con su papa y paga de inmediato.
    Valeria llega sola y dice que pagara la proxima semana.

    Registro de Miguel Ospina */

BEGIN
    PK_ADMINISTRACION.gestionarPersonas(
        p_idPersona       => 81,
        p_documento       => '1000000081',
        p_nombres         => 'Miguel',
        p_apellidos       => 'Ospina',
        p_fechaNacimiento => DATE '2016-03-10',
        p_telefono        => '3010000081',
        p_correo          => 'miguel.ospina@mail.com'
    );
END;
/

BEGIN
    PK_ADMINISTRACION.gestionarJugadores(
        p_idPersona      => 81,
        p_posicion       => 'PORTERO',
        p_numeroCamiseta => 1
    );
END;
/

BEGIN
    PK_ADMINISTRACION.gestionarInscripciones(
        p_idInscripcion     => 81,
        p_fechaInscripcion  => SYSDATE,
        p_estadoInscripcion => 'PENDIENTE',
        p_idPersona         => 81,
        p_idEscuela         => 80
    );
END;
/

/* El papa de Miguel paga en el momento. El sistema registra el pago,
    asigna la fecha automaticamente y cambia la inscripcion a ACTIVA. */

INSERT INTO Pago (idPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (81, 150000.00, 'PAGADO', 'TRANSFERENCIA', 81);

/* La inscripcion de Miguel ya esta activa. */

SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 81;


/* Registro de Valeria Rios */

BEGIN
    PK_ADMINISTRACION.gestionarPersonas(
        p_idPersona       => 82,
        p_documento       => '1000000082',
        p_nombres         => 'Valeria',
        p_apellidos       => 'Rios',
        p_fechaNacimiento => DATE '2015-11-20',
        p_telefono        => '3010000082',
        p_correo          => 'valeria.rios@mail.com'
    );
END;
/

BEGIN
    PK_ADMINISTRACION.gestionarJugadores(
        p_idPersona      => 82,
        p_posicion       => 'DEFENSA',
        p_numeroCamiseta => 5
    );
END;
/

BEGIN
    PK_ADMINISTRACION.gestionarInscripciones(
        p_idInscripcion     => 82,
        p_fechaInscripcion  => SYSDATE,
        p_estadoInscripcion => 'PENDIENTE',
        p_idPersona         => 82,
        p_idEscuela         => 80
    );
END;
/

/* Valeria aun no paga. Se registra el pago como PENDIENTE.
    La inscripcion permanece en PENDIENTE. */

INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (82, SYSDATE, 150000.00, 'PENDIENTE', 'EFECTIVO', 82);

/* Ana verifica que Valeria aparece en el reporte de pendientes. */

SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 82;
SELECT * FROM VW_INSCRIPCIONES_PENDIENTES WHERE idPersona = 82;


/* La nueva sede programa sus primeros dos entrenamientos.
    Pedro Lopez sera el entrenador encargado de la sede Occidente. */
    
BEGIN
    PK_ENTRENAMIENTO.gestionarEntrenamientos(
        p_idEntrenamiento => 81,
        p_fecha           => DATE '2024-08-05',
        p_hora            => TO_TIMESTAMP('2024-08-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_lugar           => 'Cancha Occidente A',
        p_estado          => 'PROGRAMADO',
        p_idEquipo        => 80
    );
END;
/

BEGIN
    PK_ENTRENAMIENTO.gestionarEntrenamientos(
        p_idEntrenamiento => 82,
        p_fecha           => DATE '2024-08-12',
        p_hora            => TO_TIMESTAMP('2024-08-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_lugar           => 'Cancha Occidente B',
        p_estado          => 'PROGRAMADO',
        p_idEquipo        => 80
    );
END;
/

/* Los dos entrenamientos aparecen en el panel de programados. */
SELECT * FROM VW_ENTRENAMIENTOS_PROGRAMADOS WHERE idEquipo = 80;


/* Llega el dia del primer entrenamiento. Los dos jugadores asisten
    y Pedro dirige la sesion con entusiasmo. Todo sale perfecto. */
    
INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (81, 81, 'S', 'JUGADOR', 'Buen inicio de temporada, reflejos destacados');

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (82, 81, 'S', 'JUGADOR', 'Buen desempeno defensivo, muy concentrada');

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (5, 81, 'S', 'ENTRENADOR', 'Dirigio sesion de fundamentos tecnicos');

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (81, 80, 'S', 'Equipo completo, primera sesion exitosa');

/* Pedro revisa la asistencia del primer entrenamiento. Todo cuadra. */

SELECT * FROM VW_ASISTENCIA_PARTICIPANTES
WHERE idEntrenamiento = 81 ORDER BY rol, apellidos;


/* En el segundo entrenamiento, Miguel asiste pero Valeria no llega.
    Pedro registra la ausencia de Valeria sin escribir observacion
    porque no sabe la razon. El sistema la completa automaticamente. */

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (81, 82, 'S', 'JUGADOR', 'Muy buena sesion de tactica');

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (82, 82, 'N', 'JUGADOR', NULL);

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (5, 82, 'S', 'ENTRENADOR', 'Se trabajo tactica de presion alta');

/* Pedro verifica el registro. Valeria aparece con la observacion
    automatica del sistema: "No asistio al entrenamiento". */

SELECT pe.nombres, pe.apellidos, pa.asistencia, pa.observaciones
FROM Participante pa
JOIN Persona pe ON pa.idPersona = pe.idPersona
WHERE pa.idEntrenamiento = 82
ORDER BY pa.rol, pe.apellidos;


/* Al cierre del mes, Ana revisa el estado financiero de la nueva sede.
    Miguel pago, Valeria no. El sistema lo muestra claramente. */

SELECT * FROM VW_RECAUDO_POR_ESCUELA WHERE idEscuela = 80;

/* Ana consulta el listado completo de jugadores de la nueva sede
    usando el paquete de entrenamiento. */

DECLARE
    v_cursor         SYS_REFCURSOR;
    v_idPersona      NUMBER;
    v_nombres        VARCHAR2(50);
    v_apellidos      VARCHAR2(50);
    v_posicion       VARCHAR2(20);
    v_numeroCamiseta NUMBER;
BEGIN
    v_cursor := PK_ENTRENAMIENTO.obtenerJugadoresPorEquipo(80);
    LOOP
        FETCH v_cursor INTO v_idPersona, v_nombres, v_apellidos, v_posicion, v_numeroCamiseta;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            'Jugador: ' || v_nombres || ' ' || v_apellidos ||
            ' | Posicion: ' || v_posicion ||
            ' | Camiseta: ' || v_numeroCamiseta
        );
    END LOOP;
    CLOSE v_cursor;
END;
/

SELECT * FROM VW_JUGADORES_POR_EQUIPO   WHERE idEquipo    = 80;
SELECT * FROM VW_JUGADORES_POR_CATEGORIA WHERE idCategoria = 80;


/* Ana deja constancia en la auditoria de la apertura de la sede. */

BEGIN
    PK_AUDITORIAS.registrarAuditoria(
        p_idUsuario     => 4,
        p_tipoAccion    => 'INSERT',
        p_tabla         => 'Escuela',
        p_idRegistro    => 80,
        p_valorAntes    => NULL,
        p_valorDespues  => 'Apertura sede Occidente con 2 jugadores inscritos y 2 entrenamientos realizados',
        p_fechaHora     => SYSTIMESTAMP
    );
END;
/

SELECT * FROM Auditoria WHERE idUsuario = 4 ORDER BY fechaHora DESC;


/* Semanas despues, la directiva decide cerrar la sede Occidente
    por baja demanda. Ana elimina la escuela del sistema.
    Gracias a las acciones de referencia en cascada, el sistema
    borra automaticamente el equipo, los entrenamientos y todos
    los participantes registrados. No queda ningun registro huerfano. */

DELETE FROM Escuela WHERE idEscuela = 80;

/* Ana verifica que todo fue eliminado correctamente en cascada. */

SELECT COUNT(*) AS equiposEliminados      FROM Equipo        WHERE idEquipo        = 80;
SELECT COUNT(*) AS entrenamientosEliminados FROM Entrenamiento WHERE idEntrenamiento IN (81, 82);
SELECT COUNT(*) AS participantesEliminados  FROM Participante  WHERE idEntrenamiento IN (81, 82);

/* Los tres resultados deben ser 0.
    La sede Occidente ya no existe en el sistema. */

ROLLBACK;
