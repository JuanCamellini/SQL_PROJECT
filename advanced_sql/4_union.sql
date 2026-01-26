SELECT * 
FROM january_jobs;

UNION

SELECT *
FROM february_jobs;

UNION

SELECT * 
FROM march_jobs;

SELECT * FROM skills_dim;
SELECT * FROM skills_JOB_dim;
/* PRACTICTE PROBLEM 1
Obtener el correspondiente skill y tipo de skill por cada trabajo posteado en q1,
incluir los que no tienen skills tambien, por que? mira las skills y 
el tipo por cada trabajo en el primer cuarto que tenga salario mayor a 70mil 
*/
-- hacer un union all de los 3 jobs y filtrar el salario tmb
-- continuar con un left join del skill job dim, otro left join con skills dim
-- obtener skills y tipo de

WITH q1_jobs AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg > 70000 AS salary_70
    FROM january_jobs

    UNION ALL
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg > 70000 AS salary_70
    FROM february_jobs

    UNION ALL
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg > 70000 AS salary_70
    FROM march_jobs

)

SELECT 
    sd.skills AS skill_name,
    sd.type AS skill_type,
    CASE
        WHEN q1.salary_70 = true THEN TRUE
        ELSE False
    END AS salary_70
FROM q1_jobs AS q1
LEFT JOIN 
    skills_JOB_dim AS sjd ON sjd.job_id = q1.job_id
LEFT JOIN 
    skills_dim AS sd ON sd.skill_id = sjd.skill_id
ORDER BY salary_70 DESC
