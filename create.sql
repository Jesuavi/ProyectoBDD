-- DOMINIOSASIGNAR
CREATE DOMAIN tipo_postgrado AS VARCHAR(15)
    CHECK (VALUE IN ('especializacion','maestria','doctorado'));

CREATE DOMAIN modalidad AS VARCHAR(20)
    CHECK (VALUE IN ('presencial','virtual','hibrida'));

CREATE DOMAIN tipo_asignatura AS VARCHAR(15)
    CHECK (VALUE IN ('teorica','practica','mixta'));

CREATE DOMAIN tipo_contrato AS VARCHAR(15)
    CHECK (VALUE IN ('tiempo completo','medio tiempo','por horas'));

CREATE DOMAIN estado_academico AS VARCHAR(15)
    CHECK (VALUE IN ('activo','egresado','suspendido'));

CREATE DOMAIN estado_inscripcion AS VARCHAR(15)
    CHECK (VALUE IN ('inscrito','retirado','aprobado','reprobado'));

CREATE DOMAIN estado_factura AS VARCHAR(20)
    CHECK (VALUE IN ('pagada','pendiente','vencida'));

CREATE DOMAIN metodo_pago AS VARCHAR(20)
    CHECK (VALUE IN ('efectivo','tarjeta','transferencia','mixto'));

CREATE DOMAIN tipo_evaluacion AS VARCHAR(20)
    CHECK (VALUE IN ('parcial','practica','proyecto'));

CREATE DOMAIN tipo_aula AS VARCHAR(20)
    CHECK (VALUE IN ('auditorio','salon','laboratorio'));

CREATE DOMAIN sexo AS VARCHAR(20)
    CHECK (VALUE IN ('masculino','femenino','N/A'));


-- 1. PERSONAS, ESTUDIANTES, PERSONAL, PROFESORES

CREATE TABLE persona(
    ci BIGINT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    fecha_nac DATE NOT NULL,
    direccion VARCHAR(100),
    correo VARCHAR(80) NOT NULL
);

CREATE TABLE estudiante(
    ciEstudiante BIGINT PRIMARY KEY,
    nro_carnet BIGINT NOT NULL UNIQUE,
    sexo VARCHAR(20) NOT NULL,       
    estado_ac VARCHAR(15) NOT NULL,
    ciRep BIGINT,
    parentesco VARCHAR(20),
    FOREIGN KEY (ciEstudiante) REFERENCES persona(ci),
    FOREIGN KEY (ciRep) REFERENCES persona(ci)
);

CREATE TABLE personal(
    ciPersonal BIGINT PRIMARY KEY,
    fecha_EmpTrabajar DATE NOT NULL,
    FOREIGN KEY (ciPersonal) REFERENCES persona(ci)
);

CREATE TABLE profesor(
    ciProfesor BIGINT PRIMARY KEY,
    FOREIGN KEY (ciProfesor) REFERENCES personal(ciPersonal)
);

-- TABLA FACULTAD
CREATE TABLE facultad(
    codigoFacultad SERIAL,
    nombre VARCHAR(20) NOT NULL,
    ci BIGINT NOT NULL,

    CONSTRAINT PK_facultad PRIMARY KEY (codigoFacultad),
    -- FKs
    CONSTRAINT FK_facultad_profesor FOREIGN KEY (ci) REFERENCES profesor(ciProfesor)
);

CREATE TABLE administrativo(
    ciAdmin BIGINT PRIMARY KEY,
    FOREIGN KEY (ciAdmin) REFERENCES personal(ciPersonal)
);

d
-- 2. PROGRAMAS ACADÉMICOS

CREATE TABLE programa_academico(
    IDPrograma SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    modalidad VARCHAR(20) NOT NULL, 
    requisitos_ingreso VARCHAR(200),
    codigoFacultad INT NOT NULL,
    duracion INT NOT NULL,
    FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);

CREATE TABLE pregrado(
    IDPrograma INT PRIMARY KEY,
    FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma)
);

CREATE TABLE postgrado(
    IDPrograma INT PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL, 
    FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma)
);


-- 3. SEDE UNIVERSITARIA

CREATE TABLE sede_universitaria(
    IDSede SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    ubicacion VARCHAR(60) NOT NULL,
    cantidad_labs INT NOT NULL,
    cantidad_oficinas INT NOT NULL,
    cantidad_aulas INT NOT NULL
);

CREATE TABLE sede_tiene_facultad(
    IDSede INT,
    codigoFacultad INT,
    PRIMARY KEY (IDSede, codigoFacultad),
    FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);


-- 4. RECURSOS ACADÉMICOS

CREATE TABLE recurso_academico(
    IDRec SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE software_educativo(
    IDRec INT PRIMARY KEY,
    licencia VARCHAR(40),
    fecha_expiracion DATE NOT NULL,
    FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);

CREATE TABLE equipos_tecnologicos(
    IDRec INT PRIMARY KEY,
    tipo VARCHAR(30),
    marca VARCHAR(30),
    modelo VARCHAR(30),
    ciProfesor BIGINT NOT NULL,
    FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec),
    FOREIGN KEY (ciProfesor) REFERENCES profesor(ciProfesor)
);

CREATE TABLE libro(
    IDRec INT PRIMARY KEY,
    ISBN VARCHAR(20),
    autor VARCHAR(60),
    editorial VARCHAR(60),
    edicion VARCHAR(20),
    FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);

CREATE TABLE material_lab(
    IDRec INT PRIMARY KEY,
    tipo VARCHAR(30),
    FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);


-- 5. PROVEEDOR, EMPRESA Y FACTURA

CREATE TABLE proveedor(
    IDProv SERIAL PRIMARY KEY,
    nombre VARCHAR(60),
    ubicacion VARCHAR(60)
);

CREATE TABLE empresa_patrocinadora(
    RIF BIGINT PRIMARY KEY,
    nombre VARCHAR(60),
    direccion VARCHAR(100),
    contacto VARCHAR(20),
    tipo_convenio VARCHAR(30)
);

CREATE TABLE factura(
    num_factura SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    monto NUMERIC(10,2) NOT NULL,
    estado VARCHAR(20),
    metodo VARCHAR(20), 
    monto_pagado NUMERIC(10,2) DEFAULT 0,
    rif BIGINT,
    ciEstudiante BIGINT NOT NULL,
    FOREIGN KEY (rif) REFERENCES empresa_patrocinadora(RIF),
    FOREIGN KEY (ciEstudiante) REFERENCES estudiante(ciEstudiante)
);

CREATE TABLE emite(
    ci BIGINT,
    num_factura INT,
    PRIMARY KEY (ci, num_factura),
    FOREIGN KEY (ci) REFERENCES administrativo(ciAdmin),
    FOREIGN KEY (num_factura) REFERENCES factura(num_factura)
);


-- 6. CARGOS, CONTRATOS Y ASIGNATURAS

CREATE TABLE cargo_admin(
    IDcargo SERIAL PRIMARY KEY,
    nombre VARCHAR(40)
);

CREATE TABLE contrato(
    IDSede INT,
    IDcargo INT,
    ciProfesor BIGINT,
    codigoFacultad INT,
    salario NUMERIC(10,2),
    tipo_contrato VARCHAR(20),
    PRIMARY KEY (IDSede, IDcargo, ciProfesor),
    FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    FOREIGN KEY (IDcargo) REFERENCES cargo_admin(IDcargo),
    FOREIGN KEY (ciProfesor) REFERENCES profesor(ciProfesor),
    FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);

CREATE TABLE asignatura(
    codigoAsignatura SERIAL PRIMARY KEY,
    nombre VARCHAR(60),
    nro_creditos INT NOT NULL,
    tipo VARCHAR(15),
    fk_asignatura INT,
    FOREIGN KEY (fk_asignatura) REFERENCES asignatura(codigoAsignatura)
);

CREATE TABLE plan_estudio(
    IDPrograma INT,
    codigoAsignatura INT,
    es_obligatorio BOOLEAN,
    PRIMARY KEY (IDPrograma, codigoAsignatura),
    FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma),
    FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura)
);


-- 7. PERÍODOS, HORARIO, AULA, SECCIÓN

CREATE TABLE periodo_academico(
    periodo VARCHAR(20),
    trimestre INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    PRIMARY KEY (periodo, trimestre)
);

CREATE TABLE horario(
    dia_semana VARCHAR(20),
    hora_inicio TIME,
    hora_fin TIME,
    PRIMARY KEY (dia_semana, hora_inicio, hora_fin)
);

CREATE TABLE aula(
    numero INT PRIMARY KEY,
    tipo VARCHAR(20) 
);

CREATE TABLE seccion(
    numero INT,
    codigoAsignatura INT,
    periodo VARCHAR(20),
    trimestre INT,
    capacidad INT,
    ciProfesor BIGINT,
    hora_inicio TIME,
    hora_fin TIME,
    dia_semana VARCHAR(20),
    numero_aula INT,
    PRIMARY KEY (numero, codigoAsignatura, periodo, trimestre),
    FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura),
    FOREIGN KEY (periodo, trimestre) REFERENCES periodo_academico(periodo, trimestre),
    FOREIGN KEY (ciProfesor) REFERENCES profesor(ciProfesor),
    FOREIGN KEY (dia_semana, hora_inicio, hora_fin) REFERENCES horario(dia_semana, hora_inicio, hora_fin),
    FOREIGN KEY (numero_aula) REFERENCES aula(numero)
);


-- 8. INSCRIPCIONES, CURSA Y EVALUACIONES

CREATE TABLE cursa(
    fecha_inicio DATE,
    IDPrograma INT,
    ci BIGINT,
    promedio NUMERIC(5,2),
    PRIMARY KEY (IDPrograma, ci),
    FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma),
    FOREIGN KEY (ci) REFERENCES estudiante(ciEstudiante)
);

CREATE TABLE inscribe(
    numero INT,
    codigoAsignatura INT,
    periodo VARCHAR(20),
    trimestre INT,
    ci BIGINT,
    fecha DATE,
    estado_ins VARCHAR(20), 
    calificacion_final NUMERIC(5,2),
    PRIMARY KEY (numero, codigoAsignatura, periodo, trimestre, ci),
    FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura),
    FOREIGN KEY (periodo, trimestre) REFERENCES periodo_academico(periodo, trimestre),
    FOREIGN KEY (ci) REFERENCES estudiante(ciEstudiante)
);

CREATE TABLE evaluacion(
    IDEvaluacion SERIAL PRIMARY KEY,
    ponderacion NUMERIC(5,2),
    tipo VARCHAR(20), 
    descripcion VARCHAR(200),
    codigoAsignatura INT NOT NULL,
    FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura)
);

CREATE TABLE presenta(
    IDEvaluacion INT,
    CI BIGINT,
    calificacion NUMERIC(5,2),
    PRIMARY KEY (IDEvaluacion, CI),
    FOREIGN KEY (IDEvaluacion) REFERENCES evaluacion(IDEvaluacion),
    FOREIGN KEY (CI) REFERENCES estudiante(ciEstudiante)
);


-- 9. COMPRA E INVENTARIO

CREATE TABLE compra(
    IDSede INT,
    IDRec INT,
    IDProv INT,
    fecha_adq DATE,
    cantidad INT,
    PRIMARY KEY (IDSede, IDRec, IDProv, fecha_adq),
    FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec),
    FOREIGN KEY (IDProv) REFERENCES proveedor(IDProv)
);

CREATE TABLE inventario(
    IDSede INT,
    IDRec INT,
    cantidad_disponible INT,
    PRIMARY KEY (IDSede, IDRec),
    FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);


-- 10. TELÉFONOS

CREATE TABLE telefono(
    numero BIGINT,
    ciPersona BIGINT,
    PRIMARY KEY (numero, ciPersona),
    FOREIGN KEY (ciPersona) REFERENCES persona(ci)
);
