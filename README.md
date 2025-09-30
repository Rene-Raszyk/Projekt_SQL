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

    - Pokud ve sloupci `differences` není hodnota, znamená to, že pro daný rok nemáme předchozí rok k porovnání (data začínají rokem 2000).
    - Pokud je hodnota v `differences` záporná, mzdy klesly oproti předchozímu roku.
    - Pokud je hodnota v `differences` kladná, mzdy vzrostly.
    ```bash
    +------+------------------------------------------+-----------+-------------+
    | year | industry_name                            | payroll   | differences |
    +------+------------------------------------------+-----------+-------------+
    | 2019 | Kulturní, zábavní a rekreační činnosti   | 30242     | 2662        |
    | 2020 | Kulturní, zábavní a rekreační činnosti   | 30611     | 369         |
    | 2021 | Kulturní, zábavní a rekreační činnosti   | 29685     | -926        |
    | 2000 | Ostatní činnosti                         | 10557     |             |
    | 2001 | Ostatní činnosti                         | 11501     | 944         |
    | 2002 | Ostatní činnosti                         | 12592     | 1091        |
    | 2003 | Ostatní činnosti                         | 13508     | 916         |
    +------+------------------------------------------+-----------+-------------+
    ```
    **Závěr:**  
    Mzdy nerostou rovnoměrně ve všech odvětvích – i když dlouhodobě průměrná mzda roste, některá odvětví v některých letech vykazují meziroční pokles.

2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

    Analýza ukazuje, kolik litrů mléka a kilogramů chleba bylo možné koupit za průměrnou mzdu v prvním a posledním srovnatelném období dostupných dat:
    ```bash
    +------+------------------------------+--------+----------------+ 
    | year | product_name                 | amount | Kilogram/Liter |
    +------+------------------------------+--------+----------------+ 
    | 2006 | Chléb konzumní kmínový       | 1287   | Kg             | 
    | 2018 | Chléb konzumní kmínový       | 1342   | Kg             | 
    | 2006 | Mléko polotučné pasterované  | 1437   | L              | 
    | 2018 | Mléko polotučné pasterované  | 1641   | L              |
    +------+------------------------------+--------+----------------+ 
    ```
    **Závěr:**  
    Počet kilogramů chleba a litrů mléka, který si bylo možné koupit z průměrné mzdy, mezi roky 2006 a 2018 vzrostl. To naznačuje, že růst mezd převyšoval růst cen těchto základních potravin, což pozitivně ovlivnilo kupní sílu obyvatel.

3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

    Analýza meziročních nárůstů cen ukazuje, že některé kategorie potravin zdražují výrazně pomaleji než jiné. Nejnižší průměrný meziroční nárůst cen mají:
    ```bash
    +------------------------------------+---------------------+
    | product_name                       | percentage_increase |
    +------------------------------------+---------------------+
    | Cukr krystalový                    | -0.0192             |
    | Rajská jablka červená kulatá       | -0.0067             |
    | Přírodní minerální voda uhličitá   |  0.0083             |
    | Banány žluté                       |  0.0083             |
    +------------------------------------+---------------------+
    ```
    **Závěr:** 
    Podle výsledků je kategorií s nejnižším meziročním nárůstem cen Cukr krystalový, který má průměrný meziroční nárůst -0,0192 %.

4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
