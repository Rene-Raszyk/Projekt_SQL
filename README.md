# Projekt SQL

## Úvod
Cílem projektu je analyzovat vztah mezi mzdami a cenami potravin v České republice v čase a porovnat je s ekonomickými ukazateli, jako je HDP.  
Dále je projekt rozšířen o sekundární tabulku s makroekonomickými daty evropských států, což umožňuje širší mezinárodní srovnání.  

Výsledkem projektu jsou:
- dvě výstupní tabulky (`t_rene_raszyk_project_SQL_primary_final` a `t_rene_raszyk_project_SQL_secondary_final`)
- sada SQL dotazů zodpovídajících výzkumné otázky

## Příprava tabulek a dat
V rámci projektu byly vytvořeny dvě hlavní tabulky:

### Primární tabulka  
**Název:** `t_rene_raszyk_project_SQL_primary_final`  
**Obsah:** Data o mzdách a cenách potravin v České republice.  

**Sloupce:**  
- `year` (rok)  
- `industry_code` (kód odvětví)  
- `industry_name` (název odvětví)  
- `payroll` (průměrná mzda)  
- `product_code` (kód produktu)  
- `product_name` (název produktu)  
- `product_price` (průměrná cena produktu)  

Data byla vložena z těchto zdrojových tabulek:  
- `czechia_payroll` – průměrná hrubá mzda na zaměstnance  
- `czechia_payroll_industry_branch` – slovník odvětví (kód ↔ název)  
- `czechia_price` – průměrné ceny potravin, agregované na roční bázi  
- `czechia_price_category` – slovník kategorií potravin (kód ↔ název)  

---

### Sekundární tabulka  
**Název:** `t_rene_raszyk_project_SQL_secondary_final`  
**Obsah:** Makroekonomická data evropských států.  

**Sloupce:**  
- `year` (rok)  
- `country` (stát)  
- `gdp` (HDP)  
- `population` (populace)  
- `gini` (GINI index)  

Data byla vložena z těchto zdrojových tabulek:  
- `economies` – obsahuje makroekonomická data států (HDP, populace, GINI)  
- `countries` – slovník států a jejich vlastností, použitý pro filtrování na evropské státy (`continent ILIKE '%Europe%'`)  



## Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
    Analýza meziročních rozdílů mezd ukazuje, že mzdy neklesají ve všech odvětvích, ale některá vykazují meziroční pokles. Například:

+------+--------------------------------------------------------+---------------+-----------------+
| Rok | Odvětví | Průměrná mzda | Meziroční rozdíl |
+------+--------------------------------------------------------+---------------+-----------------+
| 2009 | Zemědělství, lesnictví, rybářství | 17419 | -109 |
| 2021 | Zemědělství, lesnictví, rybářství | 27378 | -1082 |
| 2009 | Těžba a dobývání | 28161 | -1093 |
| 2013 | Těžba a dobývání | 31586 | -928 |
| 2014 | Těžba a dobývání | 31336 | -250 |
| 2016 | Těžba a dobývání | 31487 | -187 |
| 2013 | Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu | 40531 | -1851 |
+------+--------------------------------------------------------+---------------+-----------------+

**Závěr:**  
Mzdy nerostou rovnoměrně ve všech odvětvích – i když dlouhodobě průměrná mzda roste, některá odvětví v některých letech vykazují meziroční pokles.
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? 
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? 
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
