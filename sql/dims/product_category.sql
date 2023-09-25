DROP TABLE IF EXISTS dim.product_category;

CREATE TABLE dim.product_category AS (

SELECT 
        CAST(string_field_0 AS INTEGER) AS product_category_code,
        string_field_1 AS product_category
FROM cepii.product_codes
WHERE string_field_0 NOT IN ('code', '9999AA')); --header and legacy code not in fact