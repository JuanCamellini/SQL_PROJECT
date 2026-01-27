/* Cuales son las mejores skills basadas en el salario
Mirar el salario asociado por cada skill en Data Analyst posicion
Buscar roles con salarios especificos sin importar la ubicacion
Esto revela como impacta las distintas skills en los salarios para trabajos de data analista
y ayuda a encontrar la skill con mejores recompensas financieras para aprender.
*/

SELECT 
    ROUND(AVG(salary_year_avg),0) AS salary_avg,
    skills_dim.skills AS skill_name
FROM job_postings_fact as jpf
LEFT JOIN
    skills_job_dim ON skills_job_dim.job_id = jpf.job_id
LEFT JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY 
    salary_avg DESC
LIMIT 30;

-- Este codigo es para los trabajos remotos
SELECT 
    ROUND(AVG(salary_year_avg),0) AS salary_avg,
    skills_dim.skills AS skill_name
FROM job_postings_fact as jpf
LEFT JOIN
    skills_job_dim ON skills_job_dim.job_id = jpf.job_id
LEFT JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL AND
    jpf.job_work_from_home = True
GROUP BY
    skills_dim.skills
ORDER BY 
    salary_avg DESC
LIMIT 30;
