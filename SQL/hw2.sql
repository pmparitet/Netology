SELECT 'Морозов Александр Федорович';
-- 1. Простые выборки
-- 1.1 SELECT , LIMIT - выбрать 10 записей из таблицы rating (Для всех дальнейших запросов выбирать по 10 записей, если не указано иное)
SELECT *
FROM public.ratings
LIMIT 10;

-- 1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid оканчивается на "42", а поле movieid между 100 и 1000
SELECT *
FROM public.links
WHERE
    movieid >= '100'
    AND movieid < '1000'
    AND imdbid like '%42'
LIMIT 10;

-- 2. Сложные выборки: JOIN
-- 2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5
SELECT
    imdbid
FROM public.links
JOIN public.ratings
    ON links.movieid=ratings.movieid
WHERE ratings.rating =5
LIMIT 10;

-- 3. Аггрегация данных: базовые статистики
-- 3.1 COUNT() Посчитать число фильмов без оценок
SELECT
    COUNT(links.movieid) as count_movie_ratind_0
FROM public.links
LEFT JOIN public.ratings
    ON links.movieid=ratings.movieid
WHERE ratings.rating IS NULL
LIMIT 10;

-- 3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5
SELECT
    userId,
    COUNT(rating) as activity
FROM public.ratings
GROUP BY userId
HAVING AVG(rating) > 3.5
ORDER BY activity DESC
LIMIT 10;

-- 4. Иерархические запросы
-- 4.1 Подзапросы: достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.
SELECT
    imdbid
FROM public.links
WHERE movieId IN
    (
    SELECT movieId
    FROM public.ratings
    GROUP BY movieId
    HAVING AVG(rating) > 3.5
    )
LIMIT 10;

--4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок. Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие - то есть в ответе должно быть одно число.
WITH tmp_user10
AS (
    SELECT
    userid
    FROM public.ratings
    GROUP BY userid
    HAVING COUNT(rating) > 10
    )
SELECT
AVG(rating)
FROM public.ratings
WHERE ratings.userid IN (select userid from tmp_user10)
LIMIT 10;
