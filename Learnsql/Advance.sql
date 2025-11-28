SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM 
    job_postings_fact;

-----------------------------------------------

-- SELECT
--     COUNT (job_id) AS job_posted_count,
--     EXTRACT (MONTH FROM job_posted_date) AS month
-- FROM
--     job_postings_fact
-- WHERE
--     job_title_short = 'Data Analyst'
-- GROUP BY
--     month
-- ORDER BY
--     job_posted_count DESC;

-----------------------------------------------



-- SELECT 
--     AVG(salary_year_avg) AS avg_yearly_salary,
--     AVG(salary_hour_avg) AS avg_hourly_salary,
--     EXTRACT (MONTH FROM job_posted_date) AS month,
--     EXTRACT (YEAR FROM job_posted_date) AS year
-- FROM job_postings_fact
-- GROUP BY 
--     job_schedule_type,
--     EXTRACT(MONTH FROM job_posted_date),
--     EXTRACT(YEAR FROM job_posted_date);

    --------------------------------------------------------------------

    -- SELECT 
    --     job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York',
    --     EXTRACT (MONTH FROM job_posted_date) AS month,
    --     COUNT(job_posted_date) AS total_jobs
    -- FROM
    --     job_postings_fact
    -- GROUP BY
    --     EXTRACT (MONTH FROM job_posted_date),
    --     job_posted_date
    -- ORDER BY
    --     month;

-- SELECT 
--     EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS year,
--     EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
--     COUNT(*) AS total_jobs
-- FROM
--     job_postings_fact
-- GROUP BY
--     year, month
-- ORDER BY
--     year, month;

-- SELECT 
--     EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS year,
--     EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
--     EXTRACT(DAY FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS day,
--     COUNT(*) AS job_posted
-- FROM
--     job_postings_fact
-- WHERE 
--     EXTRACT(YEAR FROM job_posted_date) = 2024 AND
--     EXTRACT(Month FROM job_posted_date) = 3
-- GROUP BY
--     year,month,day
-- ORDER BY
--      day;





SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'New York'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;



SELECT 
    job_title AS job,
    CASE
        WHEN salary_year_avg > 150000 THEN 'High'
        WHEN salary_year_avg BETWEEN 100000 AND 150000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_category,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC;






SELECT 
    COUNT(*) AS total_jobs,
    company_dim.name AS company_name,
    CASE
        WHEN salary_year_avg > 150000 THEN 'Premium'
        WHEN salary_year_avg  BETWEEN 90000 AND 150000 THEN 'Good'
        ELSE 'Low Salary'
    END AS salary_category
FROM    
    job_postings_fact
LEFT JOIN company_dim
ON 
    job_postings_fact.company_id = company_dim.company_id    
GROUP BY
    company_name,
    salary_category
HAVING
    COUNT(*) >= 5 
ORDER BY 
    company_name DESC;




SELECT
    job_title_short,
    avg_salary
FROM (
    SELECT
        job_title_short,
        AVG(salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
    GROUP BY
        job_title_short
) AS avg_table
WHERE
avg_salary > 120000;





WITH avg_salary AS (
    SELECT
        job_title_short,
        job_location,
        AVG(salary_year_avg) as global_avg_salary   
    FROM
       job_postings_fact
    GROUP BY
        job_title_short,
        job_location       
)
SELECT *
FROM
    avg_salary,
    job_postings_fact
WHERE
    salary_year_avg > global_avg_salary AND
         job_work_from_home = TRUE
ORDER BY 
    salary_year_avg DESC;


WITH avg_salary_cte AS (
    SELECT 
        AVG(salary_year_avg) AS global_avg_salary
    FROM 
        public.job_postings_fact
)
SELECT 
    j.job_title_short,
    j.job_location,
    j.salary_year_avg
FROM 
    public.job_postings_fact AS j,
    avg_salary_cte AS a
WHERE 
    j.job_work_from_home = TRUE
    AND j.salary_year_avg > a.global_avg_salary
ORDER BY 
    j.salary_year_avg DESC;

SELECT


