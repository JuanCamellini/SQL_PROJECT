/*
----------->   CASE   <------------
Crear una nueva columna llamada location_category donde:
- 'Anywhere' as remote
- 'New York, NY' as local
- otherwise 'onsite'
*/

SELECT 
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

/* PROBLEM 1
Categorizar los salarios por cada job posting high medium low:
solo data analistas rols.
*/

SELECT 
    job_title_short AS job_title,
    salary_year_avg AS salary,
    CASE
        WHEN salary_year_avg >= 120000 THEN 'High salary'
			WHEN salary_year_avg BETWEEN 80000 AND 119999 THEN 'Medium salary'
			WHEN salary_year_avg < 80000 THEN 'Low salary'
			ELSE 'Unknown'
	END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT Null
ORDER BY salary DESC;

/* PROBLEM 2
Sacar el % de cada categoria en total
*/
SELECT 
    COUNT(job_id) AS job_count,
    
    CASE
        WHEN salary_year_avg >= 120000 THEN 'High salary'
			WHEN salary_year_avg BETWEEN 80000 AND 119999 THEN 'Medium salary'
			WHEN salary_year_avg < 80000 THEN 'Low salary'
			ELSE 'Unknown'
	END AS salary_category
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL AND job_title_short = 'Data Analyst'
GROUP BY salary_category
ORDER BY salary_category DESC;