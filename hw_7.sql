/*1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.*/

SELECT 
users.name,
COUNT(*) AS 'Колличество заказов'
FROM users
JOIN
orders
ON users.id = orders.user_id
GROUP BY users.id
;


/* 2.Выведите список товаров products и разделов catalogs, который соответствует товару.*/

SELECT 
  p.name AS product, c.name AS `catalog` 
FROM
  products AS p 
JOIN
  catalogs AS c
ON 
  c.id = p.catalog_id
; 


/*3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.*/

DROP TABLE IF EXISTS flights;
CREATE TABLE flights ( 
  id SERIAL PRIMARY KEY, 
  `from` VARCHAR(255) COMMENT 'Город отправления', 
  `to` VARCHAR(255) COMMENT 'Город прибытия' 
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities ( 
  id SERIAL PRIMARY KEY, 
  `label` VARCHAR(255) COMMENT 'Метка города по-английски', 
  `name` VARCHAR(255) COMMENT 'Название города по-русски' 
);

INSERT INTO flights (`from`, `to`) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');

INSERT INTO cities (`label`, `name`) VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
 
SELECT  
  flights.id, 
  (SELECT name FROM cities WHERE flights.from = cities.label) AS from_ru, 
  (SELECT name FROM cities WHERE  flights.to = cities.label) AS to_ru
FROM  
  flights
JOIN  
  cities
ON 
  flights.from = cities.label 
ORDER BY flights.id 
;


