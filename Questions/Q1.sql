WITH tmp AS (
	SELECT 
		"year",
		industry_name,
		payroll,
	    payroll - LAG(payroll) OVER (PARTITION BY industry_code ORDER BY year) AS differences
	FROM t_rene_raszyk_project_SQL_primary_final
	WHERE 1=1
		AND industry_name IS NOT NULL
	ORDER BY industry_code, "year"
)
SELECT *
FROM tmp
WHERE 1=1
	AND industry_name IS NOT NULL;
	--AND differences < 0;