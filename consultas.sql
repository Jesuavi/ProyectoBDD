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

-- Consulta C








--Consulta G
SELECT p.ci, p.nombre, p.apellido, c.promedio
FROM estudiante e
JOIN persona p ON e.ciEstudiante = p.ci
JOIN cursa c ON e.ciEstudiante = c.ci
WHERE e.estado_ac = 'egresado'
  AND c.promedio >= 17.5;


--Consulta F
SELECT 
num_factura,
ciEstudiante,
fecha,
monto,
monto_pagado,
(monto - monto_pagado) AS saldo_pendiente,
metodo,
(fecha + INTERVAL '30 days' - CURRENT_DATE) AS dias_restantes
FROM 
factura
WHERE 
metodo = 'mixto' AND (monto - monto_pagado) > 0;