-- Función que actualiza el inventario
CREATE OR REPLACE FUNCTION actualizar_inventario()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM inventario 
               WHERE IDRec = NEW.IDRec AND IDSede = NEW.IDSede) THEN
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

CREATE TRIGGER trigger_actualizar_inventario_v2
AFTER INSERT ON compra
FOR EACH ROW
EXECUTE FUNCTION actualizar_inventario();


-- Función que verifica si el estudiante terminó todas las asignaturas
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

CREATE TRIGGER trigger_actualizar_estado_v2
AFTER INSERT OR UPDATE ON inscribe
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_estudiante();


-- Función para actualizar el estado de la factura
CREATE OR REPLACE FUNCTION actualizar_estado_factura()
RETURNS TRIGGER AS $$
BEGIN
    -- Asignar un valor válido del dominio estado_factura
    IF COALESCE(NEW.monto_pagado,0) >= COALESCE(NEW.monto,0) THEN
        NEW.estado := 'pagada';
    ELSIF NEW.fecha < current_date AND COALESCE(NEW.monto_pagado,0) < COALESCE(NEW.monto,0) THEN
        NEW.estado := 'vencida';
    ELSE
        NEW.estado := 'pendiente';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger que actúa antes de insertar o actualizar una factura
CREATE TRIGGER trigger_estado_factura_v2
BEFORE INSERT OR UPDATE ON factura
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_factura();
