USE vk;
SHOW tables;

SELECT * FROM users LIMIT 10;
UPDATE users SET
	updated_at = NOW() WHERE updated_at < created_at;


DESC profiles;
SELECT * FROM profiles LIMIT 10;
UPDATE profiles SET 
	updated_at = NOW() WHERE updated_at < created_at;


DESC messages;
SELECT * FROM messages LIMIT 10;
UPDATE messages SET 
	from_user_id = FLOOR(1 + RAND() * 100),
	to_user_id = FLOOR(1 + RAND() * 100);


DESC media;
SELECT * FROM media;
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
INSERT INTO extensions VALUES ('avi'), ('png'), ('mp3'), ('mpeg4'); 
SELECT * FROM extensions;
SELECT * FROM media_types;
TRUNCATE media_types;
INSERT INTO media_types (name) VALUES
	('audio'),
	('video'),
	('image');
UPDATE media SET 
	user_id = FLOOR(1 + RAND() * 100),
	filename = CONCAT(
	'http://dropbox.com/vk/', 
	filename,
	'.',
	(SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
	),
	media_type_id = FLOOR(1 + RAND() * 3),
		metadata = CONCAT(
	'{"owner":"',
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE media.user_id = users.id),
'"}'),
	SIZE = FLOOR(10000 + RAND() * 1000000) WHERE SIZE < 10000;


DESC frendship;
SELECT * FROM frendship;
ALTER TABLE frendship DROP COLUMN requested_at;
UPDATE frendship SET 
	user_id = FLOOR(1 + RAND() * 100),
	friend_id = FLOOR(1 + RAND() * 100),

SELECT * FROM friendship_statuses;
TRUNCATE friendship_statuses;
INSERT INTO friendship_statuses (name) VALUES
	('Requested'),
	('Confirmed'),
	('Rejected');
UPDATE frendship SET 
	friendship_status_id = FLOOR(1 + RAND() * 3);


SELECT * FROM communities;
DELETE FROM communities WHERE id > 20;
UPDATE communities SET
	owner_id = FLOOR(1 + RAND() * 100);
DESC communities_users;
SELECT * FROM communities_users;
UPDATE communities_users SET
	community_id = FLOOR(1 + RAND() * 20);








