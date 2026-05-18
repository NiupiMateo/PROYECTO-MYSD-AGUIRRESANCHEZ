   /* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Creación de tablas */

CREATE TABLE Persona (
    idPersona NUMBER NOT NULL,
    documento VARCHAR2(10) NOT NULL,
    nombres VARCHAR2(50) NOT NULL,
    apellidos VARCHAR2(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    telefono VARCHAR2(20) NOT NULL,
    correo VARCHAR2(100) NOT NULL
);

CREATE TABLE Jugador (
    idPersona NUMBER NOT NULL,
    posicion VARCHAR2(20),
    numeroCamiseta NUMBER NOT NULL
);

CREATE TABLE Acudiente (
    idPersona NUMBER NOT NULL,
    parentesco VARCHAR2(20) NOT NULL
);

CREATE TABLE Administrador (
    idPersona NUMBER NOT NULL,
    fechaRegistro DATE
);

CREATE TABLE Entrenador (
    idPersona NUMBER NOT NULL,
    experiencia VARCHAR2 (300),
    especialidad VARCHAR2 (100)
);

CREATE TABLE Escuela (
    idEscuela NUMBER NOT NULL,
    nombre VARCHAR2(120) NOT NULL,
    direccion VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20)NOT NULL,
    correo VARCHAR2(100) NOT NULL
);

CREATE TABLE Categoria (
    idCategoria NUMBER NOT NULL,
    nombre VARCHAR2(10) NOT NULL,
    descripcion VARCHAR2(120),
    nivel VARCHAR2(20) NOT NULL
);

CREATE TABLE Equipo (
    idEquipo NUMBER NOT NULL,
    nombre VARCHAR2(30) NOT NULL,
    estadoEquipo VARCHAR2(30) NOT NULL,
    idEscuela NUMBER NOT NULL,
    idCategoria NUMBER NOT NULL
);

CREATE TABLE Inscripcion (
    idInscripcion NUMBER NOT NULL,
    fechaInscripcion DATE NOT NULL,
    estadoInscripcion VARCHAR2(30) NOT NULL,
    idPersona NUMBER NOT NULL,
    idEscuela NUMBER NOT NULL
);

CREATE TABLE Pago (
    idPago NUMBER NOT NULL,
    fechaPago DATE NOT NULL,
    monto NUMBER(10,2) NOT NULL,
    estadoPago VARCHAR2(30) NOT NULL,
    metodoPago VARCHAR2(30) NOT NULL,
    idInscripcion NUMBER
);

CREATE TABLE Entrenamiento (
    idEntrenamiento NUMBER NOT NULL,
    fecha DATE NOT NULL,
    hora TIMESTAMP NOT NULL,
    lugar VARCHAR2(200) NOT NULL,
    estado VARCHAR2(30) NOT NULL,
    idEquipo NUMBER NOT NULL
);

CREATE TABLE Participante (
    idPersona NUMBER NOT NULL,
    idEntrenamiento NUMBER NOT NULL,
    asistencia CHAR(1) NOT NULL,
    rol VARCHAR2(20) NOT NULL,
    observaciones VARCHAR2(100)
);

CREATE TABLE Recibe (
    idEntrenamiento NUMBER NOT NULL, 
    idEquipo NUMBER NOT NULL,
    asistencia CHAR(1) NOT NULL,
    observaciones VARCHAR2(100)
);
