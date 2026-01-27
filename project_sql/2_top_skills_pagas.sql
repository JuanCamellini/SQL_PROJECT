/*
Cuales son los programas que mas pagan en trabajos de data analista?
- Usar los 50 trabajos mejores pagos del primer query
- Agregar las skills especificas de esos trabajos
- Con los datos obtenidos sabremos que skills se requieren para poder obtener un buen salario
*/
-- Usado posteriormente para analizar demanda de skill en los salarios mas altos
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        ROUND(salary_year_avg / 12, 2) AS salary_month,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    ORDER BY 
        salary_year_avg DESC
    LIMIT 50
) 

SELECT 
    top_paying_jobs.*,
    sd.skills
FROM top_paying_jobs 
INNER JOIN -- Usamos inner porque no nos interesa si hay skills nulas con un left
    skills_job_dim AS sjd ON sjd.job_id = top_paying_jobs.job_id
INNER JOIN
    skills_dim AS sd ON sd.skill_id = sjd.skill_id
ORDER BY 
    top_paying_jobs.salary_month DESC


