/* PROYECTO: Formando Campeones
   CICLO 4
   OBJETIVO: Definición de roles y permisos */

/*CREAR ROLES*/
CREATE ROLE C##ADMINISTRADOR;
CREATE ROLE C##ENTRENADOR;

/*GRANT PERMISOS A ADMINISTRADOR (Acceso a todos los componentes)*/
GRANT EXECUTE ON PK_ADMINISTRACION TO C##ADMINISTRADOR;

GRANT EXECUTE ON PK_ENTRENAMIENTO TO C##ADMINISTRADOR;

GRANT EXECUTE ON PK_AUDITORIAS TO C##ADMINISTRADOR;

GRANT EXECUTE ON PK_ENTRENAMIENTO TO C##ENTRENADOR;


COMMIT;


/* Nota:
   La ejecución de CREATE ROLE puede requerir privilegios DBA.
   El script fue definido correctamente, pero su ejecución
   depende de los permisos del usuario Oracle utilizado.
*/