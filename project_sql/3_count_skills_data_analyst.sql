/*
Cuales son las skills mas demandadas en trabajos de data analista=?
- Identificar las 6 skills mas demandadas
- Con la informacion sabremos cuales son las skills mas demandas para trabajos de data analista
*/

SELECT 
    skills AS skill_name,
    COUNT(skills_job.job_id) AS demand_count
FROM job_postings_fact AS job_post
INNER JOIN skills_job_dim AS skills_job ON skills_job.job_id = job_post.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job.skill_id
WHERE 
    job_post.job_title_short = 'Data Analyst' AND job_post.job_work_from_home = True
GROUP BY skill_name
ORDER BY 
    demand_count DESC
LIMIT 6;