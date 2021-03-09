/*3. Определить кто больше поставил лайков (всего) - мужчины или женщины?*/

SELECT 
	gender,
	COUNT(*) AS total_of_likes
FROM 
(SELECT user_id AS USER, 
(SELECT gender FROM profiles WHERE user_id = user) 
AS gender FROM likes ) AS total 	
	GROUP BY gender;

/*4. Подсчитать общее количество лайков десяти самым молодым пользователям 
(сколько лайков получили 10 самых молодых пользователей).*/

SELECT CONCAT('10 самых молодых пользователей получили ', 
	(SELECT COUNT(*) AS total FROM likes WHERE user_id IN (
	SELECT user_id FROM (
 	SELECT user_id, (YEAR(NOW()) - YEAR(birthday)) AS age FROM profiles WHERE user_id IN (
 	SELECT user_id FROM likes) ORDER BY age LIMIT 10) AS young)), 
 	' лайка') AS total; 
 	
