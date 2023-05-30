#  Subqueries and JOINs

-- 1. Managers
-- query to retrieve information about the managers – id, full_name, deparment_id and
-- department_name. Select the first 5 departments ordered by employee_id 

SELECT e.employee_id, 
concat_ws(' ', first_name, last_name) AS full_name,
d.department_id,
d.name AS department_name
 FROM employees AS e
 RIGHT JOIN departments AS d
 ON e.employee_id = d.manager_id
 ORDER BY e.employee_id
 LIMIT 5;
 
 -- 2. Towns and Addresses
 
 -- query to get information about the addresses in the database, which are in San Francisco, Sofia or
-- Carnation. Retrieve town_id, town_name, address_text. Order the result by town_id, then by address_id

SELECT t.town_id, t.name AS town_name, a.address_text
 FROM towns AS t
JOIN addresses AS a
 ON t.town_id = a.town_id
 WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
 ORDER BY town_id;
 
 -- 3. Employees Without Managers 
--  query to get information about employee_id, first_name, last_name, department_id and salary
-- for all employees who don't have a manager.
 
 SELECT employee_id, 
 first_name, 
 last_name,
 department_id,
 salary
 FROM employees
 WHERE manager_id IS NULL;
 
 
 -- 4. High Salary 
 -- query to count the number of employees who receive salary higher than the average 
 
 SELECT count(employee_id) AS count FROM employees
 WHERE salary >
 (SELECT AVG(salary) FROM employees);
 
 
 
 
 
 
 
 
 
 