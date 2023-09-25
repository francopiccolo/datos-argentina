DROP TABLE IF EXISTS dim.country;

CREATE TABLE dim.country AS (

SELECT 
        country_code,
        country_name_abbreviation   AS country_short,
        country_name_full           AS country,
        iso_2digit_alpha            AS iso_2d,
        iso_3digit_alpha            AS iso_3d
FROM    cepii.country_codes);