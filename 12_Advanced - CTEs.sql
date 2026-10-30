-- Using Common Table Expressions (CTE)
-- A CTE allows you to define a subquery block that can be referenced within the main query. 
-- It is particularly useful for recursive queries or queries that require referencing a higher level
-- this is something we will look at in the next lesson/

-- Let's take a look at the basics of writing a CTE:


-- First, CTEs start using a "With" Keyword. Now we get to name this CTE anything we want
-- Then we say as and within the parenthesis we build our subquery/table we want
WITH CTE_Example AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary), AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- directly after using it we can query the CTE
SELECT *
FROM CTE_Example;

-- Now if I come down here, it won't work because it's not using the same syntax
SELECT *
FROM CTE_Example;


-- Now we can use the columns within this CTE to do calculations on this data that
-- we couldn't have done without it.

WITH CTE_Example AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- notice here I have to use back ticks to specify the table names  - without them it doesn't work
SELECT gender, ROUND(AVG(`SUM(salary)`/`COUNT(salary)`),2)
FROM CTE_Example
GROUP BY gender;



-- we also have the ability to create multiple CTEs with just one With Expression

WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
), -- just have to separate by using a comma
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
)

-- Now if we change this a bit, we can join these two CTEs together
SELECT *
FROM CTE_Example cte1
LEFT JOIN CTE_Example2 cte2
	ON cte1. employee_id = cte2. employee_id;





WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date, birth_date>'1985-01-01'
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
), -- just have to separate by using a comma
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
)

-- Now if we change this a bit, we can join these two CTEs together
SELECT *
FROM CTE_Example cte1
LEFT JOIN CTE_Example2 cte2
	ON cte1. employee_id = cte2. employee_id;


-- the last thing I wanted to show you is that we can actually make our life easier by renaming the columns in the CTE
-- let's take our very first CTE we made. We had to use tick marks because of the column names

-- we can rename them like this
WITH CTE_Example (gender, sum_salary, min_salary, max_salary, count_salary) AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- notice here I have to use back ticks to specify the table names  - without them it doesn't work
SELECT gender, ROUND(AVG(sum_salary/count_salary),2)
FROM CTE_Example
GROUP BY gender;

-- Create table
create table departments (
	dept_id int primary key,
    dept_name varchar(50),
    budget int
);

create table employees (
	emp_id int primary key,
    name varchar(50),
    dept_id int,
    salary int,
    hire_date DATE
);

-- insert data
insert into departments values
(1, 'HR', 150000),
(2, 'Engineering', 50000),
(3, 'Marketing', 250000),
(4, 'Sales', 300000);

insert into employees values
(101, 'Alice', 2, 120000, '2021-03-15'),
(102, 'Bob', 2, 95000, '2022-06-01'),
(103, 'Charlie', 3, 70000, '2023-01-10'),
(104, 'David', 4, 85000, '2020-11-22'),
(105, 'Eva', 1, 65000, '2024-02-18'),
(106, 'Frank', 2, 110000, '2023-08-12'),
(107, 'Grace', 3, 90000, '2021-07-19');



WITH DeptSalaryTotal AS (
    SELECT dept_id, SUM(salary) AS total_salary_spend
    FROM employees c
    GROUP BY dept_id
)
SELECT 
    d.dept_name,
    d.budget,
    c.total_salary_spend,
    (c.total_salary_spend / d.budget) * 100 AS budget_utilization_pct
FROM departments d
JOIN DeptSalaryTotal c ON d.dept_id = c.dept_id 
WHERE (c.total_salary_spend / d.budget) * 100 > 30;
