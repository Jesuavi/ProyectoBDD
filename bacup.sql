-- DROP TRIGGERS
DROP TRIGGER IF EXISTS trigger_actualizar_inventario ON compra CASCADE;
DROP TRIGGER IF EXISTS trigger_actualizar_estado ON inscribe CASCADE;
DROP TRIGGER IF EXISTS trigger_estado_factura ON factura CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_inscripcion ON inscribe CASCADE;
DROP TRIGGER IF EXISTS trigger_validar_seccion_profesor ON seccion CASCADE;

-- DROP FUNCTIONS
DROP FUNCTION IF EXISTS actualizar_inventario() CASCADE;
DROP FUNCTION IF EXISTS actualizar_estado_estudiante() CASCADE;
DROP FUNCTION IF EXISTS actualizar_estado_factura() CASCADE;
DROP FUNCTION IF EXISTS validar_inscripcion() CASCADE;
DROP FUNCTION IF EXISTS validar_seccion_profesor() CASCADE;

-- DROP DOMAINS
DROP DOMAIN IF EXISTS tipo_postgrado CASCADE;
DROP DOMAIN IF EXISTS modalidad CASCADE;
DROP DOMAIN IF EXISTS tipo_asignatura CASCADE;
DROP DOMAIN IF EXISTS tipo_contrato CASCADE;
DROP DOMAIN IF EXISTS estado_academico CASCADE;
DROP DOMAIN IF EXISTS estado_inscripcion CASCADE;
DROP DOMAIN IF EXISTS estado_factura CASCADE;
DROP DOMAIN IF EXISTS metodo_pago CASCADE;
DROP DOMAIN IF EXISTS tipo_evaluacion CASCADE;
DROP DOMAIN IF EXISTS tipo_aula CASCADE;
DROP DOMAIN IF EXISTS sexo CASCADE;

-- DROP TABLES
DROP TABLE IF EXISTS inscribe CASCADE;
DROP TABLE IF EXISTS cursa CASCADE;
DROP TABLE IF EXISTS presenta CASCADE;
DROP TABLE IF EXISTS plan_estudio CASCADE;
DROP TABLE IF EXISTS emite CASCADE;
DROP TABLE IF EXISTS contrato CASCADE;
DROP TABLE IF EXISTS sede_tiene_facultad CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS compra CASCADE;
DROP TABLE IF EXISTS seccion CASCADE;
DROP TABLE IF EXISTS aula CASCADE;
DROP TABLE IF EXISTS horario CASCADE;
DROP TABLE IF EXISTS periodo_academico CASCADE;
DROP TABLE IF EXISTS evaluacion CASCADE;
DROP TABLE IF EXISTS telefono CASCADE;
DROP TABLE IF EXISTS asignatura CASCADE;
DROP TABLE IF EXISTS cargo_admin CASCADE;
DROP TABLE IF EXISTS factura CASCADE;
DROP TABLE IF EXISTS empresa_patrocinadora CASCADE;
DROP TABLE IF EXISTS proveedor CASCADE;
DROP TABLE IF EXISTS material_lab CASCADE;
DROP TABLE IF EXISTS libro CASCADE;
DROP TABLE IF EXISTS equipos_tecnologicos CASCADE;
DROP TABLE IF EXISTS software_educativo CASCADE;
DROP TABLE IF EXISTS recurso_academico CASCADE;
DROP TABLE IF EXISTS postgrado CASCADE;
DROP TABLE IF EXISTS pregrado CASCADE;
DROP TABLE IF EXISTS programa_academico CASCADE;
DROP TABLE IF EXISTS administrativo CASCADE;
DROP TABLE IF EXISTS profesor CASCADE;
DROP TABLE IF EXISTS personal CASCADE;
DROP TABLE IF EXISTS estudiante CASCADE;
DROP TABLE IF EXISTS persona CASCADE;
DROP TABLE IF EXISTS facultad CASCADE;
DROP TABLE IF EXISTS sede_universitaria CASCADE;

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


-- 1. TRIGGER PARA ACTUALIZAR INVENTARIO DESPUÉS DE UNA COMPRA

CREATE OR REPLACE FUNCTION actualizar_inventario()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inventario
        WHERE IDRec = NEW.IDRec AND IDSede = NEW.IDSede
    ) THEN
        UPDATE inventario
        SET cantidad_disponible = cantidad_disponible + NEW.cantidad
        WHERE IDRec = NEW.IDRec AND IDSede = NEW.IDSede;
    ELSE
        INSERT INTO inventario(IDRec, IDSede, cantidad_disponible)
        VALUES (NEW.IDRec, NEW.IDSede, NEW.cantidad);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_inventario
AFTER INSERT ON compra
FOR EACH ROW
EXECUTE FUNCTION actualizar_inventario();


-- 2. TRIGGER PARA ACTUALIZAR ESTADO DEL ESTUDIANTE (EGRESADO)

CREATE OR REPLACE FUNCTION actualizar_estado_estudiante()
RETURNS TRIGGER AS $$
DECLARE
    total_asignaturas INT;
    asignaturas_aprobadas INT;
BEGIN
    SELECT COUNT(*) INTO total_asignaturas
    FROM plan_estudio pe
    JOIN cursa c ON c.IDPrograma = pe.IDPrograma
    WHERE c.ci = NEW.ci;

    SELECT COUNT(*) INTO asignaturas_aprobadas
    FROM inscribe i
    WHERE i.ci = NEW.ci AND i.estado_ins = 'aprobado';

    IF asignaturas_aprobadas >= total_asignaturas THEN
        UPDATE estudiante
        SET estado_ac = 'egresado'
        WHERE ciEstudiante = NEW.ci;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_estado
AFTER INSERT OR UPDATE ON inscribe
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_estudiante();

-- 3. TRIGGER PARA ACTUALIZAR ESTADO DE LA FACTURA

CREATE OR REPLACE FUNCTION actualizar_estado_factura()
RETURNS TRIGGER AS $$
BEGIN
    IF COALESCE(NEW.monto_pagado,0) >= COALESCE(NEW.monto,0) THEN
        NEW.estado := 'pagada';
    ELSIF NEW.fecha < CURRENT_DATE AND COALESCE(NEW.monto_pagado,0) < COALESCE(NEW.monto,0) THEN
        NEW.estado := 'vencida';
    ELSE
        NEW.estado := 'pendiente';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_estado_factura
BEFORE INSERT OR UPDATE ON factura
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_factura();

-- 4. TRIGGER PARA VALIDAR INSCRIPCIÓN (PREREQUISITOS Y DUPLICADOS)

CREATE OR REPLACE FUNCTION validar_inscripcion()
RETURNS TRIGGER AS $$
DECLARE
    asignatura_prerequisito BIGINT;
    prerequisito_aprobado BOOLEAN;
    inscripcion_duplicada BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM inscribe 
        WHERE ci = NEW.ci 
        AND codigoAsignatura = NEW.codigoAsignatura
        AND periodo = NEW.periodo 
        AND trimestre = NEW.trimestre
        AND estado_ins IN ('inscrito', 'aprobado')
    ) INTO inscripcion_duplicada;
    
    IF inscripcion_duplicada THEN
        RAISE EXCEPTION 'El estudiante ya está inscrito en esta asignatura para el periodo % trimestre %', NEW.periodo, NEW.trimestre;
    END IF;

    SELECT fk_asignatura INTO asignatura_prerequisito 
    FROM asignatura 
    WHERE codigoAsignatura = NEW.codigoAsignatura;
    
    IF asignatura_prerequisito IS NOT NULL THEN
        SELECT EXISTS (
            SELECT 1 FROM inscribe 
            WHERE ci = NEW.ci 
            AND codigoAsignatura = asignatura_prerequisito
            AND estado_ins = 'aprobado'
        ) INTO prerequisito_aprobado;
        
        IF NOT prerequisito_aprobado THEN
            RAISE EXCEPTION 'Prerequisito no aprobado. Debe aprobar la asignatura % primero', asignatura_prerequisito;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_inscripcion
BEFORE INSERT ON inscribe
FOR EACH ROW
EXECUTE FUNCTION validar_inscripcion();

-- 5. TRIGGER PARA VALIDAR SECCIÓN CON PROFESOR

CREATE OR REPLACE FUNCTION validar_seccion_profesor()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ciProfesor IS NULL THEN
        RAISE EXCEPTION 'Toda sección debe tener un profesor asignado';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_seccion_profesor
BEFORE INSERT OR UPDATE ON seccion
FOR EACH ROW
EXECUTE FUNCTION validar_seccion_profesor();




-- 1. PERSONAS

INSERT INTO persona (ci, nombre, apellido, fecha_nac, direccion, correo) VALUES
-- Estudiantes
(25500123, 'María', 'González', '2000-05-15', 'Av. Libertador', 'maria@email.com'),
(44567890, 'Juan', 'Pérez', '2001-08-30', 'El Paraíso', 'juan.perez@email.com'),
(33567890, 'Ana', 'Morales', '1999-03-15', 'Los Naranjos', 'ana.morales@email.com'),
(26789234, 'Carlos', 'Pérez', '2001-08-22', 'Urb. El Paraíso', 'carlos@email.com'),
(28956345, 'Ana', 'Rodríguez', '1999-12-10', 'La Candelaria', 'ana@email.com'),
(30123456, 'Luis', 'Martínez', '2002-03-30', 'Chacao', 'luis@email.com'),
(31234567, 'Elena', 'Torres', '2000-11-18', 'El Hatillo', 'elena@email.com'),
-- Profesores
(15456789, 'Roberto', 'Silva', '1975-02-14', 'Altamira', 'rsilva@uni.edu'),
(16345890, 'Carmen', 'López', '1980-07-19', 'La Castellana', 'clopez@uni.edu'),
(17234901, 'Javier', 'Mendoza', '1978-09-25', 'Los Palos Grandes', 'jmendoza@uni.edu'),
-- Administrativos
(18567012, 'Patricia', 'Rojas', '1985-04-08', 'San Bernardino', 'projas@uni.edu'),
(19478123, 'Ricardo', 'Fernández', '1982-01-12', 'El Recreo', 'rfernandez@uni.edu'),
-- Representantes
(40567890, 'José', 'González', '1970-06-20', 'Av. Libertador', 'jose@email.com'),
(41789012, 'Marta', 'Pérez', '1972-09-15', 'Urb. El Paraíso', 'marta@email.com');

-- 2. ESTRUCTURA UNIVERSITARIA


INSERT INTO sede_universitaria (nombre, ubicacion, cantidad_labs, cantidad_oficinas, cantidad_aulas) VALUES
('Central', 'Caracas', 8, 25, 40),
('Litoral', 'La Guaira', 4, 12, 20),
('Oriente', 'Barcelona', 5, 15, 25);


-- 3. ESTUDIANTES, PERSONAL, PROFESORES

INSERT INTO estudiante (ciEstudiante, nro_carnet, sexo, estado_ac, parentesco, CIRep) VALUES
(44567890, 2024001, 'masculino', 'activo', 'hijo', 41789012),
(25500123, 2023001, 'femenino', 'activo', 'hija', 40567890),
(33567890, 2023006, 'femenino', 'egresado', 'hija', 40567890),
(26789234, 2023002, 'masculino', 'activo', 'hijo', 41789012),
(28956345, 2023003, 'femenino', 'activo', 'hija', 40567890),
(30123456, 2023004, 'masculino', 'activo', 'hijo', 41789012),
(31234567, 2023005, 'femenino', 'activo', 'hija', 40567890);

INSERT INTO personal (ciPersonal, fecha_EmpTrabajar) VALUES
(15456789, '2010-03-15'),
(16345890, '2012-08-20'),
(17234901, '2015-01-10'),
(18567012, '2018-06-01'),
(19478123, '2019-11-15');

INSERT INTO profesor (ciProfesor) VALUES
(15456789), (16345890), (17234901);

INSERT INTO facultad (nombre, ci) VALUES
('Ingeniería', 15456789),
('Ciencias', 16345890),
('Humanidades', 17234901);

INSERT INTO administrativo (ciAdmin) VALUES (18567012), (19478123);

-- 4. PROGRAMAS ACADÉMICOS

INSERT INTO programa_academico (nombre, modalidad, requisitos_ingreso, codigoFacultad, duracion) VALUES
('Ing. Informática', 'presencial', 'Bachillerato', 1, 10),
('Ing. Civil', 'presencial', 'Bachillerato', 1, 12),
('Maestría IA', 'hibrida', 'Título univ', 1, 4),
('Doctorado TIC', 'virtual', 'Maestría', 1, 6),
('Lic. Matemáticas', 'presencial', 'Bachillerato', 2, 9),
('Esp. Estadística', 'hibrida', 'Título univ', 2, 2);

INSERT INTO pregrado (IDPrograma) VALUES (1), (2), (5);

INSERT INTO postgrado (IDPrograma, tipo) VALUES
(3, 'maestria'), (4, 'doctorado'), (6, 'especializacion');

-- 5. ASIGNATURAS Y PLAN DE ESTUDIO

INSERT INTO asignatura (nombre, nro_creditos, tipo, fk_asignatura) VALUES
-- Semestre 1
('Programación I', 4, 'practica', NULL),
('Matemáticas I', 4, 'teorica', NULL),
('Física General', 3, 'mixta', NULL),
-- Semestre 2
('Programación II', 4, 'practica', 1),
('Matemáticas II', 4, 'teorica', 2),
('Estructuras Datos', 4, 'mixta', 1),
-- Semestre 3
('Bases Datos I', 4, 'mixta', 4),
('Algoritmos', 4, 'teorica', 6),
('Estadística', 3, 'mixta', 5);

INSERT INTO plan_estudio (IDPrograma, codigoAsignatura, es_obligatorio) VALUES
(1, 1, true), (1, 2, true), (1, 3, true),
(2, 2, true), (2, 5, true), (5, 9, true),
(1, 4, true), (1, 5, true), (1, 6, true),
(1, 7, true), (1, 8, true), (1, 9, true);

-- 6. CARGOS Y CONTRATOS

INSERT INTO cargo_admin (nombre) VALUES
('Profesor Titular'),
('Profesor Asociado'),
('Profesor Asistente'),
('Coordinador');

INSERT INTO contrato (IDSede, IDcargo, ciProfesor, codigoFacultad, salario, tipo_contrato) VALUES
(1, 1, 15456789, 1, 2500.00, 'tiempo completo'),
(1, 2, 16345890, 1, 2000.00, 'tiempo completo'),
(1, 4, 15456789, 1, 2800.00, 'tiempo completo'),
(1, 3, 16345890, 2, 2200.00, 'medio tiempo'),
(2, 2, 17234901, 3, 2300.00, 'tiempo completo'),
(3, 4, 17234901, 3, 1500.00, 'por horas'),
(1, 3, 17234901, 2, 1800.00, 'medio tiempo');

-- 7. PERÍODOS, HORARIOS, AULAS

INSERT INTO periodo_academico (periodo, trimestre, fecha_inicio, fecha_fin) VALUES
('2024-1', 1, '2024-01-15', '2024-04-15'),
('2024-2', 2, '2024-05-10', '2024-08-10'),
('2024-3', 3, '2024-09-05', '2024-12-05');

INSERT INTO horario (dia_semana, hora_inicio, hora_fin) VALUES
('Lunes', '08:00', '10:00'),
('Lunes', '10:30', '12:30'),
('Martes', '08:00', '10:00'),
('Miércoles', '14:00', '16:00'),
('Viernes', '16:00', '18:00');

INSERT INTO aula (numero, tipo) VALUES
(101, 'salon'), (102, 'salon'), (201, 'laboratorio'), 
(202, 'laboratorio'), (301, 'auditorio');

-- 8. SECCIONES

INSERT INTO seccion (numero, codigoAsignatura, periodo, trimestre, capacidad, ciProfesor, hora_inicio, hora_fin, dia_semana, numero_aula) VALUES
(1, 1, '2024-1', 1, 30, 15456789, '08:00', '10:00', 'Lunes', 101),
(1, 2, '2024-1', 1, 35, 16345890, '10:30', '12:30', 'Lunes', 102),
(2, 2, '2024-1', 1, 30, 16345890, '10:30', '12:30', 'Lunes', 102),
(1, 9, '2024-2', 2, 25, 17234901, '08:00', '10:00', 'Martes', 201),
(2, 1, '2024-1', 1, 25, 15456789, '14:00', '16:00', 'Miércoles', 201);

-- 9. INSCRIPCIONES Y CURSA

INSERT INTO cursa (fecha_inicio, IDPrograma, ci, promedio) VALUES
('2024-01-15', 1, 25500123, 18.5),
('2023-01-15', 1, 33567890, 18.7),
('2024-01-15', 1, 26789234, 17.2),
('2024-01-15', 1, 28956345, 16.8);

INSERT INTO inscribe (numero, codigoAsignatura, periodo, trimestre, ci, fecha, estado_ins, calificacion_final) VALUES
-- Semestre 1 - sin prerequisitos
(1, 1, '2024-1', 1, 25500123, '2024-01-16', 'aprobado', 19),
(1, 2, '2024-1', 1, 44567890, CURRENT_DATE - INTERVAL '3 months', 'reprobado', 5),
(1, 2, '2024-1', 1, 25500123, '2024-01-16', 'aprobado', 18),
(1, 1, '2024-1', 1, 26789234, '2024-01-16', 'aprobado', 17),
(1, 2, '2024-1', 1, 26789234, '2024-01-16', 'aprobado', 16);

-- 10. RECURSOS ACADÉMICOS

INSERT INTO recurso_academico (nombre, descripcion) VALUES
('Laptop Dell', 'Equipo lab programación'),
('Office 365', 'Suite ofimática'),
('Libro BD I', 'Fundamentos BD'),
('Microscopio', 'Equipo lab ciencias');

INSERT INTO software_educativo (IDRec, licencia, fecha_expiracion) VALUES
(2, 'EDU-2024-001', '2024-12-31');

INSERT INTO equipos_tecnologicos (IDRec, tipo, marca, modelo, ciProfesor) VALUES
(1, 'Laptop', 'Dell', 'Latitude 5420', 15456789);

INSERT INTO libro (IDRec, ISBN, autor, editorial, edicion) VALUES
(3, '978-1234567890', 'Carlos Date', 'Pearson', '6ta');

INSERT INTO material_lab (IDRec, tipo) VALUES (4, 'Óptico');

-- 11. PROVEEDORES Y COMPRAS

INSERT INTO proveedor (nombre, ubicacion) VALUES
('TecnoSol', 'Caracas'),
('LibrosEduc', 'Valencia'),
('SoftVen', 'Maracaibo');

INSERT INTO compra (IDSede, IDRec, IDProv, fecha_adq, cantidad) VALUES
(1, 1, 1, '2024-01-10', 5),
(1, 2, 3, '2024-01-12', 1),
(1, 3, 2, '2024-01-15', 20),
(1, 4, 1, '2024-01-20', 3);

-- 12. EMPRESAS Y FACTURAS

INSERT INTO empresa_patrocinadora (RIF, nombre, direccion, contacto, tipo_convenio) VALUES
(123456789, 'TecnoCorp', 'Av. Principal', '0212-5551234', 'Educativo'),
(987654321, 'EduFund', 'Centro Ciudad', '0212-5555678', 'Becas');

INSERT INTO factura (fecha, monto, estado, metodo, monto_pagado, rif, ciEstudiante) VALUES
('2024-01-20', 500.00, 'pendiente', 'transferencia', 0, 123456789, 25500123),
('2024-01-25', 750.00, 'pendiente', 'mixto', 750.00, 987654321, 26789234);

INSERT INTO factura (fecha, monto, estado, metodo, monto_pagado, rif, ciEstudiante) VALUES
('2024-11-01', 900.00, 'pendiente', 'mixto', 400.00, 123456789, 25500123);


INSERT INTO emite (ci, num_factura) VALUES
(18567012, 1), (19478123, 2);

-- 13. EVALUACIONES Y PRESENTACIONES

INSERT INTO evaluacion (ponderacion, tipo, descripcion, codigoAsignatura) VALUES
(30.00, 'parcial', 'Primer parcial', 1),
(40.00, 'practica', 'Proyecto lab', 1),
(30.00, 'proyecto', 'Proyecto final', 1);

INSERT INTO presenta (IDEvaluacion, CI, calificacion) VALUES
(1, 25500123, 18.5),
(1, 26789234, 16.0),
(2, 25500123, 19.0),
(2, 26789234, 17.5);

-- 14. RELACIONES SEDE-FACULTAD

INSERT INTO sede_tiene_facultad (IDSede, codigoFacultad) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2),
(3, 1);

-- 15. TELÉFONOS

INSERT INTO telefono (numero, ciPersona) VALUES
(4125551234, 25500123),
(4145555678, 26789234),
(4165559012, 15456789),
(4245553456, 18567012);


