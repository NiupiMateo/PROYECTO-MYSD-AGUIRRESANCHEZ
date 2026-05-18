/* PROYECTO: Formando Campeones */


/*
CONFIGURACIÓN DE USUARIOS Y PRIVILEGIOS PARA PRUEBAS

Este script define los usuarios de prueba y la asignación de roles
para el sistema "Formando Campeones".

Despues de haber ya creado y asignado roles 

USUARIO ADMINISTRADOR

CREATE USER C##ADMIN_TEST IDENTIFIED BY "pass123";
GRANT CREATE SESSION TO C##ADMIN_TEST;

-- Asignación del rol administrador
GRANT C##ADMINISTRADOR TO C##ADMIN_TEST;


USUARIO ENTRENADOR:

CREATE USER C##MATEO IDENTIFIED BY "pass123";
GRANT CREATE SESSION TO C##MATEO;

-- Asignación del rol entrenador
GRANT C##ENTRENADOR TO C##MATEO;


USUARIO GERENTE:


CREATE USER C##GERENTE_USER IDENTIFIED BY "pass123";

GRANT CREATE SESSION TO C##GERENTE_USER;

-- Asignación del rol gerente
GRANT C##GERENTE TO C##GERENTE_USER;


Tenemos presente que estos usuarios únicamente tienen permiso para iniciar sesión
y ejecutar los privilegios heredados desde sus roles.
No se asignan permisos directos sobre objetos del esquema,
ya que el control de acceso se maneja exclusivamente mediante roles.
*/

/* PRUEBA DE ACEPTACION 1
   Nombre: El día que Sofia se convirtio en jugadora oficial

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
   único, correo único y telefono único. Después de la ejecución debe funcionar. */
     
BEGIN
    USUARIO_CAMILO.PC_PERSONA.AD_PERSONA(
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
   El indice sobre documento hace esta busqueda rapida en el usuario de la DB */

SELECT * FROM Persona WHERE idPersona = 750;


/* Camilo intenta registrar otra persona con el mismo documento
   de Sofia. Detecta el duplicado y lanza error. */

BEGIN
    USUARIO_CAMILO.PC_PERSONA.AD_PERSONA(
        p_idPersona       => 751,
        p_documento       => '1050000750',
        p_nombres         => 'Duplicado',
        p_apellidos       => 'Test',
        p_fechaNacimiento => DATE '2014-01-01',
        p_telefono        => '3150000751',
        p_correo          => 'duplicado@mail.com'
    );
END;
/


/* Sofia es mayor de 5 años, asi que Camilo la inscribe en la escuela.
   El package PC_INSCRIPCION valida que la fecha de inscripcion no
   sea futura. Después de la ejecución debe funcionar. */

BEGIN
    USUARIO_CAMILO.PC_INSCRIPCION.AD_INSCRIPCION(
        p_idInscripcion     => 750,
        p_fechaInscripcion  => TRUNC(SYSDATE),
        p_estadoInscripcion => 'PENDIENTE',
        p_idPersona         => 750,
        p_idEscuela         => 1
    );
END;
/

/* La vista de inscripciones pendientes ya muestra a Sofia
   esperando confirmar su pago en usuario_camilo*/

SELECT idInscripcion, nombres, apellidos, escuelaNombre, estadoInscripcion
FROM vw_inscripciones_pendientes
WHERE nombres = 'Sofia';


/* El papá de Sofia paga en efectivo en ese momento.
   Camilo registra el pago. */

BEGIN
    USUARIO_CAMILO.PC_PAGO.AD_PAGO(
        p_idPago        => 750,
        p_fechaPago     => NULL,
        p_monto         => 150000.00,
        p_estadoPago    => 'PAGADO',
        p_metodoPago    => 'EFECTIVO',
        p_idInscripcion => 750
    );
END;
/


/* Camilo verifica los efectos automáticos de los disparadores desde usuario_camilo*/

SELECT idPago, fechaPago, estadoPago FROM Pago WHERE idPago = 750;
SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 750;


/* Un practicante intenta registrar un pago con monto negativo.
   El package PC_PAGO lo detecta y rechaza. Después de la ejecución debe fallar. */
   
BEGIN
    USUARIO_CAMILO.PC_PAGO.AD_PAGO(
        p_idPago        => 751,
        p_fechaPago     => SYSDATE,
        p_monto         => -50000.00,
        p_estadoPago    => 'PENDIENTE',
        p_metodoPago    => 'EFECTIVO',
        p_idInscripcion => 750
    );
END;
/

/* Otro intento erroneo: metodo de pago con valor no permitido.
   Solo se aceptan EFECTIVO, TRANSFERENCIA o TARJETA. Después de la ejecución debe fallar. */
   
BEGIN
    USUARIO_CAMILO.PC_PAGO.AD_PAGO(
        p_idPago        => 752,
        p_fechaPago     => SYSDATE,
        p_monto         => 100000.00,
        p_estadoPago    => 'PENDIENTE',
        p_metodoPago    => 'BITCOIN',
        p_idInscripcion => 750
    );
END;
/

/* La vista de recaudos refleja el pago de Sofia en usuario_camilo */

SELECT escuelaNombre, totalRecaudado, totalPendiente
FROM vw_recaudos_por_escuela
WHERE idEscuela = 1;


/* Llega el primer entrenamiento. Pedro Lopez, el entrenador,
   usa su rol PA_ENTRENADOR para crear el entrenamiento. */

BEGIN
    USUARIO_CAMILO.PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-06-15',
        TO_TIMESTAMP('2025-06-15 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Norte Principal',
        1
    );
END;
/

/* Pedro revisa los entrenamientos programados en usuario_camilo. */

SELECT idEntrenamiento, TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha,
       lugar, equipoNombre
FROM vw_entrenamientos_programados
WHERE idEquipo = 1
ORDER BY fecha;

/* Sofia llega al entrenamiento. Pedro registra su asistencia
   con observación. Después de la ejecución debe funcionar. */

BEGIN
    USUARIO_CAMILO.PA_ENTRENADOR.asistenciaReg(
        750,
        2,
        'S',
        'Sofia demostro excelente tecnica en su primera sesion'
    );
END;
/

/* Pedro intenta registrar asistencia S sin observación.
   La restricción de tupla lo impide. Después de la ejecución debe fallar. */

BEGIN
    INSERT INTO USUARIO_CAMILO.PARTICIPANTE (
        idPersona,
        idEntrenamiento,
        asistencia,
        rol,
        observaciones
    )
    VALUES (
        777,
        (
            SELECT MAX(idEntrenamiento)
            FROM USUARIO_CAMILO.ENTRENAMIENTO
            WHERE lugar = 'Cancha Norte Principal'
        ),
        'S',
        'JUGADOR',
        NULL
    );
END;
/

/* Al siguiente entrenamiento Sofia no puede ir. Pedro registra
   su ausencia sin observación. El trigger la completa automáticamente. 
   Después de la ejecución debe funcionar. */

/* Crear el entrenamiento */

BEGIN
    USUARIO_CAMILO.PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
        p_idEntrenamiento => 750,
        p_fecha           => DATE '2025-06-22',
        p_hora            => TO_TIMESTAMP('2025-06-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_lugar           => 'Cancha Norte Auxiliar',
        p_estado          => 'PROGRAMADO',
        p_idEquipo        => 1
    );
END;
/
/* Registrar la asistencia */

BEGIN
    USUARIO_CAMILO.PC_ASISTENCIA.AD_ASISTENCIA(
        p_idPersona       => 750,
        p_idEntrenamiento => 750,
        p_asistencia      => 'N',
        p_rol             => 'JUGADOR',
        p_observaciones   => NULL
    );
END;
/

/* Pedro verifica que el trigger completó la observación en usuario_camilo */

SELECT asistencia, observaciones
FROM Participante
WHERE idPersona = 750 AND idEntrenamiento = 750;


/* Camilo consulta la asistencia de Sofia. en usuario_camilo */

SELECT TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha, nombres, apellidos,
       asistencia, rol, observaciones
FROM vw_asistencia_entrenamientos
WHERE idPersona = 750
ORDER BY fecha;


/* Camilo revisa el estado financiero vía PA_GERENTE. */

DECLARE
    v_cur      SYS_REFCURSOR;
    v_estado   VARCHAR2(30);
    v_cantidad NUMBER;
    v_monto    NUMBER;
BEGIN
    v_cur := USUARIO_CAMILO.PA_GERENTE.pagosPorEstado();

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
    USUARIO_CAMILO.PA_ADMINISTRADOR.escuelasAdd(
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
    USUARIO_CAMILO.PA_ADMINISTRADOR.categoriasAdd(
        850,
        'SUB10',
        'Categoria pre-infantil menores de 10 años',
        'BASICO'
    );
END;
/

/* El equipo Panteras Occidente queda activo. */

BEGIN
    USUARIO_CAMILO.PC_EQUIPO.AD_EQUIPO(
        p_idEquipo     => 850,
        p_nombre       => 'Panteras Occidente',
        p_estadoEquipo => 'ACTIVO',
        p_idEscuela    => 850,
        p_idCategoria  => 850
    );
END;
/

/* Verificación de la estructura creada desde usuario_Camilo */

SELECT * FROM Escuela   WHERE idEscuela   = 850;
SELECT * FROM Categoria WHERE idCategoria = 850;
SELECT * FROM Equipo    WHERE idEquipo    = 850;


/* Llegan dos jugadores: Miguel Ospina y Valeria Rios.
   Miguel paga de inmediato. Valeria paga después. */

/* Registro de Miguel Ospina */

BEGIN
    USUARIO_CAMILO.PA_ADMINISTRADOR.personasAd(
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

/* Crear inscripción */

BEGIN
    USUARIO_CAMILO.PA_ADMINISTRADOR.inscripcionesAd(
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
    USUARIO_CAMILO.PA_ADMINISTRADOR.pagosAd(
        851,
        150000.00,
        'PAGADO',
        'TRANSFERENCIA',
        851
    );
END;
/

/* Se verifica que la inscripción de Miguel cambió a ACTIVA desde usuario_camilo */

SELECT idInscripcion, estadoInscripcion FROM Inscripcion WHERE idInscripcion = 851;


/* Registro de Valeria Rios */

BEGIN
    USUARIO_CAMILO.PA_ADMINISTRADOR.personasAd(
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
    USUARIO_CAMILO.PA_ADMINISTRADOR.inscripcionesAd(
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
    USUARIO_CAMILO.PA_ADMINISTRADOR.pagosAd(
        852,
        150000.00,
        'PENDIENTE',
        'EFECTIVO',
        852
    );
END;
/

/* Camilo verifica en la vista que Valeria aparece como deudora en usuario_camilo. */

SELECT nombres, apellidos, escuelaNombre, montoPendiente, cantidadPagosPendientes
FROM vw_inscripciones_pendientes
WHERE nombres = 'Valeria';


/* Pedro López programa dos entrenamientos. */

BEGIN
    USUARIO_CAMILO.PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-05',
        TO_TIMESTAMP('2025-07-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha Occidente A',
        850
    );
END;
/

BEGIN
    USUARIO_CAMILO.PA_ENTRENADOR.entrenamientosAd(
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


/* Primer entrenamiento: ambos asisten con observación en usuario_camilo. */

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MIN(idEntrenamiento)
    INTO v_idEntrenamiento
    FROM USUARIO_CAMILO.ENTRENAMIENTO
    WHERE idEquipo = 850;

    USUARIO_CAMILO.PA_ENTRENADOR.asistenciaReg(
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
    FROM USUARIO_CAMILO.ENTRENAMIENTO
    WHERE idEquipo = 850;

    USUARIO_CAMILO.PA_ENTRENADOR.asistenciaReg(
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

/* Pedro revisa la asistencia del primer entrenamiento en usuario_camilo. */

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
    FROM USUARIO_CAMILO.ENTRENAMIENTO
    WHERE idEquipo = 850;

    USUARIO_CAMILO.PA_ENTRENADOR.asistenciaReg(
        851,
        v_idEntrenamiento,
        'S',
        'Muy buena sesion de tactica'
    );
END;
/

/* Valeria no asiste */

DECLARE
    v_idEntrenamiento NUMBER;
BEGIN
    SELECT MAX(idEntrenamiento)
    INTO v_idEntrenamiento
    FROM USUARIO_CAMILO.ENTRENAMIENTO
    WHERE idEquipo = 850;

    USUARIO_CAMILO.PC_ASISTENCIA.AD_ASISTENCIA(
        p_idPersona       => 852,
        p_idEntrenamiento => v_idEntrenamiento,
        p_asistencia      => 'N',
        p_rol             => 'JUGADOR',
        p_observaciones   => NULL
    );
END;
/

/* Pedro verifica que Valeria aparece con la observación automática, desde usuario_camilo */

SELECT pe.nombres, pe.apellidos, pa.asistencia, pa.observaciones
FROM Participante pa
JOIN Persona pe ON pa.idPersona = pe.idPersona
WHERE pa.idEntrenamiento = (SELECT MAX(idEntrenamiento) FROM Entrenamiento WHERE idEquipo = 850)
ORDER BY pe.apellidos;


/* Camilo consulta el estado financiero de la sede Occidente. */

SELECT escuelaNombre, totalRecaudado, totalPendiente, totalPagos
FROM vw_recaudos_por_escuela
WHERE idEscuela = 850;

DECLARE
    v_cur         SYS_REFCURSOR;
    v_idEscuela   NUMBER;
    v_nombre      VARCHAR2(120);
    v_inscritos   NUMBER;
BEGIN
    v_cur := USUARIO_CAMILO.PA_GERENTE.escuelasConMayorDemanda();

    LOOP
        FETCH v_cur INTO v_idEscuela, v_nombre, v_inscritos;
        EXIT WHEN v_cur%NOTFOUND;
    END LOOP;

    CLOSE v_cur;
END;
/

/* Camilo modifica la información de Valeria (correo con error). */

BEGIN
    USUARIO_CAMILO.PC_PERSONA.MO_PERSONA(
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


/* ESCENARIO 1: Mateo intenta eliminar una inscripción

El usuario C##MATEO tiene permisos para ejecutar el paquete
PA_ENTRENADOR, pero no tiene permisos sobre PA_ADMINISTRADOR.

Cuando intenta ejecutar:

PA_ADMINISTRADOR.inscripcionesEli(852)

Oracle valida primero los privilegios del usuario y bloquea
la ejecución porque no tiene el permiso EXECUTE sobre ese paquete.

Por seguridad, la inscripción no se elimina y la base de datos
permanece consistente. */

BEGIN

    PA_ADMINISTRADOR.inscripcionesEli(852);
END;
/


/* Verificación: Inscripción de Valeria sigue existiendo */

SELECT idInscripcion, idPersona, estadoInscripcion
FROM Inscripcion
WHERE idInscripcion = 852;


/* ESCENARIO 2: Mateo intenta crear un pago

El usuario C##MATEO tiene permisos para ejecutar el paquete
PA_ENTRENADOR, pero no tiene permisos sobre PA_ADMINISTRADOR.

Cuando intenta ejecutar:

PA_ADMINISTRADOR.pagosAd(...)

Oracle valida primero los privilegios del usuario y bloquea
la ejecución porque no tiene el permiso EXECUTE sobre ese paquete.

Por seguridad, el pago no se crea y la base de datos
permanece protegida. */
   
BEGIN
    USUARIO_CAMILO.PA_ADMINISTRADOR.pagosAd(
        999,
        50000.00,
        'PAGADO',
        'EFECTIVO',
        852
    );
END;
/

/* Verificación: Pago malicioso no se creó */

SELECT COUNT(*) AS pagos_no_autorizados
FROM Pago
WHERE idPago = 999;


/* ESCENARIO 3: Gerente intenta crear un entrenamiento

El usuario C##GERENTE tiene permisos para ejecutar el paquete
PA_GERENTE, pero no tiene permisos sobre PA_ENTRENADOR.

Cuando intenta ejecutar:

PA_ENTRENADOR.entrenamientosAd(...)

Oracle valida primero los privilegios del usuario y bloquea
la ejecución porque no tiene el permiso EXECUTE sobre ese paquete.

Por seguridad, el entrenamiento no se crea y el usuario solo
puede consultar reportes según los permisos asignados a su rol. */
   
BEGIN
    USUARIO_CAMILO.PA_ENTRENADOR.entrenamientosAd(
        DATE '2025-07-20',
        TO_TIMESTAMP('2025-07-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        'Cancha No Autorizada',
        850
    );
END;
/

/* Verificación: Entrenamiento no autorizado no existe */

SELECT COUNT(*) AS entrenamientos_no_autorizados
FROM Entrenamiento
WHERE lugar = 'Cancha No Autorizada';


/* CIERRE EN CASCADA: la directiva decide cerrar la sede Occidente.
    Al eliminar la escuela, Oracle ejecuta automáticamente las acciones
    en cascada definidas en la base de datos: se eliminan los equipos
    asociados, también los entrenamientos relacionados con esos equipos
    y los pagos quedan con idInscripcion en NULL para mantener la
    integridad de los datos. */

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


/* CIERRE EN CASCADA: la directiva decide cerrar la sede Occidente.
    Al eliminar la escuela, Oracle ejecuta automáticamente las acciones
    en cascada configuradas en la base de datos, eliminando los equipos
    y entrenamientos asociados. Además, los pagos relacionados conservan
    su información, pero el campo idInscripcion queda en NULL para
    mantener la integridad referencial. */

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
