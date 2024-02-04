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

-- 5. On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. 
-- 	Now, find all names that did not appear in the 1950s but were used both before and after the 1950s.
	
-- 6. In question 16, you found how many names appeared in only one year. Which year had the highest 
-- 	number of names that only appeared once?

-- 7. Which year had the most new names (names that hadn't appeared in any years before that year)?

-- 8. Is there more variety (more distinct names) for females or for males? Is this true for all
-- 	years or are their any years where this is reversed?

-- 9. Which names are closest to being evenly split between male and female usage? For this question,
-- 	consider only names that have been used at least 10000 times in total.

-- 10. Which names have been among the top 25 most popular names for their gender in every single
-- 	year contained in the names table?

-- 11. Find the name that had the biggest gap between years that it was used. 

-- 12. Have there been any names that were not used in the first year of the dataset (1880) but
-- 	which made it to be the most-used name for its gender in some year?
-- 	Difficult follow-up: What is the shortest amount of time that a name has gone from not being
-- 	used at all to being the number one used name for its gender in a year?
