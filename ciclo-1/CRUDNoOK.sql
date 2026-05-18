/* PROYECTO: Formando Campeones CRUDNoOK
   CICLO 1 - INTENTO DE DATOS ERRÓNEOS
*/


/*BLOQUE 1: PC_PERSONA*/

/*1.1 Documento duplicado
 El documento '1020304050' ya pertenece a la persona 901*/
BEGIN
  PC_PERSONA.AD_PERSONA(
    p_idPersona       => 990,
    p_documento       => '1020304059',
    p_nombres         => 'Duplicado',
    p_apellidos       => 'Documento',
    p_fechaNacimiento => DATE '2012-01-01',
    p_telefono        => '3000000000',
    p_correo          => 'dupicladopersona@mail.com'
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*1.2 ID de persona duplicado*/
/*     El idPersona 901 ya está registrado*/
BEGIN
  PC_PERSONA.AD_PERSONA(
    p_idPersona       => 901,
    p_documento       => '9999999990',
    p_nombres         => 'Duplicado',
    p_apellidos       => 'Id',
    p_fechaNacimiento => DATE '2012-01-01',
    p_telefono        => '3000000001',
    p_correo          => 'dupid@mail.com'
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*1.3 Modificar persona inexistente*/
/*     El idPersona 990 no existe en la tabla Persona*/
BEGIN
  PC_PERSONA.MO_PERSONA(
    p_idPersona       => 990,
    p_documento       => '9999999790',
    p_nombres         => 'Nadie',
    p_apellidos       => 'Inexistente',
    p_fechaNacimiento => DATE '2012-01-01',
    p_telefono        => '3000000000',
    p_correo          => 'nadie@mail.com'
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*1.4 Eliminar persona inexistente*/
/* El idPersona 990 no existe en la tabla Persona*/
BEGIN
  PC_PERSONA.EL_PERSONA(p_idPersona => 990);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*BLOQUE 2: PC_EQUIPO*/

/*2.1 Escuela inexistente*/
/*     El idEscuela 990 no existe en la tabla Escuela*/
BEGIN
  PC_EQUIPO.AD_EQUIPO(
    p_idEquipo     => 990,
    p_nombre       => 'Equipo Fantasma',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela    => 990,
    p_idCategoria  => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*2.2 Categoría inexistente*/
/*     El idCategoria 990 no existe en la tabla Categoria*/
BEGIN
  PC_EQUIPO.AD_EQUIPO(
    p_idEquipo     => 990,
    p_nombre       => 'Sin Categoria',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela    => 901,
    p_idCategoria  => 990
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*2.3 ID de equipo duplicado*/
/*     El idEquipo 901 ya está registrado*/
BEGIN
  PC_EQUIPO.AD_EQUIPO(
    p_idEquipo     => 901,
    p_nombre       => 'Copia FC',
    p_estadoEquipo => 'ACTIVO',
    p_idEscuela    => 901,
    p_idCategoria  => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*2.4 Eliminar equipo inexistente*/
/* El idEquipo 990 no existe en la tabla Equipo*/
BEGIN
  PC_EQUIPO.EL_EQUIPO(p_idEquipo => 990);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/


/*BLOQUE 3: PC_INSCRIPCION*/


/*3.1 Fecha de inscripción futura*/
/*     La fecha 2099-12-31 es posterior a SYSDATE*/
BEGIN
  PC_INSCRIPCION.AD_INSCRIPCION(
    p_idInscripcion     => 990,
    p_fechaInscripcion  => DATE '2099-12-31',
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona         => 901,
    p_idEscuela         => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*3.2 Inscripción activa duplicada*/
/* Persona 901 ya tiene una inscripción ACTIVA en escuela 901*/
BEGIN
  PC_INSCRIPCION.AD_INSCRIPCION(
    p_idInscripcion     => 990,
    p_fechaInscripcion  => DATE '2025-03-01',
    p_estadoInscripcion => 'ACTIVA',
    p_idPersona         => 901,
    p_idEscuela         => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*3.3 Eliminar inscripción con pagos asociados*/
/*     Inscripción 901 tiene el pago 901 (PAGADO) registrado*/
BEGIN
  PC_INSCRIPCION.EL_INSCRIPCION(p_idInscripcion => 901);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/* 3.4 Eliminar inscripción inexistente*/
/*El idInscripcion 990 no existe en la tabla Inscripcion*/
BEGIN
  PC_INSCRIPCION.EL_INSCRIPCION(p_idInscripcion => 990);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*BLOQUE 4: PC_PAGO*/

/*4.1 Monto negativo*/
/*     El procedimiento valida que monto > 0*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 990,
    p_fechaPago     => DATE '2025-02-10',
    p_monto         => -50000.00,
    p_estadoPago    => 'PENDIENTE',
    p_metodoPago    => 'EFECTIVO',
    p_idInscripcion => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*4.2 Monto cero*/
/* El procedimiento valida que monto > 0*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 990,
    p_fechaPago     => DATE '2025-02-10',
    p_monto         => 0,
    p_estadoPago    => 'PENDIENTE',
    p_metodoPago    => 'EFECTIVO',
    p_idInscripcion => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*4.3 Método de pago no permitido*/
/*     Solo se aceptan: EFECTIVO, TRANSFERENCIA, TARJETA*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 990,
    p_fechaPago     => DATE '2025-02-10',
    p_monto         => 100000.00,
    p_estadoPago    => 'PENDIENTE',
    p_metodoPago    => 'BITCOIN',
    p_idInscripcion => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*4.4 Inscripción inexistente en pago*/
/*     El idInscripcion 990 no existe en la tabla Inscripcion*/
BEGIN
  PC_PAGO.AD_PAGO(
    p_idPago        => 990,
    p_fechaPago     => DATE '2025-02-10',
    p_monto         => 100000.00,
    p_estadoPago    => 'PENDIENTE',
    p_metodoPago    => 'EFECTIVO',
    p_idInscripcion => 990
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*4.5 Eliminar pago confirmado*/
/*     Pago 901 tiene estadoPago = 'PAGADO', no se puede eliminar*/
BEGIN
  PC_PAGO.EL_PAGO(p_idPago => 901);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*4.6 Eliminar pago inexistente*/
/*     El idPago 990 no existe en la tabla Pago*/
BEGIN
  PC_PAGO.EL_PAGO(p_idPago => 990);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*BLOQUE 5: PC_ENTRENAMIENTO*/

/*5.1 Equipo inexistente*/
/*     El idEquipo 990 no existe en la tabla Equipo*/
BEGIN
  PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
    p_idEntrenamiento => 990,
    p_fecha           => DATE '2025-03-01',
    p_hora            => TIMESTAMP '2025-03-01 08:00:00',
    p_lugar           => 'Cancha Inexistente',
    p_estado          => 'PROGRAMADO',
    p_idEquipo        => 990
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*5.2 ID de entrenamiento duplicado*/
/*     El idEntrenamiento 901 ya está registrado*/
BEGIN
  PC_ENTRENAMIENTO.AD_ENTRENAMIENTO(
    p_idEntrenamiento => 901,
    p_fecha           => DATE '2025-04-01',
    p_hora            => TIMESTAMP '2025-04-01 10:00:00',
    p_lugar           => 'Otra Cancha',
    p_estado          => 'PROGRAMADO',
    p_idEquipo        => 901
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*5.3 Eliminar entrenamiento inexistente*/
/*El idEntrenamiento 990 no existe en la tabla Entrenamiento*/
BEGIN
  PC_ENTRENAMIENTO.EL_ENTRENAMIENTO(p_idEntrenamiento => 990);
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*BLOQUE 6: PC_ASISTENCIA*/

/* 6.1 Participante duplicado
 Persona 901 ya está registrada en el entrenamiento 901*/
BEGIN
  PC_ASISTENCIA.AD_ASISTENCIA(
    p_idPersona       => 901,
    p_idEntrenamiento => 901,
    p_asistencia      => 'S',
    p_rol             => 'JUGADOR',
    p_observaciones   => 'Registro duplicado'
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

/*6.2 Modificar asistencia de participante inexistente
La persona 990 no está registrada en el entrenamiento 901*/
BEGIN
  PC_ASISTENCIA.MO_ASISTENCIA(
    p_idPersona       => 990,
    p_idEntrenamiento => 901,
    p_asistencia      => 'N',
    p_observaciones   => 'No existe este participante'
  );
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/