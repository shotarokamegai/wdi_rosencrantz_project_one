CREATE TABLE micro_posts (
	id serial primary key, 
	author_id integer, 
	title varchar(50), 
	content varchar(10000), 
	tag_name varchar(50), 
	created_at date, 
	image varchar(255));

CREATE TABLE authors (
	id serial primary key,
	name varchar(50),
	email varchar(50),
	micro_post_id integer
);

CREATE TABLE subscribers (
	id serial primary key,
	name varchar(50),
	phone_number integer
);

CREATE TABLE tags (
	id serial primary key,
	name varchar(50),
);








