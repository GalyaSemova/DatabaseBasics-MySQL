-- 18 Oct 2020 part 2
CREATE DATABASE softuni_stores_system;
USE softuni_stores_system;

-- 01. Table Design

CREATE TABLE pictures(
id INT PRIMARY KEY AUTO_INCREMENT,
url VARCHAR(100) NOT NULL,
added_on DATETIME NOT NULL
);
 
 CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL UNIQUE
);

 CREATE TABLE products(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL UNIQUE,
best_before DATE,
price DECIMAL(10, 2) NOT NULL,
description TEXT,
category_id INT NOT NULL,
picture_id INT NOT NULL,
CONSTRAINT fk_products_categories
FOREIGN KEY (category_id)
REFERENCES categories(id),
CONSTRAINT fk_products_pictures
FOREIGN KEY (picture_id)
REFERENCES pictures(id)
);

 CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL UNIQUE
);

 CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL UNIQUE,
town_id INT NOT NULL,
CONSTRAINT fk_addresses_towns
FOREIGN KEY (town_id)
REFERENCES towns(id)
);

CREATE TABLE stores(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL UNIQUE,
rating FLOAT NOT NULL,
has_parking TINYINT(1) DEFAULT FALSE,
address_id INT NOT NULL,
CONSTRAINT fk_stores_addresses
FOREIGN KEY (address_id)
REFERENCES addresses(id)
);

CREATE TABLE products_stores(
product_id INT NOT NULL,
store_id INT NOT NULL,
PRIMARY KEY (product_id, store_id),
CONSTRAINT fk_products_stores__products
FOREIGN KEY (product_id)
REFERENCES products(id),
CONSTRAINT fk_products_stores__stores
FOREIGN KEY (store_id)
REFERENCES stores(id)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(15) NOT NULL,
middle_name CHAR(1),
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(19, 2) DEFAULT 0,
hire_date DATE NOT NULL,
manager_id INT,
store_id INT NOT NULL,
CONSTRAINT fk_employees_employees
FOREIGN KEY (manager_id)
REFERENCES employees(id),
CONSTRAINT fk_employees_stores
FOREIGN KEY (store_id)
REFERENCES stores(id)
);


-- 05. Employees 

SELECT first_name, middle_name, last_name, salary, hire_date FROM employees
ORDER BY hire_date DESC;

-- 06. Products with old pictures

SELECT p.name AS product_name, p.price,
 p.best_before,
 (CONCAT(LEFT(p.description, 10), '...')) AS short_description,
 pi.url
FROM products AS p
JOIN pictures AS pi
ON pi.id = p.picture_id
WHERE p.price > 20 AND length(p.description)  > 100 AND YEAR(pi.added_on) < 2019
ORDER BY p.price DESC;
 
-- 07. Counts of products in stores

SELECT s.name, COUNT(p.id) AS product_count,
ROUND(AVG(p.price), 2) AS avg FROM stores AS s
LEFT JOIN products_stores AS ps
ON s.id = ps.store_id
LEFT JOIN products AS p
ON ps.product_id = p.id
GROUP BY s.id
ORDER BY product_count DESC, avg DESC, s.id;

-- 08. Specific employee

SELECT concat_ws(' ', e.first_name, e.last_name) AS Full_name,
s.name AS Store_name,
a.name AS address,
e.salary FROM employees AS e
JOIN stores AS s
ON s.id = e.store_id
JOIN addresses AS a
ON a.id = s.address_id
WHERE e.salary < 4000 AND a.name LIKE '%5%' AND length(s.name) > 8 
AND (e.last_name) LIKE '%n';
 
-- 09. Find all information of stores

 SELECT reverse(s.name) AS reversed_name,
 (CONCAT(UPPER(t.name), '-', a.name)) AS full_address,
 COUNT(e.id) AS employees_count
 FROM stores AS s
 LEFT JOIN employees AS e
 ON s.id = e.store_id
 JOIN addresses AS a
 ON a.id = s.address_id
 JOIN towns AS t
 ON t.id = a.town_id
 GROUP BY s.id
 HAVING employees_count >= 1
 ORDER BY full_address;


-- 10. Find name of top paid employee by store name

-- SELECT concat(e.first_name, ' ', e.middle_name,'. ', e.last_name,
--     ' works in store for ', 2020 - YEAR(e.hire_date), ' years'
--     ) FROM employees AS e
-- JOIN stores AS s
-- ON e.store_id = s.id
-- WHERE s.name = 'Stronghold'
-- ORDER BY e.salary DESC
-- LIMIT 1;

DELIMITER $$
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN 
DECLARE result VARCHAR(100);
SET result := (
	SELECT 
    concat(e.first_name, ' ', e.middle_name,'. ', e.last_name,
    ' works in store for ', 2020 - YEAR(e.hire_date), ' years'
    )
    FROM employees AS e
	JOIN stores AS s
	ON e.store_id = s.id
	WHERE s.name = store_name
	ORDER BY e.salary DESC
	LIMIT 1);
RETURN result;
END $$
DELIMITER ;

SELECT udf_top_paid_employee_by_store('Keylex') as 'full_info';

-- 11. Update product price by address

-- SELECT * FROM products AS p
-- JOIN products_stores AS ps
-- ON p.id = ps.product_id
-- JOIN stores AS s
-- ON s.id = ps.store_id
-- JOIN addresses AS a
-- ON a.id = s.address_id
-- WHERE a.name = '07 Armistice Parkway';


DELIMITER $$
CREATE PROCEDURE udp_update_product_price (address_name VARCHAR (50))
BEGIN
	UPDATE products AS p
	JOIN products_stores AS ps
	ON p.id = ps.product_id
	JOIN stores AS s
	ON s.id = ps.store_id
	JOIN addresses AS a
	ON a.id = s.address_id
    SET p.price = CASE
        WHEN a.name LIKE '0%' THEN p.price + 100
        ELSE p.price + 200
    END
	WHERE a.name = address_name;
END $$
DELIMITER ;


-- 02. Insert
INSERT INTO products_stores (product_id, store_id )
 (SELECT p.id, 1 FROM products AS p
 LEFT JOIN products_stores As ps
 ON p.id = ps.product_id
 LEFT JOIN stores AS s
 ON s.id = ps.store_id
 WHERE s.id IS NULL);
 
 -- 03. Update
 

UPDATE employees AS e
LEFT JOIN employees AS e1
ON e.id = e1.manager_id
JOIN stores AS s
ON s.id = e.store_id
SET e.manager_id = 3 , e.salary = e.salary - 500
WHERE YEAR(e.hire_date) > 2003 AND s.name NOT IN ('Cardguard', 'Veribet');

-- 04. Delete
DELETE e FROM employees AS e
WHERE e.salary >= 6000 AND e.manager_id IS NOT NULL;












 








