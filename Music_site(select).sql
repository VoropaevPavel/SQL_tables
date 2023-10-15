-- Задание 2
-- 1. Название и продолжительность самого длительного трека.
SELECT name, duration FROM song WHERE duration = (SELECT max(duration) FROM song);

-- 2. Название треков, продолжительность которых не менее 3,5 минут.
SELECT name FROM song WHERE duration >= '03:30:00';

-- 3. Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name, release_yaer FROM collection WHERE release_yaer BETWEEN '2018' AND '2020';

-- 4. Исполнители, чьё имя состоит из одного слова.
SELECT name FROM artist WHERE name NOT LIKE '%% %%';

-- 5. Название треков, которые содержат слово «мой» или «my».
SELECT name FROM song WHERE name iLIKE '%my%';


-- Задание 3
-- 1. Количество исполнителей в каждом жанре.
SELECT g.name, count(a.name) AS artist_in_genre FROM genre g 
JOIN artist_genre ag ON g.id = ag.genre_id 
JOIN artist a ON ag.artist_id = a.id 
GROUP BY g.name
ORDER BY count(artist_id) DESC;

-- 2. Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT a.name AS album, release_yaer, count(s.name) AS tracks_in_albums FROM album a 
JOIN song s ON s.album_id = a.id
GROUP BY a.name, a.release_yaer
HAVING a.release_yaer BETWEEN '2019' AND '2020';

-- 3. Средняя продолжительность треков по каждому альбому.
SELECT a.name AS a, avg(s.duration) AS average_songs_duration FROM album a
JOIN song s ON s.album_id = a.id 
GROUP BY a.name
ORDER BY avg(s.duration);

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT DISTINCT a.name AS a FROM artist a
WHERE a.name NOT IN
(SELECT DISTINCT a2.name AS a2 FROM artist a2 
JOIN artist_album aa ON a.id = aa.artist_id  
JOIN album ON aa.album_id = album.id
WHERE album.release_yaer = 2020)
ORDER BY a.name;

-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT c.name AS music_collection, a2.name AS artist FROM collection c 
LEFT JOIN song_collection sc ON c.id = sc.collection_id 
LEFT JOIN song s ON sc.song_id = s.id 
LEFT JOIN album a ON s.album_id = a.id 
LEFT JOIN artist_album aa ON a.id = aa.album_id 
LEFT JOIN artist a2 ON aa.artist_id  = a2.id
WHERE a2.id = 1
GROUP BY a2.name, c.name;


-- Задание 4
-- 1. Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT a.name AS album FROM album a
LEFT JOIN artist_album aa ON a.id = aa.album_id
LEFT JOIN artist a2 ON a2.id = aa.artist_id  
LEFT JOIN artist_genre ag ON a2.id = ag.artist_id
LEFT JOIN genre g ON g.id = ag.genre_id 
GROUP BY a.name
HAVING count(distinct g.name) > 1
ORDER BY a.name;

-- 2. Наименования треков, которые не входят в сборники.
SELECT s.name AS song FROM song s
WHERE NOT EXISTS
(SELECT FROM song_collection sc WHERE sc.song_id = s.id);

-- 3. Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT a.name AS singer, s.duration, s.name AS song FROM song s
LEFT JOIN album a2 ON a2.id = s.album_id
LEFT JOIN artist_album aa ON aa.album_id = a2.id
LEFT JOIN artist a ON a.id = aa.artist_id 
GROUP BY a.name, s.duration, s.name
HAVING s.duration = (SELECT min(duration) FROM song s2)
ORDER BY a.name; 

-- 4. Названия альбомов, содержащих наименьшее количество треков.
SELECT DISTINCT a.name AS album FROM album a
JOIN song s ON s.album_id = a.id
WHERE s.album_id IN
(SELECT album_id FROM song s2 
GROUP BY album_id
HAVING count (album_id) = (SELECT count(album_id) FROM song s3 
GROUP BY album_id
ORDER BY count(album_id)
LIMIT 1))
ORDER BY a.name;
