/*
Q1
*/

SELECT MIN(debut), MAX (finalGame)
FROM people

SELECT *
FROM people
ORDER BY debut DESC

--1871 to 2017

SELECT*
FROM people AS p 
INNER JOIN batting AS b
ON p.playerid=b.playerid
WHERE b.playerid = 'torrejo02'

SELECT 
MAX (year),
MIN(year),
MAX (year)-MIN(year) AS span_of_years
FROM homegames;

--145 YEARS (also says 1st day of opening season 2017)

select MIN(span_first), MAX(span_last),
MAX(span_last) - MIN(span_first) as span_of_days
from homegames

--53112 days