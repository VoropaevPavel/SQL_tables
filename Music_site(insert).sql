INSERT INTO artist (name)
VALUES 
('Berlin'),
('Michael Jackson'),
('Whitney Houston'),
('Queen'),
('The Weekend'),
('Rammstein');

INSERT INTO album (name, release_yaer)
VALUES 
('Top Gun', '1986'),
('Thriller', '1982'),
('Whitney', '1987'),
('Bohemian Rhapsody', '1974'),
('Blinding Lights', '2020'),
('The Show Must Go On', '1991'),
('Rammstein', '2019');

INSERT INTO genre (name)
VALUES 
('Pop'),
('Rock'),
('Metal');

INSERT INTO song (name, duration, album_id)
VALUES 
('Take My Breath Away', '4:15', '1'),
('Billie Jean', '4:54', '2'),
('I Wanna Dance With Somebody', '4:52', '3'),
('Bohemian Rhapsody', '5:55', '4'),
('Blinding Lights', '3:21', '5'),
('The Show Must Go On', '4:23', '6'),
('Puppe', '4:33', '7'),
('Tattoo', '4:11', '7');

INSERT INTO collection (name, release_yaer)
VALUES 
('PopMusic', '2020'),
('Rocknrolla', '2023'),
('Lovely Days', '2022'),
('Work', '2022');

INSERT INTO song_collection (song_id, collection_id)
VALUES 
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(6, 2),
(7, 2),
(8, 2),
(2, 3),
(5, 3),
(2, 4),
(6, 4),
(8, 4);

INSERT INTO artist_genre (genre_id, artist_id)
values
(1, 1), (1, 2), (1, 3), (1, 5), (2, 4), (3, 6);

INSERT INTO artist_album (album_id, artist_id)
values
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 4), (7, 6);