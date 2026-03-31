
-- 1. vehicles involved in drug-related stops
SELECT
    vehicle_number,
    COUNT(*) AS drug_related_stops
FROM traffic_stops
WHERE drugs_related_stop = TRUE
GROUP BY vehicle_number
ORDER BY drug_related_stops DESC
LIMIT 10;


-- 2. Vehicles most frequently searched
SELECT
    vehicle_number,
    COUNT(*) AS search_count
FROM traffic_stops
WHERE search_conducted = TRUE
GROUP BY vehicle_number
ORDER BY search_count DESC
LIMIT 10;


-- 3. Driver age group with the highest arrest count
SELECT
    CASE
        WHEN driver_age < 25 THEN 'Below 25'
        WHEN driver_age BETWEEN 25 AND 40 THEN '25-40'
        ELSE 'Above 40'
    END AS age_group,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrest_count
FROM traffic_stops
GROUP BY age_group
ORDER BY arrest_count DESC;


-- 4. Gender distribution of drivers in each country
SELECT
    country_name,
    driver_gender,
    COUNT(*) AS total_stops
FROM traffic_stops
GROUP BY country_name, driver_gender
ORDER BY country_name;


-- 5. Race and gender combination with highest search rate
SELECT
    driver_race,
    driver_gender,
    COUNT(*) FILTER (WHERE search_conducted = TRUE) AS search_count
FROM traffic_stops
GROUP BY driver_race, driver_gender
ORDER BY search_count DESC
LIMIT 1;


-- 6. Time of day with the most traffic stops
SELECT
    EXTRACT(HOUR FROM stop_time) AS hour_of_day,
    COUNT(*) AS total_stops
FROM traffic_stops
GROUP BY hour_of_day
ORDER BY total_stops DESC;


-- 7. Average stop duration by violation
-- (Stop duration is categorical, so frequency is analyzed)
SELECT
    violation,
    stop_duration,
    COUNT(*) AS total_stops
FROM traffic_stops
GROUP BY violation, stop_duration
ORDER BY violation;


-- 8. Compare arrest likelihood during Day vs Night
SELECT
    CASE
        WHEN EXTRACT(HOUR FROM stop_time) BETWEEN 20 AND 23
          OR EXTRACT(HOUR FROM stop_time) BETWEEN 0 AND 5
        THEN 'Night'
        ELSE 'Day'
    END AS time_period,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrest_count
FROM traffic_stops
GROUP BY time_period;


-- 9. Violations most associated with searches and arrests
SELECT
    violation,
    COUNT(*) FILTER (WHERE search_conducted = TRUE) AS search_count,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrest_count
FROM traffic_stops
GROUP BY violation
ORDER BY arrest_count DESC;


-- 10. Violations most common among young drivers (<25)
SELECT
    violation,
    COUNT(*) AS total_cases
FROM traffic_stops
WHERE driver_age < 25
GROUP BY violation
ORDER BY total_cases DESC;


-- 11. Violation that rarely results in search or arrest
SELECT
    violation,
    COUNT(*) FILTER (
        WHERE search_conducted = TRUE OR is_arrested = TRUE
    ) AS police_action_count
FROM traffic_stops
GROUP BY violation
ORDER BY police_action_count ASC
LIMIT 1;


-- 12. Countries with highest drug-related stops
SELECT
    country_name,
    COUNT(*) FILTER (WHERE drugs_related_stop = TRUE) AS drug_cases
FROM traffic_stops
GROUP BY country_name
ORDER BY drug_cases DESC;


-- 13. Arrest count by country and violation
SELECT
    country_name,
    violation,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrest_count
FROM traffic_stops
GROUP BY country_name, violation
ORDER BY arrest_count DESC;


-- 14. Country with the highest number of searches conducted
SELECT
    country_name,
    COUNT(*) FILTER (WHERE search_conducted = TRUE) AS total_searches
FROM traffic_stops
GROUP BY country_name
ORDER BY total_searches DESC
LIMIT 1;


-- 15. Yearly breakdown of stops and arrests by country
SELECT
    country_name,
    EXTRACT(YEAR FROM stop_date) AS year,
    COUNT(*) AS total_stops,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrests,
    RANK() OVER (
        PARTITION BY country_name
        ORDER BY COUNT(*) DESC
    ) AS yearly_rank
FROM traffic_stops
GROUP BY country_name, year;


-- 16. Driver violation trends based on age group and race
SELECT
    driver_race,
    CASE
        WHEN driver_age < 25 THEN 'Below 25'
        WHEN driver_age BETWEEN 25 AND 40 THEN '25-40'
        ELSE 'Above 40'
    END AS age_group,
    violation,
    COUNT(*) AS total_cases
FROM traffic_stops
GROUP BY driver_race, age_group, violation
ORDER BY total_cases DESC;


-- 17. Time-period analysis: Year, Month, Hour
SELECT
    EXTRACT(YEAR FROM stop_date) AS year,
    EXTRACT(MONTH FROM stop_date) AS month,
    EXTRACT(HOUR FROM stop_time) AS hour,
    COUNT(*) AS total_stops
FROM traffic_stops
GROUP BY year, month, hour
ORDER BY year, month, hour;


-- 18. Violations with high search and arrest rates using window function
SELECT
    violation,
    COUNT(*) FILTER (WHERE search_conducted = TRUE) AS search_count,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrest_count,
    RANK() OVER (
        ORDER BY COUNT(*) FILTER (WHERE is_arrested = TRUE) DESC
    ) AS arrest_rank
FROM traffic_stops
GROUP BY violation;


-- 19. Driver demographics by country
SELECT
    country_name,
    driver_gender,
    driver_race,
    COUNT(*) AS total_drivers
FROM traffic_stops
GROUP BY country_name, driver_gender, driver_race
ORDER BY country_name;


-- 20. Top 5 violations with highest arrest counts
SELECT
    violation,
    COUNT(*) FILTER (WHERE is_arrested = TRUE) AS arrest_count
FROM traffic_stops
GROUP BY violation
ORDER BY arrest_count DESC
LIMIT 5;

