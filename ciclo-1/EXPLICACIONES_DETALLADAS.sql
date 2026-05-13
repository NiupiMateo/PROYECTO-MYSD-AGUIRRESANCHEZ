/*
================================================================================
        EXPLICACIONES DETALLADAS CON RESULTADOS ESPERADOS
              POR QUÉ FUNCIONA CADA COMPONENTE Y QUÉ ESPERAR
================================================================================

Este archivo explica en PROFUNDIDAD cada componente del proyecto.
Úsalo como REFERENCIA mientras ejecutas el proyecto.

================================================================================
                    SECCIÓN 1: CONSTRAINTS COMPLEJOS (TUPLAS)
================================================================================

Archivo: TUPLAS.sql

¿QUÉ SON CONSTRAINTS COMPLEJOS?
════════════════════════════════

Son validaciones que involucran MÚLTIPLES COLUMNAS de una tabla.

Ejemplo: "Si asistencia='S' (sí asistió), ENTONCES observaciones debe tener valor"

Esto es diferente a un CHECK simple como "monto > 0" que solo mira 1 columna.

CONSTRAINT 1: ck_participante_asistencia_obs
═════════════════════════════════════════════

REGLA:
──────
"Si un Participante asistió (asistencia='S'), DEBE tener observaciones.
 Si NO asistió (asistencia='N'), las observaciones pueden ser NULL."

¿POR QUÉ?
─────────
Porque si alguien sí asistió, queremos SABER CÓMO FUE su desempeño:
  - "Jugó bien"
  - "Necesita mejorar defensa"
  - "Muy cansado"

Pero si NO asistió, el TRIGGER ya auto-llena: "No asistio al entrenamiento"

SQL:
────
ALTER TABLE Participante
ADD CONSTRAINT ck_participante_asistencia_obs
CHECK (asistencia = 'N' OR observaciones IS NOT NULL);

EXPLICACIÓN:
────────────
  asistencia = 'N' OR observaciones IS NOT NULL
  
Significa:
  - O la asistencia es 'N' (no asistió)
  - O hay observaciones (sí asistió Y tiene observaciones)

¿QUÉ PASARÍA SI VIOLO ESTA REGLA?
──────────────────────────────────

INSERTANDO INVÁLIDO:
  INSERT INTO Participante (..., asistencia='S', observaciones=NULL)
  
RESULTADO:
  ORA-02290: check constraint violated
  
TRADUCCIÓN: "¡asistencia es 'S' pero observaciones está vacío!"

INSERTANDO VÁLIDO:
  INSERT INTO Participante (..., asistencia='S', observaciones='Jugó bien')
  
RESULTADO:
  1 row created.
  
TRADUCCIÓN: "OK, asistió Y tiene observaciones"

CONSTRAINT 2: ck_recibe_asistencia_obs
═══════════════════════════════════════

IDÉNTICO al anterior pero para la tabla RECIBE.

Almacena: Si un EQUIPO completo asistió al entrenamiento.

¿POR QUÉ HAY 2 SIMILARES?
──────────────────────────
Porque:
  - PARTICIPANTE: Registra PERSONAS individuales
  - RECIBE: Registra EQUIPOS (grupos completos)

Las reglas son iguales pero en tablas diferentes.

CONSTRAINT 3: ck_pago_estado_monto
════════════════════════════════════

REGLA:
──────
"El estado del pago DEBE ser uno de estos 3 valores Y el monto DEBE ser > 0"

SQL:
────
CHECK (estadoPago IN ('PAGADO', 'PENDIENTE', 'ANULADO') AND monto > 0)

EXPLICACIÓN:
────────────
Valida DOS cosas simultáneamente:
  1. El estado es válido: 'PAGADO', 'PENDIENTE', o 'ANULADO'
  2. El monto es positivo: > 0

¿QUÉ PASARÍA SI VIOLO ESTA REGLA?
──────────────────────────────────

INSERTANDO CON ESTADO INVÁLIDO:
  INSERT INTO Pago (..., estadoPago='COMPLETADO', monto=100000)
  
RESULTADO:
  ORA-02290: check constraint violated
  
TRADUCCIÓN: "'COMPLETADO' NO está en ('PAGADO', 'PENDIENTE', 'ANULADO')"

INSERTANDO CON MONTO NEGATIVO:
  INSERT INTO Pago (..., estadoPago='PAGADO', monto=-50000)
  
RESULTADO:
  ORA-02290: check constraint violated
  
TRADUCCIÓN: "-50000 NO es > 0"

INSERTANDO VÁLIDO:
  INSERT INTO Pago (..., estadoPago='PAGADO', monto=100000)
  
RESULTADO:
  1 row created.

================================================================================
                    SECCIÓN 2: VISTAS - CONSULTAS SIMPLIFICADAS
================================================================================

Archivo: VISTAS.sql

¿QUÉ SON LAS VISTAS?
════════════════════

Son "tablas virtuales" que contienen el RESULTADO de una consulta compleja.

En lugar de escribir la consulta cada vez, simplemente haces:
  SELECT * FROM vw_jugadores_por_equipo;

VENTAJAS:
─────────
  1. Simplifica consultas complejas
  2. Reutilizable
  3. Más rápido (aprovecha índices)
  4. Mantenimiento más fácil

VISTA 1: vw_jugadores_por_equipo
═════════════════════════════════

¿QUÉ HACE?
──────────
Muestra TODOS los jugadores de cada equipo con sus datos completos.

COLUMNAS RESULTADO:
───────────────────
  - idEquipo: ID del equipo
  - equipoNombre: Nombre del equipo
  - idPersona: ID del jugador
  - nombres: Nombre del jugador
  - apellidos: Apellido del jugador
  - documento: Cédula del jugador
  - posicion: Posición del jugador (DELANTERO, DEFENSA, etc.)
  - numeroCamiseta: Número de camiseta

SQL SIMPLIFICADO:
──────────────────
CREATE OR REPLACE VIEW vw_jugadores_por_equipo AS
SELECT 
    eq.idEquipo, eq.nombre AS equipoNombre,
    p.idPersona, p.nombres, p.apellidos, p.documento,
    j.posicion, j.numeroCamiseta
FROM Equipo eq
JOIN Escuela e ON eq.idEscuela = e.idEscuela
JOIN Inscripcion i ON e.idEscuela = i.idEscuela
JOIN Persona p ON i.idPersona = p.idPersona
LEFT JOIN Jugador j ON p.idPersona = j.idPersona
WHERE j.idPersona IS NOT NULL
ORDER BY eq.idEquipo, p.nombres;

¿POR QUÉ TANTOS JOINS?
──────────────────────
Porque para ir de Equipo → Jugador, necesitas:
  1. Equipo → Escuela (está en FK)
  2. Escuela → Inscripcion (inscripciones en escuelas)
  3. Inscripcion → Persona (personas inscritas)
  4. Persona → Jugador (personas que son jugadores)

RESULTADO ESPERADO (Datos de ejemplo):
──────────────────────────────────────
  idEquipo  equipoNombre   idPersona  nombres    apellidos   posicion    numeroCamiseta
  ────────  ─────────────  ─────────  ─────────  ─────────   ─────────   ──────────────
  1         Equipo A       1          Juan       Perez       DELANTERO   9
  1         Equipo A       2          Carlos     Gomez       DEFENSA     4
  2         Equipo B       3          Laura      Martinez    ARQUERO     1

CÓMO USARLA:
────────────
SELECT * FROM vw_jugadores_por_equipo 
WHERE equipoNombre = 'Equipo A';

RESULTADO:
  3 filas con todos los jugadores del Equipo A

VISTA 2: vw_recaudos_por_escuela
═════════════════════════════════

¿QUÉ HACE?
──────────
Muestra CUÁNTO DINERO ha RECAUDADO cada escuela.

COLUMNAS RESULTADO:
───────────────────
  - escuelaNombre: Nombre de la escuela
  - totalRecaudado: Dinero que ya pagaron
  - totalPendiente: Dinero que FALTA pagar
  - totalInscripciones: Total de inscripciones

SQL:
────
CREATE OR REPLACE VIEW vw_recaudos_por_escuela AS
SELECT 
    e.nombre AS escuelaNombre,
    COUNT(DISTINCT p.idPago) AS totalPagos,
    SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END) AS totalRecaudado,
    SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END) AS totalPendiente,
    SUM(p.monto) AS totalInscripciones
FROM Escuela e
LEFT JOIN Inscripcion i ON e.idEscuela = i.idEscuela
LEFT JOIN Pago p ON i.idInscripcion = p.idInscripcion
GROUP BY e.nombre
ORDER BY e.idEscuela;

¿POR QUÉ CASE WHEN?
────────────────────
Porque queremos SUMAR SOLO los pagos PAGADOS, y SUMAR SOLO los PENDIENTES.

CASE WHEN estadoPago = 'PAGADO' THEN p.monto ELSE 0 END
Significa:
  "Si el pago es PAGADO, suma el monto. Si no, suma 0"

RESULTADO ESPERADO (Datos de ejemplo):
──────────────────────────────────────
  escuelaNombre                    totalRecaudado  totalPendiente  totalInscripciones
  ─────────────────────────────    ──────────────  ──────────────  ──────────────────
  Escuela Formando Campeones Norte 240000.00       150000.00       390000.00
  Escuela Formando Campeones Sur   180000.00       120000.00       300000.00

INTERPRETACIÓN:
───────────────
Escuela Norte:
  - Ya recaudó: $240,000
  - Falta cobrar: $150,000
  - Total inscripciones: $390,000
  - Porcentaje cobrado: 61.5%

CÓMO USARLA:
────────────
SELECT escuelaNombre, 
       ROUND((totalRecaudado / totalInscripciones) * 100, 2) AS porcentajeCobrado
FROM vw_recaudos_por_escuela
WHERE totalRecaudado > 0;

RESULTADO:
  Muestra qué % de inscripciones ha sido cobrado por cada escuela

VISTA 3: vw_inscripciones_pendientes
═════════════════════════════════════

¿QUÉ HACE?
──────────
Lista TODAS las inscripciones que AÚN NO HAN PAGADO completamente.

COLUMNAS RESULTADO:
───────────────────
  - idInscripcion: ID de la inscripción
  - nombres / apellidos: Quién se inscribió
  - escuelaNombre: En cuál escuela
  - montoPendiente: Cuánto falta pagar

RESULTADO ESPERADO (Datos de ejemplo):
──────────────────────────────────────
  idInscripcion  nombres    apellidos   escuelaNombre                    montoPendiente
  ─────────────  ────────   ─────────   ─────────────────────────────    ──────────────
  1              Juan       Perez       Escuela Formando Campeones Norte 50000.00
  3              Laura      Martinez    Escuela Formando Campeones Sur   75000.00

CÓMO USARLA:
────────────
SELECT * FROM vw_inscripciones_pendientes 
WHERE montoPendiente > 100000;

RESULTADO:
  Muestra inscripciones con más de $100,000 pendientes

VISTA 4: vw_entrenamientos_programados
═══════════════════════════════════════

¿QUÉ HACE?
──────────
Lista todos los entrenamientos que AÚN NO SE HAN REALIZADO.

COLUMNAS RESULTADO:
───────────────────
  - idEntrenamiento: ID
  - fechaHora: Cuándo es
  - equipoNombre: De qué equipo
  - lugar: Dónde es
  - equiposParticipantes: Cuántos equipos asisten

RESULTADO ESPERADO (Datos de ejemplo):
──────────────────────────────────────
  fechaHora            equipoNombre  lugar              equiposParticipantes
  ──────────────────   ────────────  ────────────────   ────────────────────
  2024-05-09 10:30:00  Equipo A      Cancha Norte      2
  2024-05-10 15:00:00  Equipo B      Gimnasio Central  1

CÓMO USARLA:
────────────
SELECT * FROM vw_entrenamientos_programados 
WHERE fechaHora > SYSDATE
ORDER BY fechaHora;

RESULTADO:
  Muestra todos los entrenamientos futuros programados

VISTA 5: vw_asistencia_entrenamientos
═════════════════════════════════════

¿QUÉ HACE?
──────────
Muestra la asistencia detallada de cada persona a cada entrenamiento.

COLUMNAS RESULTADO:
───────────────────
  - fechaHora: Cuándo fue el entrenamiento
  - nombres / apellidos: Quién fue
  - posicion: Posición del jugador
  - asistencia: 'S' o 'N'
  - observaciones: Notas ("Jugó bien", "Enfermo", etc.)

RESULTADO ESPERADO (Datos de ejemplo):
──────────────────────────────────────
  fechaHora            nombres  apellidos  posicion    asistencia  observaciones
  ──────────────────   ───────  ────────   ────────    ──────────  ──────────────────
  2024-05-09 10:30:00  Juan     Perez      DELANTERO   S           Jugó excelente
  2024-05-09 10:30:00  Carlos   Gomez      DEFENSA     N           No asistio al entrenamiento

CÓMO USARLA (para hacer reportes):
──────────────────────────────────
SELECT 
    nombres, apellidos,
    COUNT(*) AS totalEntrenamientos,
    SUM(CASE WHEN asistencia='S' THEN 1 ELSE 0 END) AS asistencias,
    SUM(CASE WHEN asistencia='N' THEN 1 ELSE 0 END) AS inasistencias
FROM vw_asistencia_entrenamientos
GROUP BY nombres, apellidos;

RESULTADO:
  Juan Perez:     Total=10, Asistencias=9, Inasistencias=1 (90%)
  Carlos Gomez:   Total=10, Asistencias=7, Inasistencias=3 (70%)

VISTA 6: vw_jugadores_categoria
════════════════════════════════

¿QUÉ HACE?
──────────
Muestra cuántos jugadores hay en cada categoría.

COLUMNAS RESULTADO:
───────────────────
  - categoriaNombre: Nombre de categoría (SUB12, SUB14, etc.)
  - edadMinima / edadMaxima: Rango de edad
  - cantidadJugadores: Cuántos jugadores en esa categoría

RESULTADO ESPERADO (Datos de ejemplo):
──────────────────────────────────────
  categoriaNombre  edadMinima  edadMaxima  cantidadJugadores
  ───────────────  ──────────  ──────────  ─────────────────
  SUB12            10          12          15
  SUB14            13          14          22
  SUB16            15          16          18

CÓMO USARLA:
────────────
SELECT categoriaNombre, cantidadJugadores
FROM vw_jugadores_categoria
WHERE cantidadJugadores > 10;

RESULTADO:
  Muestra categorías con más de 10 jugadores

================================================================================
                    SECCIÓN 3: PACKAGES - LÓGICA DE NEGOCIO
================================================================================

Archivos: COMPONENTES_E.sql (especificación), COMPONENTES_I.sql (implementación)

¿QUÉ SON LOS PACKAGES?
══════════════════════

Son colecciones de PROCEDIMIENTOS PL/SQL agrupados por funcionalidad.

Ejemplo de uso:
  EXEC PK_ADMINISTRACION.gestionarPersonas(1, '123456', 'Juan', 'Perez', ...);

PACKAGE 1: PK_ADMINISTRACION
═════════════════════════════

¿QUÉ CONTIENE?
──────────────
11 procedimientos para administración general:

1. gestionarPersonas(p_idPersona, p_documento, p_nombres, ...)
   ¿QUÉ HACE?
   Inserta o actualiza una PERSONA
   
   ¿POR QUÉ?
   Centraliza la lógica de inserción de personas (validaciones, etc.)
   
   EJEMPLO:
     EXEC PK_ADMINISTRACION.gestionarPersonas(
       1, '123456789', 'Juan', 'Perez', 
       DATE '2010-05-10', '3001111111', 'juan@mail.com'
     );
   
   RESULTADO ESPERADO:
     1 fila insertada en Persona

2. gestionarJugadores(p_idPersona, p_posicion, p_numeroCamiseta)
   ¿QUÉ HACE?
   Inserta o actualiza un JUGADOR
   
   EJEMPLO:
     EXEC PK_ADMINISTRACION.gestionarJugadores(1, 'DELANTERO', 9);
   
   RESULTADO ESPERADO:
     1 fila insertada en Jugador
     (Automáticamente el trigger valida edad >= 5)

3. gestionarEquipos(p_idEquipo, p_nombre, p_estadoEquipo, p_idEscuela, p_idCategoria)
   ¿QUÉ HACE?
   Inserta o actualiza un EQUIPO
   
   EJEMPLO:
     EXEC PK_ADMINISTRACION.gestionarEquipos(
       1, 'Equipo A', 'ACTIVO', 1, 1
     );
   
   RESULTADO ESPERADO:
     1 fila insertada en Equipo

4. gestionarPagos(p_idPago, p_fechaPago, p_monto, p_estadoPago, p_metodoPago, p_idInscripcion)
   ¿QUÉ HACE?
   Inserta o actualiza un PAGO
   
   LÓGICA AUTOMÁTICA:
     - Si estadoPago='PAGADO' → trigger trg_actualizar_estado_inscripcion 
       actualiza la inscripción a 'ACTIVA'
     - Si estadoPago='PAGADO' y fechaPago es NULL → trigger asigna SYSDATE
   
   EJEMPLO:
     EXEC PK_ADMINISTRACION.gestionarPagos(
       1, NULL, 120000, 'PAGADO', 'EFECTIVO', 1
     );
   
   RESULTADO ESPERADO:
     1 fila insertada en Pago
     Inscripción actualizada a ACTIVA automáticamente
     fechaPago rellenada con hoy (SYSDATE)

5. gestionarInscripciones(p_idInscripcion, p_fechaInscripcion, p_estadoInscripcion, p_idPersona, p_idEscuela)
   ¿QUÉ HACE?
   Inserta o actualiza una INSCRIPCIÓN

6. gestionarEscuelas, gestionarCategorias, gestionarEntrenadores, gestionarAcudientes, gestionarAdministradores
   Similar: Insertan/actualizan cada entidad

7. generarReportes(p_tipo)
   ¿QUÉ HACE?
   Genera reportes del sistema

PACKAGE 2: PK_ENTRENAMIENTO
════════════════════════════

¿QUÉ CONTIENE?
──────────────
5 procedimientos para gestión de entrenamientos:

1. gestionarEntrenamientos(p_idEntrenamiento, p_fecha, p_hora, p_lugar, p_estado, p_idEquipo)
   Crea/actualiza entrenamientos

2. registrarAsistencia(p_idPersona, p_idEntrenamiento, p_asistencia)
   Registra si una persona asistió
   
   LÓGICA AUTOMÁTICA:
     - Si asistencia='N' → trigger rellena observaciones: "No asistio al entrenamiento"
   
   EJEMPLO:
     EXEC PK_ENTRENAMIENTO.registrarAsistencia(1, 1, 'N');
   
   RESULTADO EN BD:
     Participante.observaciones = 'No asistio al entrenamiento' (automático)

3. participantesAdelantados(p_idEntrenamiento)
   Muestra participantes que asistieron correctamente

4. generarReporteAsistencia
   Genera reporte de asistencias por entrenamiento

5. obtenerEquiposActivos
   Retorna equipos que están activos

PACKAGE 3: PK_AUDITORIAS
═════════════════════════

¿QUÉ CONTIENE?
──────────────
2 procedimientos para auditoría:

1. registrarAuditoria(p_tabla, p_operacion, p_usuario, p_descripcion)
   Registra cambios en la BD para auditoría

2. generarReporteAuditorias
   Genera reporte de cambios realizados

================================================================================
                    SECCIÓN 4: INDICES - OPTIMIZACIÓN
================================================================================

Archivo: INDICES.sql

¿QUÉ SON LOS ÍNDICES?
══════════════════════

Son estructuras que aceleran búsquedas en columnas frecuentemente usadas.

ANALOGY: Es como un ÍNDICE de un libro. En lugar de leer 500 páginas,
         consultas el índice y sabes exactamente dónde está la información.

ÍNDICES CREADOS:
═════════════════

1. idx_persona_documento
   ¿POR QUÉ?
   Porque frecuentemente buscas personas por documento:
     SELECT * FROM Persona WHERE documento = '123456789';
   
   SIN ÍNDICE: Oracle busca en TODAS las 5000 personas
   CON ÍNDICE: Oracle va directo a la persona con ese documento

2. idx_pago_estadoPago
   ¿POR QUÉ?
   Porque frecuentemente filtras pagos por estado:
     SELECT * FROM Pago WHERE estadoPago = 'PENDIENTE';

3. idx_inscripcion_estadoInscripcion
   ¿POR QUÉ?
   Para filtrar inscripciones activas vs. canceladas rápidamente

4. idx_entrenamiento_estado
   ¿POR QUÉ?
   Para encontrar rápidamente entrenamientos programados

5-10. Otros índices en columnas de búsqueda/filtro frecuentes

¿CUÁL ES EL IMPACTO?
═════════════════════

SIN ÍNDICES:
  SELECT * FROM Pago WHERE estadoPago = 'PAGADO';
  Tiempo: 5-10 segundos (escanea todas las filas)

CON ÍNDICE:
  SELECT * FROM Pago WHERE estadoPago = 'PAGADO';
  Tiempo: 0.1 segundos (usa el índice)

MEJORA: 50-100x más rápido

CÓMO VERIFICAR QUE ESTÁN CREADOS:
═════════════════════════════════

SELECT index_name, table_name, column_name 
FROM user_ind_columns
WHERE index_name LIKE 'IDX_%'
ORDER BY index_name;

RESULTADO ESPERADO:
  INDEX_NAME                     TABLE_NAME      COLUMN_NAME
  ────────────────────────────   ─────────────   ──────────────────
  IDX_PERSONA_DOCUMENTO          PERSONA         DOCUMENTO
  IDX_PAGO_ESTADOPAGO            PAGO            ESTADOPAGO
  IDX_INSCRIPCION_ESTADO...      INSCRIPCION     ESTADOINSCRIPCION
  ... (10 índices totales)

================================================================================
                    CONCLUSIÓN
================================================================================

✅ TRIGGERS: Validan y automatizan el ingreso de datos
✅ VISTAS: Simplifican consultas complejas frecuentes
✅ PACKAGES: Agrupan lógica de negocio en procedimientos reutilizables
✅ ÍNDICES: Aceleran búsquedas y filtros

TODO JUNTO: Un sistema de BD empresarial completo,
            mantenible, rápido y confiable.

================================================================================
*/
