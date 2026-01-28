/*
-. Cuales son los mejores pagos trabajos de data analista?
- Identificar los 10 mejores pagos para analista de datos remotos.
- Trabajos con salario no nulo.
- Con los datos obtenidos podemos observar las oportunidades y requerimientos que ofrecen los trabajos de data analista
*/
WITH ranked_jobs AS (
    SELECT 
        job_title,
        ROUND(salary_year_avg / 12, 2) AS salary_month,
        job_posted_date::DATE AS job_posted_date,
        cd.name AS company_name,
        ROW_NUMBER() OVER (
            PARTITION BY job_title_short
            ORDER BY salary_year_avg DESC
        ) AS salary_rank
    FROM job_postings_fact  jpf
    LEFT JOIN company_dim  cd ON cd.company_id = jpf.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
)

SELECT *
FROM ranked_jobs
WHERE salary_rank <= 10
ORDER BY salary_month DESC;
