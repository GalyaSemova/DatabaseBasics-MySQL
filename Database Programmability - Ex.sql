# Database Programmability - Ex
# 01. Employees with Salary Above 35000

-- Create stored procedure usp_get_employees_salary_above_35000 that returns all employees' first and last
-- names for whose salary is above 35000. The result should be sorted by first_name then by last_name
-- alphabetically, and id ascending.



DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name, last_name FROM employees
	WHERE salary > 35000
	ORDER BY first_name, last_name, employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above_35000();

-- 02. Employees with Salary Above Number
-- Create stored procedure usp_get_employees_salary_above that accept a decimal number (with precision, 4
-- digits after the decimal point) as parameter and return all employee's first and last names whose salary is above or
-- equal to the given number. The result should be sorted by first_name then by last_name alphabetically and id
-- ascending.

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary_limit DECIMAL(19, 4))
BEGIN
	SELECT first_name, last_name FROM employees
	WHERE salary >= salary_limit
	ORDER BY first_name, last_name, employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above(45000);

-- 03. Town Names Starting With
-- stored procedure usp_get_towns_starting_with that accept string as parameter and returns all town
-- names starting with that string. The result should be sorted by town_name alphabetically.


DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with (starts_with VARCHAR(50))
BEGIN
	SELECT `name` AS town_name FROM towns
	WHERE `name` LIKE concat(starts_with, '%') 
	ORDER BY `name`;
END $$
DELIMITER ;

CALL usp_get_towns_starting_with('b');

-- 04. Employees from Town
-- stored procedure usp_get_employees_from_town that accepts town_name as parameter and return
-- the employees' first and last name that live in the given town. The result should be sorted by first_name then by
-- last_name alphabetically and id ascending



DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(50))
BEGIN
	SELECT e.first_name, e.last_name FROM employees AS e
	JOIN addresses AS a
	ON e.address_id = a.address_id
	JOIN towns AS t
	ON t.town_id = a.town_id
	WHERE t.name = town_name
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_from_town ('Sofia');

-- 05. Salary Level Function
-- a function ufn_get_salary_level that receives salary of an employee and returns the level of the salary.
-- • If salary is < 30000 return "Low"
-- • If salary is between 30000 and 50000 (inclusive) return "Average"
-- • If salary is > 50000 return "High"



CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19, 4))
RETURNS VARCHAR(7)
DETERMINISTIC
RETURN (
	 CASE 
	 WHEN salary < 30000 THEN 'Low'
	 WHEN salary BETWEEN 30000 AND 50001  THEN 'Average'
	 ELSE 'High'
	 END);
     
     
SELECT  ufn_get_salary_level(200);

-- 06. Employees by Salary Level
-- stored procedure usp_get_employees_by_salary_level that receive as parameter level of salary
-- (low, average or high) and print the names of all employees that have given level of salary. The result should be
-- sorted by first_name then by last_name both in descending order.
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(7))
BEGIN
	SELECT first_name, last_name
	FROM employees
	WHERE (salary < 30000 AND salary_level = 'Low')
	OR (salary >= 30000 AND salary <=50000 AND salary_level = 'Average')
	OR (salary > 50000 AND salary_level = 'High')
	ORDER BY first_name DESC, last_name DESC;
END $$
DELIMITER ;

CALL usp_get_employees_by_salary_level('Low');

-- 07. Define Function
-- Define a function ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50)) that
-- returns 1 or 0 depending on that if the word is a comprised of the given set of letters. 

CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
DETERMINISTIC
RETURN word REGEXP(concat('^[', set_of_letters, ']+$'));

SELECT ufn_is_word_comprised('nikolaissss', 'test');

-- PART II – Queries for Bank Database

-- 08. Find Full Name
-- • account_holders(id (PK), first_name, last_name, ssn)
-- and
-- • accounts(id (PK), account_holder_id (FK), balance)
-- Write a stored procedure usp_get_holders_full_name that selects the full names of all people. The result should be
-- sorted by full_name alphabetically and id ascending.
 
 DELIMITER $$
 CREATE PROCEDURE usp_get_holders_full_name()
 BEGIN
	 SELECT concat_ws(' ', first_name, last_name) 
	 AS full_name 
	 FROM account_holders
	 ORDER BY full_name, id;
 END $$
 DELIMITER ;
 
 CALL usp_get_holders_full_name();
 
 -- 9. People with Balance Higher Than 
--  create a stored procedure usp_get_holders_with_balance_higher_than that accepts a
-- number as a parameter and returns all people who have more money in total of all their accounts than the
-- supplied number. The result should be sorted by account_holders.id ascending. 
 
 DELIMITER $$
 CREATE PROCEDURE usp_get_holders_with_balance_higher_than(number DECIMAL(19,4))
 BEGIN
	 SELECT ah.first_name, ah.last_name FROM account_holders AS ah
	 JOIN accounts AS a
	 ON ah.id = a.account_holder_id
	 GROUP BY a.account_holder_id
	 HAVING SUM(a.balance) > number
	 ORDER BY a.account_holder_id;
 END $$
 DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

-- 10. Future Value Function
-- create a function ufn_calculate_future_value that accepts as parameters – sum (with
-- precision, 4 digits after the decimal point), yearly interest rate (double) and number of years(int). It should
-- calculate and return the future value of the initial sum. The result from the function must be decimal, with
-- percision 4.  


CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19, 4), 
yearly_interest_rate DOUBLE, years INT)
RETURNS  DECIMAL(19,4)
DETERMINISTIC
RETURN sum * pow((1 + yearly_interest_rate), years);

SELECT ufn_calculate_future_value(1000, 0.5, 5);

-- 11. Calculating Interest
-- stored procedure usp_calculate_future_value_for_account that accepts as
-- parameters – id of account and interest rate. The procedure uses the function from the previous problem to give
-- an interest to a person's account for 5 years, along with information about his/her account id, first name, last name
-- and current balance as it is shown in the example below. It should take the account_id and the interest_rate as
-- parameters. Interest rate should have precision up to 0.0001, same as the calculated balance after 5 years. 

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT, interest_per_year DECIMAL(19,4))
BEGIN
	SELECT a.id, ah.first_name, ah.last_name, a.balance AS current_balance, 
	ufn_calculate_future_value(a.balance, interest_per_year, 5) AS balance_in_5_years   
    FROM accounts AS a
	JOIN account_holders AS ah
	ON ah.id = a.account_holder_id
    WHERE a.id = account_id;
END $$
DELIMITER ;

CALL usp_calculate_future_value_for_account(1, 0.1);

-- 12. Deposit Money
-- stored procedure usp_deposit_money(account_id, money_amount) that operate in transactions.
-- Make sure to guarantee valid positive money_amount with precision up to fourth sign after decimal point. The
-- procedure should produce exact results working with the specified precision.

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
	CASE WHEN money_amount < 0 
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts as a 
		SET a.balance = a.balance + money_amount
        	WHERE a.id = account_id;
	END CASE;
COMMIT;
END $$
DELIMITER ;

-- 13. Withdraw Money
-- stored procedures usp_withdraw_money(account_id, money_amount) that operate in transactions.
-- Make sure to guarantee withdraw is done only when balance is enough and money_amount is valid positive
-- number. Work with precision up to fourth sign after decimal point.

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
	CASE WHEN money_amount < 0 || money_amount > (SELECT a.balance FROM accounts as a
						      WHERE a.id = account_id)
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts as a 
		SET a.balance = a.balance - money_amount
        	WHERE a.id = account_id;
	END CASE;
COMMIT;
END $$
DELIMITER 

-- 14. Money Transfer
-- stored procedure usp_transfer_money(from_account_id, to_account_id, amount) that
-- transfers money from one account to another. Consider cases when one of the account_ids is not valid, the
-- amount of money is negative number, outgoing balance is enough or transferring from/to one and the same
-- account. Make sure that the whole procedure passes without errors and if error occurs make no change in the
-- database. 

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19, 4))
BEGIN 
START TRANSACTION;
	CASE WHEN from_account_id < 0 || to_account_id < 0 || amount <= 0 || amount > (SELECT a.balance FROM accounts as a
								  WHERE a.id = from_account_id)
		THEN ROLLBACK;
	ELSE
		UPDATE accounts as a 
			SET a.balance = a.balance - amount
				WHERE a.id = from_account_id;
		UPDATE accounts as a 
			SET a.balance = a.balance + amount
				WHERE a.id = to_account_id;
	END CASE;
COMMIT;
END $$
DELIMITER ;


-- 15. Log Accounts Trigger
-- Create another table – logs(log_id, account_id, old_sum, new_sum). Add a trigger to the accounts
-- table that enters a new entry into the logs table every time the sum on an account changes.

CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(19,4) NOT NULL,
new_sum DECIMAL(19,4) NOT NULL);

DELIMITER $$
CREATE TRIGGER log_balance_changes AFTER UPDATE ON accounts 
FOR EACH ROW
BEGIN
	CASE WHEN OLD.balance != NEW.balance THEN 
		INSERT INTO `logs`(account_id, old_sum, new_sum)
		VALUES (OLD.id, OLD.balance, NEW.balance);
	ELSE
		BEGIN END;
	END CASE;
END $$
DELIMITER ;

-- 16. Emails Trigger 
-- table – notification_emails(id, recipient, subject, body). Add a trigger to logs table
-- to create new email whenever new record is inserted in logs table. The following data is required to be filled for
-- each email:
-- • recipient – account_id
-- • subject – "Balance change for account: {account_id}"
-- • body - "On {date (current date)} your balance was changed from {old} to {new}."

CREATE TABLE notification_emails(
id INT PRIMARY KEY AUTO_INCREMENT,
recipient INT NOT NULL,
subject VARCHAR(50) NOT NULL,
body TEXT NOT NULL);

DELIMITER $$
CREATE TRIGGER create_notification_email AFTER INSERT ON `logs` 
FOR EACH ROW
BEGIN 
	INSERT INTO notification_emails (recipient, subject, body)
	VALUES (NEW.account_id, CONCAT('Balance change for account: ', NEW.account_id),
	CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y'), ' at ', DATE_FORMAT(NOW(), '%r'),
	' your account balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.'));
END $$
DELIMITER ;































