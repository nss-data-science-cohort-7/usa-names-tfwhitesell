-- 1. Find the longest name contained in this dataset. What do you notice about the long names?
SELECT name, LENGTH(name) AS longest_name
FROM names
GROUP BY 1
ORDER BY 2 DESC;
-- The longest names in the dataset are 15 characters. They appear to be concatenations of two names.
-- Additionally, I think the maximum number of allowed characters in the data might be 15 as many of the names
-- seem to be incomplete (eg Christopherjame or Christopheranth).

-- 2. How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?
WITH palindromes AS (
	SELECT name
	FROM names
	GROUP BY 1
	HAVING LOWER(name) = LOWER(REVERSE(name))
)

SELECT COUNT(*)
FROM palindromes;
-- There are 137 names that are palindromes in the dataset.

-- 3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels).
-- not using regex
SELECT name
FROM names
WHERE NOT(LOWER(name) LIKE '%a%'
		 OR LOWER(name) LIKE '%e%'
		 OR LOWER(name) LIKE '%i%'
		 OR LOWER(name) LIKE '%o%'
		 OR LOWER(name) LIKE '%u%'
		 OR LOWER(name) LIKE '%y%')
GROUP BY 1;

-- with regex
SELECT name
FROM names
WHERE name NOT SIMILAR TO '%[aeiouyAEIOUY]%'
GROUP BY 1;

-- 4. How many double-letter names show up in the dataset? Double-letter means the same letter repeated 
-- 	back-to-back, like Matthew or Aaron. Are there any triple-letter names?
WITH double_letters AS (
	SELECT name
	FROM names
	WHERE LOWER(name) ~ '(.)\1'
	GROUP BY 1
)

SELECT COUNT(*) AS num_names
FROM double_letters;
-- There are 22537 names with back-to-back double letters.
-- This could be more compact by using COUNT DISTINCT but it takes about 4 times longer to run.
-- Choosing the less compact code in favor of performance. DISTINCT is a pretty heavy load computationally.

WITH double_letters AS (
	SELECT name
	FROM names
	WHERE LOWER(name) ~ '(.)\1\1'
	GROUP BY 1
)

SELECT COUNT(*) AS num_names
FROM double_letters;
-- There are 12 names with triple back-to-back repeated letters.

-- 5. On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. 
-- 	Now, find all names that did not appear in the 1950s but were used both before and after the 1950s.
SELECT name
FROM names
WHERE name NOT IN (SELECT name
FROM names
WHERE year BETWEEN 1950 AND 1959
GROUP BY 1)
GROUP BY 1;
-- There are 81393 names in the dataset that did not appear in the 1950s.
	
-- 6. In question 16, you found how many names appeared in only one year. Which year had the highest 
-- 	number of names that only appeared once?
SELECT year, COUNT(*) AS unique_names
FROM names
WHERE name IN (SELECT name
	FROM names
	GROUP BY 1
	HAVING COUNT(DISTINCT year) = 1)
GROUP BY 1
ORDER BY 2 DESC;
-- There were 1060 names that only appeared in 2018 which is higher than any other year.

-- 7. Which year had the most new names (names that hadn't appeared in any years before that year)?
SELECT first_used, COUNT(*) AS new_names
FROM (SELECT name, MIN(year) AS first_used
		FROM names
		GROUP BY 1)
GROUP BY 1
ORDER BY 2 DESC;
-- There were 2027 names in 2007 which had not appeared in any prior year.

-- 8. Is there more variety (more distinct names) for females or for males? Is this true for all
-- 	years or are their any years where this is reversed?
SELECT (SELECT COUNT(DISTINCT name)
			FROM names
			WHERE gender = 'M') AS num_male_names,
		(SELECT COUNT(DISTINCT name)
			FROM names
			WHERE gender = 'F') AS num_female_names
FROM names
GROUP BY 1, 2;
-- There are 41495 distinct male names and 67698 distinct female names so females have a greater variety
--	of names than males.

WITH female_names AS (
	SELECT year, COUNT(*) AS num_female_names
	FROM names
	WHERE gender = 'F'
	GROUP BY 1
),

male_names AS (
	SELECT year, COUNT(*) AS num_male_names
	FROM names
	WHERE gender = 'M'
	GROUP BY 1
)

SELECT f.year, num_female_names, num_male_names, (num_female_names - num_male_names) AS gender_diff
FROM female_names AS f
INNER JOIN male_names AS m
	USING(year)
WHERE (num_female_names - num_male_names) <= 0;
-- There were 3 years where more male names were used than female names - 1880, 1881, 1882.

SELECT f.year, num_female_names, num_male_names, (num_female_names - num_male_names) AS gender_diff
FROM (SELECT year, COUNT(*) AS num_female_names
		FROM names
		WHERE gender = 'F'
		GROUP BY 1) AS f
INNER JOIN (SELECT year, COUNT(*) AS num_male_names
		FROM names
		WHERE gender = 'M'
		GROUP BY 1) AS m
	USING(year)
WHERE (num_female_names - num_male_names) <= 0;
-- same as above but with the CTEs replaced by subqueries in the FROM statement

-- 9. Which names are closest to being evenly split between male and female usage? For this question,
-- 	consider only names that have been used at least 10000 times in total.
-- in my thinking, for a name to be split between male and female it should be a unisex name
SELECT f.name, female_reg, male_reg, ABS(female_reg - male_reg) AS abs_gender_diff -- absolute difference to get values closest to 0
FROM 
	-- get female names and num_registered
	(SELECT name, SUM(num_registered) AS female_reg
	 	FROM names
	  	WHERE gender = 'F'
	 	GROUP BY 1) AS f
	-- inner join male names to down-select to names used by both genders in the dataset
INNER JOIN (SELECT name, SUM(num_registered) AS male_reg
	 	FROM names
		WHERE gender = 'M'
	 	GROUP BY 1) AS m
	USING(name)
-- filter for names that have been used at least 10000 times between both genders
WHERE name IN (SELECT name
			FROM names
			 GROUP BY 1
			HAVING SUM(num_registered) >= 10000)
ORDER BY 4
-- The most evenly split is Unknown, although that name is probably a result of messy data.
-- The most evenly split real name is Santana with a difference of 93 between female and male usage.

-- 10. Which names have been among the top 25 most popular names for their gender in every single
-- 	year contained in the names table?

-- 11. Find the name that had the biggest gap between years that it was used. 

-- 12. Have there been any names that were not used in the first year of the dataset (1880) but
-- 	which made it to be the most-used name for its gender in some year?
-- 	Difficult follow-up: What is the shortest amount of time that a name has gone from not being
-- 	used at all to being the number one used name for its gender in a year?
