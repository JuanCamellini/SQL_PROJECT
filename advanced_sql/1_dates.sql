SELECT DISTINCT -- distinct para que no repita empresas
    cd.name as company
FROM job_postings_fact AS jpf
INNER JOIN --inner join ya que solo necesitamos las compañias que contengan health insurance
    company_dim AS cd ON jpf.company_id = cd.company_id --comparten estas keys
WHERE
    (EXTRACT(MONTH FROM job_posted_date) BETWEEN 4 AND 6) AND (jpf.job_health_insurance = True)
ORDER BY 
    company; 

