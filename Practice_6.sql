--EX1
SELECT 
COUNT (company_id) AS duplicate_companies
FROM 
( SELECT company_id
FROM job_listings
GROUP BY COMPANY_ID
HAVING COUNT(COMPANY_ID) >= 2) as ABC

--EX2
WITH a1 AS
(SELECT CATEGORY, PRODUCT, SUM(SPEND)
FROM PRODUCT_SPENd
WHERE CATEGORY = 'appliance' AND  EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product, category
ORDER BY SUM(SPEND) DESC
LIMIT 2), 
a2 AS
(SELECT CATEGORY, PRODUCT, SUM(SPEND)
FROM PRODUCT_SPENd
WHERE CATEGORY = 'electronics' AND  EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY product, category
ORDER BY SUM(SPEND) DESC
LIMIT 2)
SELECT * FROM a1
UNION
SELECT * FROM a2

--EX3
WITH abc as (SELECT policy_holder_id,count(case_id)
FROM callers
GROUP BY policy_holder_id
HAVING count(case_id)>=3)
SELECT COUNT(policy_holder_id) FROM abc;

--EX4
SELECT a.page_id
FROM pages as A
left join page_likes as B
on a.page_id = b.page_id
WHERE liked_date IS NULL
ORDER BY b.user_id DESC;

--EX5
WITH a1 as 
(SELECT  user_id	
from user_actions 
where EXTRACT(month from event_date) in (6,7) 
and EXTRACT(year from event_date) = 2022 
GROUP BY user_id 
Having count(DISTINCT EXTRACT(month from event_date)) = 2)
SELECT 7 as month_ , count(*) as number_of_user 
from a1
  
--EX6
SELECT LEFT(trans_date,7) AS month, country,
COUNT(id) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

--EX7
SELECT product_id, year AS first_year, quantity, price 
FROM sales
WHERE (product_id, year) IN (SELECT product_id, MIN(year)  FROM sales GROUP BY product_id)

--EX8
SELECT customer_id
FROM customer 
GROUP BY customer_id
HAVING count(distinct product_key) = (SELECT count(distinct product_key) 
FROM product)

--EX9
WITH a1 as(
  select *
  from Employees
  where manager_id is not null)
select a.employee_id 
from a1 as a 
left join Employees as b
on b.employee_id =a.manager_id 
where a.salary <30000 and b.employee_id is null

--EX10 (bấm vào link ra giống EX1)
SELECT 
COUNT (company_id) AS duplicate_companies
FROM 
( SELECT company_id
FROM job_listings
GROUP BY COMPANY_ID
HAVING COUNT(COMPANY_ID) >= 2) as ABC

--EX11
(SELECT name results
FROM Users as a, MovieRating as b
WHERE a.user_id = b.user_id
GROUP BY a.user_id
ORDER BY COUNT(b.user_id) DESC, name ASC 
LIMIT 1)
UNION ALL
(SELECT title results
FROM Movies as c, MovieRating as d
WHERE c.movie_id = d.movie_id AND created_at BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY c.movie_id
ORDER BY AVG(rating) DESC, title ASC 
LIMIT 1)

--EX12
SELECT id, COUNT(*) AS num 
FROM ( SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id FROM RequestAccepted) AS friends_count
GROUP BY id
ORDER BY num DESC 
LIMIT 1;
