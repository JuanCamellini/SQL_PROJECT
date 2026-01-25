/*
Queremos ver las compañias que no mencionan job_degree entonces lo podemos hacer con una subquery utilizando dentro del WHERE y IN
*/

SELECT
    company_id,
    name AS company_name
FROM
    company_dim
WHERE company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = true
    ORDER BY company_id
)

/*
        CTEs - Common Table Expression
*/
/* Encontrar las compañias que tengan la mayor  cantidad de trabajos abiertos
- conseguir el total de posteos por compañia id
- devolver el numero total de trabajos por el nombre de la compañia
*/

WITH company_job_count AS (
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY company_job_count.total_jobs DESC
-- tenemos que hacer un left join teniendo company_dim como izquierda ya que queremos ver todas las compañias, incluso las que no tengan 
-- job posteds
/*  */
/* PRACTICE PROBLEM 1
Identificar las 5 skills mas mencionadas de los posteos, usar subquery para encontrar los skills_id con la mayor cantidad de conteos
en la tabla skills_job_dim y unir el resultado con la tabla skills_dim para obtener los nombres
*/

-- se puede hacer con un left join
SELECT
    skills AS skill_name,
    COUNT(sjd.skill_id) AS skill_count
FROM 
    skills_dim
LEFT JOIN 
    skills_job_dim AS sjd ON sjd.skill_id = skills_dim.skill_id
GROUP BY 
    skill_name
ORDER BY
    skill_count DESC
LIMIT 5;
-- abajo esta la subquery de forma correcta
SELECT
    sd.skills AS skill_name,
    sj.skill_count
FROM skills_dim AS sd
JOIN (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
    LIMIT 5
) AS sj
ON sd.skill_id = sj.skill_id
ORDER BY sj.skill_count DESC;

/* PRACTICE PROBLEM 2
Determinar el tamaño de la categoria (small, medium, large) por cada compañy
por la cantidad de job posted, usar subquery para calcular el total por compañia
Small less than 10, medium less than 51. Implementar una subquery para
agregar job counts por compañia antes de clasificarlas
*/


SELECT 
    job_count,
    company_name,
    company_size
FROM (
    SELECT 
        CASE
            WHEN COUNT(jpf.company_id) < 10 THEN 'Small'
            WHEN COUNT(jpf.company_id) BETWEEN 10 AND 50 THEN 'Medium'
            WHEN COUNT(jpf.company_id) > 50 THEN 'Large'
            ELSE 'Unknown'
        END AS company_size,
        COUNT(*) AS job_count,
        cd.name AS company_name
    FROM 
        job_postings_fact AS jpf
    JOIN
        company_dim AS cd ON cd.company_id = jpf.company_id
    GROUP BY company_name, cd.company_id
    ORDER BY job_count DESC
)

/* 
Encontrar la cantidad de trabajos remotos por skill
    - Mostrar las 5 skills mas deseadas en trabajos remotos
    - incluir skill id, y la cantidad de posteos por la skill
 */
WITH job_remote_id AS (
SELECT
    CASE 
        WHEN job_work_from_home = true THEN job_id
        ELSE Null
    END AS job_remote
FROM job_postings_fact
)

SELECT
    skills AS skill_name,
    COUNT(sd.skill_id) AS skill_count,
    sd.skill_id
FROM skills_dim AS sd
JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
JOIN job_remote_id AS jri ON jri.job_remote = sjd.job_id
GROUP BY sd.skills, sd.skill_id
ORDER BY skill_count DESC
LIMIT 5;


SELECT * FROM job_postings_fact LIMIT 30

