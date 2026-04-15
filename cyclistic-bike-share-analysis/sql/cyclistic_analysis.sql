-- Cyclistic Bike Share Analysis (2025)
-- Tools: Google BigQuery
-- Objective: Compare behavior between casual riders and annual members

--------------------------------------------------
-- 1. Combine Monthly Data
--------------------------------------------------

-- Combine all monthly trip datasets into one table

CREATE TABLE cyclistic_data.all_trips_2025 AS
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202501_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202502_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202503_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202504_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202505_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202506_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202507_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202508_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202509_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202510_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202511_trips`
UNION ALL
SELECT * FROM `alien-device-491322-n2.cyclistic_data.202512_trips`;

--------------------------------------------------
-- 2. Feature Engineering
--------------------------------------------------

-- Create new variables: ride length and day of week

CREATE TABLE cyclistic_data.cleaned_trips AS
SELECT *,
  TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length_seconds,
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM cyclistic_data.all_trips_2025;

--------------------------------------------------
-- 3. Data Cleaning
--------------------------------------------------

-- Filter invalid data (duration, nulls, user types, coordinates)

CREATE TABLE cyclistic_data.final_trips AS
SELECT *
FROM cyclistic_data.cleaned_trips
WHERE 
  ride_length_seconds > 0
  AND ride_length_seconds < 86400
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND member_casual IN ('member', 'casual')
  AND start_lat BETWEEN -90 AND 90
  AND end_lat BETWEEN -90 AND 90
  AND start_lng BETWEEN -180 AND 180
  AND end_lng BETWEEN -180 AND 180;

--------------------------------------------------
-- 4. Overall Usage Comparison
--------------------------------------------------

-- Calculate total rides and average ride duration by user type

SELECT 
  member_casual,
  COUNT(*) AS total_rides,
  ROUND(AVG(ride_length_seconds)/60, 2) AS avg_ride_length_minutes
FROM cyclistic_data.final_trips
GROUP BY member_casual;

--------------------------------------------------
-- 5. Ride Distribution by Day of Week
--------------------------------------------------

-- Analyze ride frequency across days of the week

SELECT 
  member_casual,
  day_of_week,
  COUNT(*) AS total_rides
FROM cyclistic_data.final_trips
GROUP BY member_casual, day_of_week
ORDER BY member_casual, day_of_week;

--------------------------------------------------
-- 6. Percentage Distribution
--------------------------------------------------

-- Calculate percentage share of rides by user type

SELECT 
  member_casual,
  COUNT(*) AS total_rides,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM cyclistic_data.final_trips
GROUP BY member_casual;

