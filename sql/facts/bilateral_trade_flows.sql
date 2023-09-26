DROP TABLE IF EXISTS fact.bilateral_trade_flows;

CREATE TABLE fact.bilateral_trade_flows AS (
SELECT 
        CAST(t AS INTEGER)      AS year,
        CAST(k AS INTEGER)	AS product_category,
        CAST(i AS INTEGER)      AS exporter_country_code,
        CAST(j AS INTEGER)	AS importer_country_code,
        CAST(v*1000 AS FLOAT64)	AS trade_value_current_usd,
        SAFE_CAST(q AS FLOAT64) AS qty_tons --some values were NA
FROM    cepii.bilateral_trade_flows
JOIN    dim.country ce ON ce.country_code = i 
JOIN    dim.country ci ON ci.country_code = j
WHERE   ce.country IN ('Argentina', 'Brazil', 'Plurinational State of Bolivia', 'Chile', 'Colombia', 'Ecuador', 'Paraguay', 'Peru', 'Uruguay', 'Venezuela')
        OR ci.country IN ('Argentina', 'Brazil', 'Plurinational State of Bolivia', 'Chile', 'Colombia', 'Ecuador', 'Paraguay', 'Peru', 'Uruguay', 'Venezuela')
);