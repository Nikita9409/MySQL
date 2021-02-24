/*4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).*/

select 
 (select count(*) 
  from likes 
  WHERE target_id in 
   (select * from 
    (select user_id 
    from profiles 
    order by birthday 
    limit 10) 
   as temp_tbl) 
  AND target_type_id = 
   (SELECT id FROM target_types WHERE name LIKE 'users')) AS total;
   
  
 /* 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети */
  
  
  
SELECT CONCAT(first_name, ' ', last_name) AS user,
  (SELECT COUNT(*) FROM media  WHERE media.user_id = users.id) +
  (SELECT COUNT(*) FROM likes  WHERE likes.user_id = users.id) + 	
  (SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) 
	AS activity 
	FROM users
	ORDER BY activity
	LIMIT 10;