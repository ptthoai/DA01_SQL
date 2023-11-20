--EX1
WITH A AS(SELECT  customer_id , order_date , customer_pref_delivery_date,
ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY order_date ) AS FIRST_ORDER
from delivery ),
B AS(SELECT * 
FROM A
WHERE FIRST_ORDER = 1)
SELECT 
ROUND(100.00*SUM(CASE WHEN order_date = customer_pref_delivery_date then 1 else 0 END)/COUNT(*),2) AS immediate_percentage
FROM B

--EX2
