DROP VIEW IF EXISTS views.bilateral_trade_flows;

CREATE VIEW views.bilateral_trade_flows AS (

SELECT  tf.year, 
        ce.country          AS exporter_country,
        ci.country          AS importer_country,
        pc.*,
        tf.trade_value_current_usd,
        tf.qty_tons
FROM    fact.bilateral_trade_flows tf
JOIN    dim.country ce ON ce.country_code = tf.exporter_country_code
JOIN    dim.country ci ON ci.country_code = tf.importer_country_code
JOIN    dim.product_category pc ON pc.product_category_l4_code = tf.product_category
);