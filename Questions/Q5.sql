WITH tmp as(
    SELECT
        gdp.year,
        gdp.gdp,
        AVG(pf.payroll) AS payroll,
        AVG(pf.product_price) AS product_price
    FROM t_rene_raszyk_project_sql_secondary_final gdp
    JOIN t_rene_raszyk_project_sql_primary_final pf
        ON gdp.year = pf.year
    WHERE gdp.country = 'Czech Republic'
    GROUP BY gdp.year, gdp.gdp
)
SELECT
    year,
    gdp,
    ROUND((gdp - LAG(gdp) OVER (ORDER BY year))
    		/ LAG(gdp) OVER (ORDER BY year) * 100, 2) AS "gdp_growth_%",
    payroll,
    ROUND((payroll - LAG(payroll) OVER (ORDER BY year))
    		/ LAG(payroll) OVER (ORDER BY year) * 100, 2) AS "payroll_growth_%",
    product_price,
    ROUND((product_price - LAG(product_price) OVER (ORDER BY year))
    		/ LAG(product_price) OVER (ORDER BY year) * 100, 2) AS "product_growth_%"
FROM tmp
ORDER BY year;