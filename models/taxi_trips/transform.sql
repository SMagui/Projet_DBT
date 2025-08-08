with source_data AS (
    SELECT * EXCLUDE(VendorID, RatecodeID)
    FROM {{ source('taxi_trips', 'row_yellow_tripdata') }}

),

filtered_data AS (

     SELECT *
     FROM source_data
     WHERE 
         passenger_count > 0
         AND trip_distance > 0
         AND total_amount > 0
         AND tpep_dropoff_datetime > tpep_pickup_datetime -- Correction ici
         AND store_and_fwd_flag = 'N'
         AND tip_amount >= 0
         AND payment_type IN (1,2)

),

transformed_data AS (
    SELECT 
       CAST(passenger_count AS BIGINT) AS passenger_count,
       CASE 
           WHEN payment_type = 1 THEN 'Credit Card'
           WHEN payment_type = 2 THEN 'Cash'
       END AS payment_method,

       DATE_DIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS trip_duration_minutes,
       
       *EXCLUDE (passenger_count, payment_type)
       FROM filtered_data
      
)
,final_data AS(
    SELECT* EXCLUDE (tpep_pickup_datetime, tpep_dropoff_datetime),
       CAST(tpep_pickup_datetime AS DATE) AS pickup_date,
       CAST(tpep_dropoff_datetime AS DATE) AS dropoff_date
    FROM transformed_data
    WHERE CAST(tpep_pickup_datetime AS DATE) >= '2024-01-01' AND CAST(tpep_pickup_datetime AS DATE) < '2025-01-01'
          AND CAST(tpep_dropoff_datetime AS DATE) >= '2024-01-01' AND CAST(tpep_dropoff_datetime AS DATE) < '2025-01-01'

)

 SELECT * EXCLUDE (pickup_date, dropoff_date)
 FROM final_data
 WHERE trip_duration_minutes > 0