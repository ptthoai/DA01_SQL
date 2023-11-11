--EX1
SELECT name
FROM Students
where marks > 75
order by right(name,3), ID ASC;

--EX2
SELECT user_id, 
Upper(LEFT(name,1))|| lower(substring(name from 2 for (length(name)-1))) AS name
from users
order by user_id asc;

--EX3
SELECT manufacturer,
'$' || round(SUM(total_sales)/1000000,0)||' '||'million'
FROM pharmacy_sales
Group by manufacturer
order by SUM(total_sales) DESC, manufacturer;

--EX4
SELECT extract(month from submit_date) AS months,
product_id, 
round(AVG(stars),2)
FROM reviews
group by product_id, months
order by extract(month from submit_date), product_id;

--EX5
SELECT SENDER_ID, 
count(MESSAGE_ID) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-30'
GROUP BY SENDER_ID
ORDER BY count(MESSAGE_ID) DESC
LIMIT 2;

--EX6
SELECT tweet_id
from tweets
where length(content) > 15;

--EX7
SELECT activity_date AS day,
count(DISTINCT(USER_ID)) as active_USERS
from activity
WHERE  (activity_date BETWEEN '2019-06-27 ' AND '2019-07-27')
GROUP BY activity_date

--EX8
select COUNT(ID)
from employees
WHERE joining_date between '2022-01-01' AND '2022-07-31';

--EX9
select
POSITION ('a' IN first_name)
from worker
where first_name =  'Amitah';

--EX10
select id,
Substring (title from length(winery)+2 for 4)
from winemag_p2
where country = 'Macedonia';
