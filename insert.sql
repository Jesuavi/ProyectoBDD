-- SCRIPT COMPLETO DE INSERTS CORREGIDOS - SISTEMA DE GESTIÓN ACADÉMICA MULTISEDE

-- =============================================
-- 1. PERSONAS
-- =============================================
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

-- =============================================
-- 2. ESTRUCTURA UNIVERSITARIA
-- =============================================

INSERT INTO sede_universitaria (nombre, ubicacion, cantidad_labs, cantidad_oficinas, cantidad_aulas) VALUES
('Central', 'Caracas', 8, 25, 40),
('Litoral', 'La Guaira', 4, 12, 20),
('Oriente', 'Barcelona', 5, 15, 25);

-- =============================================
-- 3. ESTUDIANTES, PERSONAL, PROFESORES
-- =============================================
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

-- =============================================
-- 4. PROGRAMAS ACADÉMICOS
-- =============================================
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

-- =============================================
-- 5. ASIGNATURAS Y PLAN DE ESTUDIO
-- =============================================
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

-- =============================================
-- 6. CARGOS Y CONTRATOS
-- =============================================
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

-- =============================================
-- 7. PERÍODOS, HORARIOS, AULAS
-- =============================================
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

-- =============================================
-- 8. SECCIONES
-- =============================================
INSERT INTO seccion (numero, codigoAsignatura, periodo, trimestre, capacidad, ciProfesor, hora_inicio, hora_fin, dia_semana, numero_aula) VALUES
(1, 1, '2024-1', 1, 30, 15456789, '08:00', '10:00', 'Lunes', 101),
(1, 2, '2024-1', 1, 35, 16345890, '10:30', '12:30', 'Lunes', 102),
(2, 2, '2024-1', 1, 30, 16345890, '10:30', '12:30', 'Lunes', 102),
(1, 9, '2024-2', 2, 25, 17234901, '08:00', '10:00', 'Martes', 201),
(2, 1, '2024-1', 1, 25, 15456789, '14:00', '16:00', 'Miércoles', 201);

-- =============================================
-- 9. INSCRIPCIONES Y CURSA
-- =============================================
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

-- =============================================
-- 10. RECURSOS ACADÉMICOS
-- =============================================
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

-- =============================================
-- 11. PROVEEDORES Y COMPRAS
-- =============================================
INSERT INTO proveedor (nombre, ubicacion) VALUES
('TecnoSol', 'Caracas'),
('LibrosEduc', 'Valencia'),
('SoftVen', 'Maracaibo');

INSERT INTO compra (IDSede, IDRec, IDProv, fecha_adq, cantidad) VALUES
(1, 1, 1, '2024-01-10', 5),
(1, 2, 3, '2024-01-12', 1),
(1, 3, 2, '2024-01-15', 20),
(1, 4, 1, '2024-01-20', 3);

-- =============================================
-- 12. EMPRESAS Y FACTURAS
-- =============================================
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

-- =============================================
-- 13. EVALUACIONES Y PRESENTACIONES
-- =============================================
INSERT INTO evaluacion (ponderacion, tipo, descripcion, codigoAsignatura) VALUES
(30.00, 'parcial', 'Primer parcial', 1),
(40.00, 'practica', 'Proyecto lab', 1),
(30.00, 'proyecto', 'Proyecto final', 1);

INSERT INTO presenta (IDEvaluacion, CI, calificacion) VALUES
(1, 25500123, 18.5),
(1, 26789234, 16.0),
(2, 25500123, 19.0),
(2, 26789234, 17.5);

-- =============================================
-- 14. RELACIONES SEDE-FACULTAD
-- =============================================
INSERT INTO sede_tiene_facultad (IDSede, codigoFacultad) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2),
(3, 1);

-- =============================================
-- 15. TELÉFONOS
-- =============================================
INSERT INTO telefono (numero, ciPersona) VALUES
(4125551234, 25500123),
(4145555678, 26789234),
(4165559012, 15456789),
(4245553456, 18567012);

-- ===========================================
-- FIN DEL SCRIPT
-- =============================================

