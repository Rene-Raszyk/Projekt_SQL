CREATE TABLE t_rene_raszyk_project_SQL_secondary_final (
	"year" INT,
	country TEXT,
	GDP NUMERIC,
	population NUMERIC,
	GINI NUMERIC	
);

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