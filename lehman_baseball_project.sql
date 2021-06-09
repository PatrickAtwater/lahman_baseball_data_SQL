/*
Q1
What range of years for baseball games played does the provided database cover?
*/

SELECT MIN(debut), MAX (finalGame)
FROM people

--1871 to 2017

SELECT *
FROM people
ORDER BY debut DESC

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


/*
Q2 [R]
Find the name and height of the shortest player in the database.
How many games did he play in? What is the name of the team for which he played?
*/

/*
Q3 [R]
Find all players in the database who played at Vanderbilt University.
Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues.
Sort this list in descending order by the total salary earned.
Which Vanderbilt player earned the most money in the majors?
*/




/*
Q4 [S]
Using the fielding table,
group players into three groups based on their position:
	label players with position OF as "Outfield",
	those with position "SS", "1B", "2B", and "3B" as "Infield",
	and those with position "P" or "C" as "Battery".
Determine the number of putouts
			  made by each of these three groups
			  in 2016.
			  
Thoughts on execution: group players with case when for outfield, infield, battery
sum po
year=2016
*/

WITH position_table AS (SELECT playerid,
				  		 	   pos,
				  		 	   po,
				         	   yearid,
						 	   CASE WHEN pos = 'OF' THEN 'Outfield'
						 	  	    WHEN pos = 'SS' THEN 'Infield'
							  		WHEN pos = '1B' THEN 'Infield'
							  		WHEN pos = '2B' THEN 'Infield'
							  		WHEN pos = '3B' THEN 'Infield'
							  		WHEN pos = 'P' THEN 'Battery'
							  		WHEN pos = 'C' THEN 'Battery' END AS position
				 		FROM fielding)

SELECT position, SUM(po)
FROM position_table
WHERE yearid = '2016'
GROUP BY position

--BATTERY: 41,424
--INFIELD: 58,934
--OUTFIELD: 29,560


/*
Q5 [P]
Find the average number of strikeouts per game by decade since 1920.
Round the numbers you report to 2 decimal places. Do the same for home runs per game.
Do you see any trends?
*/

/*
Q6 [J]
Find the player who had the most success stealing bases in 2016,
where success is measured as the percentage of stolen base attempts which are successful.
(A stolen base attempt results either in a stolen base or being caught stealing.)
Consider only players who attempted at least 20 stolen bases.
*/

/*
Q7 [J]
From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?
What is the smallest number of wins for a team that did win the world series?
Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case.
Then redo your query, excluding the problem year.
How often from 1970 – 2016 was it the case that a team with the most wins also won the world series?
What percentage of the time?
*/



/*
Q8 [P]
Using the attendance figures from the homegames table,
find the teams and parks which had the top 5 average attendance per game in 2016
(where average attendance is defined as total attendance divided by number of games).
Only consider parks where there were at least 10 games played.
Report the park name, team name, and average attendance.
Repeat for the lowest 5 average attendance
*/

/*
Q9 [S]
Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)?
Give their full name and the teams that they were managing when they won the award.
*/

--look at awards managers and awards share managers tables (not in shared because only BBWAA there)

WITH managers_awards		AS (SELECT DISTINCT am1.yearid AS yearid1,
									am1.playerid AS playerid,
									am1.lgid AS lgid1,
									am2.lgid AS lgid2,
									am1.awardid AS awardid1
						 		FROM awardsmanagers as am1
						 	 	 INNER JOIN awardsmanagers AS am2
						 	 	 USING (playerid)
								 WHERE am1.awardid = 'TSN Manager of the Year'
								 	AND am2.awardid = am1.awardid
									AND am1.lgid <> 'ML'
									AND am2.lgid <> 'ML'
							   		AND am1.lgid <> am2.lgid),
managers_names			AS (SELECT ma.yearid1 AS yearid,
							       ma.playerid AS playerid,
								   ma.lgid1 AS lgid1,
								   ma.lgid2 AS lgid2,
								   ma.awardid1 AS awardid,
								   p.namefirst AS namefirst,
								   p.namelast AS namelast
							   FROM managers_awards as ma
							   LEFT JOIN people as p
							   ON ma.playerid=p.playerid),
managers_table			AS (SELECT DISTINCT mn.yearid AS yearid,
							       mn.playerid AS playerid,
								   mn.namefirst AS namefirst,
								   mn.namelast AS namelast,
								   m.teamid AS teamid
						   FROM managers_names AS mn
						   LEFT JOIN managers AS m
						   ON mn.playerid=m.playerid
						   AND mn.yearid=m.yearid
						   GROUP BY mn.yearid, mn.playerid,namefirst,namelast,teamid),					     	 
managers_and_teams		AS(SELECT DISTINCT t.yearid AS yearid,
							       mn.playerid AS playerid,
								   mn.namefirst AS namefirst,
								   mn.namelast AS namelast,
						   		   t.name AS name
						  FROM managers_table AS mn
						  LEFT JOIN teams AS t
						  ON mn.yearid=t.yearid
						  AND mn.teamid=t.teamid)
							 

SELECT *
FROM managers_and_teams


------------------------------- OPEN ENDED QUESTIONS ------------------------------------
/*
Q10
Analyze all the colleges in the state of Tennessee.
Which college has had the most success in the major leagues.
Use whatever metric for success you like - number of players, number of games, salaries, world series wins, etc.
*/

/*
Q11
Is there any correlation between number of wins and team salary?
Use data from 2000 and later to answer this question.
As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis
*/

/*Q12
In this question, you will explore the connection between number of wins and attendance.

A. Does there appear to be any correlation between attendance at home games and number of wins?
B. 1. Do teams that win the world series see a boost in attendance the following year?
   2. What about teams that made the playoffs?
Making the playoffs means either being a division winner or a wild card winner

thought process:
will need table 27 (homegames) to see attendance
table 8 (teams) to see teamid, team name (name), wins(w), division winner (DivWin) & wildcard winner (WCWin) = playoffs, world series winner (WSWin) for corellated following year's attendance
maybe look at post tables for playoff performance?

*/


/*q12 In this question, you will explore the connection between number of wins and attendance.
A. Does there appear to be any correlation between attendance at home games and number of wins?*/



---attendance up and wins up
SELECT DISTINCT t1.yearid AS year_1,
	   t2.yearid AS year_2,
	   t1.name AS team_names,
	   t1.w AS wins_year_1,
	   t2.w AS wins_year_2,
	   t1.attendance AS attendance_year_1,
	   t2.attendance AS attendance_year_2,
	   t1.l AS losses_year_1,
	   t2.l AS losses_year_2
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.attendance IS NOT NULL
AND t1.ghome IS NOT NULL
AND t2. attendance IS NOT NULL
AND t2.ghome IS NOT NULL
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.w<t2.w
--822 rows

---attendance up, wins down
SELECT DISTINCT t1.yearid AS year_1,
	   t2.yearid AS year_2,
	   t1.name AS team_names,
	   t1.w AS wins_year_1,
	   t2.w AS wins_year_2,
	   t1.attendance AS attendance_year_1,
	   t2.attendance AS attendance_year_2,
	   t1.l AS losses_year_1,
	   t2.l AS losses_year_2
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.attendance IS NOT NULL
AND t1.ghome IS NOT NULL
AND t2. attendance IS NOT NULL
AND t2.ghome IS NOT NULL
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.w>t2.w
--350 rows

-----------------------------------------------------------------

---attendance up and wins up and losses down
SELECT DISTINCT t1.yearid AS year_1,
	   t2.yearid AS year_2,
	   t1.name AS team_names,
	   t1.w AS wins_year_1,
	   t2.w AS wins_year_2,
	   t1.attendance AS attendance_year_1,
	   t2.attendance AS attendance_year_2,
	   t1.l AS losses_year_1,
	   t2.l AS losses_year_2
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.attendance IS NOT NULL
AND t1.ghome IS NOT NULL
AND t2. attendance IS NOT NULL
AND t2.ghome IS NOT NULL
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.w<t2.w
AND t1.l>t2.l
--728 rows


--attendance up, wins up, losses up
SELECT DISTINCT t1.yearid AS year_1,
	   t2.yearid AS year_2,
	   t1.name AS team_names,
	   t1.w AS wins_year_1,
	   t2.w AS wins_year_2,
	   t1.attendance AS attendance_year_1,
	   t2.attendance AS attendance_year_2,
	   t1.l AS losses_year_1,
	   t2.l AS losses_year_2
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.attendance IS NOT NULL
AND t1.ghome IS NOT NULL
AND t2. attendance IS NOT NULL
AND t2.ghome IS NOT NULL
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.w<t2.w
AND t1.l<t2.l
--79 rows

--attendance down, wins up, losses down
SELECT DISTINCT t1.yearid AS year_1,
	   t2.yearid AS year_2,
	   t1.name AS team_names,
	   t1.w AS wins_year_1,
	   t2.w AS wins_year_2,
	   t1.attendance AS attendance_year_1,
	   t2.attendance AS attendance_year_2,
	   t1.l AS losses_year_1,
	   t2.l AS losses_year_2
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.attendance IS NOT NULL
AND t1.ghome IS NOT NULL
AND t2. attendance IS NOT NULL
AND t2.ghome IS NOT NULL
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
AND t1.w<t2.w
AND t1.l>t2.l
--306 rows

/*
SELECT *
FROM homegames

SELECT *
FROM teams
WHERE wswin = 'Y'
--yearid, 7 lgids (AA,AL,NA,PL,NL,UA,FL), 139 distinct team names, 149 distinct team ids, 236 rows where divwin = 'Y', 54 rows where wcwin = 'Y', 117 rows where wswin = 'Y'

SELECT *
FROM homegames AS h
LEFT JOIN teams AS t
ON h.year=t.yearid
AND h.team=t.teamid

--3006 rows

SELECT t.year AS year
	   t.teamid AS team_code
	   t.name AS team_name
	   h.games AS home_games
	   h.attendance AS attendance
	   t.g AS total_games_played
	   
FROM homegames AS h
LEFT JOIN teams AS t
ON h.year=t.yearid
AND h.team=t.teamid

STOPPED THERE AND SWITCHED GEARS BECAUSE I REALIZED THAT ATTENDANCE AND HOME GAMES WERE ON THE TEAMS TABLE
*/

--------------------------------
SELECT *
FROM teams
--2835 ROWS

SELECT yearid, lgid, teamid, g, ghome, w, l, divwin, wcwin, wswin, name, attendance
FROM teams

--2835 ROWS
SELECT yearid, lgid, teamid, g, ghome, w, l, divwin, wcwin, wswin, name, attendance
FROM teams
WHERE attendance IS NOT NULL
--2556 ROWS
SELECT yearid, lgid, teamid, g, ghome, w, l, divwin, wcwin, wswin, name, attendance
FROM teams
WHERE attendance IS NOT NULL
AND ghome IS NOT NULL
--2436 ROWS


/*Q12 In this question, you will explore the connection between number of wins and attendance.
B. 1. Do teams that win the world series see a boost in attendance the following year?
   2. What about teams that made the playoffs?
Making the playoffs means either being a division winner or a wild card winner*/

--teams that won world series and attendance higher following year:
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.wswin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
--57 rows


--teams that won world series and attendance lower following year:
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.wswin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
--54 rows



--B. 2. What about teams that made the playoffs?

--teams that have divwin as 'Y' and attendance higher
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
--127 rows


--teams that have divwin as 'Y' and attendance lower
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
--102 rows


--teams that have divwin as 'Y' but wswin as 'N' and attendance higher
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.wswin='N'
--99 rows


--teams that have divwin as 'Y' but wswin as 'N' and attendance lower
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
AND t1.wswin='N'
--90 rows


--teams that have wcwin as 'Y' and attendance higher
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
--35 rows


--teams that have wcwin as 'Y' and attendance lower
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
--15 rows


--teams that have wcwin as 'Y' but wswin as 'N' and attendance higher
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.wswin='N'
--30 rows


--teams that have wcwin as 'Y' but wswin as 'N' and attendance lower
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
AND t1.wswin='N'
--14 rows


--combined wcwin OR divwin and att higher
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE (t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance)
OR (t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance)
--162 rows


--combined wcwin OR divwin and att lower
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE (t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance)
OR (t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance)
--117 rows


--combined (wcwin OR divwin) AND wswin is N and att higher
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE (t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.wswin='N')
OR (t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance<t2.attendance
AND t1.wswin='N')
--129 rows


--combined (wcwin OR divwin) AND wswin is N and att lower
SELECT t1.name,t1.yearid,t1.attendance,t2.yearid,t2.attendance
FROM teams AS t1 INNER JOIN teams AS t2
USING(teamid)
WHERE (t1.wcwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
AND t1.wswin='N')
OR (t1.divwin='Y'
AND t1.yearid<t2.yearid
AND t2.yearid=(t1.yearid+1)
AND t1.attendance>t2.attendance
AND t1.wswin='N')
--104 rows

--
/*
Q13
It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective.
Investigate this claim and present evidence to either support or dispute this claim.
First, determine just how rare left-handed pitchers are compared with right-handed pitchers.
Are left-handed pitchers more likely to win the Cy Young Award?
Are they more likely to make it into the hall of fame?
*/



