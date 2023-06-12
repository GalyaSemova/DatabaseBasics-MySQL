-- 20 June 2021
CREATE DATABASE stc;
USE stc;

--  01. Table Design

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(10) NOT NULL
);

CREATE TABLE drivers(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
rating FLOAT DEFAULT 5.5
);

CREATE TABLE cars(
id INT PRIMARY KEY AUTO_INCREMENT,
make VARCHAR(20) NOT NULL,
model VARCHAR(20),
year INT NOT NULL DEFAULT 0,
mileage INT DEFAULT 0,
`condition` CHAR(1) NOT NULL,
category_id INT NOT NULL,
CONSTRAINT fk_cars_categories
FOREIGN KEY (category_id)
REFERENCES categories(id) 
);

CREATE TABLE clients(
id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(50) NOT NULL,
phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE courses(
id INT PRIMARY KEY AUTO_INCREMENT,
from_address_id INT NOT NULL,
start DATETIME NOT NULL,
bill DECIMAL(10, 2) DEFAULT 10,
car_id INT NOT NULL,
client_id INT NOT NULL,
CONSTRAINT fk_courses_clients
FOREIGN KEY (client_id)
REFERENCES clients(id),
CONSTRAINT fk_courses_cars
FOREIGN KEY (car_id)
REFERENCES cars(id),
CONSTRAINT fk_courses_addresses
FOREIGN KEY (from_address_id)
REFERENCES addresses(id)
);

CREATE TABLE cars_drivers(
car_id INT NOT NULL,
driver_id INT NOT NULL,
PRIMARY KEY (car_id, driver_id),
CONSTRAINT fk_cars_drivers__cars
FOREIGN KEY (car_id)
REFERENCES cars(id),
CONSTRAINT fk_cars_drivers__drivers
FOREIGN KEY (driver_id)
REFERENCES drivers(id)
);



-- 05. Cars 

SELECT make, model, `condition` FROM cars
ORDER BY id;

-- 06. Drivers and Cars

SELECT d.first_name, d.last_name,
c.make, c.model, c.mileage FROM drivers AS d
JOIN cars_drivers AS cd
ON cd.driver_id = d.id
JOIN cars AS c
ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name;

-- 07. Number of courses
SELECT c.id, c.make, c.mileage,
COUNT(co.id)  AS count_of_courses,
ROUND(AVG(co.bill), 2) AS avg_bill
FROM courses AS co
RIGHT JOIN cars AS c
ON co.car_id = c.id
GROUP BY c.id
HAVING count_of_courses < 2 OR count_of_courses > 2
ORDER BY count_of_courses DESC, c.id;
 
-- 08. Regular clients

 SELECT c.full_name,
 COUNT(ca.id) AS count_of_cars,
 (SUM(co.bill)) AS total_sum
 FROM clients AS c
 JOIN courses AS co
 ON c.id = co.client_id
 JOIN cars AS ca
 ON ca.id = co.car_id
 WHERE c.full_name LIKE '_a%'
 GROUP BY c.id
 HAVING count_of_cars > 1
 ORDER BY c.full_name;
 
-- 09. Full info for courses

 SELECT a.name,
 (IF(hour(c.start) BETWEEN '6' AND '20' , 'Day' ,'Night')) AS day_time,
 c.bill, cl.full_name, ca.make, ca.model,
 cat.name AS category_name
 FROM addresses AS a
 JOIN courses AS c
 ON a.id = c. from_address_id
 JOIN clients AS cl
 ON cl.id = c.client_id
 JOIN cars AS ca
 ON ca.id = c.car_id
 JOIN categories AS cat
 ON cat.id = ca.category_id
 -- WHERE (DAY(c.start) BETWEEN 6 AND 20) AND (TIME(c.start) BETWEEN 21 AND 5)
 ORDER BY c.id;
 
-- 10. Find all courses by client’s phone number
 
-- SELECT COUNT(co.id) FROM clients AS c
-- JOIN courses AS co
-- ON c.id = co.client_id
-- WHERE c.phone_number = '(803) 6386812'
-- GROUP BY c.id;

DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20)) 
RETURNS INT
DETERMINISTIC
BEGIN
 DECLARE result INT;
SET result := (
SELECT COUNT(co.id) FROM clients AS c
JOIN courses AS co
ON c.id = co.client_id
WHERE c.phone_number = phone_num
GROUP BY c.id
);
RETURN result;
END $$
DELIMITER ;

-- 11. Full info for address

SELECT a.name, cl.full_name AS full_names, 
( CASE
WHEN c.bill <= 20 THEN 'Low'
WHEN c.bill <= 30 Then 'Medium'
ELSE 'High'
END) AS level_of_bill,
ca.make, ca.condition, cat.name AS car_name   FROM addresses AS a
JOIN courses AS c
ON a.id = c.from_address_id
JOIN clients AS cl
ON cl.id = c.client_id
JOIN cars AS ca
ON ca.id = c.car_id
JOIN categories AS cat
ON cat.id = ca.category_id
WHERE a.name = '700 Monterey Avenue'
ORDER BY ca.make, cl.full_name;


DELIMITER $$
CREATE PROCEDURE udp_courses_by_address(address_name VARCHAR(100))
BEGIN
 SELECT a.name, cl.full_name AS full_names, 
( CASE
WHEN c.bill <= 20 THEN 'Low'
WHEN c.bill <= 30 Then 'Medium'
ELSE 'High'
END) AS level_of_bill,
ca.make, ca.condition, cat.name AS car_name   FROM addresses AS a
JOIN courses AS c
ON a.id = c.from_address_id
JOIN clients AS cl
ON cl.id = c.client_id
JOIN cars AS ca
ON ca.id = c.car_id
JOIN categories AS cat
ON cat.id = ca.category_id
WHERE a.name = address_name
ORDER BY ca.make, cl.full_name;
END $$
DELIMITER ;


-- 02. Insert
INSERT INTO clients (full_name, phone_number)
 (SELECT 
 concat_ws(' ', d.first_name, d.last_name),
 concat('(088) 9999', d.id * 2)
 FROM drivers AS d
 WHERE d.id BETWEEN 10 AND 20);


-- 03. Update

UPDATE cars
SET `condition` = 'C'
WHERE (mileage >= 800000 OR mileage IS NULL) AND year <= 2010;

-- 04. Delete

DELETE c FROM clients AS c
LEFT JOIN courses AS co
ON c.id = co.client_id
WHERE length(c.full_name) > 3 AND co.id IS NULL;

 
 












 
 
