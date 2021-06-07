

--1
SELECT
MAX (year),
MIN(year),
MAX (year)-MIN(year) AS span_of_years
FROM homegames;

--1871 to 2016 (and opening day of 2017) = 145 years

/*SELECT *
FROM people
WHERE finalgame IS NOT NULL
ORDER BY finalgame DESC;*/

/* FROM SAMANTHA

SELECT MIN(debut), MAX (finalGame)
FROM people;

SELECT *
FROM people
ORDER BY debut DESC;

SELECT*
FROM people AS p
INNER JOIN batting AS b
ON p.playerid=b.playerid
WHERE b.playerid = 'torrejo02';
*/
/* FROM JULIEN
select MIN(span_first), MAX(span_last),
MAX(span_last) - MIN(span_first) as span_of_days
from homegames
*/