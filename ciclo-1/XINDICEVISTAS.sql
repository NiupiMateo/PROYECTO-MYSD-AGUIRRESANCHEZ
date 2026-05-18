/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Eliminación de todas las vistas e índices creados */

/*ELIMINAR VISTAS (en orden inverso de dependencia)*/
DROP VIEW IF EXISTS vw_jugadores_categoria;
DROP VIEW IF EXISTS vw_asistencia_entrenamientos;
DROP VIEW IF EXISTS vw_entrenamientos_programados;
DROP VIEW IF EXISTS vw_inscripciones_pendientes;
DROP VIEW IF EXISTS vw_recaudos_por_escuela;
DROP VIEW IF EXISTS vw_jugadores_por_equipo;
COMMIT;

/*ELIMINAR INDICES*/
DROP INDEX IF EXISTS idx_persona_documento;
DROP INDEX IF EXISTS idx_pago_estadoPago;
DROP INDEX IF EXISTS idx_inscripcion_estadoInscripcion;
DROP INDEX IF EXISTS idx_entrenamiento_estado;
DROP INDEX IF EXISTS idx_jugador_numeroCamiseta;
DROP INDEX IF EXISTS idx_participante_idEntrenamiento;
DROP INDEX IF EXISTS idx_recibe_idEntrenamiento;
DROP INDEX IF EXISTS idx_inscripcion_idEscuela;
DROP INDEX IF EXISTS idx_entrenamiento_idEquipo;
DROP INDEX IF EXISTS idx_inscripcion_idPersona;
COMMIT;
