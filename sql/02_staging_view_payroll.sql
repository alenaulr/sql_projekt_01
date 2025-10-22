-- Yearly average wage (CZK) by industry, using the correct metric code.
-- Intentionally ignore unit_code inconsistencies in raw data.

DROP VIEW IF EXISTS v_payroll_wage_yearly;
CREATE VIEW v_payroll_wage_yearly AS
SELECT
  p.payroll_year  AS year,
  ib.code         AS industry_code,
  ib.name         AS industry_name,
  AVG(p.value)    AS avg_wage_czk
FROM czechia_payroll p
JOIN czechia_payroll_industry_branch ib
  ON ib.code = p.industry_branch_code
WHERE p.value_type_code = 5958                    
GROUP BY 1,2,3;