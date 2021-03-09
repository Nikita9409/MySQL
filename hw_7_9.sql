/*1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.*/

DROP TABLE IF EXISTS sample.users;

CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255),
birthday_at DATE DEFAULT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

START TRANSACTION;

INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;

DELETE FROM shop.users WHERE id = 1;

COMMIT;

/* 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.*/

CREATE VIEW prod_cat AS SELECT products.name AS prod_name,
catalogs.name AS cat_name FROM products JOIN catalogs ON products.catalog_id = catalogs.id;

SELECT * FROM prod_cat;


 /* 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
 с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

DROP PROCEDURE IF EXISTS hello;
delimiter //
CREATE PROCEDURE hello()
BEGIN
	IF(CURTIME() BETWEEN '06:00:00' AND '12:00:00') THEN
		SELECT 'Доброе утро';
	ELSEIF(CURTIME() BETWEEN '12:00:00' AND '18:00:00') THEN
		SELECT 'Добрый день';
	ELSEIF(CURTIME() BETWEEN '18:00:00' AND '00:00:00') THEN
		SELECT 'Добрый вечер';
	ELSE
		SELECT 'Доброй ночи';
	END IF;
END //
delimiter ;

CALL hello();

/* 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DROP TRIGGER IF EXISTS nulltr;
delimiter //
CREATE TRIGGER nulltr BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Предупреждение! Введено значение NULL';
	END IF;
END //
delimiter ;

 /*3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.*/

DROP FUNCTION IF EXISTS FIBONACCI;
delimiter //

CREATE FUNCTION FIBONACHI (num INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE fib0 INT DEFAULT 0;
	DECLARE fib1 INT DEFAULT 1;
	DECLARE fib INT;
	DECLARE i INT DEFAULT 1;
        
        IF num = 0 THEN
            RETURN fib0;
        END IF;
        IF num = 1 THEN
            RETURN fib1;
        END IF;
        
        WHILE i < num DO
            SET i = i + 1;
        SET fib = fib0 + fib1;
        SET fib0 = fib1;
        SET fib1 = fib;
    END WHILE;
        RETURN fib;
    END//
delimiter ;

