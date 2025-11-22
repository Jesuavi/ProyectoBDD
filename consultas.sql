--Consulta A
SELECT
s.nombre AS sede,
f.nombre AS facultad,
COALESCE(SUM(CASE WHEN pr.IDPrograma IS NOT NULL THEN 1 ELSE 0 END),0) AS num_pregrado,
COALESCE(SUM(CASE WHEN po.IDPrograma IS NOT NULL THEN 1 ELSE 0 END),0) AS num_postgrado
FROM sede_tiene_facultad st
JOIN sede_universitaria s ON st.IDSede = s.IDSede
JOIN facultad f ON st.codigoFacultad = f.codigoFacultad
LEFT JOIN programa_academico pa ON pa.codigoFacultad = f.codigoFacultad
LEFT JOIN pregrado pr ON pa.IDPrograma = pr.IDPrograma
LEFT JOIN postgrado po ON pa.IDPrograma = po.IDPrograma
GROUP BY s.nombre, f.nombre
ORDER BY s.nombre, f.nombre;

--Consulta B
SELECT DISTINCT p.ci, p.nombre, p.apellido, e.estado_ac
FROM inscribe i
JOIN estudiante e ON i.ci = e.ciEstudiante
JOIN persona p ON e.ciEstudiante = p.ci
WHERE i.estado_ins IN ('reprobado', 'retirado')
  AND i.fecha >= (current_date - INTERVAL '1 year')
ORDER BY p.apellido, p.nombre;

--Consulta c
SELECT 
    ra.nombre AS recurso,
    s.nombre AS sede,
    p.nombre AS proveedor,
    SUM(c.cantidad) AS cantidad_comprada,
    i.cantidad_disponible,
    SUM(c.cantidad) AS indicador_uso
FROM recurso_academico ra
JOIN compra c ON ra.IDRec = c.IDRec
JOIN sede_universitaria s ON c.IDSede = s.IDSede
JOIN proveedor p ON c.IDProv = p.IDProv
JOIN inventario i ON ra.IDRec = i.IDRec AND s.IDSede = i.IDSede
GROUP BY ra.nombre, s.nombre, p.nombre, i.cantidad_disponible
ORDER BY indicador_uso DESC
LIMIT 3;

--dConsulta D
SELECT 
    p.ciProfesor,
    per.nombre,
    per.apellido,
    COUNT(DISTINCT c.IDcargo) AS cantidad_cargos,
    STRING_AGG(DISTINCT ca.nombre, ', ') AS cargos_ejercidos,
    MIN(pl.fecha_EmpTrabajar) AS fecha_inicio_contratacion,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(pl.fecha_EmpTrabajar))) || ' años y ' ||
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, MIN(pl.fecha_EmpTrabajar))) || ' meses' AS tiempo_en_universidad,
    STRING_AGG(DISTINCT c.tipo_contrato, ', ') AS tipos_contrato
FROM profesor p
JOIN persona per ON p.ciProfesor = per.ci
JOIN personal pl ON p.ciProfesor = pl.ciPersonal
JOIN contrato c ON p.ciProfesor = c.ciProfesor
JOIN cargo_admin ca ON c.IDcargo = ca.IDcargo
GROUP BY p.ciProfesor, per.nombre, per.apellido
HAVING COUNT(DISTINCT c.IDcargo) >= 2
ORDER BY cantidad_cargos DESC, tiempo_en_universidad DESC;

-- CONSULTA E 
SELECT 
    a.codigoAsignatura,
    a.nombre AS asignatura,
    COUNT(DISTINCT pe.IDPrograma) AS programas_inscritos,
    STRING_AGG(DISTINCT pa.nombre, ', ') AS nombres_programas,
    COUNT(DISTINCT s.ciProfesor) AS profesores_distintos,
    COUNT(DISTINCT s.periodo || '-' || s.trimestre) AS periodos_dictados,
    COUNT(DISTINCT s.numero) AS secciones_totales
FROM asignatura a
JOIN plan_estudio pe ON a.codigoAsignatura = pe.codigoAsignatura
JOIN programa_academico pa ON pe.IDPrograma = pa.IDPrograma
LEFT JOIN seccion s ON a.codigoAsignatura = s.codigoAsignatura
GROUP BY a.codigoAsignatura, a.nombre
HAVING COUNT(DISTINCT pe.IDPrograma) > 1
ORDER BY programas_inscritos DESC, profesores_distintos DESC;







--Consulta G
SELECT p.ci, p.nombre, p.apellido, c.promedio
FROM estudiante e
JOIN persona p ON e.ciEstudiante = p.ci
JOIN cursa c ON e.ciEstudiante = c.ci
WHERE e.estado_ac = 'egresado'
  AND c.promedio >= 17.5;


-- CONSULTA F - VERSIÓN SIMPLIFICADA
SELECT 
    f.num_factura,
    p.nombre || ' ' || p.apellido AS estudiante,
    f.fecha,
    f.monto,
    f.monto_pagado,
    (f.monto - f.monto_pagado) AS saldo_pendiente,
    f.metodo,
    (f.fecha + 30) AS fecha_vencimiento,
    GREATEST(0, (f.fecha + 30 - CURRENT_DATE)) AS dias_restantes,
    CASE 
        WHEN (f.fecha + 30) < CURRENT_DATE THEN 'VENCIDA'
        WHEN (f.fecha + 30 - CURRENT_DATE) <= 5 THEN 'POR VENCER'
        ELSE 'EN PLAZO'
    END AS estado_vencimiento
FROM factura f
JOIN estudiante e ON f.ciEstudiante = e.ciEstudiante
JOIN persona p ON e.ciEstudiante = p.ci
WHERE f.metodo = 'mixto' 
AND (f.monto - f.monto_pagado) > 0
ORDER BY dias_restantes ASC;