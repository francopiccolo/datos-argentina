DROP TABLE IF EXISTS fact.gasto_publico_anual_por_prestacion;

CREATE TABLE fact.gasto_publico_anual_por_prestacion AS (
WITH gasto_ingresos AS (
SELECT  indice_tiempo, 
        SUM(gasto) AS gasto
FROM    fact.gasto_publico_en_ingresos
GROUP   BY 1)

, gasto_rest AS (
SELECT  indice_tiempo, 
        gasto_publico - COALESCE(gasto, 0) AS gasto
FROM    fact.gasto_publico_anual
LEFT    JOIN gasto_ingresos USING (indice_tiempo)
)

, data AS (
SELECT  indice_tiempo, 
        gasto, 'ingresos'   AS prestacion_l1, 
        CASE 
            WHEN prestacion IN ('programa_jefas_jefes_hogar_desocupados', 'argentina_trabaja') THEN 'Plan Potenciar'
            WHEN prestacion LIKE 'jubilaciones%' OR prestacion LIKE 'pension%' THEN 'Jubilaciones y pensiones'
            WHEN prestacion LIKE 'seguro_desempleo%' THEN 'Seguro desempleo'
            ELSE prestacion 
        END                 AS prestacion_l2,
        prestacion          AS prestacion_l3
FROM    fact.gasto_publico_en_ingresos
UNION ALL
SELECT  indice_tiempo, 
        gasto, 
        'resto'             AS prestacion_l1, 
        'resto'             AS prestacion_l2, 
        'resto'             AS prestacion_l3 
FROM    gasto_rest)

SELECT  indice_tiempo, 
        gasto, 
        prestacion_l1, 
        prestacion_l2, 
        prestacion_l3, 
        CASE WHEN prestacion_l1 = 'ingresos' AND prestacion_l2 <> 'Jubilaciones y pensiones' THEN  TRUE ELSE FALSE  END AS is_ingreso_sin_jubilaciones,
        CASE WHEN prestacion_l1 = 'ingresos' AND prestacion_l2 = 'Plan Potenciar' THEN  TRUE ELSE FALSE             END AS is_plan_potenciar,
FROM    data);