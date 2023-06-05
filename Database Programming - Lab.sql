# Database Programmability and Transactions - Lab

# 1. Count Employees by Town
--  function ufn_count_employees_by_town(town_name) that accepts town_name as parameter and
-- returns the count of employees who live in that town 

DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(*) AS count FROM employees AS e
		JOIN addresses AS a
		ON e.address_id = a.address_id
		JOIN towns AS t
		ON a.town_id = t.town_id
		WHERE t.name = town_name);
END $$

SELECT ufn_count_employees_by_town('Sofia') AS count $$

-- 2. Employees Promotion
-- stored procedure usp_raise_salaries(department_name) to raise the salary of all employees in
-- given department as parameter by 5%.


DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
UPDATE employees SET salary = salary * 1.05
WHERE department_id = (SELECT department_id FROM departments WHERE name = department_name);
END $$
DELIMITER ;
;

SELECT * FROM departments;

CALL usp_raise_salaries('Engineering');

-- 3. Employees Promotion by ID
 -- stored procedure usp_raise_salary_by_id(id) that raises a given employee's salary (by id as
-- parameter) by 5%. Consider that you cannot promote an employee that doesn't exist – if that happens, no changes
-- to the database should be made.

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
DECLARE employee_id_count INT;
SET employee_id_count := (SELECT COUNT(*) FROM employees WHERE employee_id = id);
IF(employee_id_count = 1)
THEN
UPDATE employees SET salary = salary * 1.05 WHERE employee_id = id;
END IF;
END $$
DELIMITER ;
;

CALL usp_raise_salary_by_id(17);

-- 4. Triggered
-- Create a table deleted_employees(employee_id PK,
-- first_name,last_name,middle_name,job_title,deparment_id,salary) that will hold information
-- about fired(deleted) employees from the employees table. Add a trigger to employees table that inserts the
-- corresponding information in deleted_employees 

CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
middle_name VARCHAR(50),
job_title VARCHAR(50),
department_id INT,
salary DECIMAL(19,4)
);

DELIMITER $$
CREATE TRIGGER tr_after_delete_employees
AFTER DELETE
ON employees
FOR EACH ROW
BEGIN
INSERT INTO deleted_employees (first_name, last_name, middle_name, job_title, department_id, salary)
VALUES (
OLD.first_name,
OLD.last_name,
OLD.middle_name,
OLD.job_title,
-- (SELECT name FROM departments WHERE department_id = OLD.department_id),
OLD.department_id,
OLD.salary
);
END $$
DELIMITER ;
;
























