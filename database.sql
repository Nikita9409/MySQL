DROP DATABASE IF EXISTS kinopoisk;
CREATE DATABASE kinopoisk;
USE kinopoisk;

-- Создадим таблицу публичных данных пользователя
DROP TABLE IF EXISTS  users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100) NOT NULL,
	lastname VARCHAR(100) NOT NULL,
	email VARCHAR(100) UNIQUE,
	password_numb VARCHAR(100),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX users_firstname_lastname (firstname, lastname)
);

-- Создадим таблицу профиля пользователя с второстепенными данными
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id SERIAL PRIMARY KEY,
	gender ENUM('F', 'M'),
	birthday DATE,
	country VARCHAR(100),
	city VARCHAR(100),
	description_user TEXT,
	interests TEXT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE profiles 
ADD CONSTRAINT profiles_fk
	FOREIGN KEY (user_id) REFERENCES users(id);


-- Создадим таблицу друзей пользователей

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested', 'approved', 'declined', 'unfriended'),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (initiator_user_id, target_user_id),
	INDEX(initiator_user_id),
	INDEX(target_user_id)
);

ALTER TABLE friend_requests 
ADD CONSTRAINT friend_requests_fk
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
ADD CONSTRAINT friend_requests_fk_1
	FOREIGN KEY (target_user_id) REFERENCES users(id);

-- Создадим таблицу сообщений пользователей 1*M (один пользоматель может писать смс многим)
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL, -- Кто написал
	to_user_id BIGINT UNSIGNED NOT NULL, -- Кому написал
	body TEXT, -- Текст сообщения
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	INDEX (from_user_id),
	INDEX (to_user_id)
);

ALTER TABLE  messages 
ADD CONSTRAINT messages_fk
	FOREIGN KEY (from_user_id) REFERENCES users(id),
ADD CONSTRAINT messages_fk_1
	FOREIGN KEY (to_user_id) REFERENCES users(id);

-- Создадим табицу оценок фильмов
DROP TABLE IF EXISTS stars_movies;
CREATE TABLE stars_movies (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	stars INT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE stars_movies 
ADD CONSTRAINT stars_movies_fk
	FOREIGN KEY (user_id) REFERENCES users(id);		



-- Создадим таблицу фильмов
DROP TABLE IF EXISTS movies;
CREATE TABLE movies(
	id SERIAL PRIMARY KEY,
	stars_movie_id BIGINT UNSIGNED NOT NULL,
	movies_review_id BIGINT UNSIGNED NOT NULL,
	title VARCHAR(100) NOT NULL,
	movie_description TEXT,
	country_production VARCHAR(100) NOT NULL,
	movie_year YEAR,
	movie_genre ENUM('action', 'drama', 'comedy', 'horror', 'docudrama', 'detective', 'musical')
);

ALTER TABLE movies 
ADD CONSTRAINT movies_fk
	FOREIGN KEY (stars_movie_id) REFERENCES stars_movies(id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
ADD CONSTRAINT movies_fk_1
	FOREIGN KEY (movies_review_id) REFERENCES movie_reviews(id)
	ON DELETE RESTRICT
	ON UPDATE CASCADE;


DROP TABLE IF EXISTS movie_reviews;
CREATE TABLE movie_reviews (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
body TEXT,
type_review ENUM ('like', 'unlike'),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE movie_reviews 
ADD CONSTRAINT movie_reviews_fk
	FOREIGN KEY (user_id) REFERENCES users(id);	




DROP TABLE IF EXISTS actors_and_directors;
CREATE TABLE actors_and_directors (
	id SERIAL primary KEY,
	movie_id BIGINT UNSIGNED NOT NULL,
	firstname VARCHAR(100) NOT NULL,
	lastname VARCHAR(100) NOT NULL,
	birthday DATE,
	country VARCHAR(100) NOT NULL,
	status ENUM('actor', 'director')
);

ALTER TABLE actors_and_directors 
ADD CONSTRAINT actors_and_directors_fk
	FOREIGN KEY (movie_id) REFERENCES movies(id);	

CREATE INDEX `actors_and_directors_IDX`
USING BTREE ON actors_and_directors (movie_id, firstname, lastname);




DROP TABLE IF EXISTS news;
CREATE TABLE news (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	description TEXT,
	created_at DATE
);


DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	news_id BIGINT UNSIGNED NOT NULL,
	comment TEXT,
	created_at DATE
);

ALTER TABLE comments
ADD CONSTRAINT comments_fk
	FOREIGN KEY (news_id) REFERENCES news(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT comments_fk_1
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;


	
