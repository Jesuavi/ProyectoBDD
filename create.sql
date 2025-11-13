-- DOMINIOS
CREATE DOMAIN sexo AS VARCHAR(10)
    CHECk (VALUE IN('masculino', 'femenino', 'N/A'));

CREATE DOMAIN tipo_postgrado AS VARCHAR(15)
    CHECK (VALUE IN ('especializacion','maestria','doctorado'));

CREATE DOMAIN modalidad AS VARCHAR(10)
    CHECK (VALUE IN ('presencial','virtual','hibrida'));

CREATE DOMAIN tipo_asigantura AS VARCHAR(15)
    CHECK (VALUE IN ('teorica','practica','mixta'));

CREATE DOMAIN tipo_contrato AS VARCHAR(15)
    CHECK (VALUE IN ('tiempo completo','medio tiempo','por horas'));

CREATE DOMAIN estado_academico AS VARCHAR(15)
    CHECK (VALUE IN ('activo','egresado','suspendido'));

CREATE DOMAIN estado_inscripcion AS VARCHAR(15)
    CHECK (VALUE IN ('inscrito','retirado','aprobado','reprobado'));

CREATE DOMAIN estado_factura AS VARCHAR(10)
    CHECK (VALUE IN ('pagada','pendiente','vencida'));

CREATE DOMAIN metodo_pago AS VARCHAR(10)
    CHECK (VALUE IN ('efectivo','tarjeta','transferencia','mixto'));

CREATE DOMAIN tipo_evaluacion AS VARCHAR(10)
    CHECK (VALUE IN ('parcial','practica','proyecto'));

CREATE DOMAIN tipo_aula AS VARCHAR(10)
    CHECK (VALUE IN ('auditorio','salon','laboratorio'));

-- PERSONA
CREATE TABLE persona(
    ci INTEGER NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    fecha_nac DATE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    correo VARCHAR(20) NOT NULL, 

    CONSTRAINT PK_persona PRIMARY KEY (ci)
);

CREATE TABLE estudiante(
    ciEstudiante INTEGER NOT NULL,
    nro_carnet INTEGER NOT NULL,
    sexo sexo NOT NULL,
    estado_ac estado_academico NOT NULL,
-- Representante??


    CONSTRAINT PK_estudiante PRIMARY KEY (ci),
    CONSTRAINT FK_estudiante_persona FOREIGN KEY (ci) REFERENCES persona(ci),

);

CREATE TABLE personal(
    ciPersonal INTEGER NOT NULL,
    fecha_EmpTrabajar DATE NOT NULL,

    CONSTRAINT PK_personal PRIMARY KEY (ciPersonal),
    CONSTRAINT FK_personal_persona FOREIGN KEY (ciPersonal) REFERENCES persona(ci)
);

-- TABLA FACULTAD
CREATE TABLE facultad(
    codigoFacultad SERIAL,
    nombre VARCHAR(10) NOT NULL,

    CONSTRAINT PK_facultad PRIMARY KEY (codigoFacultad),
    -- FKs
);

CREATE TABLE profesor(
    ciProfesor INTEGER NOT NULL,
    codigoFacultad INTEGER NOT NULL,

    CONSTRAINT PK_docente PRIMARY KEY (ciDocente),
    -- FKs
    CONSTRAINT FK_docente_persona FOREIGN KEY (ciProfesor) REFERENCES personal(ciPersonal),
    CONSTRAINT FK_docente_facultad FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);

CREATE TABLE administrativo(
    ciAdmin INTEGER NOT NULL,

    CONSTRAINT PK_administrativo PRIMARY KEY (ciAdmin),
    -- FKs
    CONSTRAINT FK_admin_persona FOREIGN KEY (ciAdmin) REFERENCES personal(ciPersonal)
);

-- PROGRAMA ACADEMICO
CREATE TABLE programa_academico(
    IDPrograma SERIAL,
    nombre VARCHAR(20) NOT NULL,
    modalidad modalidad NOT NULL,
    requisitos_ingreso VARCHAR(50) NOT NULL,
    codigoFacultad INTEGER NOT NULL,

    CONSTRAINT PK_programa_academico PRIMARY KEY (codigoPrograma),
    -- FKs
    CONSTRAINT FK_prog_acad_facultad FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);
-- PREGRADO POSTGRADO

-- TABLA SEDE UNIVERSITARIA
CREATE TABLE sede_universitaria(
    IDSede SERIAL, 
    nombre VARCHAR(10) NOT NULL,
    ubicacion VARCHAR(20) NOT NULL,
    cantidad_labs INTEGER NOT NULL,
    cantidad_oficinas INTEGER NOT NULL,
    cantidad_aulas INTEGER NOT NULL,
    
    CONSTRAINT PK_sede_universitaria PRIMARY KEY (IDSede),
    -- FKs
);



-- RECURSOS ACADEMICOS
CREATE TABLE recurso_academico(
    IDRec SERIAL,
    nombre VARCHAR(20) NOT NULL,   
    descripcion VARCHAR(50) NOT NULL,

    CONSTRAINT PK_recurso_academico PRIMARY KEY (IDRec)
);

CREATE TABLE software_educativo(
    IDRec INTEGER NOT NULL,
    licencia VARCHAR(20) NOT NULL,
    fecha_expiracion DATE NOT NULL,

    CONSTRAINT PK_software_educativo PRIMARY KEY (IDRec),
    CONSTRAINT FK_soft_edu_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);

CREATE TABLE equipos_tecnologicos(
    IDRec INTEGER NOT NULL,
    tipo_equipo VARCHAR(20) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    modelo VARCHAR(20) NOT NULL,
    ciProfesor INTEGER NOT NULL,

    CONSTRAINT PK_equipos_tecnologicos PRIMARY KEY (IDRec),
    -- FKs
    CONSTRAINT FK_equipos_tec_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec),
    CONSTRAINT FK_equipos_tec_profesor FOREIGN KEY (ciProfesor) REFERENCES profesor(ciProfesor)
);

CREATE TABLE libro(
    IDRec INTEGER NOT NULL,
    ISBN VARCHAR(20) NOT NULL,
    autor VARCHAR(30) NOT NULL,
    editorial VARCHAR(30) NOT NULL,
    edicion VARCHAR(10) NOT NULL,

    CONSTRAINT PK_libro PRIMARY KEY (IDRec),
    CONSTRAINT FK_libro_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);

CREATE TABLE material_lab(
    IDRec INTEGER NOT NULL,
    tipo_material VARCHAR(20) NOT NULL,

    CONSTRAINT PK_material_lab PRIMARY KEY (IDRec),
    CONSTRAINT FK_mat_lab_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);


-- TABLA PROVEEDOR
CREATE TABLE proveedor(
    IDProv SERIAL, 
    nombre VARCHAR(10) NOT NULL,
    ubicacion VARCHAR(20) NOT NULL,
    
    CONSTRAINT PK_proveedor PRIMARY KEY (IDProv),
    -- FKs
); 

-- TABLA EMPRESA PATROCINADORA 
CREATE TABLE empresa_patrocinadora(
    RIF INTEGER,
    nombre VARCHAR(10) NOT NULL,
    direccion VARCHAR(20) NOT NULL,
    contacto VARCHAR(15) NOT NULL,
    tipo_convenio VARCHAR(15) NOT NULL,

    CONSTRAINT PK_empresa_patrocinadora PRIMARY KEY (RIF),
    -- FKs
);

-- FACTURA
CREATE TABLE factura(
    nro_factura SERIAL,
    fecha DATE NOT NULL,
    monto FLOAT(10,2) NOT NULL,
    estado estado_factura NOT NULL,
    metodo_pago metodo_pago NOT NULL,
    monto_pagado FLOAT(10,2) NOT NULL,
    rif_emp_patrocinadora INTEGER,
    ciEstudiante INTEGER NOT NULL,

    CONSTRAINT PK_factura PRIMARY KEY (nro_factura),
    -- FKs
    CONSTRAINT FK_factura_empresa_patrocinadora FOREIGN KEY (rif_emp_patrocinadora) REFERENCES empresa_patrocinadora(RIF),
    CONSTRAINT FK_factura_estudiante FOREIGN KEY (ciEstudiante) REFERENCES estudiante(ciEstudiante)
);

-- CARGO ADMINISTRATIVO
CREATE TABLE cargo_administrativo(
    IDcargo SERIAL,
    nombre VARCHAR(20) NOT NULL,

    CONSTRAINT PK_cargo_administrativo PRIMARY KEY (IDcargo),
    -- FKs
);

-- TABLA ASIGNATURA
CREATE TABLE asignatura(
    codigoAsignatura SERIAL,
    nombre VARCHAR(20) NOT NULL,
    nro_creditos INTEGER NOT NULL,
    tipo_asignatura tipo_asigantura NOT NULL,
    fk_asignatura INTEGER,

    CONSTRAINT PK_asignatura PRIMARY KEY (codigoAsignatura),
    -- FKs
    CONSTRAINT FK_asignatura_asignatura FOREIGN KEY (fk_asignatura) REFERENCES asignatura(codigoAsignatura),
);
 

