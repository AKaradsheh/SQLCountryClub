/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost > 0;


-- Tennis Court 1
-- Tennis Court 2
-- Massage Room 1
-- Massage Room 2
-- Squash Court

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) AS no_fee_facilities
FROM Facilities
WHERE membercost = 0;

--     4


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
AND membercost < (monthlymaintenance * 0.2);

-- 0,Tennis Court 1,5.0,200
-- 1,Tennis Court 2,5.0,200
-- 4,Massage Room 1,9.9,3000
-- 5,Massage Room 2,9.9,3000
-- 6,Squash Court,3.5,80

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1, 5);

-- 1,Tennis Court 2,5.0,25.0,8000,200
-- 5,Massage Room 2,9.9,80.0,4000,3000

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT
    name,
    monthlymaintenance,
    CASE
        WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap'
    END AS cost_label
FROM Facilities;

-- Tennis Court 1,200,expensive
-- Tennis Court 2,200,expensive
-- Badminton Court,50,cheap
-- Table Tennis,10,cheap
-- Massage Room 1,3000,expensive
-- Massage Room 2,3000,expensive
-- Squash Court,80,cheap
-- Snooker Table,15,cheap
-- Pool Table,15,cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (SELECT MAX(joindate) FROM Members);

/*Darren,Smith


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT
    f.name AS court_name,
    (m.firstname || ' ' || m.surname) AS member_name
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
JOIN Members m ON b.memid = m.memid
WHERE b.facid IN (0, 1)
ORDER BY member_name;

-- Tennis Court 1,Anne Baker
-- Tennis Court 2,Anne Baker
-- Tennis Court 2,Burton Tracy
-- Tennis Court 1,Burton Tracy
-- Tennis Court 1,Charles Owen
-- Tennis Court 2,Charles Owen
-- Tennis Court 2,Darren Smith
-- Tennis Court 1,David Farrell
-- Tennis Court 2,David Farrell
-- Tennis Court 2,David Jones
-- Tennis Court 1,David Jones
-- Tennis Court 1,David Pinker
-- Tennis Court 1,Douglas Jones
-- Tennis Court 1,Erica Crumpet
-- Tennis Court 2,Florence Bader
-- Tennis Court 1,Florence Bader
-- Tennis Court 2,GUEST GUEST
-- Tennis Court 1,GUEST GUEST
-- Tennis Court 1,Gerald Butters
-- Tennis Court 2,Gerald Butters
-- Tennis Court 2,Henrietta Rumney
-- Tennis Court 1,Jack Smith
-- Tennis Court 2,Jack Smith
-- Tennis Court 1,Janice Joplette
-- Tennis Court 2,Janice Joplette
-- Tennis Court 2,Jemima Farrell
-- Tennis Court 1,Jemima Farrell
-- Tennis Court 1,Joan Coplin
-- Tennis Court 1,John Hunt
-- Tennis Court 2,John Hunt
-- Tennis Court 1,Matthew Genting
-- Tennis Court 2,Millicent Purview
-- Tennis Court 2,Nancy Dare
-- Tennis Court 1,Nancy Dare
-- Tennis Court 2,Ponder Stibbons
-- Tennis Court 1,Ponder Stibbons
-- Tennis Court 2,Ramnaresh Sarwin
-- Tennis Court 1,Ramnaresh Sarwin
-- Tennis Court 2,Tim Boothe
-- Tennis Court 1,Tim Boothe
-- Tennis Court 2,Tim Rownam
-- Tennis Court 1,Tim Rownam
-- Tennis Court 2,Timothy Baker
-- Tennis Court 1,Timothy Baker
-- Tennis Court 1,Tracy Smith
-- Tennis Court 2,Tracy Smith


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT
    f.name AS facility_name,
    (m.firstname ||  ' ' || m.surname) AS member_name,
    CASE
        WHEN b.memid = 0 THEN b.slots * f.guestcost
        ELSE b.slots * f.membercost
    END AS cost
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
JOIN Members m ON b.memid = m.memid
WHERE DATE(b.starttime) = '2012-09-14'
AND CASE
        WHEN b.memid = 0 THEN b.slots * f.guestcost
        ELSE b.slots * f.membercost
    END > 30
ORDER BY cost DESC;

-- Massage Room 2,GUEST GUEST,320
-- Massage Room 1,GUEST GUEST,160
-- Massage Room 1,GUEST GUEST,160
-- Massage Room 1,GUEST GUEST,160
-- Tennis Court 2,GUEST GUEST,150
-- Tennis Court 1,GUEST GUEST,75
-- Tennis Court 1,GUEST GUEST,75
-- Tennis Court 2,GUEST GUEST,75
-- Squash Court,GUEST GUEST,70
-- Massage Room 1,Jemima Farrell,39.6
-- Squash Court,GUEST GUEST,35
-- Squash Court,GUEST GUEST,35

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT
    f.name AS facility_name,
    (m.firstname || ' '
        || m.surname) AS member_name,
    bq.cost
FROM (
    SELECT
        b.bookid,
        b.facid,
        b.memid,
        b.starttime,
        CASE
            WHEN b.memid = 0 THEN b.slots * f.guestcost
            ELSE b.slots * f.membercost
        END AS cost
    FROM Bookings b
    JOIN Facilities f ON b.facid = f.facid
    WHERE DATE(b.starttime) = '2012-09-14'
) bq
JOIN Facilities f ON bq.facid = f.facid
JOIN Members m ON bq.memid = m.memid
WHERE bq.cost > 30
ORDER BY bq.cost DESC;

-- Massage Room 2,GUEST GUEST,320
-- Massage Room 1,GUEST GUEST,160
-- Massage Room 1,GUEST GUEST,160
-- Massage Room 1,GUEST GUEST,160
-- Tennis Court 2,GUEST GUEST,150
-- Tennis Court 1,GUEST GUEST,75
-- Tennis Court 1,GUEST GUEST,75
-- Tennis Court 2,GUEST GUEST,75
-- Squash Court,GUEST GUEST,70
-- Massage Room 1,Jemima Farrell,39.6
-- Squash Court,GUEST GUEST,35
-- Squash Court,GUEST GUEST,35

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT
   f.name AS facility_name,
   SUM(CASE
        WHEN b.memid = 0 THEN b.slots * f.guestcost
        ELSE b.slots * f.membercost
   END) AS total_revenue
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
GROUP BY f.name
HAVING total_revenue < 1000
ORDER BY total_revenue;

-- Table Tennis,180
-- Snooker Table,240
-- Pool Table,270

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT
    m1.surname AS member_surname,
    m1.firstname AS member_firstname,
    COALESCE(m2.firstname || ' ' || m2.surname, 'None') AS recommender
FROM Members m1
LEFT JOIN Members m2 ON m1.recommendedby = m2.memid
WHERE m1.memid != 0
ORDER BY m1.surname, m1.firstname;

Bader,Florence,Ponder Stibbons
Baker,Anne,Ponder Stibbons
Baker,Timothy,Jemima Farrell
Boothe,Tim,Tim Rownam
Butters,Gerald,Darren Smith
Coplin,Joan,Timothy Baker
Crumpet,Erica,Tracy Smith
Dare,Nancy,Janice Joplette
Farrell,David,None
Farrell,Jemima,None
Genting,Matthew,Gerald Butters
Hunt,John,Millicent Purview
Jones,David,Janice Joplette
Jones,Douglas,David Jones
Joplette,Janice,Darren Smith
Mackenzie,Anna,Darren Smith
Owen,Charles,Darren Smith
Pinker,David,Jemima Farrell
Purview,Millicent,Tracy Smith
Rownam,Tim,None
Rumney,Henrietta,Matthew Genting
Sarwin,Ramnaresh,Florence Bader
Smith,Darren,None
Smith,Darren,None
Smith,Jack,Darren Smith
Smith,Tracy,None
Stibbons,Ponder,Burton Tracy
Tracy,Burton,None
Tupperware,Hyacinth,None
Worthington-Smyth,Henry,Tracy Smith


/* Q12: Find the facilities with their usage by member, but not guests */

SELECT
    f.name AS facility_name,
    SUM(b.slots) AS member_usage
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name;

-- Badminton Court,1086
-- Massage Room 1,884
-- Massage Room 2,54
-- Pool Table,856
-- Snooker Table,860
-- Squash Court,418
-- Table Tennis,794
-- Tennis Court 1,957
-- Tennis Court 2,882


/* Q13: Find the facilities usage by month, but not guests */

SELECT
    f.name AS facility_name,
    strftime('%Y-%m', b.starttime) AS month,
    SUM(b.slots) AS member_usage
FROM Bookings b
JOIN Facilities f ON b.facid = f.facid
WHERE b.memid != 0
GROUP BY f.name, strftime('%Y-%m', b.starttime)
ORDER BY month, f.name;

-- Badminton Court,2012-07,165
-- Massage Room 1,2012-07,166
-- Massage Room 2,2012-07,8
-- Pool Table,2012-07,110
-- Snooker Table,2012-07,140
-- Squash Court,2012-07,50
-- Table Tennis,2012-07,98
-- Tennis Court 1,2012-07,201
-- Tennis Court 2,2012-07,123
-- Badminton Court,2012-08,414
-- Massage Room 1,2012-08,316
-- Massage Room 2,2012-08,18
-- Pool Table,2012-08,303
-- Snooker Table,2012-08,316
-- Squash Court,2012-08,184
-- Table Tennis,2012-08,296
-- Tennis Court 1,2012-08,339
-- Tennis Court 2,2012-08,345
-- Badminton Court,2012-09,507
-- Massage Room 1,2012-09,402
-- Massage Room 2,2012-09,28
-- Pool Table,2012-09,443
-- Snooker Table,2012-09,404
-- Squash Court,2012-09,184
-- Table Tennis,2012-09,400
-- Tennis Court 1,2012-09,417
-- Tennis Court 2,2012-09,414



