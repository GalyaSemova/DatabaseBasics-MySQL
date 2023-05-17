CREATE DATABASE gamebar;
USE gamebar;
-- • id – INT, primary key, AUTO_INCREMENT;
-- • first_name – VARCHAR, NOT NULL;
-- • last_name – VARCHAR, NOT NULL; 

CREATE TABLE employees (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL
);

-- Create the "categories" and "products" tables analogically:
-- Table "categories":
-- • id – INT, primary key, AUTO_INCREMENT;
-- • name – VARCHAR, NOT NULL;

CREATE TABLE categories (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

-- Table "products":
-- • id – INT, primary key, AUTO_INCREMENT;
-- • name – VARCHAR, NOT NULL;
-- • category_id – INT, NOT NULL – it is not a foreign key for now.

CREATE TABLE prolducts (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL,
category_id INT NOT NULL
);

drop table prolducts;

CREATE TABLE products (
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL,
category_id INT NOT NULL
);

-- insert data in tables

SHOW tables;
INSERT INTO employees (id, first_name, last_name) VALUES 
(1, 'test1', 'test1'),
(2, 'test2', 'test2'),
(3, 'test3', 'test3');

-- alter table

ALTER TABLE employees
ADD COLUMN employeesmiddle_name VARCHAR(50);

-- ADDING CONTSRAINTS Create the connection via foreign key between the "products" and "categories" tables that you've created
-- earlier. Make "category_id" foreign key linked to "id" in the "categories" table. 

ALTER TABLE products
ADD CONSTRAINT fk_p_c FOREIGN KEY (category_id)
REFERENCES categories (id);

--  MODIFY COLUMNS. Change the property "VARCHAR(50)" to "VARCHAR(100)" to the "middle_name" column in "employees"
-- table.

ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100); 



 








 






















