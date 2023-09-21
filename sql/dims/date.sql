DROP TABLE IF EXISTS dim.date;
CREATE TABLE dim.date
AS (
WITH dates AS (
SELECT  *
FROM    UNNEST(GENERATE_DATE_ARRAY('2000-01-01', '2024-12-31', INTERVAL 1 DAY)) AS date
)


, weeks AS (
SELECT 
        EXTRACT(YEAR FROM date)                            AS year,
        CAST(EXTRACT(WEEK FROM date) AS INT64) + 1         AS week_of_year,
        MIN(date)                                          AS first_date_of_week,
        MAX(date)                                          AS last_date_of_week,
FROM    dates
GROUP   BY 1, 2
)

SELECT
        CAST(EXTRACT(YEAR FROM d.date) as INT64)*10000 + CAST(EXTRACT(MONTH FROM d.date) AS INT64)*100 + CAST(EXTRACT(DAY FROM d.date) AS INT64) AS date_id,
        d.date                               AS date,
        EXTRACT(YEAR FROM d.date)            AS year,
        FORMAT_DATE('%Q', d.date)            AS quarter,
        
        CAST(EXTRACT(YEAR FROM d.date) as INT64)*100+ CAST(EXTRACT(MONTH FROM d.date) AS INT64) AS month_id,        
        CONCAT(FORMAT_DATE('%b', d.date) , " " , CAST(EXTRACT(YEAR FROM d.date) as string))     AS month_year_name,
        EXTRACT(MONTH FROM d.date)                                                              AS month,        
        FORMAT_DATETIME("%B", DATETIME(d.date))                                                 AS month_name,
        FORMAT_DATE('%b', d.date)                                                               AS month_name_short,
        DATE_TRUNC(d.date, YEAR)                                                                AS first_date_of_year,
        CASE WHEN d.date = DATE_TRUNC(d.date, YEAR) THEN TRUE ELSE FALSE END                    AS is_first_date_of_year,
        DATE_TRUNC(d.date, MONTH)                                                               AS first_date_of_month,
        DATE_SUB(DATE_TRUNC(DATE_ADD(d.date, INTERVAL 1 MONTH), MONTH), INTERVAL 1 DAY)         AS last_date_of_month,
        CASE    WHEN d.date = DATE_TRUNC(d.date, MONTH) THEN TRUE ELSE FALSE END                AS is_first_date_of_month,
        CASE d.date WHEN DATE_SUB(DATE_TRUNC(DATE_ADD(d.date, INTERVAL 1 MONTH), MONTH), INTERVAL 1 DAY) THEN TRUE ELSE FALSE END  AS is_last_date_of_month,
        EXTRACT(day FROM LAST_DAY(CURRENT_DATE(), month))                                       AS month_day_count,
        
        CAST(EXTRACT(YEAR FROM d.date) as INT64)*100+ CAST(EXTRACT(WEEK FROM d.date) as INT64)+1        AS week_id,
        first_date_of_week                                                                              AS first_date_of_week,
        CONCAT(CAST (FORMAT_DATE("%d %b",first_date_of_week ) AS STRING),'-',CAST (FORMAT_DATE("%d %b", last_date_of_week ) as string)) AS week_range,
        CAST(EXTRACT(WEEK FROM d.date) as INT64) + 1                                                    AS week_of_year,
                CASE WHEN d.date = first_date_of_week THEN TRUE ELSE FALSE END                          AS is_first_date_of_week,
        CASE WHEN d.date = last_date_of_week  THEN TRUE ELSE FALSE END                                  AS is_last_date_of_week,
        LAST_DAY(d.date, week)                                                                          AS last_date_of_week,
        
        EXTRACT(DAY FROM d.date)                        AS day_of_year,
        CAST(FORMAT_DATE('%d', d.date) AS INT64)        AS day_of_month,
        CAST(FORMAT_DATE('%w', d.date)as INT64) + 1     AS day_of_week,
        FORMAT_DATE('%A', d.date)                       AS day_name,
        (CASE WHEN FORMAT_DATE('%A', d.date) IN ('Friday', 'Saturday') THEN "Weekend" ELSE "Weekday" END) AS day_type
FROM    dates d
JOIN    weeks
        ON weeks.year =  EXTRACT(YEAR FROM d.date)
        AND weeks.week_of_year = CAST(EXTRACT(WEEK FROM d.date) AS INT64) + 1
ORDER   BY d.date
);