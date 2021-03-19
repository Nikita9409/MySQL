/*Получим список актеров для фильмы с id = 82*/


SELECT
	concat(a_d.firstname, ' ', a_d.lastname) AS fullname,
	a_d.status, 
	m.title AS title_movie
FROM actors_and_directors AS a_d
JOIN movies AS m ON m.id = a_d.movie_id
WHERE m.id = 82 AND a_d.status = 'actor';



/* Получим комментарии для всех новостей */

SELECT
	n.id AS news_id,
	n.title AS news_title,
	concat(u.firstname, ' ', u.lastname) AS user_full_name,
	c.comment AS user_comment,
	c.created_at AS comment_created_at
FROM news AS n
JOIN comments AS c ON n.id = c.news_id
JOIN users AS u ON u.id = c.user_id
ORDER BY n.id
;



/*Получим 10 самых молодых режиссеров  от 18-и лет и их фильмы */

SELECT
	concat(a_d.firstname, ' ', a_d.lastname) AS full_name,
	a_d.status,
	a_d.country,
	TIMESTAMPDIFF(YEAR, a_d.birthday, NOW()) AS age,
	m.title AS movie_title,
	movie_year,
	country_production
FROM actors_and_directors AS a_d
JOIN movies AS m ON m.id = a_d.movie_id
WHERE a_d.status = 'director'
AND TIMESTAMPDIFF(YEAR, a_d.birthday, NOW()) >= 18
ORDER BY age
LIMIT 10
;

/* Количество друзей у всех пользователей */

SELECT firstname, lastname, COUNT(*) AS total_friends
FROM users
JOIN friend_requests ON (users.id = friend_requests.initiator_user_id or users.id = friend_requests.target_user_id)
where friend_requests.status = 'approved'
GROUP BY users.id
ORDER BY total_friends DESC;






