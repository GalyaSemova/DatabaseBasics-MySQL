-- Exercises: Built-in Functions
--  Part I – Queries for SoftUni Database

-- 1. Find Names of All Employees by First Name
-- find first and last names of all employees whose first name starts with "Sa" (case
-- insensitively). Order the information by id

USE soft_uni;
select * from employees;

SELECT first_name, last_name FROM employees
WHERE LOWER(first_name)  LIKE LOWER('Sa%')
ORDER BY employee_id;

-- 02. Find Names of All Employees by Last Name
-- find first and last names of all employees whose last name contains "ei" (case insensitively).
-- Order the information by id

SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

-- 3. Find First Names of All Employess 
-- find the first names of all employees in the departments with ID 3 or 10 and whose hire year is
-- between 1995 and 2005 inclusively. Order the information by id.

SELECT first_name FROM employees
WHERE department_id IN (3, 10) AND
YEAR(hire_date) >= 1995 AND YEAR(hire_date) <= 2005
ORDER BY employee_id;

-- 04. Find All Employees Except Engineers
-- find the first and last names of all employees whose job titles does not contain "engineer".
-- Order the information by id 

SELECT first_name, last_name FROM employees
WHERE LOWER(job_title) NOT LIKE '%engineer%' 
ORDER BY employee_id;

-- 05. Find Towns with Name Length
-- find town names that are 5 or 6 symbols long and order them alphabetically by town name. 

SELECT name FROM towns
WHERE LENGTH(name) IN (5, 6)
ORDER BY name ASC;


-- 06. Find Towns Starting With
-- find all towns that start with letters M, K, B or E (case insensitively). Order them
-- alphabetically by town name. 

SELECT * FROM towns
WHERE UPPER(LEFT(name, 1)) IN ('M', 'K', 'B', 'E')
ORDER BY name;

SELECT * FROM towns
WHERE name REGEXP '^[MKBE]'
ORDER BY name;

-- 07. Find Towns Not Starting With
-- find all towns that do not start with letters R, B or D (case insensitively). Order them
-- alphabetically by name

SELECT * FROM towns
WHERE UPPER(LEFT(name, 1)) NOT IN ('R', 'D', 'B')
ORDER BY name;

 
-- 08. Create View Employees Hired After
-- create view v_employees_hired_after_2000 with the first and the last name of all employees
-- hired after 2000 year. Select all from the created view 

CREATE VIEW  `v_employees_hired_after_2000` AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;

-- 09. Length of Last Name
-- find the first and last names of all employees whose last name is exactly 5 characters long.

SELECT first_name, last_name FROM employees
WHERE char_length(last_name) = 5;

-- Part II – Queries for Geography Database 


-- 10. Countries Holding 'A'
-- Find all countries that hold the letter 'A' in their name at least 3 times (case insensitively), sorted by ISO code.
-- Display the country name and the ISO code

USE geography;
 
SELECT country_name, iso_code FROM countries
WHERE LOWER(country_name) LIKE '%a%a%a%'
ORDER BY iso_code;

SELECT country_name, iso_code FROM countries
WHERE 
char_length(country_name) -
char_length(replace(lower(country_name), 'a', ''))
>= 3
ORDER BY iso_code;

-- 11. Mix of Peak and River Names
-- Combine all peak names with all river names, so that the last letter of each peak name is the same as the first letter
-- of its corresponding river name. Display the peak name, the river name, and the obtained mix(converted to lower
-- case). Sort the results by the obtained mix alphabetically. 

SELECT 
p.peak_name,
r.river_name,
LOWER(CONCAT(LEFT(p.peak_name, LENGTH(p.peak_name) - 1),
r.river_name)) AS mix
FROM 
rivers AS r,
peaks AS p
WHERE UPPER(RIGHT(p.peak_name, 1)) = UPPER(LEFT(r.river_name, 1))
ORDER BY mix;

SELECT peak_name, river_name, 
CONCAT(LOWER(peak_name), '', SUBSTRING(LOWER(river_name), 2)) AS mix 
FROM peaks, rivers
WHERE RIGHT(peak_name, 1) = LEFT(river_name, 1)
ORDER BY mix;

-- Part III – Queries for Diablo Database

-- 12. Games from 2011 and 2012 Year
-- Find the top 50 games ordered by start date, then by name. 
-- Display only the games from the years 2011 and 2012.
-- Display the start date in the format "YYYY-MM-DD"

USE diablo;

SELECT name, DATE_FORMAT(start, '%Y-%m-%d') FROM games
WHERE YEAR(start) IN (2011, 2012)
ORDER BY start, name
LIMIT 50;

-- 13. User Email Providers
-- Find information about the email providers of all users. 
-- Display the user_name and the email provider. Sort the
-- results by email provider alphabetically, then by username.

SELECT user_name, 
SUBSTRING_INDEX(email, '@', -1) AS `email provider`
FROM users
ORDER BY `email provider`, user_name;

 SELECT user_name, 
REGEXP_REPLACE(email, '.*@', '') AS `email provider`
FROM users
ORDER BY `email provider`, user_name;

-- 14. Get Users with IP Address Like Pattern
-- Find the user_name and the ip_address for each user, 
-- sorted by user_name alphabetically. Display only 
-- the rows,
-- where the ip_address matches the pattern: 
-- "___.1%.%.___".

SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

-- 15. Show All Games with Duration
-- Find all games with their corresponding part of 
-- the day and duration. Parts of the day should be 
-- Morning (start time is >= 0 and < 12), 
-- Afternoon (start time is >= 12 and < 18), 
-- Evening (start time is >= 18 and < 24). Duration
-- should be Extra Short (smaller or equal to 3), 
-- Short (between 3 and 6 including), 
-- Long (between 6 and 10 including)
-- and Extra Long in any other cases or without duration.

SELECT name AS games,
CASE 
	WHEN hour(start) BETWEEN 0 AND 11 THEN 'Morning'
	WHEN hour(start) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening' 
END AS 'Part of the day',
CASE
	WHEN duration <= 3 THEN 'Extra Short'
    WHEN duration BETWEEN 4 AND 6 THEN 'Short'
    WHEN duration BETWEEN 7 AND 10 THEN 'Long'
    ELSE 'Extra Long'
END AS 'Duration'    
FROM games;

 
-- Part IV – Date Functions Queries

-- 16. Orders Table
-- You are given a table orders (id, product_name, order_date) filled with data. Consider that the payment for an
-- order must be accomplished within 3 days after the order date. Also the delivery date is up to 1 month. Write a
-- query to show each product's name, order date, pay and deliver due dates  

SELECT 
	product_name,
    order_date,
    DATE_ADD(order_date, INTERVAL 3 DAY) AS pay_due,
    DATE_ADD(order_date, INTERVAL 1 MONTH) AS deliver_due
    FROM orders;

