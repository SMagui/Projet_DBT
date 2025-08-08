with months AS (
     SELECT DISTINCT EXTRACT(MONTH FROM tpep_pickup_datetime) AS month
     FROM {{ref('transform')}}
     
)

SELECT COUNT(*)
FROM months
HAVING COUNT(*) <> 12