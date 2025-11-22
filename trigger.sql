-- =============================================
-- 1. TRIGGER PARA ACTUALIZAR INVENTARIO DESPUÉS DE UNA COMPRA
-- =============================================
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

-- =============================================
-- 2. TRIGGER PARA ACTUALIZAR ESTADO DEL ESTUDIANTE (EGRESADO)
-- =============================================
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

-- =============================================
-- 3. TRIGGER PARA ACTUALIZAR ESTADO DE LA FACTURA
-- =============================================
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

-- =============================================
-- 4. TRIGGER PARA VALIDAR INSCRIPCIÓN (PREREQUISITOS Y DUPLICADOS)
-- =============================================
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

-- =============================================
-- 5. TRIGGER PARA VALIDAR SECCIÓN CON PROFESOR
-- =============================================
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