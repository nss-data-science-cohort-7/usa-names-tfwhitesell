## SQL Names

Save a script containing the query you used to answer each question and your answer (as a comment).

1. How many rows are in the names table?

2. How many total registered people appear in the dataset?

3. Which name had the most appearances in a single year in the dataset?

4. What range of years are included?

5. What year has the largest number of registrations?

6. How many different (distinct) names are contained in the dataset?

7. Are there more males or more females registered?

8. What are the most popular male and female names overall (i.e., the most total registrations)?

9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?

10. Which year had the most variety in names (i.e. had the most distinct names)?

11. What is the most popular name for a girl that starts with the letter X?

12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?

13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.

14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?

15. How many names have made an appearance in every single year since 1880?

16. How many names have only appeared in one year?

17. How many names only appeared in the 1950s?

18. How many names made their first appearance in the 2010s?

19. Find the names that have not be used in the longest.

20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.

--------------------------

## Names Bonus Questions

For this first set of questions, you might find it useful to refer to the PostgreSQL string functions (https://www.postgresql.org/docs/current/functions-string.html).

	1. Find the longest name contained in this dataset. What do you notice about the long names?

	2. How many names are palindromes (i.e. read the same backwards and forwards, such as Bob and Elle)?

	3. Find all names that contain no vowels (for this question, we'll count a,e,i,o,u, and y as vowels). (Hint: you might find this page helpful: https://www.postgresql.org/docs/current/functions-matching.html)

	4. How many double-letter names show up in the dataset? Double-letter means the same letter repeated back-to-back, like Matthew or Aaron. Are there any triple-letter names?

For the next few questions, you'll likely need to make use of subqueries. A subquery is a SQL query nested inside another query. You'll learn more about subqueries over the next few DataCamp assignments.

	5. On question 17 of the first part of the exercise, you found names that only appeared in the 1950s. Now, find all names that did not appear in the 1950s but were used both before and after the 1950s. We'll answer this question in two steps.
		a. First, write a query that returns all names that appeared during the 1950s.
		b. Now, make use of this query along with the IN keyword in order the find all names that did not appear in the 1950s but which were used both before and after the 1950s. See the example "A subquery with the IN operator." on this page: https://www.dofactory.com/sql/subquery.
	
	6. In question 16, you found how many names appeared in only one year. Which year had the highest number of names that only appeared once?

	7. Which year had the most new names (names that hadn't appeared in any years before that year)? For this question, you might find it useful to write a subquery and then select from this subquery. See this page about using subqueries in the from clause: https://www.geeksforgeeks.org/sql-sub-queries-clause/

	8. Is there more variety (more distinct names) for females or for males? Is this true for all years or are their any years where this is reversed? Hint: you may need to make use of multiple subqueries and JOIN them in order to answer this question.

	9. Which names are closest to being evenly split between male and female usage? For this question, consider only names that have been used at least 10000 times in total. 

For the last questions, you might find window functions useful (see https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS and https://www.postgresql.org/docs/current/functions-window.html for a list of window function available in PostgreSQL). A window function is like an aggregate function in that it can be applied across a group, but a window function does not collapse each group down to a single summary statistic. The groupings for a window function are specified using the PARTITION BY keyword (and can include an ORDER BY when it is needed). The PARTITION BY and ORDER BY associated with a window function are CONTAINED in an OVER clause.
For example, to rank each row by the value of num_registered, we can use the query
```
SELECT name, year, num_registered, RANK() OVER(ORDER BY num_registered DESC)
FROM names;
```

If I want to rank within gender, I can add a PARTITION BY:  
```
SELECT name, year, num_registered, RANK() OVER(PARTITION BY gender ORDER BY num_registered DESC)
FROM names;
```

	10. Which names have been among the top 25 most popular names for their gender in every single year contained in the names table? Hint: you may have to combine a window function and a subquery to answer this question.

	11. Find the name that had the biggest gap between years that it was used. 

	12. Have there been any names that were not used in the first year of the dataset (1880) but which made it to be the most-used name for its gender in some year? Difficult follow-up: What is the shortest amount of time that a name has gone from not being used at all to being the number one used name for its gender in a year?