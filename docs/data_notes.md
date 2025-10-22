# Data Notes – sql_project_01 Food Accessibility

Last updated: 2025-10-22  
Author: Alena Ulrichova

## 1) Purpose
This document records data quality findings, assumptions, filters, and transformations so the analysis is reproducible and auditable.

## 2) Data Sources
- `czechia_payroll` + reference tables:
  - `czechia_payroll_industry_branch` (industry),
  - `czechia_payroll_unit` (units),
  - `czechia_payroll_value_type` (metrics),
  - `czechia_payroll_calculation` (calculation method).
- `czechia_price` + `czechia_price_category` (food prices).
- Additional: `economies`, `countries` (EU metrics: GDP, GINI, population).

## 3) Known Issues / Anomalies

### 3.1 Swapped units in `czechia_payroll`
While inspecting `value_type_code × unit_code` combinations, I observed:

- `value_type_code = 5958` = “Průměrná hrubá mzda na zaměstnance” (Average gross wage per employee)  
  appears in the raw data with `unit_code = 200` = “tis. osob (thousands of persons)” expected: CZK

- `value_type_code = 316` = “Průměrný počet zaměstnaných osob” (Average number of employed persons)  
  appears with `unit_code = 80403` = “Kč (CZK)” expected: thousands of persons

Interpretation: In this dataset dump, the unit codes for the two primary metrics appear swapped. The values themselves look plausible (wages in thousands/tens of thousands CZK; employment in thousands of persons), but the attached `unit_code` is inconsistent.

Decision: I did not modify raw data. Instead, I fixed the interpretation in staging viewa by deriving the unit logically from `value_type_code` (wages → CZK, employment → thousands of persons).

Diagnostic query (repro):
```sql
SELECT 
  vt.code AS vt_code, vt.name AS value_type,
  u.code  AS unit_code, u.name AS unit_name,
  COUNT(*) AS rows,
  MIN(p.value) AS min_v, MAX(p.value) AS max_v
FROM czechia_payroll p
JOIN czechia_payroll_value_type vt ON vt.code = p.value_type_code
JOIN czechia_payroll_unit       u  ON u.code  = p.unit_code
GROUP BY 1,2,3,4
ORDER BY 1,3;
