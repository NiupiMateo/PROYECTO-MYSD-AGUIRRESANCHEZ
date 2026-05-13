/* PROYECTO: Formando Campeones
   CICLO 4
   OBJETIVO: Definición de roles y permisos */

/*CREAR ROLES*/
CREATE ROLE ADMINISTRADOR;
CREATE ROLE ENTRENADOR;

/*GRANT PERMISOS A ADMINISTRADOR (Acceso a todos los componentes)*/
GRANT EXECUTE ON PK_ADMINISTRACION TO ADMINISTRADOR;
GRANT EXECUTE ON PK_ENTRENAMIENTO TO ADMINISTRADOR;
GRANT EXECUTE ON PK_AUDITORIAS TO ADMINISTRADOR;

/*GRANT PERMISOS A ENTRENADOR (Acceso limitado a componentes de entrenamiento)*/
GRANT EXECUTE ON PK_ENTRENAMIENTO TO ENTRENADOR;

COMMIT;


/* Nota:
   La ejecución de CREATE ROLE puede requerir privilegios DBA.
   El script fue definido correctamente, pero su ejecución
   depende de los permisos del usuario Oracle utilizado.
*/