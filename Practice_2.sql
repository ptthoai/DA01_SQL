--EX1
Select distinct city 
from station
where ID % 2 = 0;

--EX2
Select
(Count(city) ) - (count(distinct(city)))
from station;

--EX3 
SELECT
CEILING((AVG(SALARY)) - AVG(REPLACE(SALARY,0,'')))
FROM EMPLOYEES

--EX4
SELECT 
 ROUND(CAST(SUM(item_count * order_occurrences) / SUM(order_occurrences) AS DECIMAL),1)
FROM items_per_order;

--EX5
Select candidate_id
from candidates
where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill) = 3
order by candidate_id ASC;

--EX6
SELECT user_id,
Date(MAX(post_date)) - date(Min(post_date)) as days_between
from posts
where post_date BETWEEN '2021-01-01' AND '2021-12-31'
group by user_id
having count(post_id) > 1 ;

--EX7
SELECT card_name,
(Max(issued_amount) - min(issued_amount)) AS difference
FROM monthly_cards_issued
group by card_name
order by difference DESC;

--EX8
SELECT manufacturer,
count(drug),
sum( cogs - total_sales) as total_loss
FROM pharmacy_sales
Where cogs > total_sales
GROUP BY manufacturer
order by total_loss DESC ;

--EX9
SELECT  id, movie, description, rating
from cinema
where id % 2 = 1
AND description <> 'boring'
ORDER BY rating DESC;

--EX10
ELECT teacher_id,
count(distinct(subject_id)) as cnt
from teacher
group by teacher_id

--EX11
elect user_id,
Count(distinct(follower_id)) as followers_count
from followers
group by user_id
Order by user_id ASC;

--EX12
Select class
from courses
group by class
having count(student) > 5;
