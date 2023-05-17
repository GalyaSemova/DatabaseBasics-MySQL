CREATE DATABASE  minions;
USE minions;

-- Create Tables
 -- minions (id, name, age)
 CREATE TABLE minions (
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50),
 age INT 
 );
 
  -- towns (town_id, name)
  CREATE TABLE towns (
  town_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50)
  );
  
  -- ALTER TABLES
  use minions;
  
  ALTER TABLE minions
  ADD COLUMN town_id INT;
  
  use minions;
  ALTER TABLE minions
  ADD CONSTRAINT fk_minions_towns
  FOREIGN KEY minions(town_id)
  REFERENCES towns(id);
  
-- Insert records
-- minions      towns
-- id name age  town_id id name
-- 1 Kevin 22     1 1 Sofia
-- 2 Bob 15       3 2 Plovdiv
-- 3 Steward NULL 2 3 Varna

INSERT INTO towns(id, name)
VALUES (1,'Sofia'),
(2,'Plovdiv'),
(3,'Varna');


INSERT INTO  minions (id, name, age, town_id)
VALUES (1 , 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);


-- Truncate Table minions

SELECT * FROM minions; 

TRUNCATE TABLE minions;

SELECT * FROM minions;

-- 5. Drop All Tables
DROP TABLE minions;
DROP TABLE towns;

-- 6. Create Table people
-- • id – unique number for every person there will be no more than 231-1people. (Auto incremented)
-- • name – full name of the person will be no more than 200 Unicode characters. (Not null)
-- • picture – image with size up to 2 MB. (Allow nulls)
-- • height – In meters. Real number precise up to 2 digits after floating point. (Allow nulls)
-- • weight – In kilograms. Real number precise up to 2 digits after floating point. (Allow nulls)
-- • gender – Possible states are m or f. (Not null)
-- • birthdate – (Not null)
-- • biography – detailed biography of the person it can contain max allowed Unicode characters. (Allow nulls)

CREATE TABLE people (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(200) NOT NULL,
picture BLOB,
height DOUBLE(5,2),
weight DOUBLE(5,2),
gender CHAR(1) NOT NULL,
birthdate DATE NOT NULL,
biography TEXT
);

INSERT INTO people (name, gender, birthdate)
VALUES ('Test1', 'm', DATE(NOW())),
('Test2', 'm', DATE(NOW())),
('Test3', 'F', DATE(NOW())),
('Test4', 'm', DATE(NOW())),
('Test5', 'm', DATE(NOW()));

SELECT * FROM people;

-- 7. Create Table users
-- • id – unique number for every user. There will be no more than 263-1 users. (Auto incremented)
-- • username – unique identifier of the user will be no more than 30 characters (non Unicode). (Required)
-- • password – password will be no longer than 26 characters (non Unicode). (Required)
-- • profile_picture – image with size up to 900 KB. 
-- • last_login_time
-- • is_deleted – shows if the user deleted his/her profile. Possible states are true or false.

CREATE TABLE users (
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) NOT NULL,
password VARCHAR(26) NOT NULL,
profile_picture BLOB,
last_login_time TIMESTAMP,
is_deleted BOOLEAN
);

INSERT INTO users (username, password)
VALUES ('Test1', 'pass'),
('Test2', 'pass'),
('Test3', 'pass'),
('Test4', 'pass'),
('Test5', 'pass');

SELECT * FROM users;

-- 8. Change Primary Key
-- modify table users from the previous task. First remove current primary key then create new 
-- primary key that would be combination of fields id and username. The initial primary key name on id is pk_users. 

ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id, username);

-- 9. Set Default Value of a Field 
 -- modify table users. Make the default value of last_login_time field to be the current time.
 
 ALTER TABLE users
 CHANGE COLUMN last_login_time
 last_login_time TIMESTAMP DEFAULT NOW();
 
 -- 10. Set Unique Field
 -- modify table users. Remove username field from the primary key so only the field id would be 
-- primary key. Now add unique constraint to the username field. The initial primary key name on (id, username) is 
-- pk_users.

ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY users(id),
CHANGE COLUMN username
username VARCHAR(30) UNIQUE;

--  11 MOVIES DATABASE

-- directors (id, director_name, notes) 
-- o director_name cannot be null
-- • genres (id, genre_name, notes) 
-- o genre_name cannot be null
-- • categories (id, category_name, notes) 
-- o category_name cannot be null
-- • movies (id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes)
-- o title cannot be null

CREATE DATABASE movies;
USE movies;

CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(100) NOT NULL,
    notes TEXT
);

INSERT INTO directors(director_name)
VALUES ('test'),
('test'),
('test'),
('test'),
('test');

CREATE TABLE genres (
id INT PRIMARY KEY AUTO_INCREMENT,
genre_name VARCHAR(100) NOT NULL,
notes TEXT
);

INSERT INTO genres(genre_name)
VALUES ('test'),
('test'),
('test'),
('test'),
('test');

CREATE TABLE categories (
id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(100) NOT NULL,
notes TEXT
);

INSERT INTO categories(category_name)
VALUES ('test'),
('test'),
('test'),
('test'),
('test');

-- • movies (id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes)
-- o title cannot be null

CREATE TABLE movies(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(100) NOT NULL,
director_id INT,
copyright_year YEAR,
length DOUBLE(10,2),
genre_id INT,
category_id INT,
rating DOUBLE(3,2),
notes TEXT,
FOREIGN KEY fk_movies_directors(director_id)
REFERENCES directors(id),
FOREIGN KEY fk_movies_genres(genre_id)
REFERENCES genres(id),
FOREIGN KEY fk_movies_categories(category_id)
REFERENCES categories(id)
);

INSERT INTO movies(title, director_id, genre_id, category_id)
VALUES ('test', 1, 2, 3),
('test', 1, 2, 5),
('test', 1, 2, 4),
('test', 1, 2, 3),
('test', 1, 2, 3);

-- 12. Car Rental Database (car_rental)
-- • categories (id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
-- • cars (id, plate_number, make, model, car_year, category_id, doors, picture, car_condition, 
-- available)
-- • employees (id, first_name, last_name, title, notes)
-- • customers (id, driver_licence_number, full_name, address, city, zip_code, notes)
-- • rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, 
-- kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, 
-- total_days, rate_applied, tax_rate, order_status, notes)

CREATE DATABASE car_rental;
USE car_rental;

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
category VARCHAR(30) NOT NULL,
daily_rate DECIMAL,
weekly_rate DECIMAL,
monthly_rate DECIMAL,
weekend_rate DECIMAL
);

INSERT INTO categories(category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES('TEST', 10.5, 10.5, 10.5, 10.5),
('TEST', 10.5, 10.5, 10.5, 10.5),
('TEST', 10.5, 10.5, 10.5, 10.5);

CREATE TABLE cars(
id INT PRIMARY KEY AUTO_INCREMENT,
plate_number VARCHAR(30) NOT NULL UNIQUE,
make VARCHAR(30) NOT NULL,
model VARCHAR(30) NOT NULL,
car_year YEAR NOT NULL,
category_id INT NOT NULL,
doors INT NOT NULL,
picture BLOB,
car_condition TEXT,
available VARCHAR(30) NOT NULL
);

INSERT INTO cars(plate_number, make, model, car_year, category_id, doors, available)
VALUES ('tEST', 'make', 'model', '2020', 1, 4,  'Yes'),
('TEST1', 'make', 'model', '2008', 2, 2,  'Yes'),
('TEST2', 'make', 'model', '2020', 1, 4, 'Yes');

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
title VARCHAR(30) NOT NULL,
notes TEXT
);

INSERT INTO employees(first_name, last_name, title)
VALUES('first_name', 'last_name', 'title'),
('first_name', 'last_name', 'title'),
('first_name', 'last_name', 'title');

CREATE TABLE customers(
id INT PRIMARY KEY AUTO_INCREMENT,
driver_licence_number VARCHAR(50) NOT NULL,
full_name VARCHAR(30) NOT NULL,
address VARCHAR(255) NOT NULL,
city VARCHAR(50) NOT NULL,
zip_code INT NOT NULL,
notes TEXT
);

INSERT INTO customers(driver_licence_number, full_name, address, city, zip_code, notes)
VALUES ('111111111111111', 'TEST', 'address', 'city', 4000, 'notes'),
('HGGHHJGJGH', 'TEST', 'address', 'city', 4000, 'notes'),
('JGHFGDFSFSSFSXGFD', 'TEUST', 'address', 'city', 4000, 'notes');

CREATE TABLE rental_orders(
id INT PRIMARY KEY AUTO_INCREMENT,
employee_id INT NOT NULL,
customer_id INT NOT NULL,
car_id INT NOT NULL,
car_condition TEXT,
tank_level DOUBLE NOT NULL,
kilometrage_start INT NOT NULL,
kilometrage_end INT NOT NULL,
total_kilometrage INT NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
total_days INT NOT NULL,
rate_applied VARCHAR(50) NOT NULL,
tax_rate DECIMAL NOT NULL,
order_status VARCHAR(50),
notes TEXT
);

INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, 
kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
VALUES (2, 1, 3, 'car_condition', 44.4, 100000, 100500, 100, '2018-01-02', '2018-01-18', 3, 'rate_applied', 20.5, 'order_status', 'notes'),
(2, 1, 3, 'car_condition', 44.4, 100000, 100500, 100, '2018-01-02', '2018-01-18', 3, 'rate_applied', 20.5, 'order_status', 'notes'),
(2, 1, 3, 'car_condition', 44.4, 100000, 100500, 100, '2018-01-02', '2018-01-18', 3, 'rate_applied', 20.5, 'order_status', 'notes');


 -- 13. Basic Insert (soft_uni)
--  • towns (id, name)
--  • addresses (id, address_text, town_id)
--  • departments (id, name)
--  • employees (id, first_name, middle_name, last_name, job_title, department_id, hire_date, salary, address_id)

CREATE DATABASE soft_uni;
USE soft_uni;

CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
address_text VARCHAR(100),
town_id INT
);

CREATE TABLE departments(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
id INT PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(50), 
middle_name VARCHAR(50), 
last_name VARCHAR(50), 
job_title VARCHAR(50), 
department_id INT, 
hire_date DATETIME DEFAULT NOW(), 
salary DOUBLE(10, 2), 
address_id INT,
FOREIGN KEY (department_id)
REFERENCES departments(id),
FOREIGN KEY (address_id)
REFERENCES addresses(id)
);


INSERT INTO towns(name)
VALUES('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

--  Engineering, Sales, Marketing, Software Development, Quality Assurance
INSERT INTO departments(name)
VALUES('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO `employees` (`id`, `first_name`, `middle_name`,
`last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);


-- 14. Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

-- 15. Basic Select All Fields and Order Them
-- • towns - alphabetically by name
-- • departments - alphabetically by name
-- • employees - descending by salary

SELECT * FROM towns AS t ORDER BY t.name;
SELECT * FROM departments AS d ORDER BY d.name;
SELECT * FROM employees AS e ORDER BY e.salary DESC;

-- 16. Basic Select Some Fields
-- • towns – name
-- • departments – name
-- • employees – first_name, last_name, job_title, salary

SELECT name FROM towns AS t ORDER BY t.name;
SELECT name FROM departments AS d ORDER BY d.name;
SELECT first_name, last_name, job_title, salary FROM employees AS e ORDER BY e.salary DESC;

-- 17. Increase Employees Salary
-- increase the salary of all employees by 10%. Then select only salary column from the 
-- employees table. 

UPDATE employees
SET salary = salary * 1.1 WHERE id > 0;
SELECT salary FROM employees;












 
 
 
 














 
  



  

