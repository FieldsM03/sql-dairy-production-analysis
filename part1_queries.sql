
/*Final Project */
/*part 1*/
/* 1) Find the total milk production for the year 2023 */
SELECT sum(value) as total
FROM MILK_PRODUCTION
WHERE year = 2023;


/* 2) Show Coffee production data for the year 2015. What was the value?
   - If you want the total across all states, use SUM (most common). */
SELECT SUM(value) AS total_coffee_2015
FROM COFFEE_PRODUCTION
WHERE year = 2015;

/* 3) Find the average honey production for the year 2022 */
SELECT AVG(value) AS avg_honey_2022
FROM HONEY_PRODUCTION
WHERE year = 2022;


/* 4) Get names with their corresponding ANSI codes from the STATE_LOOKUP table */
SELECT state_name, state_ansi
FROM STATE_LOOKUP
ORDER BY state_name;

/* What number is IOWA? (You wrote "LOWA", but it's IOWA) */
SELECT state_ansi AS iowa_ansi
FROM STATE_LOOKUP
WHERE UPPER(state_name) = 'IOWA';


/* 5) Find the highest yogurt production value for the year 2022 */
SELECT MAX(value) AS max_yogurt_2022
FROM YOGURT_PRODUCTION
WHERE year = 2022;

/* 6) Find STATES where both honey and milk were produced in 2022 */
SELECT
  s.state AS state_name,
  s.state_ansi,
  COALESCE(SUM(c.value), 0) AS cheese_apr_2023
FROM state_lookup s
LEFT JOIN cheese_production c
  ON c.state_ansi = s.state_ansi
 AND c.year = 2023
 AND c.period = 'APR'
GROUP BY s.state, s.state_ansi
ORDER BY s.state;

/* Did STATE_ANSI "35" produce honey in 2022? (YES/NO) */
SELECT CASE WHEN EXISTS (
  SELECT 1
  FROM HONEY_PRODUCTION
  WHERE year = 2022
    AND state_ansi = 35
    AND value > 0
) THEN 'YES' ELSE 'NO' END AS state_35_produced_honey_2022;


/* 7) Find the total yogurt production for STATES that also produced cheese in 2022 */
SELECT SUM(y.value) AS total_yogurt_2022_in_cheese_states
FROM YOGURT_PRODUCTION y
WHERE y.year = 2022
  AND y.state_ansi IN (
    SELECT DISTINCT c.state_ansi
    FROM CHEESE_PRODUCTION c
    WHERE c.year = 2022
      AND c.value > 0
  );
