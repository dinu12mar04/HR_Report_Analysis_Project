-- CREATE DATABASE
CREATE DATABASE project_hr_analysis;
USE project_hr_analysis;

-- Verify Your Data
SHOW TABLES;
SELECT COUNT(*) FROM HR_dataset;  -- Should be 22,214

-- Core KPIs
SELECT 
    COUNT(*) AS total_employees,
    ROUND(AVG(Age), 1) AS average_age,
    ROUND(SUM(location = 'Remote') * 100.0 / COUNT(*), 1) AS remote_percentage,
    ROUND(SUM(location = 'Headquarters') * 100.0 / COUNT(*), 1) AS hq_percentage
FROM HR_dataset;

-- Hiring Rate by Year
SELECT 
    YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y')) AS hire_year,
    COUNT(*) AS new_hires
FROM HR_dataset
WHERE hire_date IS NOT NULL
GROUP BY YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y'))
HAVING hire_year IS NOT NULL
ORDER BY hire_year;

--  Gender Distribution
SELECT 
    gender,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR_dataset), 1) AS percentage
FROM HR_dataset
GROUP BY gender
ORDER BY employee_count DESC;

-- Employees by State
SELECT 
    location_state,
    COUNT(*) AS employees
FROM HR_dataset
WHERE location_state IS NOT NULL
GROUP BY location_state
ORDER BY employees DESC;

-- Employees by Department 
SELECT 
    department,
    COUNT(*) AS employees
FROM HR_dataset
WHERE department IS NOT NULL
GROUP BY department
ORDER BY employees DESC;

-- Employees by Race
SELECT 
    race,
    COUNT(*) AS employees
FROM HR_dataset
WHERE race IS NOT NULL
GROUP BY race
ORDER BY employees DESC;

-- Active employees vs terminated

SELECT      
COUNT(*) AS total,          
COUNT(CASE WHEN termdate = '' THEN 1 END) AS active_members,     
COUNT(CASE WHEN termdate != '' AND termdate IS NOT NULL THEN 1 END) AS terminated_members 
FROM HR_dataset;

-- group by age of employees
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age < 35 THEN '25-34'
        WHEN Age < 45 THEN '35-44'
        WHEN Age < 55 THEN '45-54'
        ELSE '55+'
    END AS age_bucket,
    COUNT(*) AS employee_count
FROM HR_dataset
GROUP BY age_bucket
ORDER BY MIN(Age);

--  Age vs Location
SELECT 
    location,
    ROUND(AVG(Age), 1) AS avg_age,
    COUNT(*) AS employees
FROM HR_dataset
GROUP BY location;

-- Job Title Growth (Most Hired Recently)
SELECT 
    jobtitle,
    COUNT(CASE WHEN YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y')) >= 2018 THEN 1 END) AS recent_hires,
    COUNT(*) AS total_in_role
FROM HR_dataset
GROUP BY jobtitle
HAVING total_in_role > 50
ORDER BY recent_hires DESC
LIMIT 10;




