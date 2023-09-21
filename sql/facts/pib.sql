DROP TABLE IF EXISTS fact.pib;

CREATE TABLE fact.pib AS (
SELECT Year AS year,
       CAST(LEFT(trimestre, 1) AS NUMERIC) AS quarter,
       CAST(REGEXP_REPLACE(a.pib, r'[^0-9]', '') AS NUMERIC) AS pib
FROM indec.pib a);