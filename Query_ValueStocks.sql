WITH cte AS(
SELECT company,
fiscal_year/10000 as year
FROM dividend
), cte2 AS(
SELECT company,
(CASE
	WHEN LEAD(year, 1) OVER (PARTITION BY company ORDER BY year) = year + 1
	AND LEAD(year, 2) OVER (PARTITION BY company ORDER BY year) = year + 2
	THEN 'YES'
	WHEN LAG(year, 1) OVER (PARTITION BY company ORDER BY year) = year - 1
	AND LAG(year, 2) OVER (PARTITION BY company ORDER BY year) = year - 2
	THEN 'YES'
	WHEN LAG(year, 1) OVER (PARTITION BY company ORDER BY year) = year - 1
	AND LEAD(year, 1) OVER (PARTITION BY company ORDER BY year) = year + 1
	THEN 'YES'
	ELSE NULL
END) AS "value"
FROM cte
)
SELECT array_agg (DISTINCT company || ' ' || '' ) as value_stocks
FROM cte2
WHERE
	value = 'YES';