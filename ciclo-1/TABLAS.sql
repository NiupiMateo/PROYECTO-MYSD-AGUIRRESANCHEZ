   /* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Creación de tablas */

CREATE TABLE Persona (
    idPersona INT NOT NULL,
    documento VARCHAR2(10) NOT NULL,
    nombres VARCHAR2(50) NOT NULL,
    apellidos VARCHAR2(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    telefono VARCHAR2(20) NOT NULL,
    correo VARCHAR2(100) NOT NULL
);

CREATE TABLE Jugador (
    idPersona INT NOT NULL,
    posicion VARCHAR2(20),
    numeroCamiseta INT NOT NULL
);

CREATE TABLE Acudiente (
    idPersona INT NOT NULL,
    parentesco VARCHAR2(20) NOT NULL
);

CREATE TABLE Administrador (
    idPersona INT NOT NULL,
    fechaRegistro DATE
);

CREATE TABLE Entrenador (
    idPersona INT NOT NULL,
    experiencia VARCHAR2 (300),
    especialidad VARCHAR2 (100)
);

CREATE TABLE Escuela (
    idEscuela INT NOT NULL,
    nombre VARCHAR2(120) NOT NULL,
    direccion VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20)NOT NULL,
    correo VARCHAR2(100) NOT NULL
);

CREATE TABLE Categoria (
    idCategoria INT NOT NULL,
    nombre VARCHAR2(10) NOT NULL,
    descripcion VARCHAR2(120),
    nivel VARCHAR2(20) NOT NULL
);

CREATE TABLE Equipo (
    idEquipo INT NOT NULL,
    nombre VARCHAR2(30) NOT NULL,
    estadoEquipo VARCHAR2(30) NOT NULL,
    idEscuela INT NOT NULL,
    idCategoria INT NOT NULL
);

CREATE TABLE Inscripcion (
    idInscripcion INT NOT NULL,
    fechaInscripcion DATE NOT NULL,
    estadoInscripcion VARCHAR2(30) NOT NULL,
    idPersona INT NOT NULL,
    idEscuela INT NOT NULL
);

CREATE TABLE Pago (
    idPago INT NOT NULL,
    fechaPago DATE NOT NULL,
    monto NUMBER(10,2) NOT NULL,
    estadoPago VARCHAR2(30) NOT NULL,
    metodoPago VARCHAR2(30) NOT NULL,
    idInscripcion INT NOT NULL
);

CREATE TABLE Entrenamiento (
    idEntrenamiento INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIMESTAMP NOT NULL,
    lugar VARCHAR2(200) NOT NULL,
    estado VARCHAR2(30) NOT NULL,
    idEquipo INT NOT NULL
);

CREATE TABLE Participante (
    idPersona INT NOT NULL,
    idEntrenamiento INT NOT NULL,
    asistencia CHAR(1) NOT NULL,
    rol VARCHAR2(20) NOT NULL,
    observaciones VARCHAR2(100)
);

CREATE TABLE Recibe (
    idEntrenamiento INT NOT NULL, 
    idEquipo INT NOT NULL,
    asistencia CHAR(1) NOT NULL,
    observaciones VARCHAR2(100)
);