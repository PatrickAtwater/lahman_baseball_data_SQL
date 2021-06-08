SELECT MIN(span_first), MAX(span_last),
MAX(span_last) - MIN(span_first) as span_of_days
from homegames

--Q2
SELECT namefirst, namelast, name, yearid, MIN(height) AS min_height, SUM(appearances.g_all) as total_games 
FROM people
LEFT JOIN appearances
USING(playerid)
LEFT JOIN teams
USING(teamid, yearid)
GROUP BY namefirst, namelast, playerid, appearances.teamid, yearid, name
ORDER BY min_height ASC;


--Q3
SELECT schoolname, namefirst, namelast, salary
FROM schools
LEFT JOIN collegeplaying
USING(schoolid)
LEFT JOIN people
USING(playerid)
LEFT JOIN salaries
USING(playerid)
WHERE schoolname = 'Vanderbilt University'
AND salary IS NOT NULL
ORDER BY salary DESC;



