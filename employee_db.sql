SELECT avg(s.salary), e.gender
FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no
group by e.gender;

select avg(salary) from salaries;

select distinct(t.title), avg(s.salary) as AVG_SALARY
from salaries s
join titles t ON s.emp_no = t.emp_no
group by title
order by AVG_SALARY;

select e.first_name, e.last_name,  dm.from_date, dm.to_date, t.title
from employees e
join dept_manager dm on dm.emp_no = e.emp_no
join titles t on t.emp_no = e.emp_no
where dm.from_date < "1990-01-01" and dm.from_date > "1988-01-01";

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE employees
ADD COLUMN full_name VARCHAR(255);

UPDATE employees
SET full_name = CONCAT(first_name, ' ', last_name);

SET SQL_SAFE_UPDATES = 1;

select * from employees;

select * from employees 
where birth_date > "1960-01-01" and hire_date > "1980-01-01" and first_name like "D___";



SELECT s.salary, e.first_name,
CASE
	WHEN salary > 100000 THEN salary + (salary * .10) 
    WHEN salary BETWEEN 55000 AND 80000 THEN salary + (salary * .07)
    ELSE salary + (salary * .05)
END AS Salary_Bonus
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no
LIMIT 300;


SELECT title, COUNT(title) AS title_number
FROM titles
GROUP BY title
HAVING COUNT(title) > 2;


DELIMITER $$
CREATE procedure count_salary()
BEGIN
	SELECT avg(s.salary), e.gender
	FROM salaries s
	JOIN employees e ON s.emp_no = e.emp_no
	group by e.gender;
END $$
DELIMITER ;

CALL employees.count_salary();

SELECT COUNT(*) FROM salaries
WHERE salary >= 140000;

SELECT COUNT(DISTINCT dept_no)
FROM dept_emp;

SELECT dept_no,
IFNULL(dept_name, 'Department name not provided') as dept_name
FROM departments;


SELECT dept_no, dept_name,
COALESCE(dept_no, dept_name, 'N/A') AS dept_info
FROM departments
ORDER BY dept_no ASC;

SELECT 
IFNULL(dept_no, 'N/A') as dept_no,
IFNULL(dept_name, 'DEPARTMENT NAME NOT PROVIDED') AS dept_name,
COALESCE(dept_no, dept_name) AS dept_info
FROM departments
ORDER BY dept_no ASC;


SELECT e.emp_no, e.full_name, s.salary 
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 145000;


SELECT d.dept_name, AVG(s.salary) AS average_salary
FROM departments d
JOIN dept_manager dm ON dm.dept_no = d.dept_no
JOIN salaries s ON s.emp_no = dm.emp_no
GROUP BY d.dept_name
HAVING average_salary > 0
ORDER BY AVG(salary) DESC;

SELECT * FROM employees e
WHERE EXISTS (SELECT * FROM titles t
WHERE t.emp_no = e.emp_no AND title = 'Assistant Engineer');

CREATE OR REPLACE VIEW v_manager_AVG_salary AS
SELECT ROUND(AVG(salary), 2)
FROM salaries s
JOIN dept_manager m ON s.emp_no = m.emp_no;

SELECT * FROM v_manager_AVG_salary;

DELIMITER $$
CREATE PROCEDURE emp_avg_salary_out (IN p_emp_no INTEGER, OUT p_avg_salary DECIMAL(10,2))
BEGIN
	SELECT AVG(s.salary) INTO p_avg_salary
FROM
	employees e
		JOIN 
	salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
END $$
DELIMITER ;

SET @v_avg_salary = 100000;
CALL employees.emp_avg_salary_out(11200, @v_avg_salary);
SELECT @v_avg_salary;

DELIMITER $$
CREATE FUNCTION f_emp_avg_salary (p_emp_no INTEGER) RETURNS DECIMAL(10,2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
DECLARE v_avg_salary DECIMAL(10,2);
SELECT AVG(s.salary) INTO v_avg_salary
FROM
	employees e
		JOIN 
	salaries s ON e.emp_no = s.emp_no
WHERE e.emp_no = p_emp_no;
RETURN v_avg_salary;
END$$
DELIMITER ;

SELECT f_emp_avg_salary(11200);CALL emp_avg_salary(11300)
;



select avg(s.salary), e.gender from salaries s
join employees e on e.emp_no = s.emp_no
group by e.gender;




select * from employees
where first_name is NULL;


select * from employees
where hire_date ;



select count(gender), gender from employees 
group by gender;


select distinct t.title, avg(s.salary) from titles t
join salaries s on t.emp_no = s.emp_no
group by title;




select * from departments;

CREATE TABLE departments_dup AS SELECT * FROM departments;

select * from departments_dup;
UPDATE departments_dup set dept_no = NULL where dept_name = 'Development';

select dept_no, ifnull(dept_name, 'Dept_name not provided') as name 
from departments;
select * from dept_manager;

select emp_no, dept_no,
coalesce(from_date, to_date, 'N/A') as dept_manager 
from dept_manager;


SELECT dept_no, dept_name,
COALESCE(dept_no, dept_name, 'fuck') AS dept_info
FROM departments_dup
ORDER BY dept_no ASC;


SELECT
    IFNULL(dept_no, 'N/A') as dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM departments_dup
ORDER BY dept_no ASC;


select * from departments;
select * from dept_manager;


select dm.*, d.*
from departments d 
cross join dept_manager dm
where d.dept_no = 'd009'
order by d.dept_no;

select e.*, d.* from 
employees e cross join departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;


select * from departments;
select * from dept_manager;

SELECT * FROM dept_manager
WHERE emp_no IN (SELECT emp_no FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');
 

SELECT * FROM dept_manager
WHERE exists (SELECT emp_no FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');
 
 select * from employees e
 where exists
 (select * from titles t where t.emp_no = e.emp_no
 and title = 'Assistant Engineer');
 
 
 CREATE OR REPLACE VIEW v_manager_avg_salary AS
 select round(avg(salary), 2) from salaries s
 join dept_manager dm on dm.emp_no=s.emp_no;
 
 SELECT * FROM v_manager_avg_salary;
 
drop procedure if exists select_employees;

DELIMITER $$
create procedure select_employees()
Begin
	select * from employees
    where first_name like 'R%';
end $$

DELIMITER ;


call employees.select_employees();



drop procedure if exists avg_salary;

DELIMITER $$
create procedure avg_salary()
BEGIN
	SELECT first_name, last_name
	FROM employees ;
END $$

DELIMITER ;

call avg_salary();
call employees.avg_salary();


DELIMITER $$
create function f_emp_avg_salary (p_emp_no integer) returns decimal(10, 2)
begin

Declare v_avg_salary DECIMAL(10, 2);

SELECT AVG(s.salary)
into v_avg_salary from employees e
join salaries s on e.emp_no = p.emp_no
where e.emp_no = p.emp_no;

return v_avg_salary;
END $$

DELIMITER ;


SELECT f_emp_avg_salary(11300);




SELECT s.salary, e.first_name,
CASE
	WHEN salary > 100000 THEN salary + (salary * .10) 
    WHEN salary BETWEEN 55000 AND 80000 THEN salary + (salary * .07)
    ELSE salary + (salary * .05)
END AS Salary_Bonus
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no
LIMIT 300;






select emp_no, salary,
row_number() over () as row_num
from salaries;

select emp_no, salary,
row_number() over (partition by emp_no order by salary desc) as row_num
from salaries;


select emp_no, dept_no,
row_number() over (order by emp_no) as row_num
from dept_manager;


select emp_no, first_name, last_name,
row_number() over(partition by first_name order by last_name asc) as row_num
from employees;


select emp_no, salary, 
# row_number() over () as row_num1,
row_number() over (partition by emp_no) as row_num2,
row_number() over (partition by emp_no order by salary desc) as row_num3
# row_number() over (partition by salary desc) as row_num4
from salaries;

select dm.emp_no, salary,
row_number() over(partition by emp_no order by salary asc) as row_num1,
row_number() over(partition by emp_no order by salary desc) as row_num2
from dept_manager dm
join salaries s on dm.emp_no =s.emp_no;


select dm.emp_no, salary,
row_number() over() as row_num1,
row_number() over(partition by emp_no order by salary desc) as row_num2
from dept_manager dm
join salaries s on dm.emp_no =s.emp_no
order by row_num1, emp_no, salary asc;


SELECT emp_no, first_name,
ROW_NUMBER() OVER w AS row_num
FROM employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no);


select emp_no, min(salary) as min_salary from (
select emp_no salary,
row_number() over w as row_num
from salaries
window w as (partition by emp_no order by salary)) a
group by emp_no;

SELECT a.emp_no, MIN(salary) AS min_salary FROM (
SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;


SELECT a.emp_no, MIN(salary) AS min_salary FROM (
SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;


SELECT a.emp_no,
a.salary as min_salary FROM (
SELECT emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=2;


SELECT emp_no, (count(salary) - count(distinct salary)) as diff
from salaries
group by emp_no
having diff > 0
order by emp_no;


select * from salaries;

SELECT * FROM dept_manager;
SELECT * FROM employees;

SELECT * FROM dept_manager
WHERE emp_no IN (SELECT emp_no FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');
 

SELECT * FROM dept_manager
WHERE exists (SELECT emp_no FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');
 
SELECT * FROM dept_manager
WHERE exists (SELECT emp_no FROM employees);

SELECT * FROM dept_manager
WHERE emp_no in (SELECT emp_no FROM employees);

select * from dept_manager;
select * from employees;
select * from salaries;



select s.salary, dm.dept_no  from salaries s join dept_manager dm
on dm.emp_no = s.emp_no
group by dm.dept_no;





select concat(e.first_name, ' ', e.last_name), avg(s.salary) as avg_salary,
case
	when avg(s.salary) > 100000 then 100000 + (100000 * 0.2)
    when avg(s.salary) > 150000 then 150000 + (150000 * 0.3)
    else avg(s.salary) + (avg(s.salary) * 0.15)
end as salary_bonus
from salaries s join employees e on e.emp_no = s.emp_no
group by e.emp_no;


select * from dept_manager
where exists (select * from departments where from_date < '1999-01-01');

select * from dept_manager
where dept_no in (select dept_no from departments where from_date < '1999-01-01');

select * from dept_manager
where emp_no in (select emp_no from departments where from_date < '1999-01-01');


SELECT * FROM dept_manager
WHERE emp_no IN (SELECT emp_no FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1995-01-01');
 
 
SELECT *,
ROW_NUMBER() OVER w AS row_num
FROM employees e
WHERE EXISTS (
    SELECT *
    FROM titles t
    WHERE t.emp_no = e.emp_no
    AND title = 'Assistant Engineer'
)
WINDOW w AS (PARTITION BY e.first_name and e.last_name order by emp_no);

select t.title, concat(e.first_name, ' ', e.last_name) as full_name, 
ROW_NUMBER() OVER w AS row_num
from titles t 
join employees e on e.emp_no = t.emp_no
WINDOW w AS (PARTITION BY title ORDER BY full_name);




use relatives;
select * from job;
select * from people;
select * from person_data;


select * from dept_manager;

select e.first_name, e.last_name
from employees e 
where e.emp_no in (select dm.emp_no from dept_manager dm);


select *
from dept_manager dm
where dm.emp_no in (select e.emp_no from employees e
where e.hire_date between '1990-01-01' and '1995-01-01');


select e.first_name, e.last_name
from employees e 
where exists (select * from dept_manager dm 
where dm.emp_no = e.emp_no)
order by emp_no;


select * from employees e
where exists (select * from titles t
where  t.emp_no = e.emp_no and title = 'Assistant Engineer');


select A.* from
(select e.emp_no as employee_ID,
min(de.dept_no) as department_code,
(select emp_no from dept_manager where emp_no = 110022) 
as manager_ID
from employees e
join dept_emp de on e.emp_no = de.emp_no
where e.emp_no <= 10020
group by e.emp_no
order by e.emp_no) as A
UNION
select B.* from
(select e.emp_no as employee_ID,
min(de.dept_no) as department_code,
(select emp_no from dept_manager where emp_no = 110039) 
as manager_ID
from employees e
join dept_emp de on e.emp_no = de.emp_no
where e.emp_no > 10020
group by e.emp_no
order by e.emp_no limit 20) as B;


DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (
   emp_no INT(11) NOT NULL,
   dept_no CHAR(4) NULL,
   manager_no INT(11) NOT NULL
);
INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;


select * from employees;

select emp_no, first_name, last_name,
case when gender = 'M' then 1
	 else 0
	end as gender
from employees;


select e.emp_no, e.first_name, e.last_name,
case 
	when dm.emp_no is not null then 'manager'
	else 'employee'
	end as is_manager
from employees e
left join dept_manager dm on dm.emp_no = e.emp_no
where e.emp_no > 109990;


select emp_no, first_name, last_name,
if (gender = 'M', 1, 0) as gender
from employees;


select dm.emp_no, e.first_name, e.last_name,
max(s.salary) - min(s.salary) as salary_diff,
case 
	when max(s.salary) - min(s.salary) > 30000 then 'raised by 30000'
    when max(s.salary) - min(s.salary) between 20000 and 30000 then 'between 20k-30k'
    else 'raised less than 20000'
end as salary_increase
from dept_manager dm
join employees e on e.emp_no = dm.emp_no
join salaries s on s.emp_no = dm.emp_no
group by s.emp_no;


select e.emp_no, e.first_name, e.last_name,
case 
	when dm.emp_no is not null then 'manager'
    else 'employee'
    end as is_manager
from employees e left join dept_manager dm on e.emp_no = dm.emp_no
where e.emp_no > 109990;


select dm.emp_no, e.first_name, e.last_name,
max(s.salary) - min(s.salary) as salary_diff,
case 
	when max(s.salary) - min(s.salary) > 30000 then 'raise > 30000'
	else 'raise <= 30000'
    end as salary_raise
FROM dept_manager dm  
JOIN  employees e ON e.emp_no = dm.emp_no  
JOIN  salaries s ON s.emp_no = dm.emp_no  
GROUP BY s.emp_no;

select e.emp_no, e.first_name, e.last_name,
case
WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
ELSE 'Not an employee anymore'
end as current_employee
from employees e
join dept_emp de on de.emp_no = e.emp_no
group by de.emp_no
limit 100;


select emp_no, salary,
row_number() over () as row_num
from salaries;

select emp_no, salary,
row_number() over (partition by emp_no) as row_num
from salaries;

select emp_no, salary,
row_number() over (partition by emp_no order by salary DESC) as row_num
from salaries;

select emp_no, dept_no,
row_number() over (partition by dept_no order by emp_no desc) as row_num
from dept_manager;


select emp_no, first_name, last_name,
row_number() over (partition by first_name order by last_name desc) as row_num
from employees;

select emp_no, salary,
row_number() over () as row_num1,
row_number() over (partition by emp_no) as row_num2,
row_number() over (partition by emp_no order by salary DESC) as row_num3,
row_number() over (order by salary DESC) as row_num4
from salaries
order by emp_no, salary;


select dm.emp_no, s.salary,
row_number() over (partition by emp_no ORDER BY salary ASC) AS row_num1,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   
FROM dept_manager dm
JOIN salaries s ON dm.emp_no = s.emp_no;


select emp_no, salary,
row_number() over (partition by emp_no ORDER BY salary ASC) AS row_num1
FROM salaries;

select emp_no, salary, row_number() over w as row_num
from salaries
window w as (partition by emp_no order by salary desc);

select emp_no, first_name,
row_number() over w as row_num
from employees
window w as (partition by first_name order by emp_no);

select emp_no, salary,
row_number() over (partition by emp_no order by salary desc) as row_num
from salaries;


select a.emp_no, max(salary) as max_salary from (
select emp_no, salary, row_number() over (partition by emp_no order by salary desc) as row_num
from salaries) a group by emp_no;


SELECT a.emp_no, MIN(salary) AS min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;

select emp_no, salary, 
row_number() over (partition by emp_no ORDER BY salary ASC) AS row_num1
FROM salaries;

select emp_no, salary,
row_number() over w as row_num
from salaries
where emp_no = '11839'
window w as (partition by emp_no order by salary desc);


select emp_no, salary,
rank() over w as rank_num
from salaries
where emp_no = '11839'
window w as (partition by emp_no order by salary desc);

select emp_no, salary,
dense_rank() over w as rank_num
from salaries
where emp_no = '11839'
window w as (partition by emp_no order by salary desc);


select emp_no, salary,
row_number() over w as rank_num
from salaries
where emp_no = '10560'
window w as (partition by emp_no order by salary desc);

select emp_no, (count(salary) - count(distinct salary)) as diff
from salaries
group by emp_no
having diff > 0
order by emp_no;

SELECT dm.emp_no, (COUNT(salary)) AS no_of_salary_contracts
FROM dept_manager dm
JOIN salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no
ORDER BY emp_no;


select d.dept_no, d.dept_name, 
dm.emp_no, 
rank() over w as department_salary_rank,
s.salary, s.from_date, s.to_date,
dm.from_date, dm.to_date from
dept_manager dm 
join salaries s on dm.emp_no = s.emp_no
and s.from_date between dm.from_date and dm.to_date 
and s.to_date between dm.from_date and dm.to_date
join departments d on d.dept_no = dm.dept_no
window w as (partition by dm.dept_no order by s.salary DESC);

select e.emp_no,
RANK() OVER w as employee_salary_ranking, s.salary
FROM
employees e
JOIN salaries s ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);



create temporary table f_highest_salaries
select s.emp_no, max(s.salary) as f_highest_salary
from salaries s join employees e on e.emp_no  = s.emp_no
and e.gender = 'F'
group by s.emp_no;

drop table if exists f_highest_salaries;

select * from f_highest_salaries 
where emp_no <= '10010';

create temporary table male_max_salaries
select s.emp_no, max(s.salary) as highest_salary
from salaries s join employees e on e.emp_no  = s.emp_no
and e.gender = 'M'
group by s.emp_no;

drop table if exists male_max_salaries;

SELECT * FROM male_max_salaries;

select emp_no, salary, 
lag(salary) over w as previous_salary,
lead(salary) over w as next_salary,
salary - lag(salary) over w as diff_salary_current_previous,
lead(salary) over w - salary as diff_salary_current_next
from salaries 
where emp_no = '10001'
window w as (order by salary);



select emp_no, salary, 
lag(salary) over w as previous_salary,
lead(salary) over w as next_salary,
salary - lag(salary) over w as diff_salary_current_previous,
lead(salary) over w - salary as diff_salary_current_next
from salaries 
where salary > 80000 
and emp_no between '10500' and '10600'
window w as (order by salary);


SELECT emp_no, salary,
LAG(salary) OVER w AS previous_salary,
LAG(salary, 2) OVER w AS 1_before_previous_salary,
LEAD(salary) OVER w AS next_salary,
LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;

select sysdate();

select emp_no, salary, from_date, to_date
from salaries
where to_date > sysdate();

SELECT s1.emp_no, s.salary, s.from_date, s.to_date
FROM salaries s JOIN
(SELECT
emp_no, MIN(from_date) AS from_date
FROM salaries GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE s.from_date = s1.from_date;

SELECT de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) OVER w AS average_salary_per_department
FROM (SELECT de.emp_no, de.dept_no, de.from_date, de.to_date
FROM dept_emp de JOIN
(SELECT emp_no, MAX(from_date) AS from_date
FROM dept_emp
GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE de.to_date < '2002-01-01'
AND de.from_date > '2000-01-01'
AND de.from_date = de1.from_date) de2
JOIN (SELECT s1.emp_no, s.salary, s.from_date, s.to_date
FROM salaries s JOIN
(SELECT
emp_no, MAX(from_date) AS from_date
FROM salaries GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE s.to_date < '2002-01-01'
AND s.from_date > '2000-01-01'
AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
JOIN departments d ON d.dept_no = de2.dept_no
GROUP BY de2.emp_no, d.dept_name
WINDOW w AS (PARTITION BY de2.dept_no)
ORDER BY de2.emp_no, salary;



DELIMITER $$
CREATE PROCEDURE avg_salary()
BEGIN
SELECT AVG(salary)
FROM salaries;
END$$
DELIMITER ;
CALL avg_salary;
CALL avg_salary();
CALL employees.avg_salary;
CALL employees.avg_salary();



DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
SELECT e.emp_no
INTO p_emp_no FROM employees e
WHERE e.first_name = p_first_name
AND e.last_name = p_last_name;
END$$
DELIMITER ;

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;


with cte as (
select avg(salary) as avg_salary from salaries)
select * from salaries s join
cte c;

with CTE as (
select avg(salary) as avg_salary
from salaries)
select * from employees e join 
salaries s on s.emp_no = e.emp_no
inner join cte c;


WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;