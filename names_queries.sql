-- ## SQL Names
-- Save a script containing the query you used to answer each question and your answer (as a comment).

-- 1. How many rows are in the names table?
SELECT COUNT(*) AS row_count
FROM names;
--1957046 rows in the table

-- 2. How many total registered people appear in the dataset?
SELECT SUM(num_registered) AS total_registered
FROM names;
-- 351653025 total registered

-- 3. Which name had the most appearances in a single year in the dataset?
SELECT name, num_registered, year
FROM names
ORDER BY 2 DESC;
-- Linda had the most appearances in the dataset (99689) in 1947

-- 4. What range of years are included?
SELECT MIN(year) AS min_year,
	MAX(year) AS max_year
FROM names;
-- the data ranges from 1880 to 2018

-- 5. What year has the largest number of registrations?
SELECT year, SUM(num_registered) AS total_registered
FROM names
GROUP BY 1
ORDER BY 2 DESC;
-- There were 4200022 registered in 1957

-- 6. How many different (distinct) names are contained in the dataset?
SELECT COUNT(DISTINCT name) AS name_count
FROM names;
-- There are 98400 distinct names in the dataset.

-- 7. Are there more males or more females registered?
SELECT gender, SUM(num_registered) AS total_registered
FROM names
GROUP BY 1;
-- There are about 3.5 million more males than females registered

-- 8. What are the most popular male and female names overall (i.e., the most total registrations)?
WITH males AS (
	SELECT name, gender, SUM(num_registered) AS num_registered
	FROM names
	WHERE gender = 'M'
	GROUP BY 1, 2
	ORDER BY 3 DESC
	LIMIT 1
	),

females AS (
	SELECT name, gender, SUM(num_registered) AS num_registered
	FROM names
	WHERE gender = 'F'
	GROUP BY 1, 2
	ORDER BY 3 DESC
	LIMIT 1
	)

SELECT name, gender, num_registered
FROM males

UNION

SELECT name, gender, num_registered
FROM females;
-- James and Mary are the most popular male and female names respectively.

-- 9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?
WITH males AS (
	SELECT name, gender, SUM(num_registered) AS num_registered
	FROM names
	WHERE gender = 'M' AND
		year BETWEEN 2000 AND 2009
	GROUP BY 1, 2
	ORDER BY 3 DESC
	LIMIT 1
	),

females AS (
	SELECT name, gender, SUM(num_registered) AS num_registered
	FROM names
	WHERE gender = 'F' AND
		year BETWEEN 2000 AND 2009
	GROUP BY 1, 2
	ORDER BY 3 DESC
	LIMIT 1
	)

SELECT name, gender, num_registered
FROM males

UNION

SELECT name, gender, num_registered
FROM females;
-- Emily and Jacob were the most popular female and male names in the first decade of the 2000s.

-- 10. Which year had the most variety in names (i.e. had the most distinct names)?
SELECT year, COUNT(DISTINCT name)
FROM names
GROUP BY 1
ORDER BY 2 DESC;
-- 2008 was the year with the most distinct names.

-- 11. What is the most popular name for a girl that starts with the letter X?
SELECT name, SUM(num_registered) AS num_registered
FROM names
WHERE gender = 'F' AND
	name LIKE 'X%'
GROUP BY 1
ORDER BY 2 DESC;
-- Ximena is the most popular girls name starting with the letter X.

-- 12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?
SELECT COUNT(DISTINCT name) AS q_not_qu
FROM names
WHERE name LIKE 'Q%' AND
	name NOT LIKE '_u%';
-- There are 46 names that begin with Q with a second letter that is not u.

-- 13. Which is the more popular spelling between "Stephen" and "Steven"?
-- 		Use a single query to answer this question.
SELECT name, SUM(num_registered) AS num_registered
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY 1
ORDER BY 2 DESC;
-- Steven is more popular than Stephen.

-- 14. What percentage of names are "unisex" - that is what percentage of names have been used 
--		both for boys and for girls?
WITH male_names AS (
	SELECT DISTINCT name
	FROM names
	WHERE gender = 'M'),

female_names AS (
	SELECT DISTINCT name
	FROM names
	WHERE gender = 'F'),

unisex_names AS (
	SELECT m.name
	FROM male_names AS m
	INNER JOIN female_names AS f
		ON m.name = f.name)

SELECT ROUND((COUNT(unisex_names.*) * 100.0) / (SELECT COUNT(DISTINCT name) FROM names), 2) AS percentage_unisex_names
FROM unisex_names;
-- 10.95% of names are unisex.

-- 15. How many names have made an appearance in every single year since 1880?
SELECT COUNT(DISTINCT year)
FROM names;

-- 16. How many names have only appeared in one year?

-- 17. How many names only appeared in the 1950s?

-- 18. How many names made their first appearance in the 2010s?

-- 19. Find the names that have not be used in the longest.

-- 20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.