
-- 06 August 2021
CREATE DATABASE sgd;
USE sgd;

-- 01. Table Design

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(10) NOT NULL
);


CREATE TABLE offices(
id INT PRIMARY KEY AUTO_INCREMENT,
workspace_capacity INT NOT NULL,
website VARCHAR(50),
address_id INT NOT NULL,
CONSTRAINT fk_offices_addresses
FOREIGN KEY (address_id)
REFERENCES addresses(id)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
salary DECIMAL(10, 2) NOT NULL,
job_title VARCHAR(20) NOT NULL,
happiness_level CHAR(1) NOT NULL
);

CREATE TABLE teams(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
office_id INT NOT NULL,
leader_id INT NOT NULL UNIQUE,
CONSTRAINT fk_teams_offices
FOREIGN KEY (office_id)
REFERENCES offices(id),
CONSTRAINT fk_teams_employees
FOREIGN KEY (leader_id)
REFERENCES employees(id)
);

CREATE TABLE games(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL UNIQUE,
description TEXT,
rating FLOAT NOT NULL DEFAULT 5.5,
budget DECIMAL(10,2) NOT NULL,
release_date DATE,
team_id INT NOT NULL,
CONSTRAINT fk_games_teams
FOREIGN KEY (team_id)
REFERENCES teams(id)
);

CREATE TABLE games_categories(
game_id INT NOT NULL,
category_id INT NOT NULL,
PRIMARY KEY(game_id, category_id),
CONSTRAINT fk_games_categories__games
FOREIGN KEY (game_id)
REFERENCES games(id),
CONSTRAINT fk_games_categories__categories
FOREIGN KEY (category_id)
REFERENCES categories(id)
);

-- 02. Insert
INSERT INTO games (name, rating, budget, team_id)
SELECT 
	lower(reverse(substring(t.name, 2))),
	g.team_id,
	t.leader_id * 1000,
	t.id
FROM games AS g
 RIGHT JOIN teams AS t
 ON t.id = g.team_id
WHERE t.id BETWEEN 1 AND 9;

-- SELECT 
-- 	lower(reverse(substring(t.name, 2))),
--     t.id
-- FROM games AS g
-- JOIN teams AS t
--  ON t.id = g.team_id
-- WHERE t.id BETWEEN 1 AND 9
-- ORDER BY t.id;


-- 03. Update

UPDATE employees AS e
RIGHT JOIN teams AS t
ON e.id = t.leader_id
SET e.salary = e.salary + 1000
WHERE e.age < 40 AND e.salary < 5000;

-- 04. Delete

DELETE g FROM games AS g
LEFT JOIN games_categories AS gc
ON g.id = gc.game_id
WHERE g.release_date IS NULL AND gc.category_id IS NULL;

-- 05. Employees
 
SELECT first_name, last_name, age, salary, happiness_level FROM employees
ORDER BY salary, id;

 -- 06. Addresses of the teams
 
 SELECT t.name AS team_name,
 a.name AS address_name, char_length(a.name) AS count_of_characters 
 FROM teams AS t
 JOIN offices AS o
 ON t.office_id = o.id
 JOIN addresses AS a
 ON a.id = o.address_id
 WHERE o.website IS NOT NULL
 GROUP BY t.id
 ORDER BY t.name, a.name;
 
-- 07. Categories Info

SELECT c.name,
COUNT(g.id) AS games_count,
ROUND(AVG(g.budget), 2) AS avg_budget,
(MAX(g.rating)) AS max_rating
FROM categories AS c
JOIN games_categories AS gc
ON c.id = gc.category_id
JOIN games AS g
ON g.id = gc.game_id
GROUP BY c.id
HAVING max_rating >= 9.5
ORDER BY games_count DESC, c.name;

-- 08. Games of 2022
 SELECT g.name, g.release_date,
 CONCAT(SUBSTRING(g.description, 1, 10), '...') AS summary,
 (CASE
 WHEN MONTH(g.release_date) IN ('01', '02', '03') THEN 'Q1'
 WHEN MONTH(g.release_date) IN ('04', '05', '06') THEN 'Q2'
 WHEN MONTH(g.release_date) IN ('07', '08', '09') THEN 'Q3'
 ELSE 'Q4'
 END) AS quarter, 
 t.name AS team_name
 FROM games AS g 
 JOIN teams AS t
 ON g.team_id = t.id
 WHERE g.name LIKE '%2' AND MONTH(g.release_date)% 2 = 0 AND YEAR(g.release_date) = 2022
 ORDER BY quarter;

-- 09. Full info for games

 SELECT g.name,
 (IF(g.budget < 50000, 'Normal budget', 'Insufficient budget')) AS budget_level,
 t.name AS team_name,
 a.name AS address_name
 FROM games AS g
 LEFT JOIN games_categories AS gc
 ON g.id = gc.game_id
 JOIN teams AS t
 ON t.id = g.team_id
 JOIN offices AS o
 ON o.id = t.office_id
 JOIN addresses AS a
 ON a.id = o.address_id
 WHERE gc.category_id IS NULL AND g.release_date IS NULL
 ORDER BY g.name;

-- 10. Find all basic information for a game
-- o	The "game_name" is developed by a "team_name" in an office 
with an address "address_text"
 
 DELIMITER $$
 CREATE FUNCTION udf_game_info_by_name (game_name VARCHAR (20))
 RETURNS TEXT
 DETERMINISTIC
 BEGIN 
 DECLARE result TEXT;
 SET result := (
 SELECT 
 CONCAT('The ', g.name, ' is developed by a ', t.name, ' in an office with an address ', a.name) 
 FROM games AS g
 JOIN teams AS t
 ON t.id = g.team_id
 JOIN offices AS o
 ON o.id = t.office_id
 JOIN addresses AS a
 ON a.id = o.address_id
 WHERE g.name = game_name
 );
 RETURN result;
 END$$
 DELIMITER ;


SELECT udf_game_info_by_name('Bitwolf') AS info;
SELECT udf_game_info_by_name('Fix San') AS info;

-- 11. Update Budget of the Games

-- SELECT * FROM games AS g
-- LEFT JOIN games_categories AS gc
-- ON gc.game_id = g.id
-- WHERE gc.category_id IS NULL AND g.release_date IS NOT NULL;

DELIMITER $$
CREATE PROCEDURE udp_update_budget(min_game_rating FLOAT)
BEGIN
    UPDATE games AS g
    LEFT JOIN games_categories AS gc
    ON gc.game_id = g.id
    SET g.budget = g.budget + 100000, 
        g.release_date = DATE_ADD(g.release_date, INTERVAL 1 YEAR)
    WHERE gc.category_id IS NULL 
        AND g.release_date IS NOT NULL
        AND g.rating > min_game_rating;
END $$
DELIMITER ;

CALL udp_update_budget (8);




 


