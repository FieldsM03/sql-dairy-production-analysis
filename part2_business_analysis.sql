

/* Project part 2*/
--1.)Can You find out the Total milk production for 2023? Your Manager wants this information for the yearly report.
---What us the Total Production for 2023? 
SELECT
  SUM(CAST(REPLACE(value, ',', '') AS INTEGER)) AS total_milk_2023
FROM milk_production
WHERE year = 2023;

--2.)Which STATES had cheese production greater than 100 million in April 2023? The cheese department wants to focus their market efforts there.
---How many STATES are there? 
SELECT DISTINCT
  s.state,
  c.state_ansi,
  c.value
FROM cheese_production c
JOIN state_lookup s
  ON s.state_ansi = c.state_ansi
WHERE c.year = 2023
  AND c.period = 'APR'
  AND c.value > 1000000
ORDER BY c.value DESC;

--3.) Your Manager wants to know how coffee production has changed over the years? 
---What is the total value of coffee production for 2011? 
SELECT
  (SELECT SUM(CAST(REPLACE(value, ',', '') AS INTEGER))
   FROM coffee_production
   WHERE year = 2016)
  -
  (SELECT SUM(CAST(REPLACE(value, ',', '') AS INTEGER))
   FROM coffee_production
   WHERE year = 2011)
  AS production_difference;


--4.) There is a meeting with the honey Council next week.
---Find the average honey product for 2022 so you're prepared.
SELECT
  AVG(CAST(REPLACE(value, ',', '') AS INTEGER)) AS avg_honey_2022
FROM honey_production
WHERE year = 2022
  AND CAST(REPLACE(value, ',', '') AS INTEGER) > 0;

--5.)THe STATE Relations team wants a list of ALL STATES names with their corresponding ANSI codes. Can you genarate that list? 
SELECT state, state_ansi
FROM state_lookup 
ORDER BY STATE;
---What is the STATE_ANSI code for FLORIDA?
SELECT STATE_ANSI
FROM state_lookup 
WHERE UPPER(state) = 'FLORIDA';

--6.)For a cross-commodity report,can you list all STATES with their cheese production values,even if they didn't any cheese in April of 2023? 
SELECT s.state,
s.state_ansi,
COALESCE(c.value,0) AS cheese_apr_2023
FROM state_lookup s
LEFT JOIN cheese_production c
	on c.State_ANSI = s.State_ANSI 
	AND c.year = 2023
	and c.period = 'APR'
	ORDER BY s.state;

---What is the Total for NEW Jersey?
SELECT
  s.state,
  COALESCE(SUM(CAST(REPLACE(c.value, ',', '') AS INTEGER)), 0) AS total_nj_cheese_apr_2023
FROM state_lookup s
LEFT JOIN cheese_production c
  ON c.state_ansi = s.state_ansi
 AND c.year = 2023
 AND c.period = 'APR'
WHERE UPPER(s.state) = 'NEW JERSEY'
GROUP BY s.state;

--7.)Can you find the Total yogurt production for STATES in the year 2022 which also have cheese production data from 2023? 
---This will help the Dairy Division in their planning?
SELECT SUM(y.value) AS total_yogurt_2022_in_cheese_states_2023
FROM yogurt_production y
WHERE y.year = 2022
  AND y.state_ansi IN (
	SELECT DISTINCT c.state_ansi
	FROM cheese_production c
	WHERE c.year = 2023
	);

--8.)list all STATES from state_lookup that are missing from milk production in 2023. 
SELECT s.state,s.state_ansi
FROM state_lookup s
LEFT JOIN milk_production m
	ON m.state_ansi = s.State_ANSI 
	AND m.year = 2023
WHERE m.state_ansi IS NULL 
ORDER BY s.state;

---How many STATES are there?
SELECT COUNT(*) AS num_missing_states 
FROM state_lookup s
LEFT JOIN milk_production m
	ON m.state_ansi = s.state_ansi 
	AND m.year = 2023 
WHERE m.state_ansi IS NULL;


--9.) List all states with their cheese production values, including states that didn't produce any cheese in April 2023.
 SELECT 
  s.state,
  s.state_ansi,
  COALESCE(c.value, 0) AS cheese_apr_2023
FROM STATE_LOOKUP s
LEFT JOIN CHEESE_PRODUCTION c
  ON c.state_ansi = s.state_ansi
 AND c.year = 2023
 AND c.period = 'APR'
ORDER BY s.state;
---Did Delware produce any cheese in April 2023?
SELECT CASE WHEN EXISTS (
SELECT 1
FROM cheese_production c
JOIN state_lookup s ON s.state_ansi = c.state_ansi 
WHERE c.year = 2023 
AND c.period = 'APR'
AND UPPER (s.state) = 'DELAWARE'
AND c.value > 0
) THEN 'YES' ELSE 'NO' END AS delaware_cheese_apr_2023;

--10.) Find the average coffee production for all years where the honey production exceded 1 million.
SELECT
  AVG(CAST(REPLACE(c.value, ',', '') AS INTEGER)) AS avg_coffee_when_honey_gt_1m
FROM coffee_production c
JOIN honey_production h
  ON h.year = c.year
WHERE CAST(REPLACE(h.value, ',', '') AS INTEGER) > 1000000;

