CREATE TABLE t_rene_raszyk_project_SQL_primary_final (
	"year" INT,
	industry_code TEXT,
	industry_name TEXT,
	payroll NUMERIC,
	product_code NUMERIC,
	product_name TEXT,
	product_price NUMERIC
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