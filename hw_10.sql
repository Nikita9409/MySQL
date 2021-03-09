/*1. Проанализировать какие запросы могут выполняться наиболее
часто в процессе работы приложения и добавить необходимые индексы.*/

/*Соц.сеть будет уведомлять своих пользователей о новых заявках в друзья. Поэтому будет выполняться запрос на поиск пользователя, 
у которого есть входящие заявки в друзья. Пример такого запроса:*/

SELECT friendship.friend_id, friendship.status_id 
	FROM 
		friendship 
			JOIN
        friendship_statuses 
        	ON friendship_statuses.id = friendship.status_id AND friendship_statuses.name = 'pend'
        	ORDER BY friendship.friend_id;
        

CREATE INDEX friendship_friend_id_status_id ON friendship(friend_id, status_id);

/*Для отображения медиа пользователя создами индекс для столбцов user_id и media_type_id:*/


CREATE INDEX media_media_id_media_type_ip ON media(user_id,media_type_id);



/*2. Задание на оконные функции
Построить запрос, который будет выводить следующие столбцы:
имя группы;
среднее количество пользователей в группах;
самый молодой пользователь в группе;
самый старший пользователь в группе;
общее количество пользователей в группе;
всего пользователей в системе;
отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.*/

SELECT
        DISTINCT communities.name,
        COUNT(communities_users.user_id) OVER () / (SELECT COUNT(*) FROM communities) AS avg_in_groups,
        FIRST_VALUE(communities_users.user_id) OVER (PARTITION BY communities.name ORDER BY profiles.birthday DESC) AS youngest,
        FIRST_VALUE(communities_users.user_id) OVER (PARTITION BY communities.name ORDER BY profiles.birthday) AS oldest,
        COUNT(communities_users.user_id) OVER(PARTITION BY communities.name) AS quantity_in_group,
        (SELECT COUNT(*) FROM users) AS quantity_all,
        100 * COUNT(communities_users.user_id) OVER (PARTITION BY communities.name) / (SELECT COUNT(*) FROM users) AS '%'
            FROM communities LEFT JOIN (profiles JOIN communities_users)
                ON communities.id = communities_users.community_id AND profiles.user_id = communities_users.user_id
                    WINDOW communities_name_win AS (PARTITION BY communities.name)
                ORDER BY communities.name;
