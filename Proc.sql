/* Создадим процедуру которая будет выводить из одного города и с общими друзьями */
DROP PROCEDURE IF EXISTS kinopoisk.frendship_offers;

DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE `kinopoisk`.`frendship_offers`(IN for_user_id INT)
BEGIN
	
	SELECT
		p2.user_id,
		concat(u.firstname, ' ', u.lastname) AS fullname
	FROM profiles AS p
	JOIN profiles AS p2 ON p.city = p2.city
	JOIN users AS u ON u.id = p.user_id
	WHERE p.user_id = for_user_id
		AND p2.user_id <> for_user_id
	GROUP BY u.id
		UNION
		

	SELECT
		fr3.target_user_id,
		concat(u.firstname, ' ', u.lastname) AS fullname
	FROM friend_requests AS fr
	JOIN friend_requests AS fr2 ON (fr.target_user_id = fr2.initiator_user_id
		OR fr.initiator_user_id = fr2.target_user_id)
	JOIN friend_requests AS fr3 ON (fr3.target_user_id = fr2.initiator_user_id
		OR fr3.initiator_user_id = fr2.target_user_id)
	JOIN users AS u ON u.id = fr2.initiator_user_id
		OR u.id = fr2.target_user_id
	WHERE fr2.status = 'approved' 
	AND fr3.status = 'approved'
	AND fr3.target_user_id <> for_user_id
	AND (fr.target_user_id = for_user_id
		OR fr.initiator_user_id = for_user_id) 
	order by rand() 
	limit 5  
	;
END//
DELIMITER ;


CALL kinopoisk.frendship_offers(1);


