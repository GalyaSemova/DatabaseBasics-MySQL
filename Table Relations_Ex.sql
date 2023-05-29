# Table Relations - EX

-- 1. One-To-One Relationship
CREATE DATABASE tableRelations;
USE tableRelations;

CREATE TABLE people(
person_id INT UNIQUE NOT NULL AUTO_INCREMENT,
first_name VARCHAR(50) NOT NUll,
salary DECIMAL(10,2) DEFAULT 0,
passport_id INT UNIQUE
);

CREATE TABLE passports (
passport_id INT PRIMARY KEY AUTO_INCREMENT,
passport_number VARCHAR(8) UNIQUE
);

ALTER TABLE people
ADD CONSTRAINT pk_people
PRIMARY KEY (person_id),
ADD CONSTRAINT fk_people_passports
FOREIGN KEY (passport_id)
REFERENCES passports(passport_id);

INSERT INTO passports(passport_id, passport_number)
VALUES
    (101, 'N34FG21B'),
    (102, 'K65LO4R7'),
    (103, 'ZE657QP2');
    
INSERT INTO people(person_id, first_name, salary, passport_id)   
VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101); 

-- 02. One-To-Many Relationship

CREATE TABLE manufacturers(
manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) UNIQUE NOT NULL,
established_on DATE NOT NULL
);

CREATE TABLE models (
model_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manufacturer_id INT,
CONSTRAINT fk_models_manufacturers
FOREIGN KEY (manufacturer_id)
REFERENCES manufacturers(manufacturer_id)
);

ALTER TABLE models AUTO_INCREMENT = 101;

-- 1 BMW 01/03/1916
-- 2 Tesla 01/01/2003
-- 3 Lada 01/05/1966

INSERT INTO manufacturers (name, established_on)
VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

-- 101 X1 1
-- 102 i6 1
-- 103 Model S 2
-- 104 Model X 2
-- 105 Model 3 2
-- 106 Nova 3

INSERT INTO models (name, manufacturer_id)
VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);


-- 03. Many-To-Many Relationship

CREATE TABLE students (
student_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE exams (
exam_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
 ) AUTO_INCREMENT = 101;

CREATE TABLE students_exams (
student_id INT,
exam_id INT,
CONSTRAINT pk_students_exam
PRIMARY KEY (student_id, exam_id),
CONSTRAINT fk_students_exams
FOREIGN KEY (exam_id)
REFERENCES exams(exam_id),
CONSTRAINT fk_exams_students
FOREIGN KEY (student_id)
REFERENCES students(student_id)
);
--  1 Mila
-- 2 Toni
-- 3 Ron

INSERT INTO students (name)
VALUES ('Mila'),
('Toni'),
('Ron');

-- 101 Spring MVC
-- 102 Neo4j
-- 103 Oracle 11g

INSERT INTO exams (name)
VALUES ('Spring MVC'),
('Neo4j'),
('Oracle 11g');

-- 1 101
-- 1 102
-- 2 101
-- 3 103
-- 2 102
-- 2 103

INSERT INTO students_exams
VALUES (1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

-- 04. Self-Referencing

CREATE TABLE teachers (
teacher_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
manager_id INT 
) AUTO_INCREMENT = 101;

-- 101 John
-- 102 Maya 106
-- 103 Silvia 106
-- 104 Ted 105
-- 105 Mark 101
-- 106 Greta 101

INSERT INTO teachers (name, manager_id)
Values ('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101);

ALTER TABLE teachers
ADD CONSTRAINT fk_manager_id FOREIGN KEY(manager_id)
REFERENCES teachers(teacher_id)
ON DELETE NO ACTION;
SET FOREIGN_KEY_CHECKS=0;

-- 06. University Database

CREATE TABLE subjects (
subject_id INT PRIMARY KEY AUTO_INCREMENT,
subject_name VARCHAR(50)
);

CREATE TABLE majors (
major_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50)
);

CREATE TABLE students (
student_id INT PRIMARY KEY AUTO_INCREMENT,
student_number VARCHAR(12),
student_name VARCHAR(50),
major_id INT,
CONSTRAINT fk_students_majors
FOREIGN KEY (major_id)
REFERENCES majors(major_id)
);

CREATE TABLE payments (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
payment_date DATE,
payment_amount DECIMAL(8,2),
student_id INT,
CONSTRAINT fk_payments_students
FOREIGN KEY (student_id)
REFERENCES students(student_id)
);

CREATE TABLE agenda (
student_id INT,
subject_id INT,
CONSTRAINT pk_agenda PRIMARY KEY (student_id, subject_id),
CONSTRAINT fk_agenda_students
FOREIGN KEY (student_id)
REFERENCES students(student_id),
CONSTRAINT fk_agenda_subjects
FOREIGN KEY (subject_id)
REFERENCES subjects(subject_id)
);


-- 05. Online Store Database

create DATABASE store; 
USE store;

CREATE TABLE cities (
city_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50)
);

CREATE TABLE customers (
customer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50),
birthday DATE,
city_id INT,
CONSTRAINT fk_customers_cities
FOREIGN KEY (city_id)
REFERENCES cities(city_id)
);

CREATE TABLE orders (
order_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
customer_id INT,
CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
);

CREATE TABLE item_types (
item_type_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50)
);

CREATE TABLE items (
item_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
name VARCHAR(50),
item_type_id INT,
CONSTRAINT fk_items__item_types
FOREIGN KEY (item_type_id)
REFERENCES item_types(item_type_id)
);


CREATE TABLE order_items (
order_id INT,
item_id INT,
CONSTRAINT pk_order_items PRIMARY KEY (order_id, item_id),
CONSTRAINT fk_order_items__orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id),
CONSTRAINT fk_order_items__items
FOREIGN KEY (item_id)
REFERENCES items(item_id)
);


-- 09. Peaks in Rila
use geography;
 
SELECT 
    m.mountain_range,
    p.peak_name,
    p.elevation AS peak_elevation
FROM
    mountains AS m
        JOIN
    peaks AS p ON m.id = p.mountain_id
WHERE
    m.id = 17
ORDER BY `peak_elevation` DESC;



















 


 

