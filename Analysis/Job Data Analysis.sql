-- Select all columns/jobs
SELECT *
FROM JobstreetDatabase..JobstreetDataAnalyst

-- Return all the column names
SELECT COLUMN_NAME
FROM JobstreetDatabase.INFORMATION_SCHEMA.COLUMNS

-- Select distinct jobs
SELECT *
INTO DistinctJobs
FROM 
	(
		SELECT
			*, 
			ROW_NUMBER() OVER (PARTITION BY title, company, location, salary ORDER BY title) AS row_num
		FROM
			JobstreetDatabase..JobstreetDataAnalyst
	) a
WHERE a.row_num = 1

SELECT *
FROM DistinctJobs

ALTER TABLE DistinctJobs
DROP COLUMN row_num

-- Return the number of distinct jobs
SELECT COUNT(*)
FROM DistinctJobs

-- Count the top skills
WITH TEMP AS(
	SELECT 
		sql,
		COUNT(sql) OVER(PARTITION BY sql) AS sql_count,
		excel,
		COUNT(excel) OVER(PARTITION BY excel) AS excel_count,
		tableau,
		COUNT(tableau) OVER(PARTITION BY tableau) AS tableau_count,
		power_bi,
		COUNT(power_bi) OVER(PARTITION BY power_bi) AS power_bi_count,
		python,
		COUNT(python) OVER(PARTITION BY python) AS python_count,
		r,
		COUNT(r) OVER(PARTITION BY r) AS r_count
	FROM DistinctJobs
)
SELECT 
	'sql'AS skills,
	sql_count AS skill_count
FROM TEMP 
WHERE sql = 'Yes'
UNION
SELECT 
	'excel',
	excel_count
FROM TEMP 
WHERE excel = 'Yes'
UNION
SELECT 
	'tableau',
	tableau_count
FROM TEMP 
WHERE tableau = 'Yes'
UNION
SELECT 
	'power_bi',
	power_bi_count
FROM TEMP 
WHERE power_bi = 'Yes'
UNION
SELECT 
	'python',
	python_count
FROM TEMP 
WHERE python = 'Yes'
UNION
SELECT 
	'r',
	r_count
FROM TEMP 
WHERE r = 'Yes'
ORDER BY skill_count DESC

-- Group by location
SELECT 
	location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs
GROUP BY location
ORDER BY num_of_jobs DESC

-- Number of data analyst jobs in NCR
-- National Capital Reg is the location of the job with no specified city
SELECT 
	'Makati' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Makati%'
UNION
SELECT 
	'Taguig' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Taguig%'
UNION
SELECT 
	'Mandaluyong' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Mandaluyong%'
UNION
SELECT 
	'Manila' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Manila%'
UNION
SELECT 
	'Quezon City' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Quezon City%'
UNION
SELECT 
	'San Juan' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%San Juan%'
UNION
SELECT 
	'Pasig' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Pasig%'
UNION
SELECT 
	'Pasay' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Pasay%'
UNION
SELECT 
	'Paranaque' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Paranaque%'
UNION
SELECT 
	'Caloocan' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Caloocan%'
UNION
SELECT 
	'Pateros' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Pateros%'
UNION
SELECT 
	'Marikina' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Marikina%'
UNION
SELECT 
	'Las Pinas' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Las Pinas%'
UNION
SELECT 
	'Malabon' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Malabon%'
UNION
SELECT 
	'Muntinlupa' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Muntinlupa%'
UNION
SELECT 
	'Navotas' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Navotas%'
UNION
SELECT 
	'Valenzuela' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%Valenzuela%'
UNION
SELECT 
	'National Capital Reg' AS ncr_location,
	COUNT(location) AS num_of_jobs
FROM DistinctJobs 
WHERE location LIKE '%National Capital Reg%'
ORDER BY num_of_jobs DESC

-- Average salary range
-- Based on 1272 jobs
	WITH TEMP AS(
		SELECT 
			salary,
			REPLACE(salary, 'monthly', '') AS monthly_salary,
			TRIM(SUBSTRING(salary, 1, CHARINDEX('-', salary) - 1)) AS lowest_salary,
			REPLACE(
				SUBSTRING(salary, CHARINDEX('-', salary) + 2, CHARINDEX('m', salary) - 	CHARINDEX('-', salary) - 2),
				',',
				'') AS highest_salary
		FROM DistinctJobs
		WHERE salary <> 'none'
		--ORDER BY highest_salary, lowest_salary DESC
	),
	TEMP2 AS (
		SELECT 
			monthly_salary,
			lowest_salary,
			highest_salary,
			CASE 
				WHEN SUBSTRING(lowest_salary, 1, 1) = '$' THEN
					CASE 
						WHEN RIGHT(lowest_salary, 1) = 'k' THEN
							TRY_CONVERT(FLOAT, SUBSTRING(lowest_salary, 2, LEN(lowest_salary) - 2)) * 1000 * 54
						ELSE 
							TRY_CONVERT(FLOAT, SUBSTRING(lowest_salary, 2, LEN(lowest_salary) - 1)) * 54
					END
				WHEN SUBSTRING(lowest_salary, 1, 1) = 'S' THEN
					CASE 
						WHEN RIGHT(lowest_salary, 1) = 'k' THEN
							TRY_CONVERT(FLOAT, SUBSTRING(lowest_salary, 4, LEN(lowest_salary) - 4)) * 1000 * 41
						ELSE 
							TRY_CONVERT(FLOAT, SUBSTRING(lowest_salary, 4, LEN(lowest_salary) - 3)) * 41
					END
				WHEN SUBSTRING(lowest_salary, 1, 1) <> '$' OR SUBSTRING(lowest_salary, 1, 1) <> 'S' THEN
					CASE 
						WHEN RIGHT(lowest_salary, 1) = 'k' THEN
							TRY_CONVERT(FLOAT, SUBSTRING(lowest_salary, 2, LEN(lowest_salary) - 2)) * 1000
						ELSE 
							TRY_CONVERT(FLOAT, SUBSTRING(lowest_salary, 2, LEN(lowest_salary) - 1))
					END
				ELSE ''
			END AS converted_lowest_salary_php,
			CASE 
				WHEN SUBSTRING(lowest_salary, 1, 1) = '$' THEN
					CASE 
						WHEN RIGHT(highest_salary, 1) = 'k' THEN
							TRY_CONVERT(FLOAT, SUBSTRING(highest_salary, 1, LEN(highest_salary) - 1)) * 1000 * 54
						ELSE 
							TRY_CONVERT(FLOAT, highest_salary * 54)
					END
				WHEN SUBSTRING(lowest_salary, 1, 1) = 'S' THEN
					CASE 
						WHEN RIGHT(highest_salary, 1) = 'k' THEN
							TRY_CONVERT(FLOAT, SUBSTRING(highest_salary, 1, LEN(highest_salary) - 1)) * 1000 * 41
						ELSE 
							TRY_CONVERT(FLOAT, highest_salary * 41)
					END
				WHEN SUBSTRING(lowest_salary, 1, 1) <> '$' OR SUBSTRING(lowest_salary, 1, 1) <> 'S' THEN
					CASE 
						WHEN RIGHT(highest_salary, 1) = 'k' THEN
							TRY_CONVERT(FLOAT, SUBSTRING(highest_salary, 1, LEN(highest_salary) - 1)) * 1000
						ELSE 
							TRY_CONVERT(FLOAT, highest_salary)
					END
				ELSE ''
			END AS converted_highest_salary_php
		FROM TEMP
		--ORDER BY converted_lowest_salary_php DESC
	),
	TEMP3 AS (
		SELECT 
			monthly_salary, 
			converted_lowest_salary_php,
			converted_highest_salary_php,
			(converted_lowest_salary_php + converted_highest_salary_php)/2 AS ave_salary_range
		FROM TEMP2
		--ORDER BY ave_salary_range DESC
	)
	SELECT 
		DISTINCT ave_salary_range,
		COUNT(ave_salary_range) OVER(PARTITION BY ave_salary_range) AS ave_salary_range_count
	FROM TEMP3
	ORDER BY ave_salary_range DESC