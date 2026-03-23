   /* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Creación de tablas */

CREATE TABLE Persona (
    idPersona INT NOT NULL,
    documento VARCHAR(10) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) NOT NULL
);

CREATE TABLE Jugador (
    idPersona INT NOT NULL,
    posicion VARCHAR(50),
    numeroCamiseta INT
);

CREATE TABLE Acudiente (
    idPersona INT NOT NULL,
    parentesco VARCHAR(20)
);

CREATE TABLE Administrador (
    idPersona INT NOT NULL,
    fechaRegistro DATE
);

CREATE TABLE Entrenador (
    idPersona INT NOT NULL,
    experiencia VARCHAR(300),
    especialidad VARCHAR(100)
);

CREATE TABLE Escuela (
    idEscuela INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) NOT NULL
);

CREATE TABLE Categoria (
    idCategoria INT NOT NULL,
    nombre VARCHAR(10) NOT NULL,
    descripcion VARCHAR(120),
    nivel VARCHAR(20) NOT NULL
);

CREATE TABLE Equipo (
    idEquipo INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    estadoEquipo VARCHAR(30) NOT NULL,
    idEscuela INT NOT NULL,
    idCategoria INT NOT NULL
);

CREATE TABLE Inscripcion (
    idInscripcion INT NOT NULL,
    fechaInscripcion DATE NOT NULL,
    estadoInscripcion VARCHAR(30) NOT NULL,
    idPersona INT NOT NULL,
    idEscuela INT NOT NULL
);

CREATE TABLE Pago (
    idPago INT NOT NULL,
    fechaPago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estadoPago VARCHAR(30) NOT NULL,
    idInscripcion INT NOT NULL,
    metodoPago VARCHAR(30) NOT NULL
);

CREATE TABLE Entrenamiento (
    idEntrenamiento INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(200) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    idEquipo INT NOT NULL
);

CREATE TABLE Participante (
    idPersona INT NOT NULL,
    idEntrenamiento INT NOT NULL
);