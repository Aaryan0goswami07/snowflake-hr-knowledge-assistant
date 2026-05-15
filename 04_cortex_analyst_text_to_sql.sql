-- ============================================================
-- CORTEX ANALYST — Text-to-SQL on structured employee data
-- This is the "talk to structured data" part of Course 3
-- ============================================================

USE DATABASE HR_ASSISTANT_DB;
USE WAREHOUSE RAG_WH;
USE SCHEMA RAW;

-- STEP 1: Create a semantic model YAML
-- This tells Cortex Analyst what your tables mean in plain English
-- In production this goes in a Snowflake Stage as a .yaml file
-- Here we demonstrate the concept with direct SQL queries
-- that Cortex Analyst would auto-generate from natural language

-- These are the queries Cortex Analyst generates when you ask:
-- "Who are the top earners in Engineering?"
SELECT
    name,
    role,
    salary,
    performance
FROM employees
WHERE department = 'Engineering'
ORDER BY salary DESC
LIMIT 5;

-- "How many leave days has each department taken this year?"
SELECT
    e.department,
    COUNT(l.leave_id)       AS total_leave_requests,
    SUM(l.days_taken)       AS total_days_taken,
    ROUND(AVG(l.days_taken), 1) AS avg_days_per_request
FROM leave_records l
JOIN employees e ON l.employee_id = e.employee_id
WHERE l.approved = TRUE
GROUP BY e.department
ORDER BY total_days_taken DESC;

-- "Show me all excellent performers and their salaries"
SELECT
    name,
    department,
    role,
    salary,
    city,
    DATEDIFF('year', join_date, CURRENT_DATE()) AS years_at_company
FROM employees
WHERE performance = 'Excellent'
ORDER BY salary DESC;

-- "Which employees took the most sick leave?"
SELECT
    e.name,
    e.department,
    SUM(l.days_taken) AS total_sick_days
FROM leave_records l
JOIN employees e ON l.employee_id = e.employee_id
WHERE l.leave_type = 'Sick'
GROUP BY e.name, e.department
ORDER BY total_sick_days DESC;

-- "What is the average salary by department?"
SELECT
    department,
    COUNT(*)                    AS headcount,
    ROUND(AVG(salary), 0)       AS avg_salary,
    MIN(salary)                 AS min_salary,
    MAX(salary)                 AS max_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

