CREATE TABLE t_rene_raszyk_project_SQL_primary_final (
	"year" INT,
	industry_code TEXT,
	industry_name TEXT,
	payroll NUMERIC,
	product_code NUMERIC,
	product_name TEXT,
	product_price NUMERIC
);

CREATE TABLE t_rene_raszyk_project_SQL_secondary_final (
	"year" INT,
	country TEXT,
	GDP NUMERIC,
	population NUMERIC,
	GINI NUMERIC	
);


INSERT INTO t_rene_raszyk_project_SQL_primary_final (year, industry_code, industry_name, payroll)
	SELECT
		payroll_year AS "year",
		industry_branch_code AS industry_code,
		cpib."name" AS industry_name,
		ROUND(AVG("value")) AS payroll
	FROM czechia_payroll cp
	JOIN czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code 
	WHERE "value" != 0 AND value_type_code = 5958
	GROUP BY payroll_year, cpib."name", industry_branch_code;
INSERT INTO t_rene_raszyk_project_SQL_primary_final (YEAR, product_code, product_name, product_price)
	SELECT
		EXTRACT(YEAR FROM cp.date_from) AS YEAR,
		cp.category_code AS product_code,
		cpc."name" AS product_name,
		ROUND(AVG(cp.value)::NUMERIC,2) AS product_price
	FROM czechia_price cp
	JOIN czechia_price_category cpc ON cpc.code = cp.category_code
	GROUP BY EXTRACT(YEAR FROM cp.date_from), cpc."name", cp.category_code;


INSERT INTO t_rene_raszyk_project_SQL_secondary_final (country, year, GDP, population, GINI)
	SELECT 
	    e.country AS country,
	    e."year" AS "year",
	    e.gdp AS GDP,
	    e.population AS population,
	    e.gini AS GINI
	FROM economies e
	JOIN countries c ON c.country = e.country 
	WHERE continent ILIKE '%europe%';


-- 1. otázka
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
	

-- 2. otázka
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



-- 3. otázka
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


-- 4. otázka
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


-- 5. otázka
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







