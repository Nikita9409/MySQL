/*1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.*/

SELECT * FROM users;
UPDATE users SET
	created_at = NOW() AND updated_at = NOW();

/*2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и 
в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
сохранив введённые ранее значения.*/

ALTER TABLE users MODIFY COLUMN created_at varchar(150);
ALTER TABLE users MODIFY COLUMN updated_at varchar(150);
INSERT INTO users (created_at, updated_at) VALUES ('20.10.2017 8:10', '20.10.2017 8:10');
UPDATE users
	SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i')
;
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


/*3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
0, если товар закончился и выше нуля, если на складе имеются запасы. 
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
Однако нулевые запасы должны выводиться в конце, после всех записей.*/

DROP TABLE IF EXISTS storehouses_products;
SELECT * FROM storehouses_products;
INSERT INTO storehouses_products (storehouse_id, product_id, value, created_at, updated_at) VALUES 
	(1, 1, 0, now(), now()),
	(2, 2, 2500, now(), now()),
	(3, 3, 0, now(), now()),
	(4, 4, 30, now(), now()),
	(5, 5, 500, now(), now())
;
SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 9999999 ELSE value END;

/*4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
Месяцы заданы в виде списка английских названий ('may', 'august')*/

SELECT * FROM users WHERE birthday_at RLIKE '^[0-9]{4}-(05|08)-[0-9]{2}';


/*1. Подсчитайте средний возраст пользователей в таблице users.*/


SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 0) AS AVG_Age FROM users;

/*2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/

SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day FROM users GROUP BY day;

