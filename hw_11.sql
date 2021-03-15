/*1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи,
 *  название таблицы, идентификатор первичного ключа и содержимое поля name.*/


CREATE TABLE logs (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    table_name VARCHAR(100) NOT NULL COMMENT "Имя таблицы",
    name VARCHAR(100) NOT NULL COMMENT "Содержимое поля name из таблиц users, catalogs и products",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки"
    ) COMMENT="Журнал создания пользователей" ENGINE=Archive; 
    
    DROP TRIGGER IF EXISTS users_insert_logs;
    DROP TRIGGER IF EXISTS products_insert_logs;
    DROP TRIGGER IF EXISTS catalogs_insert_logs;
   
   DELIMITER //

    CREATE TRIGGER users_insert_logs AFTER INSERT ON users
    FOR EACH ROW 
    BEGIN 
        INSERT INTO logs(table_name, name) VALUES('users', NEW.name);
    END//

    CREATE TRIGGER products_insert_logs AFTER INSERT ON products
    FOR EACH ROW 
    BEGIN 
        INSERT INTO logs(table_name, name) VALUES('products', NEW.name);
    END//

    CREATE TRIGGER catalogs_insert_logs AFTER INSERT ON catalogs
    FOR EACH ROW 
    BEGIN 
        INSERT INTO logs(table_name, name) VALUES('catalogs', NEW.name);
    END//
    
    
/* 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.*/
    
    INSERT INTO users(name, birthday_at) 
    SELECT CONCAT('user_', k), DATE(CONCAT(2020 - FLOOR(1 + RAND() * 120),'-',FLOOR(1 + RAND() * 12),'-',FLOOR(1 + RAND() * 28)))
    FROM
        (SELECT a1.n + 10 * a2.n + 100 * a3.n + 1000 * a4.n + 10000 * a5.n + 100000 * a6.n AS k
            FROM
                (SELECT 9 AS n
                    UNION SELECT 8 
                    UNION SELECT 7 
                    UNION SELECT 6 
                    UNION SELECT 5 
                    UNION SELECT 4 
                    UNION SELECT 3 
                    UNION SELECT 2 
                    UNION SELECT 1 
                    UNION SELECT 0) AS a1
                    JOIN
                (SELECT 0 AS n
                    UNION SELECT 1 
                    UNION SELECT 2 
                    UNION SELECT 3 
                    UNION SELECT 4 
                    UNION SELECT 5 
                    UNION SELECT 6 
                    UNION SELECT 7 
                    UNION SELECT 8 
                    UNION SELECT 9) AS a2
                    JOIN
                (SELECT 9 AS n
                    UNION SELECT 8 
                    UNION SELECT 7 
                    UNION SELECT 6 
                    UNION SELECT 5 
                    UNION SELECT 4 
                    UNION SELECT 3 
                    UNION SELECT 2 
                    UNION SELECT 1 
                    UNION SELECT 0) AS a3
                    JOIN
                (SELECT 0 AS n
                    UNION SELECT 1 
                    UNION SELECT 2 
                    UNION SELECT 3 
                    UNION SELECT 4 
                    UNION SELECT 5 
                    UNION SELECT 6 
                    UNION SELECT 7 
                    UNION SELECT 8 
                    UNION SELECT 9) AS a4
                    JOIN
                (SELECT 9 AS n
                    UNION SELECT 8 
                    UNION SELECT 7 
                    UNION SELECT 6 
                    UNION SELECT 5 
                    UNION SELECT 4 
                    UNION SELECT 3 
                    UNION SELECT 2 
                    UNION SELECT 1 
                    UNION SELECT 0) AS a5
                    JOIN
                (SELECT 0 AS n
                    UNION SELECT 1 
                    UNION SELECT 2 
                    UNION SELECT 3 
                    UNION SELECT 4 
                    UNION SELECT 5 
                    UNION SELECT 6 
                    UNION SELECT 7 
                    UNION SELECT 8 
                    UNION SELECT 9) AS a6) AS num;
                  
                   
                   SELECT COUNT(*) FROM users;
                   
   
    