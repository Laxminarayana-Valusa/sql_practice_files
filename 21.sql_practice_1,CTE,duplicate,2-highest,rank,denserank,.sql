USE school_db;
CREATE TABLE employee_salaries (
    record_id INT PRIMARY KEY,
    emp_id INT,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    updated_date DATE
);

INSERT INTO employee_salaries VALUES
-- Engineering (includes a duplicate row for Ananya and a salary tie)
(1, 101, 'Ananya', 'Engineering', 95000, '2026-01-10'),
(2, 101, 'Ananya', 'Engineering', 95000, '2026-03-15'),
(3, 102, 'Vikram', 'Engineering', 110000, '2026-02-01'),
(4, 103, 'Karthik', 'Engineering', 95000, '2026-02-10'),
(5, 104, 'Sneha', 'Engineering', 82000, '2026-01-20'),

-- Sales (includes a tie at the top)
(6, 201, 'Rahul', 'Sales', 78000, '2026-01-12'),
(7, 202, 'Priya', 'Sales', 78000, '2026-02-18'),
(8, 203, 'Arjun', 'Sales', 65000, '2026-03-01'),
(9, 204, 'Neha', 'Sales', 59000, '2026-01-25'),

-- HR (includes a duplicate row for Divya with a newer salary)
(10, 301, 'Divya', 'HR', 68000, '2026-01-05'),
(11, 301, 'Divya', 'HR', 72000, '2026-04-01'),
(12, 302, 'Manish', 'HR', 64000, '2026-02-14');

-- call employee_salaries
use school_db;
select*
from employee_salaries;

/* CTE (Common Table Expression) is a temporary table 
that you create using the WITH keyword just for one query. */

-- 1. Deduplicate Employees (Latest Record Only)
with cleanEmployees as (
	select*,
		row_number() over(partition by emp_id order by updated_date desc) as rn
	from employee_salaries
)

select*
from cleanEmployees
where rn = 1;
    

-- 2. 2nd Highest Salary Per Department
with cleanEmployees as (
	select*,
		row_number() over(partition by emp_id order by updated_date desc) rn
		from employee_salaries
),
rankedSalaries as (
	select*,
		dense_rank() over(partition by department order by salary desc) sal_rank
	from cleanEmployees
    where rn = 1
)
select department, emp_name, salary
from rankedSalaries
where sal_rank = 2;

-- 3. Why RANK vs. DENSE_RANK Matters in Sales
select
	emp_name,
    salary,
    rank() over(order by salary desc) as standard_rank,
    dense_rank() over(order by salary desc) as dense_rnk
from employee_salaries
where department = 'Sales';
	
-- 4. Company-Wide Top 3 Earners (With Ties)
with cleanEmployees as (
	select*,
		row_number() over(partition by emp_id order by updated_date desc) rn
	from employee_salaries
),
companyRank as (
	select*,
		dense_rank() over(order by salary desc) company_rank
	from cleanEmployees
    where rn = 1 
)
select*
from companyRank
where company_rank <= 3;

-- 5. Highest & Lowest Earner Flags Per Department
with cleanEmployees as (
	select*,
		row_number() over(partition by emp_id order by updated_date desc) rn
	from employee_salaries
),
dept_rank as (
select
	department,
    emp_name,
    salary,
	dense_rank() over(partition by department order by salary desc) dept_rank,
    case
		when row_number() over(partition by department order by salary desc, emp_id asc)=1 then 'highest' 
        when row_number() over(partition by department order by salary asc, emp_id asc)=1 then 'lowest'
        else 'Middle'
	end as salary_tier
from cleanEmployees
where rn = 1
)
select*
	from dept_rank
    where salary_tier = 'lowest' or salary_tier = 'highest'
    order by department, salary_tier;

