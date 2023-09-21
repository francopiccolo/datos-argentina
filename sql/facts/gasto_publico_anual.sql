DROP TABLE IF EXISTS fact.gasto_publico_anual;

CREATE TABLE fact.gasto_publico_anual AS (

WITH data AS (
SELECT  d.date, SUM(a.pib) AS pib
FROM    fact.pib a
JOIN    dim.date d USING (year)
WHERE   d.is_first_date_of_year
GROUP   BY 1)

SELECT  indice_tiempo, pib*gasto_publico_total/100 AS gasto_publico
FROM    data d
JOIN    datosgobar.gasto_publico_consolidado gp
        ON d.date = gp.indice_tiempo);