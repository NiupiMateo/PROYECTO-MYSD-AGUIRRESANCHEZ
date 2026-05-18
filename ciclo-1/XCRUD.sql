/* PROYECTO: Formando Campeones XCRUD
   CICLO 1 - ELIMINACIÓN DE PAQUETES
   OBJETIVO: Eliminar todos los packages (body + spec) del proyecto
*/

/*PASO 1: ELIMINAR PACKAGE BODIES*/

/*Package body: Asistencia (depende de Entrenamiento y Persona)*/
DROP PACKAGE BODY PC_ASISTENCIA;
/

/* Package body: Entrenamiento (depende de Equipo) */
DROP PACKAGE BODY PC_ENTRENAMIENTO;
/

/* Package body: Pago (depende de Inscripcion) */
DROP PACKAGE BODY PC_PAGO;
/

/* Package body: Inscripcion (depende de Persona y Escuela) */
DROP PACKAGE BODY PC_INSCRIPCION;
/

/* Package body: Equipo (depende de Escuela y Categoria) */
DROP PACKAGE BODY PC_EQUIPO;
/

/* Package body: Persona (sin dependencias de negocio) */
DROP PACKAGE BODY PC_PERSONA;
/


/* PASO 2: ELIMINAR PAQUETES*/

/* Asistencia*/
DROP PACKAGE PC_ASISTENCIA;
/

/* Entrenamiento */
DROP PACKAGE PC_ENTRENAMIENTO;
/

/* Pago*/
DROP PACKAGE PC_PAGO;
/

/* Inscripcion */
DROP PACKAGE PC_INSCRIPCION;
/

/* Equipo */
DROP PACKAGE PC_EQUIPO;
/

/* Persona */
DROP PACKAGE PC_PERSONA;
/

