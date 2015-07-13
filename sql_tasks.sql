# Schema
CREATE TABLE payments (
	`id` INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	`student_id` INT NOT NULL,
	`datetime` DATETIME NOT NULL,
	`amount` FLOAT DEFAULT 0,
	INDEX `student_id` (`student_id`)
);

CREATE TABLE student (
	`id` INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	`name` VARCHAR(20) NOT NULL,
	`surname` VARCHAR(20) DEFAULT '' NOT NULL,
	`gender` ENUM('male', 'female', 'unknown') DEFAULT 'unknown',
	INDEX `gender` (`gender`)
);

CREATE TABLE student_status (
	`id` INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	`student_id` INT NOT NULL,
	`status` ENUM('new', 'studying', 'vacation', 'testing', 'lost') DEFAULT 'new' NOT NULL,
	`datetime` DATETIME NOT NULL,
	INDEX `student_id` (`student_id`),
	INDEX `datetime` (`datetime`)
);





# Необходимо составить запрос, который находит пользователя, чья сумма платежей находится на втором месте после максимальной.
SELECT 
	student_id	
FROM `payments`
GROUP BY `student_id`
ORDER BY SUM(payments.`amount`) DESC
LIMIT 1,1
;

# Необходимо показать имена и фамилии всех студентов, чей пол до сих не известен (gender = 'unknown') и они сейчас находятся на каникулах (status = ‘vacation’).
SELECT
	`name`,
	`surname`
FROM `student` 
WHERE
	student.`gender` = 'unknown'
	AND 'vacation' = (
		SELECT student_status.`status`
		FROM `student_status`
		WHERE student_status.`student_id` = student.`id`
		ORDER BY student_status.`datetime` DESC
		LIMIT 1
	)
;

# Используя три предыдущие таблицы, найти имена и фамилии всех студентов, которые заплатили не больше трех раз и перестали учиться (status = ‘lost’). Нулевые платежи (amount = 0) не учитывать.
SELECT
	`name`,
	`surname`
FROM `student` 
WHERE
	'lost' = (
		SELECT student_status.`status`
		FROM `student_status`
		WHERE student_status.`student_id` =  student.`id`
		ORDER BY student_status.`datetime` DESC
		LIMIT 1
	)
	AND 3 >= (
		SELECT COUNT(id) AS 'quantity'
		FROM `payments`
		WHERE
			payments.`student_id`= student.`id`
			AND payments.`amount` > 0
	)
;

	
