# Descripcion General del Proyecto
Este proyecto tiene como objetivo analizar una base de datos de gran volumen sobre ofertas laborales en el mercado tecnológico, con un enfoque específico en puestos de Data Analyst, tanto en modalidad remota como presencial.

El análisis se centra en identificar qué trabajos y skills ofrecen los salarios más altos, cuáles son las tecnologías más demandadas y qué combinaciones de salario y demanda hacen que una skill sea óptima para el mercado actual. El objetivo final es extraer insights accionables que ayuden a orientar decisiones de carrera y formación dentro del rol de Data Analyst.

## Metodología y Herramientas

El proyecto se desarrolló en dos etapas principales:

### 1. SQL Analisis (PostgreSQL)
Se realizaron 5 queries principales en SQL, conectadas a una base de datos en PostgreSQL, cada una diseñada para responder una pregunta clave del mercado laboral:
- ¿Cuáles son los trabajos mejor pagos?
- ¿Cuáles son las skills mejor pagas?
- ¿Cuál es la demanda de skills en puestos de Data Analyst?
- ¿Qué skills están asociadas a los salarios más altos?
- ¿Cuáles son las skills más óptimas combinando salario y demanda?

Estas consultas incluyeron el uso de:
- Joins entre múltiples tablas
- Funciones de agregación
- CTEs
- Filtros por modalidad (remote vs onsite)
- Análisis salarial y de demanda

### 2. Python Analisis y Visualizacion
A partir de las tablas generadas en SQL, se realizó un análisis exploratorio y visual en Python, utilizando principalmente:
- Pandas para manipulación y análisis de datos
- Matplotlib y Seaborn para visualización
- Gráficos comparativos entre modalidad remota y presencial
- Scatter plots para identificar skills óptimas según salario y demanda
Los gráficos permiten visualizar de forma clara:
- Comparaciones entre trabajo remoto y presencial
- Skills con mejor relación salario–demanda
- Tecnologías clave dentro del ecosistema de Data Analytics

## Top 10 Trabajos Remunerados de Data Analista
En el siguiente grafico realizado con Pandas y Seaborn, visualizamos la primer query realizada en el proyecto,
que responde a la primer pregunta. 
Cuáles son las empresas en las que remunaran más a los Data Analistas? 
Que salario tienen?

### Codigo del Query
``` SQL
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
```

![Top Trabajos Remunerados](queries_python/images/top_pay_jobs.png)

En los top 50 puestos mejor pagos de Data Analyst, SQL aparece como la skill más frecuente,
lo que confirma que sigue siendo un requisito estructural incluso en roles de alto salario.
Python ocupa el segundo lugar, reforzando su rol como herramienta clave para análisis avanzado
y automatización. Herramientas de BI como Tableau y Power BI siguen siendo relevantes,
pero con menor presencia, lo que sugiere que en los salarios más altos se priorizan
habilidades técnicas y de manipulación de datos por sobre herramientas puramente visuales.

## Top Skills in High-Paying Data Analyst Roles

![images](skill_count_top_pay_job.png)

**Insight**  
En los puestos remotos de Data Analyst, SQL es claramente la skill más demandada,
con una diferencia significativa respecto al resto. Esto refuerza que, incluso en
roles remotos, la capacidad de consultar y transformar datos sigue siendo el núcleo
del trabajo. Excel y Python aparecen en un segundo escalón, indicando que el perfil
más buscado combina bases sólidas en SQL con habilidades de análisis y manipulación
de datos. Las herramientas de BI (Tableau y Power BI) tienen presencia, pero no son
el factor principal en la demanda para roles remotos.

![alt text](queries_python/images/skills_demand_remote_jobs.png)

**Insight**  
Skills mejor pagas en roles de Data & AI
- Los salarios más altos se concentran en skills que permiten escalar, automatizar y mantener sistemas en producción, no en herramientas aisladas o “de moda”.
- Las tecnologías mejor pagas aparecen cuando forman parte del core del stack: pipelines de datos, infraestructura, MLOps y sistemas distribuidos.
- El valor salarial no depende tanto del lenguaje en sí, sino de dónde se usa dentro del sistema (orquestación, procesamiento, despliegue, confiabilidad).

Trabajo remoto
En los roles remotos, los mejores salarios están asociados a skills portables y estandarizadas, que permiten impacto sin depender del contexto interno de la empresa:
- Procesamiento y análisis de datos a gran escala: PySpark, Databricks, Pandas, NumPy, Airflow
- Flujos de trabajo colaborativos y reproducibles: GitLab, Bitbucket, Jupyter
- Fundamentos de data engineering y cloud: GCP, PostgreSQL, Elasticsearch
Los puestos remotos premian la autonomía técnica y la capacidad de diseñar y mantener soluciones end-to-end con mínima supervisión.

Trabajo presencial (onsite)
En los roles presenciales, los salarios más altos están ligados a skills fuertemente integradas a la infraestructura interna y a sistemas críticos de la organización:
- Infraestructura y automatización: Terraform, Ansible, Puppet, VMware
- Machine Learning avanzado y frameworks productivos: TensorFlow, PyTorch, Keras, Hugging Face
- Sistemas empresariales y bases de datos especializadas: Cassandra, MongoDB, Aurora, SVN
El trabajo onsite tiende a valorar más la especialización profunda, la cercanía con equipos de infraestructura y la gestión de entornos complejos y legacy.

![alt text](queries_python/images/skills_based_salary_comparision.png)

## generar insights
optimal skills presencial

![alt text](queries_python/images/optimal_skills_onsite.png)

optimal skills remoto
![alt text](queries_python/images/optimal_skills_remote.png)

comparacion de las dos
![alt text](queries_python/images/skill_demand_salary_remote_onsite.png)