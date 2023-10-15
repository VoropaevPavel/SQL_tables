create table if not exists album (
	id SERIAL primary key,
	name VARCHAR (60) not null,
	release_yaer INTEGER not null
);

create table if not exists song (
	id SERIAL primary key,
	name VARCHAR (60) not null, 
	duration TIME not null,
	album_id INTEGER not null references album(id)
);

create table if not exists artist (
	id SERIAL primary key,
	name VARCHAR (60) not null
);

create table if not exists genre (
	id SERIAL primary key,
	name VARCHAR (60) not null
);

create table if not exists collection (
	id SERIAL primary key,
	name VARCHAR (60) not null,
	release_yaer INTEGER not null
);

create table if not exists artist_genre (
	genre_id INTEGER not null references genre(id),
	artist_id INTEGER not null references artist(id)
);

create table if not exists artist_album (
	album_id INTEGER not null references album(id),
	artist_id INTEGER not null references artist(id)
);

create table if not exists song_collection (
	song_id INTEGER not null references song(id),
	collection_id INTEGER not null references collection(id)
);
