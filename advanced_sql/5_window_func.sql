/*
over() como window function usando una aggregation function, crea una columna nueva con valores en este caso segun la funcion de agregacion
*/

-- Este trozo de codigo muestra el salario maximo de cada empresa sin repetir
SELECT 
    MAX(salary_year_avg) AS max_salary,
    cd.name AS job_company
FROM
    job_postings_fact AS job_post
LEFT JOIN
    company_dim AS cd ON cd.company_id = job_post.company_id
WHERE
    job_post.salary_year_avg IS NOT NULL
GROUP BY
    job_company
ORDER BY 
    job_company 

-- este codigo con over muestra con partition si aparece repetidas veces la compañia con su maximo salario
SELECT DISTINCT
    MAX(salary_year_avg) OVER(PARTITION BY cd.name) AS max_salary, -- PARTITION BY lo particiona segun el parametro que queramos
    cd.name AS job_company -- Si no se coloca nada dentro de over arrojara en este caso el max_salary en todos
FROM
    job_postings_fact AS job_post
LEFT JOIN
    company_dim AS cd ON cd.company_id = job_post.company_id
WHERE
    job_post.salary_year_avg IS NOT NULL
GROUP BY
    job_company, salary_year_avg
ORDER BY 
    max_salary DESC
LIMIT 100
/*
ROW_NUMBER dice la cantidad de filas que hay, se utiliza con over y partition para contar por ej cuantos 
trabajos posteados hay por empresa
*/
SELECT
    *,
    MAX(number_jobs) OVER(PARTITION BY job_company) AS max_number_jobs -- Si no se coloca nada dentro de over arrojara en este caso el max_salary en todos
FROM(
    SELECT 
        ROW_NUMBER() OVER(PARTITION BY cd.name ORDER BY MAX(salary_year_avg)) AS number_jobs,
        cd.name AS job_company
        FROM
            job_postings_fact AS job_post
        LEFT JOIN
            company_dim AS cd ON cd.company_id = job_post.company_id
        GROUP BY job_company
    )
GROUP BY 
    job_company, number_jobs
ORDER BY
    max_number_jobs DESC
LIMIT 100   

-- Numeramos las empresas según su salario máximo
SELECT
    ROW_NUMBER() OVER (ORDER BY max_salary DESC) AS company_rank,
    job_company,
    max_salary
FROM (
    SELECT
        cd.name AS job_company,
        MAX(job_post.salary_year_avg) AS max_salary
    FROM
        job_postings_fact AS job_post
    LEFT JOIN
        company_dim AS cd ON cd.company_id = job_post.company_id
    WHERE
        job_post.salary_year_avg IS NOT NULL
    GROUP BY
        cd.name
) t
ORDER BY
    company_rank ASc;
-- Enumeramos empresas según la cantidad de posteos, su maximo salario y que sean de data analista
SELECT
    ROW_NUMBER() OVER (ORDER BY total_job_postings DESC) AS company_rank,
    job_company,
    total_job_postings,
    max_salary
FROM (
    SELECT
        cd.name AS job_company,
        COUNT(*) AS total_job_postings,
        MAX(jpf.salary_year_avg) AS max_salary
    FROM
        job_postings_fact AS jpf
    LEFT JOIN
        company_dim AS cd ON cd.company_id = jpf.company_id
    WHERE
        jpf.salary_year_avg IS NOT NULL 
        AND jpf.job_title_short = 'Data Analyst'
    GROUP BY
        cd.name
) t
ORDER BY
    company_rank
LIMIT 100;

-- Enumerar las 10 mejores skills pagas y en remoto por salario promedio, data analista
WITH ranked_skills AS (
    SELECT
        sd.skills AS skill,
        AVG(jpf.salary_year_avg) AS salary_average,
        ROW_NUMBER() OVER (
            ORDER BY AVG(jpf.salary_year_avg) DESC
        ) AS ranking_skill
    FROM job_postings_fact AS jpf
    LEFT JOIN
        skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
    LEFT JOIN
        skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE 
        jpf.salary_year_avg IS NOT NULL
        AND jpf.job_title_short = 'Data Analyst'
        AND jpf.job_location = 'Anywhere'
    GROUP BY 
        sd.skills
) -- este codigo se puede resolver sin usar ctes y subqueries, y sin usar 
SELECT
    *
FROM ranked_skills
WHERE
    ranking_skill <= 10
ORDER BY
    ranking_skill;