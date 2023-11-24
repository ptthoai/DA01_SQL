---1
select 
FORMAT_DATE('%Y %b', DATE (created_at)) AS ORDER_DATE,
COUNT(DISTINCT user_id) as total_user,
COUNT(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by order_date
order by order_date

---2
