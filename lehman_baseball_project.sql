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

WITH managers_awards       AS (SELECT DISTINCT am1.yearid AS yearid1,
						 			     am2.yearid AS yearid2,
						 				 am1.lgid AS lg1,
						 				 am2.lgid AS lg2,
						 				 m.playerid,
						 				 p.namegiven,
						 				 p.namelast,
						 				 t.teamid,
							   			 am1.awardid AS award1,
							   			 am2.awardid AS award2
						 	FROM awardsmanagers as am1
						 	 	 INNER JOIN awardsmanagers AS am2
						 	 	 USING (playerid)
						     	 JOIN people AS p
						 	 	 	ON am1.playerid=p.playerid
						 		  JOIN managers AS m
						 			ON am1.playerid=m.playerid
						    	    AND am1.yearid=m.yearid
						    	  JOIN teams AS t
						 			ON m.teamid=t.teamid)
							  
							 

SELECT DISTINCT ma.yearid1,ma.teamid,t.name,ma.lg1,ma.lg2,ma.playerid,ma.namegiven,ma.namelast
FROM managers_awards as ma
LEFT JOIN teams as t
ON ma.teamid=t.teamid
WHERE (lg1='AL'AND lg2='NL'
AND award1 ='TSN Manager of the Year'
AND award2 ='TSN Manager of the Year')
OR (lg1='NL'AND lg2='AL'
AND award1 ='TSN Manager of the Year'
AND award2 ='TSN Manager of the Year')
GROUP BY namegiven,ma.teamid,ma.yearid1,t.name,ma.lg1,ma.lg2,ma.playerid,namelast
ORDER BY namegiven


---------------------------
WITH managers_awards       AS (SELECT DISTINCT am1.yearid AS yearid1,
						 			     am2.yearid AS yearid2,
						 				 am1.lgid AS lg1,
						 				 am2.lgid AS lg2,
						 				 m.playerid,
						 				 p.namegiven,
						 				 p.namelast,
						 				 t.teamid,
							   			 t.name,
							   			 am1.awardid AS award1,
							   			 am2.awardid AS award2
						 	FROM awardsmanagers as am1
						 	 	 INNER JOIN awardsmanagers AS am2
						 	 	 USING (playerid)
						     	 JOIN people AS p
						 	 	 	ON am1.playerid=p.playerid
						 		  JOIN managers AS m
						 			ON am1.playerid=m.playerid
						    	    AND am1.yearid=m.yearid
						    	  JOIN teams AS t
						 			ON m.teamid=t.teamid)
							  
							 

SELECT *
FROM managers_awards

WHERE (lg1='AL'AND lg2='NL'
AND award1 ='TSN Manager of the Year'
AND award2 ='TSN Manager of the Year')
OR (lg1='NL'AND lg2='AL'
AND award1 ='TSN Manager of the Year'
AND award2 ='TSN Manager of the Year')
GROUP BY namegiven
ORDER BY namegiven
--maybe make al & nl sep cte, join together
SELECT *
FROM awardsmanagers
WHERE awardid ='TSN Manager of the Year'

-----------------------------
WITH managers_awards		AS (SELECT *
						 		FROM awardsmanagers as am1
						 	 	 INNER JOIN awardsmanagers AS am2
						 	 	 USING (playerid)),
WITH managers_names			AS (SELECT *
							   FROM managers_awards as ma
							   LEFT JOIN people as p
							   ON ma.playerid=p.playerid),
						     	 
							  
							 

SELECT *
FROM managers_names

WHERE (lg1='AL'AND lg2='NL'
AND award1 ='TSN Manager of the Year'
AND award2 ='TSN Manager of the Year')
OR (lg1='NL'AND lg2='AL'
AND award1 ='TSN Manager of the Year'
AND award2 ='TSN Manager of the Year')
GROUP BY namegiven
ORDER BY namegiven

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

/*
Q12
In this question, you will explore the connection between number of wins and attendance.

A. Does there appear to be any correlation between attendance at home games and number of wins?
B. Do teams that win the world series see a boost in attendance the following year?
What about teams that made the playoffs?
Making the playoffs means either being a division winner or a wild card winner
*/

/*
Q13
It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective.
Investigate this claim and present evidence to either support or dispute this claim.
First, determine just how rare left-handed pitchers are compared with right-handed pitchers.
Are left-handed pitchers more likely to win the Cy Young Award?
Are they more likely to make it into the hall of fame?
*/



