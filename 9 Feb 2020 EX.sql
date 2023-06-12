-- 9 Feb 2020
CREATE DATABASE fsd;
USE fsd;

-- 01. Table Design

CREATE TABLE countries(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
country_id INT(11) NOT NULL,
CONSTRAINT fk_towns_countries
FOREIGN KEY (country_id)
REFERENCES countries(id)
);

CREATE TABLE stadiums(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
capacity INT(11) NOT NULL,
town_id INT(11) NOT NULL,
CONSTRAINT fk_stadiums_towns
FOREIGN KEY (town_id)
REFERENCES towns(id)
);


CREATE TABLE teams(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT(20) NOT NULL DEFAULT 0,
stadium_id INT(11),
CONSTRAINT fk_teams_stadiums
FOREIGN KEY (stadium_id)
REFERENCES stadiums(id)
);

CREATE TABLE skills_data(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
dribbling INT(11) DEFAULT 0,
pace INT(11) DEFAULT 0,
passing INT(11) DEFAULT 0,
shooting INT(11) DEFAULT 0,
speed INT(11) DEFAULT 0,
strength INT(11) DEFAULT 0
);

CREATE TABLE coaches(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
coach_level INT(11) NOT NULL DEFAULT 0
);

CREATE TABLE players(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
age INT(11) NOT NULL DEFAULT 0,
`position` CHAR(1) NOT NULL,
salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
hire_date DATETIME,
skills_data_id INT(11) NOT NULL,
team_id INT(11),
CONSTRAINT fk_players_teams
FOREIGN KEY (team_id)
REFERENCES teams(id),
CONSTRAINT fk_players_skills_data
FOREIGN KEY (skills_data_id)
REFERENCES skills_data(id)
 );

CREATE TABLE players_coaches(
player_id INT(11),
coach_id INT(11),
CONSTRAINT fk_players_coaches__players
FOREIGN KEY (player_id)
REFERENCES players(id),
CONSTRAINT fk_players_coaches__coaches
FOREIGN KEY (coach_id)
REFERENCES coaches(id)
);

-- 05. Players

 SELECT first_name, age, salary FROM players
 ORDER BY salary DESC;

-- 06. Young offense players without contract

SELECT p.id, 
concat_ws(' ', p.first_name, p.last_name) AS full_name,
p.age, p.`position`, p.hire_date
FROM players AS p
JOIN skills_data AS sd
ON sd.id = p.skills_data_id
WHERE p.hire_date IS NULL AND p.`position` = 'A' AND p.age < 23
AND sd.strength > 50
ORDER BY p.salary, p.age;

-- 07. Detail info for all teams

SELECT t.name AS team_name,
t.established,
t.fan_base,
COUNT(p.id) AS players
FROM teams AS t
LEFT JOIN players AS p
ON t.id = p.team_id
GROUP BY t.id
ORDER BY players DESC, t.fan_base DESC;

 -- 08. The fastest player by towns
 
 SELECT MAX(sd.speed) AS max_speed, t.name AS town_name FROM towns AS t
 LEFT JOIN stadiums AS s
 ON t.id = s.town_id
 LEFT JOIN teams AS te
 ON te.stadium_id = s.id
 LEFT JOIN players AS p
 ON p.team_id = te.id
 LEFT JOIN skills_data AS sd
 ON sd.id = p.skills_data_id
 WHERE te.name NOT IN ('Devify')
 GROUP BY t.name
 ORDER BY max_speed DESC, t.name;

-- 09. Total salaries and players by country

SELECT c.name,
COUNT(p.id) AS total_count_of_players,
SUM(p.salary) AS total_sum FROM countries AS c
LEFT JOIN towns AS t
ON c.id = t.country_id
LEFT JOIN stadiums AS s
 ON t.id = s.town_id
 LEFT JOIN teams AS te
 ON te.stadium_id = s.id
 LEFT JOIN players AS p
 ON p.team_id = te.id
 GROUP BY c.id
 ORDER BY total_count_of_players DESC, c.name;


-- 10. Find all players that play on stadium

-- SELECT COUNT(p.id) FROM stadiums AS s
-- LEFT JOIN teams AS t
-- ON s.id = t.stadium_id
-- LEFT JOIN players AS p
-- ON p.team_id = t.id
-- WHERE s.name = 'Jaxworks'
-- GROUP BY s.id;

DELIMITER $$
CREATE FUNCTION udf_stadium_players_count(stadium_name VARCHAR(30)) 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE result INT;
SET result := (
	SELECT COUNT(p.id) FROM stadiums AS s
	LEFT JOIN teams AS t
	ON s.id = t.stadium_id
	LEFT JOIN players AS p
	ON p.team_id = t.id
	WHERE s.name = stadium_name
	GROUP BY s.id
	);
RETURN result;    
END $$
DELIMITER ;
 
 -- 11. Find good playmaker by teams
 
-- SELECT concat_ws(' ', p.first_name, p.last_name) AS full_name,
--      p.age, p.salary,
--      sd.dribbling,
--      sd.speed, t.name AS team_name FROM skills_data AS sd
-- 	 LEFT JOIN players AS p
-- 	 ON sd.id = p.skills_data_id
-- 	 LEFT JOIN teams AS t
-- 	 ON p.team_id = t.id
-- 	 WHERE sd.dribbling > 20 AND t.name ='Skyble'
--       AND sd.speed > (SELECT AVG(speed) FROM skills_data)
--      ORDER BY sd.speed DESC
--      LIMIT 1;
 
 DELIMITER $$
 CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
 BEGIN
	 SELECT concat_ws(' ', p.first_name, p.last_name) AS full_name,
     p.age, p.salary,
     sd.dribbling,
     sd.speed, t.name AS team_name FROM skills_data AS sd
	 JOIN players AS p
	 ON sd.id = p.skills_data_id
	 JOIN teams AS t
	 ON p.team_id = t.id
	 WHERE sd.dribbling > min_dribble_points AND t.name = team_name
     AND sd.speed > (SELECT AVG(speed) FROM skills_data)
     ORDER BY sd.speed DESC
     LIMIT 1;
 END $$
 DELIMITER ;
 
 -- 02. Insert
 INSERT INTO coaches (first_name, last_name, salary, coach_level)
 (SELECT p.first_name,
 p.last_name,
 p.salary * 2,
 length(p.first_name)
 FROM players AS p
 WHERE p.age >= 45);
 
 -- 03. Update
 
 UPDATE coaches AS c
 JOIN players_coaches AS pc
 ON c.id = pc.coach_id
 SET c.coach_level = c.coach_level + 1
 WHERE c.first_name LIKE 'A%';
 
 -- 04. Delete
 
 DELETE p FROM players AS p
 LEFT JOIN players_coaches AS pc
 ON p.id = pc.player_id
 LEFT JOIN coaches AS c
 ON c.id = pc.coach_id
 WHERE p.first_name = c.first_name AND p.last_name = c.last_name;
 
 DELETE FROM players
WHERE EXISTS (
    SELECT *
    FROM coaches
    WHERE players.first_name = coaches.first_name
    AND players.last_name = coaches.last_name
);
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 