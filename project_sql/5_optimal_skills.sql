/*
Cuales son las skills mas optimas para aprender? (alta demanda y altos salarios)
- Identificar las skills con mas demanda y con los mejores salarios promedios para Data Analista rols
- Averiguar las posiciones remotas con salarios especificos.
*/

WITH skills_average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS salary_avg
    FROM job_postings_fact as jpf
    LEFT JOIN
        skills_job_dim ON skills_job_dim.job_id = jpf.job_id
    LEFT JOIN
        skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        jpf.job_title_short = 'Data Analyst' 
        AND jpf.salary_year_avg IS NOT NULL
        AND jpf.job_work_from_home = True 
    GROUP BY
        skills_job_dim.skill_id
), skills_demand AS ( -- Si hay muchos CTEs poner ',' y seguir con el nombre del siguiente
    SELECT 
        skills_dim.skill_id,
        skills AS skill_name,
        COUNT(skills_job.job_id) AS demand_count
    FROM job_postings_fact AS job_post
    INNER JOIN 
        skills_job_dim AS skills_job ON skills_job.job_id = job_post.job_id
    INNER JOIN 
        skills_dim ON skills_dim.skill_id = skills_job.skill_id
    WHERE 
        job_post.job_title_short = 'Data Analyst' 
        AND job_post.job_work_from_home = True 
        AND job_post.salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skill_name,
    demand_count,
    skills_average_salary.salary_avg
FROM 
    skills_demand
INNER JOIN
    skills_average_salary ON skills_demand.skill_id = skills_average_salary.skill_id
WHERE 
    demand_count > 10
ORDER BY 
   skills_average_salary.salary_avg DESC,   demand_count DESC
LIMIT 25

-- Codigo mas concistente
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS salary_avg
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
WHERE 
    job_postings_fact.job_title_short = 'Data Analyst' 
    AND job_postings_fact.job_work_from_home = True 
    AND job_postings_fact.salary_year_avg IS NOT NULL 
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY    
    salary_avg DESC,
    demand_count DESC
LIMIT 25;
-- Skills para trabajos Presencial
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS salary_avg
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN 
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id 
WHERE 
    job_postings_fact.job_title_short = 'Data Analyst' 
    AND job_postings_fact.salary_year_avg IS NOT NULL 
GROUP BY 
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY    
    salary_avg DESC,
    demand_count DESC
LIMIT 25;