/*3. Определить кто больше поставил лайков (всего) - мужчины или женщины?*/

SELECT 	p.gender, 
		COUNT(*) AS likes_num FROM
			profiles p 
		JOIN
			likes l
		ON l.user_id = p.user_id
		GROUP BY p.gender 
		ORDER BY likes_num DESC
		LIMIT 1;

/*4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).*/

  SELECT SUM(likes_all) AS likes_sum FROM
        (SELECT target_id, COUNT(*) AS likes_all
            FROM 
                    likes
                JOIN
                    (SELECT profiles.user_id FROM profiles 
                            ORDER BY birthday DESC 
                                LIMIT 10) AS young_10_users
                ON target_id = young_10_users.user_id
                    AND likes.target_type_id = 2
            GROUP BY young_10_users.user_id) AS likes_per_user;


  
 /* 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети */
  
  
  
SELECT 
        likes_user_id AS user_id,
        (SELECT CONCAT(users.first_name, ' ', users.last_name) FROM users WHERE users.id = user_id) AS username,
        likes_activity + media_activity + messages_activity AS overall_activity 
            FROM
                (SELECT users.id AS likes_user_id, IF (likes.user_id IS NULL, COUNT(*) - 1, COUNT(*)) AS likes_activity
                    FROM 
                        users LEFT JOIN likes
                            ON likes.user_id = users.id
                    GROUP BY users.id) AS likes_num
            JOIN 
                (SELECT users.id as media_user_id, IF (media.user_id IS NULL, COUNT(*) - 1, COUNT(*)) AS media_activity
                FROM 
                    users LEFT JOIN media 
                        ON media.user_id = users.id
                GROUP BY media_user_id) AS media_num
            JOIN
                (SELECT users.id as messages_user_id, IF (messages.from_user_id IS NULL, COUNT(*) - 1, COUNT(*)) AS messages_activity
                FROM 
                    users LEFT JOIN messages 
                        ON messages.from_user_id = users.id
                GROUP BY messages_user_id) AS messages_num
                ON messages_user_id = media_user_id AND likes_user_id = media_user_id
                ORDER BY overall_activity
                LIMIT 10;