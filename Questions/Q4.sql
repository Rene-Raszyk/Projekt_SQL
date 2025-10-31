WITH product AS (
	SELECT 
		product_name,
       	year,
       	product_price,
       	ROUND(((product_price - LAG(product_price) OVER (PARTITION BY product_name ORDER BY year)) 
       		/ LAG(product_price) OVER (PARTITION BY product_name ORDER BY year)) * 100) AS inflation_rate
	FROM t_rene_raszyk_project_SQL_primary_final
	WHERE 1=1
		AND product_name IS NOT NULL
),
payroll AS (
   SELECT 
        industry_name,
        year,
        ROUND(((payroll - LAG(payroll) OVER (PARTITION BY industry_name ORDER BY year)) 
              / LAG(payroll) OVER (PARTITION BY industry_name ORDER BY year)) * 100, 2) AS payroll_growth_rate
    FROM t_rene_raszyk_project_sql_primary_final
    WHERE industry_name IS NOT NULL
)
SELECT
	product.YEAR,
	product_name,
	product_price,
	product.inflation_rate,
    payroll.industry_name,
    payroll.payroll_growth_rate,
    (product.inflation_rate - payroll.payroll_growth_rate) AS difference
FROM product
JOIN payroll ON product.year = payroll.YEAR
WHERE 1=1
	AND inflation_rate IS NOT NULL
	AND (product.inflation_rate - payroll.payroll_growth_rate) > 10
ORDER BY difference DESC;