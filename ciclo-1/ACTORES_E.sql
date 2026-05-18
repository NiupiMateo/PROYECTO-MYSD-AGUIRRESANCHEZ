/* PROYECTO: Formando Campeones
   CICLO 1 - ESPECIFICACIÓN PAQUETES ACTORES_E
   
   OBJETIVO: Definir interfaces de acceso por rol (EXACTAMENTE según UML ASTAH)
   - PA_ADMINISTRADOR: Wrappers de personas, equipos, pagos, inscripciones, categorías, escuelas
   - PA_ENTRENADOR: Wrappers de entrenamientos, participantes, asistencia
   - PA_GERENTE: Wrappers de consultas gerenciales (solo lectura)
*/

/* PAQUETE PARA ADMINISTRADORES - ACCESO TOTAL */
CREATE OR REPLACE PACKAGE PA_ADMINISTRADOR AS
    
    /* PERSONAS */
    PROCEDURE personasAd(
        idPersona IN NUMBER, documento IN VARCHAR2, nombres IN VARCHAR2, 
        apellidos IN VARCHAR2, fechaNacimiento IN DATE, telefono IN VARCHAR2, correo IN VARCHAR2
    );
    
    PROCEDURE personasMod(
        idPersona IN NUMBER, documento IN VARCHAR2, nombres IN VARCHAR2, 
        apellidos IN VARCHAR2, telefono IN VARCHAR2, correo IN VARCHAR2
    );
    
    PROCEDURE personasEli(idPersona IN NUMBER);
    
    FUNCTION personasC RETURN SYS_REFCURSOR;
    
    /* EQUIPOS */
    PROCEDURE equiposAd(
        nombre IN VARCHAR2, idEscuela IN NUMBER, idCategoria IN NUMBER
    );
    
    PROCEDURE equiposMod(
        idEquipo IN NUMBER, nombre IN VARCHAR2, estadoEquipo IN VARCHAR2
    );
    
    PROCEDURE equiposEli(idEquipo IN NUMBER);
    
    FUNCTION equiposC RETURN SYS_REFCURSOR;
    
    /*  PAGOS */
    PROCEDURE pagosAd(
        idPago IN NUMBER, monto IN NUMBER, estadoPago IN VARCHAR2, 
        metodoPago IN VARCHAR2, idInscripcion IN NUMBER
    );
    
    PROCEDURE pagosMod(
        idPago IN NUMBER, estadoPago IN VARCHAR2
    );
    
    FUNCTION pagosC RETURN SYS_REFCURSOR;
    
    /* INSCRIPCIONES */
    PROCEDURE inscripcionesAd(
        idInscripcion IN NUMBER, fechaInscripcion IN DATE, estadoInscripcion IN VARCHAR2, 
        idPersona IN NUMBER, idEscuela IN NUMBER
    );
    
    PROCEDURE inscripcionesMod(
        idInscripcion IN NUMBER, estadoInscripcion IN VARCHAR2
    );
    
    PROCEDURE inscripcionesEli(idInscripcion IN NUMBER);
    
    FUNCTION recaudadoPorEscuela RETURN SYS_REFCURSOR;
    
    /* CONSULTAS OPERATIVAS */
    FUNCTION jugadoresPorEquipo(idEquipo IN NUMBER) RETURN SYS_REFCURSOR;
    
    FUNCTION jugadoresPorCategoria(idCategoria IN NUMBER) RETURN SYS_REFCURSOR;
    
    FUNCTION inscripcionesPendientes RETURN SYS_REFCURSOR;
    
    /* CATEGORÍAS */
    PROCEDURE categoriasAdd(
        idCategoria IN NUMBER, nombre IN VARCHAR2, descripcion IN VARCHAR2, nivel IN VARCHAR2
    );
    
    /* ESCUELAS */
    PROCEDURE escuelasAdd(
        idEscuela IN NUMBER, nombre IN VARCHAR2, direccion IN VARCHAR2, 
        telefono IN VARCHAR2, correo IN VARCHAR2
    );
    
END PA_ADMINISTRADOR;
/

/* PAQUETE PARA ENTRENADORES - ACCESO LIMITADO */
CREATE OR REPLACE PACKAGE PA_ENTRENADOR AS
    
    /* ENTRENAMIENTOS */
    PROCEDURE entrenamientosAd(
        fecha IN DATE, hora IN TIMESTAMP, lugar IN VARCHAR2, idEquipo IN NUMBER
    );
    
    PROCEDURE entrenamientosMod(
        idEntrenamiento IN NUMBER, fecha IN DATE, hora IN TIMESTAMP, lugar IN VARCHAR2
    );
    
    FUNCTION entrenamientosC RETURN SYS_REFCURSOR;
    
    PROCEDURE entrenamientoEli(idEntrenamiento IN NUMBER);
    
    FUNCTION entrenamientosProgramadosC RETURN SYS_REFCURSOR;
    
    /*  PARTICIPANTES  */
    PROCEDURE participantesAd(
        idPersona IN NUMBER, idEntrenamiento IN NUMBER, asistencia IN CHAR, rol IN VARCHAR2
    );
    
    FUNCTION participantesC RETURN SYS_REFCURSOR;
    
    /* CONSULTAS OPERATIVAS  */
    FUNCTION jugadoresEquipo(idEquipo IN NUMBER) RETURN SYS_REFCURSOR;
    
    /* ASISTENCIA */
    PROCEDURE asistenciaReg(
        idPersona IN NUMBER, idEntrenamiento IN NUMBER, asistencia IN CHAR, observaciones IN VARCHAR2
    );
    
    FUNCTION asistenciaC RETURN SYS_REFCURSOR;
    
END PA_ENTRENADOR;
/

/* PAQUETE PARA GERENTES - CONSULTAS GERENCIALES SOLO LECTURA */
CREATE OR REPLACE PACKAGE PA_GERENTE AS
    
    FUNCTION jugadoresPorEscuela RETURN SYS_REFCURSOR;
    
    FUNCTION pagosPorEstado RETURN SYS_REFCURSOR;
    
    FUNCTION promedioJugadoresPorEntrenamiento RETURN SYS_REFCURSOR;
    
    FUNCTION escuelasConMayorDemanda RETURN SYS_REFCURSOR;
    
    FUNCTION entrenamientosPorEquipo RETURN SYS_REFCURSOR;
    
END PA_GERENTE;
/
