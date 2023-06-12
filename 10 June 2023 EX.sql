# 10 June 2023
CREATE DATABASE universities_db;
USE universities_db;

-- 01. Table Design

 CREATE TABLE countries(
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(40) NOT NULL UNIQUE
 );
 
 CREATE TABLE cities(
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(40) NOT NULL UNIQUE,
 population INT,
 country_id INT NOT NULL,
 CONSTRAINT fk_cities_countries
 FOREIGN KEY (country_id)
 REFERENCES countries(id)
 );
 
CREATE TABLE universities(
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(60) NOT NULL UNIQUE,
 address VARCHAR(80) NOT NULL UNIQUE,
 tuition_fee DECIMAL(19, 2) NOT NULL,
 number_of_staff INT,
 city_id INT,
 CONSTRAINT fk_universities_cities
 FOREIGN KEY (city_id)
 REFERENCES cities(id)
 );
 
 CREATE TABLE students(
 id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR(40) NOT NULL,
 last_name VARCHAR(40) NOT NULL,
 age INT,
 phone VARCHAR(20) NOT NULL UNIQUE,
 email VARCHAR(255) NOT NULL UNIQUE,
 is_graduated TINYINT(1) NOT NULL,
 city_id INT,
 CONSTRAINT fk_students_cities
 FOREIGN KEY (city_id)
 REFERENCES cities(id)
 );
 
 CREATE TABLE courses(
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(40) NOT NULL UNIQUE,
 duration_hours DECIMAL(19, 2),
 start_date DATE,
 teacher_name VARCHAR(60) NOT NULL UNIQUE,
 description TEXT,
 university_id INT,
 CONSTRAINT fk_courses_universities
 FOREIGN KEY (university_id)
 REFERENCES universities(id) 
 );
 
 CREATE TABLE students_courses(
 grade DECIMAL(19, 2) NOT NULL,
 student_id INT NOT NULL,
 course_id INT NOT NULL,
 CONSTRAINT fk_students_courses__students
 FOREIGN KEY (student_id)
 REFERENCES students(id),
CONSTRAINT fk_students_courses__courses
 FOREIGN KEY (course_id)
 REFERENCES courses(id)
 );
 
 -- 05. Cities
 
 SELECT id, name, population, country_id FROM cities
 ORDER BY population DESC;
 
 -- 06. Students age
 
 SELECT first_name,
 last_name, age, phone, email FROM students
 WHERE age >= 21
 ORDER BY first_name DESC, email, id
 LIMIT 10;
 
 -- 07. New students
 
 SELECT 
 concat_ws(' ', s.first_name, s.last_name) AS full_name,
 (substring(s.email, 2, 10)) AS username,
 (reverse(s.phone)) AS password
 FROM students AS s
 LEFT JOIN students_courses AS sc
 ON s.id = sc.student_id
 WHERE sc.course_id IS NULL
 ORDER BY password DESC;
 
 -- 08. Students count
 
 SELECT COUNT(sc.student_id) AS students_count, u.name AS university_name FROM universities AS u
 LEFT JOIN courses AS c
 ON u.id = c.university_id
 LEFT JOIN students_courses AS sc
 ON c.id = sc. course_id
 GROUP BY u.id
 HAVING students_count >= 8
 ORDER BY students_count DESC, university_name DESC;
 
 -- 09. Price rankings
 
 SELECT u.name AS university_name,
 c.name AS city_name,
 u.address, 
 ( CASE
 WHEN u.tuition_fee < 800 THEN 'cheap'
 WHEN u.tuition_fee >= 800 AND  u.tuition_fee < 1200 THEN 'normal'
 WHEN u.tuition_fee >= 1200 AND u.tuition_fee < 2500 THEN 'high'
 WHEN u.tuition_fee >= 2500  THEN 'expensive'
 END ) AS price_rank
 ,u.tuition_fee FROM universities AS u
 JOIN cities AS c
 ON u.city_id = c.id
 ORDER BY u.tuition_fee;
 
 -- 10. Average grades
 
--  SELECT AVG(sc.grade) FROM courses AS c
--  JOIN students_courses AS sc
--  ON c.id = sc.course_id
--  JOIN students AS s
--  ON s.id = sc.student_id
--  WHERE c.name = 'Quantum Physics' AND s.is_graduated = 1
--  GROUP BY c.id;
 
 DELIMITER $$
 CREATE FUNCTION udf_average_alumni_grade_by_course_name(course_name VARCHAR(60)) 
 RETURNS DECIMAL (10, 2)
 DETERMINISTIC
 BEGIN
 DECLARE result DECIMAL (10, 2);
 SET result := (
  SELECT AVG(sc.grade) FROM courses AS c
 JOIN students_courses AS sc
 ON c.id = sc.course_id
 JOIN students AS s
 ON s.id = sc.student_id
 WHERE c.name = course_name AND s.is_graduated = 1
 GROUP BY c.id);
 RETURN result;
 END $$
 DELIMITER ;
 
 -- 11. Graduate students
 
 
--  SELECT * FROM courses AS c
--  JOIN students_courses AS sc
--  ON c.id = sc.course_id
--  JOIN students AS s
--  ON s.id = sc.student_id
--  -- SET s.is_graduated = 1
--  WHERE YEAR(c.start_date) = 2017;
 
 DELIMITER $$
 CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
 BEGIN
	 UPDATE courses AS c
	 JOIN students_courses AS sc
	 ON c.id = sc.course_id
	 JOIN students AS s
	 ON s.id = sc.student_id
	 SET s.is_graduated = 1
	 WHERE YEAR(c.start_date) = year_started;
 END $$
 DELIMITER ;
 
 --  02. Insert
 
 INSERT INTO courses(name, duration_hours, start_date, teacher_name, description, university_id)
 (SELECT 
	concat_ws(' ', c.teacher_name, 'course'),
	char_length(c.name) / 10,
	date_add(c.start_date, INTERVAL 5 day) ,
	reverse(c.teacher_name),
	concat('Course ', c.teacher_name, reverse(c.description)),
	DAY(c.start_date)
	FROM courses AS c
	WHERE c.id  <= 5
 );

-- SELECT concat_ws(' ', c.teacher_name, 'course'),
-- char_length(c.name) / 10,
-- date_add(c.start_date, INTERVAL 5 day) ,
-- reverse(c.teacher_name),
-- concat('Course ', c.teacher_name, reverse(c.description)),
-- DAY(c.start_date)
--  FROM courses AS c
--  WHERE c.id  <= 5;

-- 03. Update

 UPDATE universities
 SET tuition_fee = tuition_fee + 300
 WHERE id BETWEEN 5 AND 12;
 
 -- 04. Delete
 
 DELETE u FROM universities AS u
 WHERE u.number_of_staff IS NULL;
 
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 