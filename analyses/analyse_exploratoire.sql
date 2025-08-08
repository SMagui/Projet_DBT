select * from 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet' limit 10;

select vendorid, count(*) as total_trips
from 'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet'
GROUP BY vendorid;

SELECT *
FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet')
LIMIT 10;


SELECT
    COUNT(*) AS total_courses,
    MIN(tpep_pickup_datetime) AS debut_periode,
    MAX(tpep_dropoff_datetime) AS fin_periode,
    MIN(passenger_count) AS min_passagers,
    MAX(passenger_count) AS max_passagers,
    AVG(passenger_count) AS moy_passagers,
    MIN(trip_distance) AS min_distance,
    MAX(trip_distance) AS max_distance,
    AVG(trip_distance) AS moy_distance
FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet');

SELECT
    payment_type,
    COUNT(*) AS nb_courses,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet')
GROUP BY payment_type
ORDER BY nb_courses DESC;

SELECT
    ROUND(AVG(DATE_DIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime)), 2) AS duree_moyenne_min,
    ROUND(MAX(DATE_DIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime)), 2) AS duree_max_min
FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet');


SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    total_amount,
    DATE_DIFF('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS duree_min
FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet')
ORDER BY duree_min DESC
LIMIT 10;


SELECT
    EXTRACT(hour FROM tpep_pickup_datetime) AS heure,
    COUNT(*) AS nb_courses
FROM read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet')
GROUP BY heure
ORDER BY heure;
