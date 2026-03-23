/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Restricciones declarativas. */

/* PRIMARIAS */
ALTER TABLE Persona
    ADD CONSTRAINT pk_persona PRIMARY KEY (idPersona);

ALTER TABLE Jugador
    ADD CONSTRAINT pk_jugador PRIMARY KEY (idPersona);

ALTER TABLE Acudiente
    ADD CONSTRAINT pk_acudiente PRIMARY KEY (idPersona);

ALTER TABLE Administrador
    ADD CONSTRAINT pk_administrador PRIMARY KEY (idPersona);

ALTER TABLE Entrenador
    ADD CONSTRAINT pk_entrenador PRIMARY KEY (idPersona);

ALTER TABLE Escuela
    ADD CONSTRAINT pk_escuela PRIMARY KEY (idEscuela);

ALTER TABLE Categoria
    ADD CONSTRAINT pk_categoria PRIMARY KEY (idCategoria);

ALTER TABLE Equipo
    ADD CONSTRAINT pk_equipo PRIMARY KEY (idEquipo);

ALTER TABLE Inscripcion
    ADD CONSTRAINT pk_inscripcion PRIMARY KEY (idInscripcion);

ALTER TABLE Pago
    ADD CONSTRAINT pk_pago PRIMARY KEY (idPago);

ALTER TABLE Entrenamiento
    ADD CONSTRAINT pk_entrenamiento PRIMARY KEY (idEntrenamiento);

ALTER TABLE Participante
    ADD CONSTRAINT pk_participante PRIMARY KEY (idPersona, idEntrenamiento);

/* UNICAS */
ALTER TABLE Persona
    ADD CONSTRAINT uq_persona_documento UNIQUE (documento);

ALTER TABLE Persona
    ADD CONSTRAINT uq_persona_correo UNIQUE (correo);

ALTER TABLE Escuela
    ADD CONSTRAINT uq_escuela_direccion UNIQUE (direccion);

ALTER TABLE Escuela
    ADD CONSTRAINT uq_escuela_correo UNIQUE (correo);

/* FORANEAS */
ALTER TABLE Jugador
    ADD CONSTRAINT fk_jugador_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Acudiente
    ADD CONSTRAINT fk_acudiente_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Administrador
    ADD CONSTRAINT fk_administrador_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Entrenador
    ADD CONSTRAINT fk_entrenador_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Equipo
    ADD CONSTRAINT fk_equipo_escuela
    FOREIGN KEY (idEscuela) REFERENCES Escuela(idEscuela);

ALTER TABLE Equipo
    ADD CONSTRAINT fk_equipo_categoria
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria);

ALTER TABLE Inscripcion
    ADD CONSTRAINT fk_inscripcion_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Inscripcion
    ADD CONSTRAINT fk_inscripcion_escuela
    FOREIGN KEY (idEscuela) REFERENCES Escuela(idEscuela);

ALTER TABLE Pago
    ADD CONSTRAINT fk_pago_inscripcion
    FOREIGN KEY (idInscripcion) REFERENCES Inscripcion(idInscripcion);

ALTER TABLE Entrenamiento
    ADD CONSTRAINT fk_entrenamiento_equipo
    FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo);

ALTER TABLE Participante
    ADD CONSTRAINT fk_participante_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Participante
    ADD CONSTRAINT fk_participante_entrenamiento
    FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamiento(idEntrenamiento);

/* CHECK */
ALTER TABLE Jugador
    ADD CONSTRAINT ck_jugador_numeroCamiseta
    CHECK (numeroCamiseta > 0);

ALTER TABLE Pago
    ADD CONSTRAINT ck_pago_monto
    CHECK (monto > 0);

ALTER TABLE Pago
    ADD CONSTRAINT ck_pago_estado
    CHECK (estadoPago IN ('PENDIENTE', 'PAGADO', 'ANULADO'));

ALTER TABLE Pago
    ADD CONSTRAINT ck_pago_metodo
    CHECK (metodoPago IN ('EFECTIVO', 'TRANSFERENCIA', 'TARJETA'));

ALTER TABLE Inscripcion
    ADD CONSTRAINT ck_inscripcion_estado
    CHECK (estadoInscripcion IN ('ACTIVA', 'PENDIENTE', 'CANCELADA'));

ALTER TABLE Equipo
    ADD CONSTRAINT ck_equipo_estado
    CHECK (estadoEquipo IN ('ACTIVO', 'INACTIVO'));

ALTER TABLE Entrenamiento
    ADD CONSTRAINT ck_entrenamiento_estado
    CHECK (estado IN ('PROGRAMADO', 'REALIZADO', 'CANCELADO'));

ALTER TABLE Categoria
    ADD CONSTRAINT ck_categoria_nivel
    CHECK (nivel IN ('BASICO', 'INTERMEDIO', 'AVANZADO'));