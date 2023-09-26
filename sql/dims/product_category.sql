DROP TABLE IF EXISTS dim.product_category;

CREATE TABLE dim.product_category AS (

WITH data AS (
SELECT 
        CAST(string_field_0 AS INTEGER) AS product_category_l4_code,
        string_field_1 AS product_category_l4
FROM cepii.product_codes
WHERE string_field_0 NOT IN ('code', '9999AA') --header and legacy code not in fact
)

SELECT  
        product_category_l1,
        product_category_l2_code,
        product_category_l2,
        product_category_l3_code,
        product_category_l3,
        d.product_category_l4_code,
        d.product_category_l4
FROM    data d 
LEFT    JOIN    sheets.product_category pc USING (product_category_l4_code)
)
; 