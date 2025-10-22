-- View for salaries: annual average per industry

CREATE OR REPLACE VIEW v_payroll_yearly AS
SELECT
	cp.payroll_year AS YEAR,
	cpib.code AS industry_code,
	cpib.name AS industry_name,
	cpvt.code AS value_type_code,
	cpvt.name AS value_type_name,
	cpc.code AS calculation_code,
	cpc.name AS calculation_name,
	cpu.code AS unit_code,
	cpu.name AS unit_name,
	AVG(cp.value) AS avg_wage
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib ON cpib.code = cp.industry_branch_code
JOIN czechia_payroll_unit cpu ON cpu.code = cp.unit_code
JOIN czechia_payroll_value_type cpvt ON cpvt.code = cp.value_type_code
JOIN czechia_payroll_calculation cpc ON cpc.code = cp.calculation_code
GROUP BY cp.payroll_year, cpib.code, cpib.name, cpvt.code, cpvt.name, cpc.code, cpc.name, cpu.code, cpu.name; 
