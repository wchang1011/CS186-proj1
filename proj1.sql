-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;
DROP VIEW IF EXISTS CAcollege;
DROP VIEW IF EXISTS slg;
DROP VIEW IF EXISTS lslg;
DROP VIEW IF EXISTS salary_statistics;
DROP VIEW IF EXISTS maxid;
DROP VIEW IF EXISTS bins_statistics;
DROP VIEW IF EXISTS bins;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE weight >300;
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE namefirst LIKE '% %'
  ORDER BY namefirst, namelast
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(*)
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(*)
  FROM people
  GROUP BY birthyear
  HAVING AVG(height) > 70
  ORDER BY birthyear
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT P.namefirst, P.namelast, P.playerid, H.yearid
  FROM people P INNER JOIN HallofFame H
  on P.playerid = H.playerid
  WHERE H.inducted = 'Y'
  ORDER BY H.yearid DESC, P.playerid
;

-- Question 2ii
CREATE VIEW CAcollege(playerid, schoolid)
AS
  SELECT c.playerid, c.schoolid
  FROM CollegePlaying c INNER JOIN Schools s
  on c.schoolid = s.schoolid
  WHERE s.schoolState = 'CA'
;

CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT q.namefirst, q.namelast, q.playerid, c.schoolid, q.yearid
  FROM q2i q INNER JOIN CAcollege c
  on q.playerid = c.playerid
  ORDER BY q.yearid DESC, c.schoolid, c.playerid
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT q.playerid, q.namefirst, q.namelast, c.schoolid
  FROM q2i q LEFT OUTER JOIN CollegePlaying c
  on q.playerid = c.playerid
  ORDER BY q.playerid DESC, c.schoolid
;

-- Question 3i
CREATE VIEW slg(playerid, yearid, AB, slgval)
AS
  SELECT playerid, yearid, AB, (H+H2B+2*H3B+3*HR+0.0)/AB+0.0
  FROM batting
;

CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, s.yearid, s.slgval
  FROM people p INNER JOIN slg s
  on p.playerid = s.playerid
  WHERE s.AB > 50
  ORDER BY s.slgval DESC, s.yearid, p.playerid
  LIMIT 10
;

-- Question 3ii
CREATE VIEW lslg(playerid, lslgval)
AS
  SELECT playerid, (SUM(H)+SUM(H2B)+2*SUM(H3B)+3*SUM(HR)+0.0)/SUM(AB)+0.0
  FROM batting
  GROUP BY playerid
  HAVING SUM(AB) > 50
;

CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, s.lslgval
  FROM people p INNER JOIN lslg s
  on p.playerid = s.playerid
  ORDER BY s.lslgval DESC, p.playerid
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT p.namefirst, p.namelast, s.lslgval
  FROM people p INNER JOIN lslg s
  on p.playerid = s.playerid
  WHERE s.lslgval > 
    (SELECT lslgval
      FROM lslg
      WHERE playerid = 'mayswi01'
      )
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT yearid, MIN(salary), MAX(salary), AVG(salary)
  FROM Salaries
  GROUP BY yearid
  ORDER BY yearid
;


-- Helper table for 4ii
DROP TABLE IF EXISTS binids;
CREATE TABLE binids(binid);
INSERT INTO binids VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- Question 4ii
CREATE VIEW bins_statistics(binstart, binend, width)
AS 
  SELECT MIN(salary), MAX(salary), CAST(((MAX(salary)-MIN(salary))/10) AS INT)
  FROM Salaries
;

CREATE VIEW bins(binid, binstart, width)
AS 
  SELECT CAST(salary/width AS INT), binstart, width
  FROM Salaries, bins_statistics
  WHERE yearid = 2016
;

CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT b.binid, bins.binstart + b.binid * bins.width, bins.binstart + (b.binid+1)* bins.width, COUNT(*)
  FROM binids b, Salaries, bins
  WHERE (salary between bins.binstart + b.binid * bins.width and bins.binstart + (b.binid+1)* bins.width) and yearid = 2016
  GROUP BY b.binid
;

-- Question 4iii
CREATE VIEW salary_statistics(yearid, minsa, maxsa, avgsa)
AS 

;

CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS

;

-- Question 4iv
CREATE VIEW maxid(playerid, salary, yearid)
AS

;

CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS

;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS

;

