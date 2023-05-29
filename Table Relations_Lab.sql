# Table Ralations Lab
-- 1. Mountains and Peaks
-- query to create two tables – mountains and peaks and link their fields properly. Tables should have:
-- - Mountains:
-- • id
-- • name
-- - Peaks:
-- • id
-- • name
-- • mountain_id

CREATE DATABASE mountains;
USE mountains;

CREATE TABLE mountains(
id INT AUTO_INCREMENT NOT NULL,
`name` VARCHAR(100) NOT NULL,
CONSTRAINT pk_mountains_id PRIMARY KEY (id)
);

INSERT INTO mountains (name)
VALUES ('Rila'),
('Pirin');

SELECT * FROM mountains;
CREATE TABLE peaks(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
`name` VARCHAR(100) NOT NULL,
mountain_id INT NOT NULL,
CONSTRAINT fk__peaks_mountain_id__mountains_id
FOREIGN KEY (mountain_id)
REFERENCES mountains(id));

INSERT INTO peaks (name, mountain_id)
VALUES ('Musala', 1),
('Vihren', 2);

SELECT * FROM peaks;

-- DATABASE camp 

-- 2. Trip Organization
-- query to retrieve information about  camp's 
-- transportation organization. Get information about the
-- drivers (name and id) and their vehicle type. 

SELECT driver_id, vehicle_type,
CONCAT_WS(' ', first_name, last_name) AS driver_name
FROM vehicles AS v
JOIN campers AS c
ON v.driver_id = c.id;

-- 3. SoftUni Hiking
--  Get information about the hiking routes – starting point and ending point, 
--  and their leaders – name and id. 

SELECT starting_point AS 'route_starting_point',
end_point AS 'route_ending_point',
leader_id,
CONCAT_WS(' ', first_name, last_name) AS leader_name
FROM routes AS r
JOIN  campers AS c
ON r.leader_id = c.id;

-- 4. Delete Mountains
 -- query to create a one-to-many relationship between a table, 
--  holding information about
-- mountains (id, name) and other - about peaks (id, name, mountain_id), 
-- so that when a mountain
-- gets removed from the database, all his peaks are deleted too. 

USE mountains;

DROP TABLE peaks;
DROP TABLE mountains;

 CREATE TABLE mountains(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
`name` VARCHAR(100) NOT NULL
);

INSERT INTO mountains (name)
VALUES ('Rila'),
('Pirin');

SELECT * FROM mountains;

CREATE TABLE peaks(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
`name` VARCHAR(100) NOT NULL,
mountain_id INT NOT NULL,
CONSTRAINT fk__peaks_mountain_id__mountains_id
FOREIGN KEY (mountain_id)
REFERENCES mountains(id)
ON DELETE CASCADE );

INSERT INTO peaks (name, mountain_id)
VALUES ('Musala', 1),
('Vihren', 2);

SELECT * FROM peaks;

-- 5. Project Management DB*

CREATE DATABASE project_management_db;
USE project_management_db;

CREATE TABLE clients(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
client_name VARCHAR(100)
);

CREATE TABLE projects(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
client_id INT,
project_lead_id INT,
CONSTRAINT fk_projects_client_id_clients_id
FOREIGN KEY (client_id)
REFERENCES clients(id)
);

CREATE TABLE employees(
id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT,
CONSTRAINT fk_employees_project_id_projects_id
FOREIGN KEY (project_id)
REFERENCES projects(id)
);


ALTER TABLE projects
ADD CONSTRAINT fk_projects_project_lead_id_employees_id
FOREIGN KEY (project_lead_id)
REFERENCES employees(id);






