/*
-. Cuales son los mejores pagos trabajos de data analista?
- Identificar los 10 mejores pagos para analista de datos remotos.
- Trabajos con salario no nulo.
- Con los datos obtenidos podemos observar las oportunidades y requerimientos que ofrecen los trabajos de data analista
*/

SELECT 
    job_id,
    job_title_short,
    job_title,
    ROUND(salary_year_avg / 12, 2) AS salary_month,
    job_posted_date::DATE,
    company_dim.name
FROM
    job_postings_fact
LEFT JOIN
    company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL AND
    job_location = 'Anywhere'
ORDER BY 
    salary_y ear_avg DESC
LIMIT 10

