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

SELECT f_emp_avg_salary(11200);
CALL emp_avg_salary(11300)
