# Projekt SQL – Analýza mezd, cen potravin a HDP

## Úvod
Cílem projektu je analyzovat vztah mezi mzdami a cenami potravin v České republice v čase a porovnat je s ekonomickými ukazateli, jako je HDP.  
Dále je projekt rozšířen o sekundární tabulku s makroekonomickými daty evropských států, což umožňuje širší mezinárodní srovnání.  

Výsledkem projektu jsou:
- dvě výstupní tabulky (`t_rene_raszyk_project_SQL_primary_final` a `t_rene_raszyk_project_SQL_secondary_final`)
- sada SQL dotazů zodpovídajících výzkumné otázky

## Výzkumné otázky
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? 
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? 
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? 
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
