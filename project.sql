SELECT MIN(span_first), MAX(span_last),
MAX(span_last) - MIN(span_first) as span_of_days
from homegames

--Q2
SELECT namefirst, namelast, MIN(height)
FROM people