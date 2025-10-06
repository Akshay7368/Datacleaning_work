use practice


create table users(
userid int Primary key,
username varchar(20),
userstatus varchar(20)

)

INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS  VALUES (4, 'David', 'Active');
INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');



create table logins(
userid int,
login_timestamps datetime,
sessionid int primary key,
sessionscore int
Foreign key (userid) references users(userid)

)

INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);
INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);

INSERT INTO logins(userid,login_timestamps,sessionid,sessionscore)
VALUES
(1, '2024-01-10 07:45:00', 1011, 86),
(2, '2024-01-25 09:30:00', 1012, 89),
(3, '2024-02-05 11:00:00', 1013, 78),
(4, '2024-03-01 14:30:00', 1014, 91),
(5, '2024-03-15 16:00:00', 1015, 83),
(6, '2024-04-12 08:00:00', 1016, 80),
(7, '2024-05-18 09:15:00', 1017, 82),
(8, '2024-05-28 10:45:00', 1018, 87),
(9, '2024-06-15 13:30:00', 1019, 76),
(10, '2024-06-25 15:00:00', 1010, 92),
(10, '2024-06-26 15:45:00', 1020, 93),
(10, '2024-06-27 15:00:00', 1021, 92),
(10, '2024-06-28 15:45:00', 1022, 93),
(1, '2024-01-10 07:45:00', 1101, 86),
(3, '2024-01-25 09:30:00', 1102, 89),
(5, '2024-01-15 11:00:00', 1103, 78),
(2, '2023-11-10 07:45:00', 1201, 82),
(4, '2023-11-25 09:30:00', 1202, 84),
(6, '2023-11-15 11:00:00', 1203, 80);


select * from users
select * from logins

-- Find the userid those who are not logined for 5 months from today

select u.userid,u.username, MAX(l.login_timestamps) from users as u 
join logins as l
on u.userid = l.userid
group by u.userid, u.username
having max(l.login_timestamps) < DATEADD(MONTH,-5,'2024-01-28 00:00:00.000')

select userid, MAX(login_timestamps) from logins
group by userid
having MAX(login_timestamps) < DATEADD(MONTH,-5,GETDATE())


--Calculate how many users and how many sessions are there in each quarter, also find first day of the quarter 
select DATEPART(quarter,login_timestamps) as Quarter,
count(Distinct userid) as count_of_userid,
COUNT(sessionid) as count_of_session,
MIN(login_timestamps) as first_quarter_login,
DATETRUNC(quarter,MIN(login_timestamps)) as first_day_quarter
from logins
group by DATEPART(quarter,login_timestamps);

--Find the employees who login in jan 1 2024 but not in 11 nov 2023.
select distinct l.userid, u.username from logins as l
join users as u
on l.userid = u.userid
where l.login_timestamps between '2024-01-01' and '2024-01-31' 
and l.userid not in (select userid from logins where login_timestamps between '2023-11-01' and '2023-11-30')


--Calculate the percent of session count with prev session count
with cte as (
select 
DATETRUNC(quarter,MIN(login_timestamps)) as first_day_quarter,
count(Distinct userid) as count_of_userid,
COUNT(sessionid) as count_of_session
from logins
group by DATEPART(quarter,login_timestamps))

select *,
LAG(count_of_session) over(order by first_day_quarter) as prev_session_count,
(count_of_session - (LAG(count_of_session) over(order by first_day_quarter)))* 100.0 / (LAG(count_of_session) over(order by first_day_quarter)) as percent_count
from cte


--
with cte as (
select userid, cast(login_timestamps as date) as logindate , sum(sessionscore) as totalscore from logins
group by userid, cast(login_timestamps as date)
)
select * from(
select * ,
ROW_NUMBER() over(partition by logindate order by totalscore ) as rn
from cte) as t
where rn = 1






