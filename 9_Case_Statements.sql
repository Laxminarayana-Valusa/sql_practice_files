-- Case Statements

-- A Case Statement allows you to add logic to your Select Statement, 
-- sort of like an if else statement in other programming languages or even things like Excel



SELECT * 
FROM employee_demographics;


SELECT first_name, 
last_name, age, 
CASE
	WHEN age <= 30 THEN 'Young'
END young_people
FROM employee_demographics;



select employee_id, first_name, last_name, age,
case
	when age<30 then 'young'
end 
from employee_demographics;


--

SELECT first_name, 
last_name, 
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END age_status
FROM employee_demographics;


select employee_id, first_name, last_name, age,
case
	when age<=10 then 'child'
    when age between 11 and 20 then 'adult'
    when age between 21 and 30 then 'young'
    when age between 31 and 40 then 'about to old'
    when age >40 then 'old'
end as 'age_status'
from employee_demographics;


-- Poor Jerry

-- Now we don't just have to do simple labels like we did, we can also perform calculations

-- Let's look at giving bonuses to employees

SELECT * 
FROM employee_salary;


-- Pawnee Council sent out a memo of their bonus and pay increase structure so we need to follow it
-- Basically if they make less than 45k then they get a 5% raise - very generous
-- if they make more than 45k they get a 7% raise
-- they get a bonus of 10% if they work for the Finance Department

SELECT employee_id, first_name, last_name, salary, 
case
   when salary > 45000 then '5% increment'
   when salary < 45000 then '7% increment'
end as 'increment status of an employee',
CASE
	WHEN salary > 45000 THEN salary + (salary * 0.05)
    WHEN salary < 45000 THEN salary + (salary * 0.07)
END AS new_salary
FROM employee_salary
order by salary;

select salary, avg(salary)
from (
	SELECT employee_id, first_name, last_name, salary,
	case
	   when salary > 45000 then '5% increment'
	   when salary < 45000 then '7% increment'
	end as 'increment status of an employee',
	CASE
		WHEN salary > 45000 THEN salary + (salary * 0.05)
		WHEN salary < 45000 THEN salary + (salary * 0.07)
	END AS new_salary
	FROM employee_salary
	order by salary
		) new_table1
group by salary;

-- Unfortunately Pawnee Council was extremely specific in their wording and Jerry was not included in the pay increases. Maybe Next Year.

-- Now we need to also account for Bonuses, let's make a new column
SELECT employee_id, last_name, salary,
CASE
	WHEN salary > 45000 THEN salary + (salary * 0.05)
    WHEN salary < 45000 THEN salary + (salary * 0.07)
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus,
dept_id, occupation,
case
	when occupation = 'Director of Parks and Recreation' then 'Director'
    when occupation = 'Entrepreneur' then 'owner'
    when occupation = 'Assistant to the Director of Parks and Recreation' then  'Assistant'
    when occupation = 'Office Manager' then 'official'
    when occupation = 'Nurse' then 'patience'
    when occupation = 'City Manager' then 'City level post'
    when occupation = 'State Auditor' then 'Auditor'
    else 'Others'
end as occupation_status
FROM employee_salary;

-- as you can see Ben is the only one who get's a bonus
