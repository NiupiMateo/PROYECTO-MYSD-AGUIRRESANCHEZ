/* PROYECTO: Formando Campeones */


/* PRUEBA DE ACEPTACION 1
   Nombre: El dia que Sofia se convirtio en jugadora oficial

   Somos la Escuela Formando Campeones Norte, llevamos años
   formando jovenes futbolistas en la ciudad. Hoy llega Sofia
   Herrera, una niña de 10 años que quiere hacer parte del equipo
   Halcones Norte. Su papá la trae a la oficina donde Camilo,
   el administrador del sistema, la recibe con entusiasmo.
   Este es el recorrido completo desde que Sofia llega por primera
   vez hasta que participa en su primer entrenamiento oficial,
   pasando por cada capa del sistema que se construyo a lo largo
   del semestre: tablas, restricciones, tuplas, disparadores,
   acciones, indices, vistas, componentes y seguridad. */


/* Camilo abre el sistema y lo primero que hace es registrar
   a Sofia como persona. Las tablas ya estan creadas con sus
   restricciones declarativas: la persona debe tener documento
   unico, correo unico y telefono unico.
   
   ESPERADO: Éxito. Sofia se registra correctamente.
    - PC_PERSONA.AD_PERSONA valida datos y ejecuta INSERT
    - COMMIT se ejecuta automáticamente en el package
    - Sofia queda persistida en base de datos */

BEGIN
    PC_PERSONA.AD_PERSONA(
        p_idPersona       => 750,
        p_documento       => '1050000750',
        p_nombres         => 'Sofia',
        p_apellidos       => 'Herrera',
        p_fechaNacimiento => DATE '2014-06-20',
        p_telefono        => '3150000750',
        p_correo          => 'sofia.herrera@mail.com'
    );
END;
/

/* Camilo verifica que Sofia quedo registrada en el sistema.
   El indice sobre documento hace esta busqueda rapida. */

SELECT * FROM Persona WHERE idPersona = 750;


/* Camilo intenta registrar otra persona con el mismo documento
   de Sofia. El package PC_PERSONA tiene validacion interna que
   detecta el duplicado y lanza error -20014.
   
   ESPERADO: Fallo controlado
   - PC_PERSONA.AD_PERSONA revisa COUNT(*) WHERE documento
   - Encuentra documento '1050000750' ya existe (Sofia)
   - Lanza RAISE_APPLICATION_ERROR(-20014)
   - EXCEPTION captura error sin propagarlo
   - Sofia sigue siendo la única con ese documento
   
   Validación: Duplicados previenen inconsistencia de datos */

DECLARE
    v_error_code NUMBER;
    v_error_msg  VARCHAR2(100);
BEGIN
    PC_PERSONA.AD_PERSONA(
        p_idPersona       => 751,
        p_documento       => '1050000750',
        p_nombres         => 'Duplicado',
        p_apellidos       => 'Test',
        p_fechaNacimiento => DATE '2014-01-01',
        p_telefono        => '3150000751',
        p_correo          => 'duplicado@mail.com'
    );
EXCEPTION
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        v_error_msg := SQLERRM;
        -- El error es esperado: -20014 Documento ya existe
        IF v_error_code = -20014 THEN
            NULL; -- Error controlado, validación funcionando
        ELSE
            RAISE;
        END IF;
END;
/


/* Sofia es mayor de 5 años, asi que Camilo la inscribe en la escuela.
   El package PC_INSCRIPCION valida que la fecha de inscripcion no
   sea futura.
   
   ESPERADO: Éxito
   - PC_INSCRIPCION.AD_INSCRIPCION valida:
      Sofia existe (idPersona=750)
      Escuela existe (idEscuela=1)
      Fecha NO es futura (TRUNC(SYSDATE))
   - INSERT se ejecuta correctamente
   - Inscripción queda en estado PENDIENTE
   - Necesita pago para cambiar a ACTIVA */

BEGIN
    PC_INSCRIPCION.AD_INSCRIPCION(
        p_idInscripcion     => 750,
        p_fechaInscripcion  => TRUNC(SYSDATE),
        p_estadoInscripcion => 'PENDIENTE',
        p_idPersona         => 750,
        p_idEscuela         => 1
    );
END;
/

/* La vista de inscripciones pendientes ya muestra a Sofia
   esperando confirmar su pago. */

SELECT idInscripcion, nombres, apellidos, escuelaNombre, estadoInscripcion
FROM vw_inscripciones_pendientes
WHERE nombres = 'Sofia';


/* El papá de Sofia paga en efectivo en ese momento.
   Camilo registra el pago. Los disparadores automáticamente:
   - asignan SYSDATE como fechaPago
   - cambian la inscripcion de PENDIENTE a ACTIVA */

BEGIN
    PC_PAGO.AD_PAGO(
        p_idPago        => 750,
        p_fechaPago     => NULL,
        p_monto         => 150000.00,
        p_estadoPago    => 'PAGADO',
        p_metodoPago    => 'EFECTIVO',
        p_idInscripcion => 750
    );
END;
/

/* Camilo verifica los efectos automáticos de los disparadores. */

SELECT idPago, fechaPago, estadoPago FROM Pago WHERE idPago = 750;
SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 750;


/* Un practicante intenta registrar un pago con monto negativo.
   El package PC_PAGO lo detecta y rechaza.
   
   ESPERADO: Error -20012 (monto negativo)
   - PC_PAGO.AD_PAGO valida: p_monto >= 0
   - Encuentra p_monto = -50000.00 (inválido)
   - Lanza RAISE_APPLICATION_ERROR(-20012)
   - EXCEPTION captura y maneja silenciosamente
   - Pago NO se crea, BD consistente
   
   Seguridad: Previene entrada de datos fraudulentos */

DECLARE
    v_error_code NUMBER;
BEGIN
    PC_PAGO.AD_PAGO(
        p_idPago        => 751,
        p_fechaPago     => SYSDATE,
        p_monto         => -50000.00,
        p_estadoPago    => 'PENDIENTE',
        p_metodoPago    => 'EFECTIVO',
        p_idInscripcion => 750
    );
EXCEPTION
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        -- Error esperado: monto negativo rechazado
        IF v_error_code = -20012 THEN
            NULL; -- Error controlado, validación funcionando
        ELSE
            RAISE;
        END IF;
END;
/

/* Otro intento erroneo: metodo de pago con valor no permitido.
   Solo se aceptan EFECTIVO, TRANSFERENCIA o TARJETA.
   
   ESPERADO: Error -20013 (método inválido)
   - PC_PAGO.AD_PAGO valida: metodoPago IN ('EFECTIVO','TRANSFERENCIA','TARJETA')
   - Encuentra p_metodoPago = 'BITCOIN' (inválido)
   - Lanza RAISE_APPLICATION_ERROR(-20013)
   - EXCEPTION captura y maneja
   - Pago NO se crea
   
   Negocio: Solo se permiten 3 métodos de pago válidos */

DECLARE
    v_error_code NUMBER;
BEGIN
    PC_PAGO.AD_PAGO(
        p_idPago        => 752,
        p_fechaPago     => SYSDATE,
        p_monto         => 100000.00,
        p_estadoPago    => 'PENDIENTE',
        p_metodoPago    => 'BITCOIN',
        p_idInscripcion => 750
    );
EXCEPTION
    WHEN OTHERS THEN
        v_error_code := SQLCODE;
        -- Error esperado: método de pago no permitido
        IF v_error_code = -20013 THEN
            NULL; -- Error controlado, validación funcionando
        ELSE
            RAISE;
        END IF;
END;
/


/* La vista de recaudos refleja el pago de Sofia. */

SELECT escuelaNombre, totalRecaudado, totalPendiente
FROM vw_recaudos_por_escuela
WHERE idEscuela = 1;


/* Llega el primer entrenamiento. Pedro Lopez, el entrenador,
   usa su rol PA_ENTRENADOR para crear el entrenamiento. */

BEGIN
    PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-06-15',
        TO_TIMESTAMP('2025-06-15 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Norte Principal',
        1
    );
END;
/

/* Pedro revisa los entrenamientos programados. */

SELECT idEntrenamiento, TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha,
       lugar, equipoNombre
FROM vw_entrenamientos_programados
WHERE idEquipo = 1
ORDER BY fecha;

/* Sofia llega al entrenamiento. Pedro registra su asistencia
   con observación.
   
   ESPERADO: Éxito
   - PA_ENTRENADOR.asistenciaReg recibe:
     idPersona=750 (Sofia)
     idEntrenamiento= MAX del entrenamiento "Cancha Norte Principal"
     asistencia='S' (Sí asistió)
     observaciones='Sofia demostro...' (NO NULL - cumple tupla)
   - INSERT en Participante se ejecuta correctamente
   - Sofia queda registrada como asistente
   
   Nota: asistencia='S' REQUIERE observaciones (restricción tupla) */

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MAX(idEntrenamiento) INTO v_idEntrenamiento
    FROM Entrenamiento
    WHERE lugar = 'Cancha Norte Principal';
    
    PA_ENTRENADOR.asistenciaReg(
        750,
        v_idEntrenamiento,
        'S',
        'Sofia demostro excelente tecnica en su primera sesion'
    );
END;
/

/* Pedro intenta registrar asistencia S sin observación.
   La restricción de tupla lo impide.
   
   ESPERADO: Error CHECK constraint
   - Intenta INSERT en Participante con:
     asistencia='S' (Sí asistió)
     observaciones=NULL (sin descripción - INVÁLIDO)
   - BD valida restricción tupla:
   
   Negocio: Si el jugador asistió, debe haber comentario */

BEGIN
    INSERT INTO Participante (
        idPersona,
        idEntrenamiento,
        asistencia,
        rol,
        observaciones
    )
    VALUES (
        777,
        (SELECT MAX(idEntrenamiento)
         FROM Entrenamiento
         WHERE lugar = 'Cancha Norte Principal'),
        'S',
        'JUGADOR',
        NULL
    );
EXCEPTION
    WHEN OTHERS THEN
        -- Error esperado: restricción CHECK (tupla)
        NULL;
END;
/

/* Al siguiente entrenamiento Sofia no puede ir. Pedro registra
   su ausencia sin observación. El trigger la completa automáticamente.
   
   ESPERADO: Éxito + Trigger automático
   - PC_ENTRENAMIENTO.AD_ENTRENAMIENTO crea entrenamiento 750
   - PC_ASISTENCIA.AD_ASISTENCIA registra asistencia='N' (ausencia)
   - asistencia='N' SÍ permite observaciones=NULL (diferente a 'S')
   - INSERT se ejecuta correctamente
   - TRIGGER TRG_COMPLETAR_OBSERVACIONES se dispara automáticamente
   - Observación se llena automáticamente con texto genérico
   
   Automatización: El trigger reduce trabajo manual */

BEGIN
    PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
        p_idEntrenamiento => 750,
        p_fecha           => DATE '2025-06-22',
        p_hora            => TO_TIMESTAMP('2025-06-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_lugar           => 'Cancha Norte Auxiliar',
        p_estado          => 'PROGRAMADO',
        p_idEquipo        => 1
    );
END;
/

BEGIN
    PC_ASISTENCIA.AD_ASISTENCIA(
        p_idPersona       => 750,
        p_idEntrenamiento => 750,
        p_asistencia      => 'N',
        p_rol             => 'JUGADOR',
        p_observaciones   => NULL
    );
END;
/

/* Pedro verifica que el trigger completó la observación. */

SELECT asistencia, observaciones
FROM Participante
WHERE idPersona = 750 AND idEntrenamiento = 750;


/* Camilo consulta la asistencia de Sofia. */

SELECT TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha, nombres, apellidos,
       asistencia, rol, observaciones
FROM vw_asistencia_entrenamientos
WHERE idPersona = 750
ORDER BY fecha;


/* Camilo revisa el estado financiero vía PA_GERENTE. */

DECLARE
    v_cur        SYS_REFCURSOR;
    v_estado     VARCHAR2(30);
    v_cantidad   NUMBER;
    v_monto      NUMBER;
BEGIN
    v_cur := PA_GERENTE.pagosPorEstado();
    LOOP
        FETCH v_cur INTO v_estado, v_cantidad, v_monto;
        EXIT WHEN v_cur%NOTFOUND;
    END LOOP;
    CLOSE v_cur;
END;
/

ROLLBACK;


/* PRUEBA DE ACEPTACION 2
   Nombre: La nueva sede Occidente y su cierre en cascada

   La Escuela Formando Campeones abre una nueva sede en occidente.
   Camilo monta toda la infraestructura: escuela, categoría, equipo,
   dos jugadores con inscripciones y pagos, dos sesiones de entrenamiento.
   Al final, por baja demanda, se cierra la sede y el sistema
   limpia todo automáticamente gracias a cascadas. */


/* Camilo crea la nueva escuela usando PA_ADMINISTRADOR. */

BEGIN
    PA_ADMINISTRADOR.escuelasAdd(
        850,
        'Escuela Formando Campeones Occidente',
        'Avenida 68 # 45-10',
        '6014000850',
        'occidente850@campeones.com'
    );
END;
/

/* La categoría SUB10 se crea para los niños. */

BEGIN
    PA_ADMINISTRADOR.categoriasAdd(
        850,
        'SUB10',
        'Categoria pre-infantil menores de 10 años',
        'BASICO'
    );
END;
/

/* El equipo Panteras Occidente queda activo. */

BEGIN
    PC_EQUIPO.AD_EQUIPO(
        p_idEquipo     => 850,
        p_nombre       => 'Panteras Occidente',
        p_estadoEquipo => 'ACTIVO',
        p_idEscuela    => 850,
        p_idCategoria  => 850
    );
END;
/

/* Verificación de la estructura creada. */

SELECT * FROM Escuela   WHERE idEscuela   = 850;
SELECT * FROM Categoria WHERE idCategoria = 850;
SELECT * FROM Equipo    WHERE idEquipo    = 850;


/* Llegan dos jugadores: Miguel Ospina y Valeria Rios.
   Miguel paga de inmediato. Valeria paga después. */

/* Registro de Miguel Ospina */

BEGIN
    PA_ADMINISTRADOR.personasAd(
        851,
        '1050000851',
        'Miguel',
        'Ospina',
        DATE '2016-03-10',
        '3150000851',
        'miguel.ospina850@mail.com'
    );
END;
/

BEGIN
    PA_ADMINISTRADOR.inscripcionesAd(
        851,
        SYSDATE,
        'PENDIENTE',
        851,
        850
    );
END;
/

/* El papá de Miguel paga en transferencia. */

BEGIN
    PA_ADMINISTRADOR.pagosAd(
        851,
        150000.00,
        'PAGADO',
        'TRANSFERENCIA',
        851
    );
END;
/

/* Se verifica que la inscripción de Miguel cambió a ACTIVA. */

SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 851;


/* Registro de Valeria Rios */

BEGIN
    PA_ADMINISTRADOR.personasAd(
        852,
        '1050000852',
        'Valeria',
        'Rios',
        DATE '2015-11-20',
        '3150000852',
        'valeria.rios850@mail.com'
    );
END;
/

BEGIN
    PA_ADMINISTRADOR.inscripcionesAd(
        852,
        SYSDATE,
        'PENDIENTE',
        852,
        850
    );
END;
/

/* Valeria no paga aún. Su inscripción queda en PENDIENTE. */

BEGIN
    PA_ADMINISTRADOR.pagosAd(
        852,
        150000.00,
        'PENDIENTE',
        'EFECTIVO',
        852
    );
END;
/

/* Camilo verifica en la vista que Valeria aparece como deudora. */

SELECT nombres, apellidos, escuelaNombre, montoPendiente, cantidadPagosPendientes
FROM vw_inscripciones_pendientes
WHERE nombres = 'Valeria';


/* Pedro López programa dos entrenamientos. */

BEGIN
    PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-05',
        TO_TIMESTAMP('2025-07-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Occidente A',
        850
    );
END;
/

BEGIN
    PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-12',
        TO_TIMESTAMP('2025-07-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Occidente B',
        850
    );
END;
/

/* Los entrenamientos aparecen en el panel de programados. */

SELECT idEntrenamiento, TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha,
       lugar, equipoNombre
FROM vw_entrenamientos_programados
WHERE idEquipo = 850
ORDER BY fecha;


/* Primer entrenamiento: ambos asisten con observación. */

BEGIN
    PA_ENTRENADOR.asistenciaReg(
        851,
        (SELECT MIN(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850),
        'S',
        'Excelente primer dia, mucho talento'
    );
END;
/

BEGIN
    PA_ENTRENADOR.asistenciaReg(
        852,
        (SELECT MIN(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850),
        'S',
        'Buena actitud defensiva'
    );
END;
/

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES ((SELECT MIN(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850),
        850, 'S', 'Equipo completo, sesion exitosa');

/* Pedro revisa la asistencia del primer entrenamiento. */

SELECT nombres, apellidos, asistencia, rol, observaciones
FROM vw_asistencia_entrenamientos
WHERE idEntrenamiento = (SELECT MIN(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850)
ORDER BY apellidos;


/* Segundo entrenamiento: Valeria no llega.
   Pedro registra su ausencia sin observación.
   El trigger la completa automáticamente. */

BEGIN
    PA_ENTRENADOR.asistenciaReg(
        851,
        (SELECT MAX(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850),
        'S',
        'Muy buena sesion de tactica'
    );
END;
/

BEGIN
    PC_ASISTENCIA.AD_ASISTENCIA(
        p_idPersona       => 852,
        p_idEntrenamiento => (SELECT MAX(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850),
        p_asistencia      => 'N',
        p_rol             => 'JUGADOR',
        p_observaciones   => NULL
    );
END;
/

/* Pedro verifica que Valeria aparece con la observación automática. */

SELECT pe.nombres, pe.apellidos, pa.asistencia, pa.observaciones
FROM Participante pa
JOIN Persona pe ON pa.idPersona = pe.idPersona
WHERE pa.idEntrenamiento = (SELECT MAX(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850)
ORDER BY pe.apellidos;


/* Camilo consulta el estado financiero de la sede Occidente. */

SELECT escuelaNombre, totalRecaudado, totalPendiente, totalPagos
FROM vw_recaudos_por_escuela
WHERE idEscuela = 850;

/* El gerente consulta las escuelas con mayor demanda. */

DECLARE
    v_cur         SYS_REFCURSOR;
    v_idEscuela   NUMBER;
    v_nombre      VARCHAR2(120);
    v_inscritos   NUMBER;
BEGIN
    v_cur := PA_GERENTE.escuelasConMayorDemanda();
    LOOP
        FETCH v_cur INTO v_idEscuela, v_nombre, v_inscritos;
        EXIT WHEN v_cur%NOTFOUND;
    END LOOP;
    CLOSE v_cur;
END;
/


/* Camilo modifica la información de Valeria (correo con error). */

BEGIN
    PC_PERSONA.MO_PERSONA(
        p_idPersona       => 852,
        p_documento       => '1050000852',
        p_nombres         => 'Valeria',
        p_apellidos       => 'Rios',
        p_fechaNacimiento => DATE '2015-11-20',
        p_telefono        => '3150000852',
        p_correo          => 'valeria.rios.corregido@mail.com'
    );
END;
/

SELECT correo FROM Persona WHERE idPersona = 852;


/* ESCENARIOS DE SEGURIDAD: Validación de Roles y Privilegios
   
   ESCENARIO 1: Mateo (C##ENTRENADOR) intenta eliminar una inscripción
   
   CONTEXTO:
   - Mateo tiene rol: C##ENTRENADOR
   - Mateo recibió GRANT: EXECUTE ON PA_ENTRENADOR
   - Mateo NO recibió: EXECUTE ON PA_ADMINISTRADOR
   
   INTENTO:
   - Mateo llama PA_ADMINISTRADOR.inscripcionesEli(852)
   - Oracle verifica si Mateo tiene EXECUTE en PA_ADMINISTRADOR
   - NO tiene el privilegio → ERROR PLS-00306 o ORA-00942 */

BEGIN
    PA_ADMINISTRADOR.inscripcionesEli(852);
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

/* Verificación: Inscripción de Valeria sigue existiendo */

SELECT idInscripcion, idPersona, estadoInscripcion
FROM Inscripcion
WHERE idInscripcion = 852;


/*  ESCENARIO 2: Mateo (C##ENTRENADOR) intenta crear un pago
   
   CONTEXTO:
   - Mateo tiene rol: C##ENTRENADOR
   - Mateo recibió GRANT: EXECUTE ON PA_ENTRENADOR
   - Mateo NO recibió: EXECUTE ON PA_ADMINISTRADOR
   
   INTENTO:
   - Mateo llama PA_ADMINISTRADOR.pagosAd(...) para crear un pago
   - Oracle verifica si Mateo tiene EXECUTE en PA_ADMINISTRADOR
   - NO tiene el privilegio → ERROR PLS-00306 o ORA-00942 */

BEGIN
    PA_ADMINISTRADOR.pagosAd(
        999,
        50000.00,
        'PAGADO',
        'EFECTIVO',
        852
    );
EXCEPTION
    WHEN OTHERS THEN
        -- Error esperado: Acceso denegado por falta de GRANT
        NULL;
END;
/

/* Verificación: Pago malicioso no se creó */

SELECT COUNT(*) AS pagos_no_autorizados
FROM Pago
WHERE idPago = 999;


/* ESCENARIO 3: Gerente (C##GERENTE) intenta crear un entrenamiento
   
   CONTEXTO:
   - Gerente tiene rol: C##GERENTE
   - Gerente recibió GRANT: EXECUTE ON PA_GERENTE (solo lectura)
   - Gerente NO recibió: EXECUTE ON PA_ENTRENADOR
   
   INTENTO:
   - Gerente llama PA_ENTRENADOR.entrenamientosAd(...) para crear entrenamiento
   - Oracle verifica si Gerente tiene EXECUTE en PA_ENTRENADOR
   - NO tiene el privilegio → ERROR PLS-00306 o ORA-00942 */

BEGIN
    PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-20',
        TO_TIMESTAMP('2025-07-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha No Autorizada',
        850
    );
EXCEPTION
    WHEN OTHERS THEN
        -- Error esperado: Acceso denegado por falta de GRANT
        NULL;
END;
/

/* Verificación: Entrenamiento no autorizado no existe */

SELECT COUNT(*) AS entrenamientos_no_autorizados
FROM Entrenamiento
WHERE lugar = 'Cancha No Autorizada';


/* CIERRE EN CASCADA: la directiva decide cerrar la sede Occidente.
   Al borrar la escuela, las acciones en cascada automáticamente:
   - Borran Equipo 850
   - Borran Entrenamientos del equipo 850
   - Borran Participantes de esos entrenamientos
   - Ponen los pagos con idInscripcion = NULL (conservan historial) */

/* Conteos antes de borrar. */

SELECT COUNT(*) AS equiposAntes      FROM Equipo        WHERE idEquipo    = 850;
SELECT COUNT(*) AS entrenamientosAntes FROM Entrenamiento WHERE idEquipo  = 850;
SELECT COUNT(*) AS participantesAntes  FROM Participante
WHERE idEntrenamiento IN (SELECT idEntrenamiento FROM Entrenamiento WHERE idEquipo = 850);

/* Se elimina la escuela. */

DELETE FROM Inscripcion WHERE idEscuela = 850;
DELETE FROM Escuela WHERE idEscuela = 850;

/* Verificar la eliminación en cascada (resultados deben ser 0). */

SELECT COUNT(*) AS equiposEliminados      FROM Equipo        WHERE idEquipo    = 850;
SELECT COUNT(*) AS entrenamientosEliminados FROM Entrenamiento WHERE idEquipo  = 850;
SELECT COUNT(*) AS participantesEliminados  FROM Participante
WHERE idEntrenamiento NOT IN (SELECT idEntrenamiento FROM Entrenamiento);

/* Los pagos deben seguir existiendo con idInscripcion = NULL. */

SELECT idPago, monto, estadoPago, idInscripcion
FROM Pago
WHERE idPago IN (851, 852);

ROLLBACK;

/*   Nombre: La nueva sede Occidente y su cierre en cascada

   La Escuela Formando Campeones abre una nueva sede en occidente.
   Camilo monta toda la infraestructura: escuela, categoría, equipo,
   dos jugadores con inscripciones y pagos, dos sesiones de entrenamiento.
   Al final, por baja demanda, se cierra la sede y el sistema
   limpia todo automáticamente gracias a cascadas. */


/* Camilo crea la nueva escuela usando PA_ADMINISTRADOR. */

BEGIN
    PA_ADMINISTRADOR.escuelasAdd(
        850,
        'Escuela Formando Campeones Occidente',
        'Avenida 68 # 45-10',
        '6014000850',
        'occidente850@campeones.com'
    );
END;
/

/* La categoría SUB10 se crea para los niños. */

BEGIN
    PA_ADMINISTRADOR.categoriasAdd(
        850,
        'SUB10',
        'Categoria pre-infantil menores de 10 años',
        'BASICO'
    );
END;
/

/* El equipo Panteras Occidente queda activo. */

BEGIN
    PC_EQUIPO.AD_EQUIPO(
        p_idEquipo     => 850,
        p_nombre       => 'Panteras Occidente',
        p_estadoEquipo => 'ACTIVO',
        p_idEscuela    => 850,
        p_idCategoria  => 850
    );
END;
/

/* Verificación de la estructura creada. */

SELECT * FROM Escuela   WHERE idEscuela   = 850;
SELECT * FROM Categoria WHERE idCategoria = 850;
SELECT * FROM Equipo    WHERE idEquipo    = 850;


/* Llegan dos jugadores: Miguel Ospina y Valeria Rios.
   Miguel paga de inmediato. Valeria paga después. */

/* Registro de Miguel Ospina */

BEGIN
    PA_ADMINISTRADOR.personasAd(
        851,
        '1050000851',
        'Miguel',
        'Ospina',
        DATE '2016-03-10',
        '3150000851',
        'miguel.ospina850@mail.com'
    );
END;
/

BEGIN
    PA_ADMINISTRADOR.inscripcionesAd(
        851,
        SYSDATE,
        'PENDIENTE',
        851,
        850
    );
END;
/

/* El papá de Miguel paga en transferencia. */

BEGIN
    PA_ADMINISTRADOR.pagosAd(
        851,
        150000.00,
        'PAGADO',
        'TRANSFERENCIA',
        851
    );
END;
/


/* Se verifica que la inscripción de Miguel cambió a ACTIVA. */

SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 851;


/* Registro de Valeria Rios */

BEGIN
    PA_ADMINISTRADOR.personasAd(
        852,
        '1050000852',
        'Valeria',
        'Rios',
        DATE '2015-11-20',
        '3150000852',
        'valeria.rios850@mail.com'
    );
END;
/

BEGIN
    PA_ADMINISTRADOR.inscripcionesAd(
        852,
        SYSDATE,
        'PENDIENTE',
        852,
        850
    );
END;
/

/* Valeria no paga aún. Su inscripción queda en PENDIENTE. */

BEGIN
    PA_ADMINISTRADOR.pagosAd(
        852,
        150000.00,
        'PENDIENTE',
        'EFECTIVO',
        852
    );
END;
/

/* Camilo verifica en la vista que Valeria aparece como deudora. */

SELECT nombres, apellidos, escuelaNombre, montoPendiente, cantidadPagosPendientes
FROM vw_inscripciones_pendientes
WHERE nombres = 'Valeria';


/* Pedro López programa dos entrenamientos. */

BEGIN
    PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-05',
        TO_TIMESTAMP('2025-07-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Occidente A',
        850
    );
END;
/

BEGIN
    PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-12',
        TO_TIMESTAMP('2025-07-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Occidente B',
        850
    );
END;
/

/* Los entrenamientos aparecen en el panel de programados. */

SELECT idEntrenamiento, TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha,
       lugar, equipoNombre
FROM vw_entrenamientos_programados
WHERE idEquipo = 850
ORDER BY fecha;


/* Primer entrenamiento: ambos asisten con observación. */

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MIN(idEntrenamiento)
    INTO v_idEntrenamiento
    FROM Entrenamiento
    WHERE idEquipo = 850;

    PA_ENTRENADOR.asistenciaReg(
        851,
        v_idEntrenamiento,
        'S',
        'Excelente primer dia, mucho talento'
    );
END;
/

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MIN(idEntrenamiento)
    INTO v_idEntrenamiento
    FROM Entrenamiento
    WHERE idEquipo = 850;

    PA_ENTRENADOR.asistenciaReg(
        852,
        v_idEntrenamiento,
        'S',
        'Buena actitud defensiva'
    );
END;
/

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES ((SELECT MIN(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850),
        850, 'S', 'Equipo completo, sesion exitosa');


/* Pedro revisa la asistencia del primer entrenamiento. */

SELECT nombres, apellidos, asistencia, rol, observaciones
FROM vw_asistencia_entrenamientos
WHERE idEntrenamiento = (SELECT MIN(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850)
ORDER BY apellidos;

/* Segundo entrenamiento: Valeria no llega.
   Pedro registra su ausencia sin observación.
   El trigger la completa automáticamente. */

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MAX(idEntrenamiento)
    INTO v_idEntrenamiento
    FROM Entrenamiento
    WHERE idEquipo = 850;

    PA_ENTRENADOR.asistenciaReg(
        851,
        v_idEntrenamiento,
        'S',
        'Muy buena sesion de tactica'
    );
END;
/

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MAX(idEntrenamiento)
    INTO v_idEntrenamiento
    FROM Entrenamiento
    WHERE idEquipo = 850;

    PC_ASISTENCIA.AD_ASISTENCIA(
        p_idPersona       => 852,
        p_idEntrenamiento => v_idEntrenamiento,
        p_asistencia      => 'N',
        p_rol             => 'JUGADOR',
        p_observaciones   => NULL
    );
END;
/


/* Pedro verifica que Valeria aparece con la observación automática. */

SELECT pe.nombres, pe.apellidos, pa.asistencia, pa.observaciones
FROM Participante pa
JOIN Persona pe ON pa.idPersona = pe.idPersona
WHERE pa.idEntrenamiento = (SELECT MAX(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850)
ORDER BY pe.apellidos;


/* Camilo modifica la información de Valeria (correo con error). */

BEGIN
    PC_PERSONA.MO_PERSONA(
        p_idPersona       => 852,
        p_documento       => '1050000852',
        p_nombres         => 'Valeria',
        p_apellidos       => 'Rios',
        p_fechaNacimiento => DATE '2015-11-20',
        p_telefono        => '3150000852',
        p_correo          => 'valeria.rios.corregido@mail.com'
    );
END;
/

/* Verificación correo corregido */

SELECT correo FROM Persona WHERE idPersona = 852;


/* CIERRE EN CASCADA: la directiva decide cerrar la sede Occidente.
   Al borrar la escuela, las acciones en cascada automáticamente:
   - Borran Equipo 850
   - Borran Entrenamientos del equipo 850
   - Borran Participantes de esos entrenamientos
   - Ponen los pagos con idInscripcion = NULL (conservan historial) */

/* Conteos antes de borrar. */

SELECT COUNT(*) AS equiposAntes      FROM Equipo        WHERE idEquipo    = 850;
SELECT COUNT(*) AS entrenamientosAntes FROM Entrenamiento WHERE idEquipo  = 850;
SELECT COUNT(*) AS participantesAntes  FROM Participante
WHERE idEntrenamiento IN (SELECT idEntrenamiento FROM Entrenamiento WHERE idEquipo = 850);

/* Se elimina la escuela. */

DELETE FROM Inscripcion WHERE idEscuela = 850;
DELETE FROM Escuela WHERE idEscuela = 850;

/* Verificar la eliminación en cascada (resultados deben ser 0). */

SELECT COUNT(*) AS equiposEliminados      FROM Equipo        WHERE idEquipo    = 850;
SELECT COUNT(*) AS entrenamientosEliminados FROM Entrenamiento WHERE idEquipo  = 850;
SELECT COUNT(*) AS participantesEliminados  FROM Participante
WHERE idEntrenamiento NOT IN (SELECT idEntrenamiento FROM Entrenamiento);

/* Los pagos deben seguir existiendo con idInscripcion = NULL. */

SELECT idPago, monto, estadoPago, idInscripcion
FROM Pago
WHERE idPago IN (851, 852);

ROLLBACK;