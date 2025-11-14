-- DOMINIOSASIGNAR
CREATE DOMAIN tipo_postgrado AS VARCHAR(15)
    CHECK (VALUE IN ('especializacion','maestria','doctorado'));

CREATE DOMAIN modalidad AS VARCHAR(10)
    CHECK (VALUE IN ('presencial','virtual','hibrida'));

CREATE DOMAIN tipo_asignatura AS VARCHAR(15)
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

CREATE DOMAIN sexo AS VARCHAR(10)
    CHECK (VALUE IN ('masculino','femenino','N/A'));

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
    parentesco VARCHAR(10),

    CONSTRAINT PK_estudiante PRIMARY KEY (ciEstudiante),
    CONSTRAINT FK_estudiante_persona FOREIGN KEY (ciEstudiante) REFERENCES persona(ci)
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
    nombre VARCHAR(20) NOT NULL,

    CONSTRAINT PK_facultad PRIMARY KEY (codigoFacultad)
    -- FKs
);

CREATE TABLE profesor(
    ciProfesor INTEGER NOT NULL,
    codigoFacultad INTEGER NOT NULL,

    CONSTRAINT PK_profesor PRIMARY KEY (ciProfesor),
    -- FKs
    CONSTRAINT FK_profesor_persona FOREIGN KEY (ciProfesor) REFERENCES personal(ciPersonal),
    CONSTRAINT FK_profesor_facultad FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
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
    duracion INTEGER NOT NULL,

    CONSTRAINT PK_programa_academico PRIMARY KEY (IDPrograma),
    -- FKs
    CONSTRAINT FK_prog_acad_facultad FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);
-- PREGRADO POSTGRADO
CREATE TABLE pregrado(
    IDPrograma INT NOT NULL,
    
    CONSTRAINT PK_pregrado PRIMARY KEY (IDPrograma),
    CONSTRAINT FK_pregrado_prog_academico FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma)
);

CREATE TABLE postgrado(
    IDPrograma INT NOT NULL,
    tipo tipo_postgrado NOT NULL,

    CONSTRAINT PK_postgrado PRIMARY KEY (IDPrograma),
    CONSTRAINT FK_postgrado_prog_academico FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma)
);


-- TABLA SEDE UNIVERSITARIA
CREATE TABLE sede_universitaria(
    IDSede SERIAL, 
    nombre VARCHAR(10) NOT NULL,
    ubicacion VARCHAR(20) NOT NULL,
    cantidad_labs INTEGER NOT NULL,
    cantidad_oficinas INTEGER NOT NULL,
    cantidad_aulas INTEGER NOT NULL,
    
    CONSTRAINT PK_sede_universitaria PRIMARY KEY (IDSede)
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
    tipo VARCHAR(20) NOT NULL,
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
    tipo VARCHAR(20) NOT NULL,

    CONSTRAINT PK_material_lab PRIMARY KEY (IDRec),
    CONSTRAINT FK_mat_lab_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec)
);


-- TABLA PROVEEDOR
CREATE TABLE proveedor(
    IDProv SERIAL, 
    nombre VARCHAR(10) NOT NULL,
    ubicacion VARCHAR(20) NOT NULL,
    
    CONSTRAINT PK_proveedor PRIMARY KEY (IDProv)
    -- FKs
); 

-- TABLA EMPRESA PATROCINADORA 
CREATE TABLE empresa_patrocinadora(
    RIF INTEGER,
    nombre VARCHAR(10) NOT NULL,
    direccion VARCHAR(20) NOT NULL,
    contacto VARCHAR(15) NOT NULL,
    tipo_convenio VARCHAR(15) NOT NULL,

    CONSTRAINT PK_empresa_patrocinadora PRIMARY KEY (RIF)
    -- FKse
);

-- FACTURA
CREATE TABLE factura(
    num_factura SERIAL,
    fecha DATE NOT NULL,
    monto NUMERIC(5,2) NOT NULL,
    estado estado_factura NOT NULL,
    metodo metodo_pago NOT NULL,
    monto_pagado NUMERIC(5,2) NOT NULL,
    rif INTEGER,
    ciEstudiante INTEGER NOT NULL,

    CONSTRAINT PK_factura PRIMARY KEY (num_factura),
    -- FKs
    CONSTRAINT FK_factura_empresa_patrocinadora FOREIGN KEY (rif) REFERENCES empresa_patrocinadora(RIF),
    CONSTRAINT FK_factura_estudiante FOREIGN KEY (ciEstudiante) REFERENCES estudiante(ciEstudiante)
);

-- CARGO ADMINISTRATIVO
CREATE TABLE cargo_admin(
    IDcargo SERIAL,
    nombre VARCHAR(20) NOT NULL,

    CONSTRAINT PK_cargo_administrativo PRIMARY KEY (IDcargo)
    -- FKs
);

-- TABLA ASIGNATURA
CREATE TABLE asignatura(
    codigoAsignatura SERIAL,
    nombre VARCHAR(20) NOT NULL,
    nro_creditos INTEGER NOT NULL,
    tipo tipo_asignatura NOT NULL,
    fk_asignatura INTEGER,

    CONSTRAINT PK_asignatura PRIMARY KEY (codigoAsignatura),
    -- FKs
    CONSTRAINT FK_asignatura_asignatura FOREIGN KEY (fk_asignatura) REFERENCES asignatura(codigoAsignatura)
);
 
-- TELEFONO
CREATE TABLE telefono(
    IDTelefono SERIAL,
    numero INTEGER NOT NULL,
    ciPersona INTEGER NOT NULL,    

    CONSTRAINT PK_telefono PRIMARY KEY (IDTelefono),
    CONSTRAINT FK_telefono_persona FOREIGN KEY (ciPersona) REFERENCES persona(ci)
);

-- EVALUACION  
CREATE TABLE evaluacion(
    IDEvaluacion SERIAL,
    ponderacion NUMERIC(5,2) NOT NULL,
    tipo tipo_evaluacion NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    codigoAsignatura INTEGER NOT NULL,

    CONSTRAINT PK_evaluacion PRIMARY KEY (IDEvaluacion),
    CONSTRAINT FK_evaluacion_asignatura FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura)
);

-- PERIODO ACADEMICO 
CREATE TABLE periodo_academico(
    periodo VARCHAR(10) NOT NULL,
    trimestre INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

    CONSTRAINT PK_periodo_academico PRIMARY KEY (periodo, trimestre)
);

-- HORARIO 
CREATE TABLE horario(
    dia_semana VARCHAR(10) NOT NULL,
    hora_inicio VARCHAR(10) NOT NULL,
    hora_fin VARCHAR(10) NOT NULL,

    CONSTRAINT PK_horario PRIMARY KEY (dia_semana, hora_inicio, hora_fin)
);

-- AULA
CREATE TABLE aula(
    numero INTEGER NOT NULL,
    tipo tipo_aula NOT NULL,

    CONSTRAINT PK_aula PRIMARY KEY (numero)
);

-- SECCION 
CREATE TABLE seccion (
    numero INTEGER NOT NULL,
    codigoAsignatura INTEGER NOT NULL,
    -- PROG ACADEMICO?
    periodo VARCHAR(10) NOT NULL,
    trimestre INTEGER NOT NULL,
    -- 
    capacidad INTEGER NOT NULL,
    ciProfesor INTEGER NOT NULL,
    hora_inicio VARCHAR(10) NOT NULL,
    hora_fin VARCHAR(10) NOT NULL,
    dia_semana VARCHAR(10) NOT NULL,
    numero_aula INTEGER NOT NULL,

    CONSTRAINT PK_seccion PRIMARY KEY (numero, codigoAsignatura, periodo, trimestre),
    -- FKs
    CONSTRAINT FK_seccion_asignatura FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura),
    -- PROG ACADEMICO?
    CONSTRAINT FK_seccion_prog_academico FOREIGN KEY (periodo, trimestre) REFERENCES periodo_academico(periodo, trimestre),
    -- 
    CONSTRAINT FK_seccion_profesor FOREIGN KEY (ciProfesor) REFERENCES profesor(ciProfesor),
    CONSTRAINT FK_seccion_horario FOREIGN KEY (dia_semana, hora_inicio, hora_fin) REFERENCES horario(dia_semana, hora_inicio, hora_fin),
    CONSTRAINT FK_seccion_aula FOREIGN KEY (numero_aula) REFERENCES aula(numero)
);

-- N/M
-- COMPRA
CREATE TABLE compra(
    IDSede INTEGER NOT NULL,
    IDRec INTEGER NOT NULL,
    IDProv INTEGER NOT NULL,
    fecha_adq DATE NOT NULL,
    cantidad INTEGER NOT NULL,

    CONSTRAINT PK_compra PRIMARY KEY (IDSede, IDRec, IDProv),
    -- FKs
    CONSTRAINT FK_compra_sede_universitaria FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    CONSTRAINT FK_compra_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec),
    CONSTRAINT FK_compra_proveedor FOREIGN KEY (IDProv) REFERENCES proveedor(IDProv)
);
    
CREATE TABLE inventario(
    IDRec INTEGER NOT NULL,
    IDSede INTEGER NOT NULL,
    cantidad_disponible INTEGER NOT NULL,

    CONSTRAINT PK_inventario PRIMARY KEY (IDRec, IDSede),
    -- FKs
    CONSTRAINT FK_inventario_recurso_academico FOREIGN KEY (IDRec) REFERENCES recurso_academico(IDRec),
    CONSTRAINT FK_inventario_sede_universitaria FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede)
);

-- SEDE TIENE FACULTAD
CREATE TABLE sede_tiene_facultad(
    IDSede INTEGER NOT NULL,
    codigoFacultad INTEGER NOT NULL,

    CONSTRAINT PK_sede_tiene_facultad PRIMARY KEY (IDSede, codigoFacultad),
    -- FKs
    CONSTRAINT FK_sede_tiene_facultad_sede_universitaria FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    CONSTRAINT FK_sede_tiene_facultad_facultad FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);

-- CONTRATO
CREATE TABLE contrato(
    IDSede INTEGER NOT NULL,
    IDcargo INTEGER NOT NULL,
    ciProfesor INTEGER NOT NULL,
    codigoFacultad INTEGER NOT NULL,
    salario NUMERIC(10,2) NOT NULL,
    tipo_contrato tipo_contrato NOT NULL,

    CONSTRAINT PK_contrato PRIMARY KEY (IDSede, IDcargo, ciProfesor, codigoFacultad),
    -- FKs
    CONSTRAINT FK_contrato_sede_universitaria FOREIGN KEY (IDSede) REFERENCES sede_universitaria(IDSede),
    CONSTRAINT FK_contrato_cargo_admin FOREIGN KEY (IDcargo) REFERENCES cargo_admin(IDcargo),
    CONSTRAINT FK_contrato_profesor FOREIGN KEY (ciProfesor) REFERENCES profesor(ciProfesor),
    CONSTRAINT FK_contrato_facultad FOREIGN KEY (codigoFacultad) REFERENCES facultad(codigoFacultad)
);

-- EMITE
CREATE TABLE emite(
    ci INTEGER NOT NULL,
    num_factura INTEGER NOT NULL,

    CONSTRAINT PK_emite PRIMARY KEY (ci, num_factura),
    -- FKs
    CONSTRAINT FK_emite_administrativo FOREIGN KEY (ci) REFERENCES administrativo(ciAdmin),
    CONSTRAINT FK_emite_factura FOREIGN KEY (num_factura) REFERENCES factura(num_factura)
);

-- PLAN DE ESTUDIO 
CREATE TABLE plan_estudio(
    IDPrograma INTEGER NOT NULL,
    codigoAsignatura INTEGER NOT NULL,
    es_obligatorio BOOLEAN NOT NULL,

    CONSTRAINT PK_plan_estudio PRIMARY KEY (IDPrograma, codigoAsignatura),
    -- FKs
    CONSTRAINT FK_plan_estudio_prog_academico FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma),
    CONSTRAINT FK_plan_estudio_asignatura FOREIGN KEY (codigoAsignatura) REFERENCES asignatura(codigoAsignatura)
);

-- PRESENTA
CREATE TABLE presenta(
    IDEvaluacion INTEGER NOT NULL,
    CI INTEGER NOT NULL,
    calificacion NUMERIC(5,2) NOT NULL,

    CONSTRAINT PK_presenta PRIMARY KEY (IDEvaluacion, CI),
    -- FKs
    CONSTRAINT FK_presenta_evaluacion FOREIGN KEY (IDEvaluacion) REFERENCES evaluacion(IDEvaluacion),
    CONSTRAINT FK_presenta_estudiante FOREIGN KEY (CI) REFERENCES estudiante(ciEstudiante)
);

-- CURSA
CREATE TABLE cursa(
    fecha_inicio DATE NOT NULL,
    IDPrograma INTEGER NOT NULL,
    ci INTEGER NOT NULL,
    promedio NUMERIC(5,2) NOT NULL,  

    CONSTRAINT PK_cursa PRIMARY KEY (fecha_inicio, IDPrograma, ci),
    -- FKs
    CONSTRAINT FK_cursa_prog_academico FOREIGN KEY (IDPrograma) REFERENCES programa_academico(IDPrograma),
    CONSTRAINT FK_cursa_estudiante FOREIGN KEY (ci) REFERENCES estudiante(ciEstudiante)
);

-- INSCRIBE 
CREATE TABLE inscribe(
    numero INTEGER NOT NULL,
    codigoAsignatura INTEGER NOT NULL,
    periodo VARCHAR(10) NOT NULL,
    trimestre INTEGER NOT NULL,
    ci INTEGER NOT NULL,
    fecha DATE NOT NULL,
    estado_ins estado_inscripcion NOT NULL,
    calificacion_final INTEGER NOT NULL,

    CONSTRAINT PK_inscribe PRIMARY KEY (numero, codigoAsignatura, periodo, trimestre, ci, fecha),
    -- FKs
    CONSTRAINT FK_inscribe_seccion FOREIGN KEY (numero, codigoAsignatura, periodo, trimestre) REFERENCES seccion(numero, codigoAsignatura, periodo, trimestre),
    CONSTRAINT FK_inscribe_estudiante FOREIGN KEY (ci) REFERENCES estudiante(ciEstudiante)
);