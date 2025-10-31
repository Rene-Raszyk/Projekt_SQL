WITH tmp AS (
	SELECT product_name,
	       year,
	       product_price,
	       ROUND(((product_price - LAG(product_price) OVER (PARTITION BY product_name ORDER BY year)) 
	       		/ LAG(product_price) OVER (PARTITION BY product_name ORDER BY year)),2) AS inflation_rate
	FROM t_rene_raszyk_project_SQL_primary_final
	WHERE product_name IS NOT NULL
	ORDER BY product_name, "year"
)
SELECT
	product_name,
	ROUND(AVG(inflation_rate), 4	) AS percentage_increase
FROM tmp
GROUP BY tmp.product_name
ORDER BY percentage_increase;
