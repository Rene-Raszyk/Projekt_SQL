SELECT
    p."year",
    pr.product_name,
    FLOOR(AVG(p.payroll)/pr.product_price) AS amount,
    CASE 
    		WHEN pr.product_code = 111301 THEN 'Kg'
    		ELSE 'L'
    END "Kilogram/Liter"
FROM t_rene_raszyk_project_sql_primary_final p
JOIN t_rene_raszyk_project_sql_primary_final pr ON p."year" = pr."year"
WHERE pr.product_code IN ('111301','114201')
	AND p."year" IN (2006, 2018)
GROUP BY p."year", pr.product_name, pr.product_price, pr.product_code 
ORDER BY pr.product_code, p."year";