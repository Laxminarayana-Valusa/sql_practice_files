# Subqueries

#So subqueries are queries within queries. Let's see how this looks.

SELECT *
FROM employee_demographics;

#Now let's say we wanted to look at employees who actually work in the Parks and Rec Department, we could join tables together or we could use a subquery
#We can do that like this:

SELECT *
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id
				FROM employee_salary
                WHERE dept_id = 1);
                
select* 
from employee_demographics
where employee_id in
	(
		select employee_id
			from employee_salary
			where salary > 30000 and gender = 'male' or gender = 'female'
							);
		
                
#So we are using that subquery in the where statement and if we just highlight the subwuery and run it it's basically a list we are selecting from in the outer query

SELECT *
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id
				FROM employee_salary
                WHERE employee_id > 3 and birth_date > '1950-12-01');
                
# now if we try to have more than 1 column in the subquery we get an error saying the operand should contain 1 column only 

#We can also use subqueries in the select and the from statements - let's see how we can do this

-- Let's say we want to look at the salaries and compare them to the average salary

SELECT occupation, employee_id
FROM employee_salary
order by occupation;

-- if we run this it's not going to work, we are using columns with an aggregate function so we need to use group by
-- if we do that though we don't exactly get what we want
SELECT first_name, salary, AVG(salary)
FROM employee_salary
GROUP BY first_name, salary;

-- it's giving us the average PER GROUP which we don't want
-- here's a good use for a subquery

SELECT first_name, 
salary, 
(SELECT AVG(salary) 
	FROM employee_salary)
FROM employee_salary;

select employee_id, first_name, salary,
	(select avg(salary)
		from employee_salary
        order by employee_id
		 )
from employee_salary;

-- We can also use it in the FROM Statement
-- when we use it here it's almost like we are creating a small table we are querying off of
SELECT *
FROM (SELECT gender, MIN(age), MAX(age), COUNT(age),AVG(age)
FROM employee_demographics
GROUP BY gender); 

SELECT *
FROM (SELECT gender, MIN(age), MAX(age), COUNT(age),AVG(age)
FROM employee_demographics
GROUP BY gender) as tab;
-- now this doesn't work because we get an error saying we have to name it

SELECT gender, AVG(Min_age)
FROM (SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender) AS Agg_Table
GROUP BY gender
;
SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics group by gender;


SELECT *
FROM (SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender
order by gender) AS Agg_Table
-- order by gender desc
;

SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender;


SELECT *
FROM (SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender) AS Agg_Table
order by Avg_age desc
;


SELECT *
FROM employee_salary
WHERE salary > (SELECT AVG(salary) avg_sal FROM employee_salary); -- Inner subquery runs first

select *
from employee_salary
where salary > (select avg(salary)-170000 avg_sal from employee_salary);

SELECT *,
       RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS salary_rank
FROM employee_salary
order by salary_rank;

select*,
	row_number() over(partition by dept_id order by salary desc) as salary_row_num,
	Rank() over(partition by dept_id order by salary desc) as salary_rank,
    dense_rank() over(partition by dept_id order by salary desc) as dense_salary_rank
from employee_salary
order by salary_rank;

select*,
	row_number() over(order by salary desc) as salary_row_num, salary,
	Rank() over(order by salary desc) as salary_rank, salary,
    dense_rank() over(order by salary desc) as dense_salary_rank
from employee_salary
order by salary_rank;

select*
from employee_demographics
 where employee_id in ( select employee_id from employee_salary where salary >20000);
 
 select*
from employee_demographics
 where employee_id in ( select employee_id from employee_salary where salary <50000);

