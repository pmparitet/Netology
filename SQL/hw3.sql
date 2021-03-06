--задача
SELECT
    userId,
    movieId,
    (rating - MIN(rating) OVER (PARTITION BY userId))/(MAX(rating) OVER (PARTITION BY userId) - MIN(rating) OVER (PARTITION BY userId)) normed_rating,
    rating - AVG(rating) OVER (PARTITION BY userId) avg_rating
FROM public.ratings
WHERE userId IN (
    SELECT
        userId
    FROM ratings
    GROUP BY userId
    HAVING COUNT(rating) > 1 and MAX(rating) > MIN(rating)
)
ORDER BY userId, rating DESC
LIMIT 30;

--создание таблицы
psql -c '
  CREATE TABLE IF NOT EXISTS keywords_hw3 (
    Id bigint,
    tags text
  );'

--заполнение таблицы
psql -c "\\copy keywords_hw3 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER"

--проверка кол-во записей
SELECT
    COUNT(id) as count_id,
    COUNT(DISTINCT id) as distinct_id,
    COUNT(tags) as count_tags
FROM public.keywords_hw3;

--Transform запрос1 запрос2
WITH top_rated
AS (
    SELECT
        movieId,
        AVG (rating) as avg_rating
    FROM public.ratings
    GROUP BY movieId
    HAVING COUNT(rating) > 50
    ORDER BY avg_rating DESC, movieid
    LIMIT 150
    )
SELECT id,
avg_rating,
tags
FROM public.keywords_hw3
JOIN top_rated
    ON top_rated.movieId=keywords_hw3.id
ORDER BY avg_rating DESC, movieid
LIMIT 10;

--Load запрос3
WITH top_rated
AS (
    SELECT
        movieId,
        AVG (rating) as avg_rating
    FROM public.ratings
    GROUP BY movieId
    HAVING COUNT(rating) > 50
    ORDER BY avg_rating DESC, movieid
    LIMIT 150
    )
SELECT
id,
avg_rating,
tags
INTO top_rated_tags
FROM public.keywords_hw3
JOIN top_rated
    ON top_rated.movieId=keywords_hw3.id
ORDER BY avg_rating DESC, movieid
;

--выгрузка
\copy (SELECT * FROM top_rated_tags) TO '/usr/local/share/netology/top_rated_tags1.csv' WITH CSV HEADER DELIMITER as E'\t';
