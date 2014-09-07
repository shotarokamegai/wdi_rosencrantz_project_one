CREATE TABLE micro_posts (
	id serial primary key,
	title varchar(50),
	content text,
	tag_name varchar(50),
	created_at date,
	updated_at date
);

CREATE TABLE authors (
	id serial primary key,
	name varchar(50),
	email varchar(50),
	micro_post_id integer
);

CREATE TABLE snippets (
	id serial primary key,
	name varchar(50),
	url varchar(100),
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








