{{ config(materialized='view') }}

select 
    tpep_pickup_datetime, 
    tpep_dropoff_datetime, 
    passenger_count, 
    trip_distance, 
    total_amount, 
    payment_type, 
    DATE_DIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime) as trip_duration_minutes
from {{ source('tlc_taxi_trips', 'row_yellow_tripdata') }}
where passenger_count >= 1 and passenger_count <= 6
limit 10