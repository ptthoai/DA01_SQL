--EX1
SELECT B.CONTINENT, FLOOR(AVG(A.POPULATION))
FROM CITY AS A
JOIN COUNTRY AS B 
ON A.COUNTRYCODE=B.CODE
GROUP BY  B.CONTINENT;

--EX2
SELECT  
ROUND(SUM(CASE WHEN B.SIGNUP_ACTION = 'Confirmed' THEN 1 ELSE 0 END)*1.00/COUNT(B.SIGNUP_ACTION),2)
FROM EMAILS AS A
INNER JOIN TEXTS AS B
ON A.EMAIL_ID=B.EMAIL_ID
WHERE A.EMAIL_ID IS NOT NULL

--EX3
select age_bucket,
ROUND((SUM(CASE WHEN activity_type='send' then time_spent else 0 end)/SUM(time_spent))*100.0,2) as send_perc,
ROUND((SUM(CASE WHEN activity_type='open' then time_spent else 0 end)/sum(time_spent))*100.0,2) as open_perc
from activities AS a
inner join age_breakdown AS b
on a.user_id = b.user_id
where a.activity_type in ('send','open')
group by age_bucket;

--EX4
SELECT A.CUSTOMER_ID
FROM Customer_contracts AS A
LEFT JOIN PRODUCTS AS B
ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY A.CUSTOMER_ID
HAVING COUNT(DISTINCT(PRODUCT_CATEGORY))=3

--EX5
SELECT e.employee_id,e.name
,count(e2.reports_to) as reports_count
,ROUND(AVG(e2.age*1.0),0) as average_age
FROM employees e 
INNER JOIN employees e2 ON e.employee_id=e2.reports_to
WHERE e2.reports_to IS NOT NULL
GROUP BY e.employee_id,e.name
ORDER BY e.employee_id
