---1 Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
FORMAT_DATE('%Y %b', DATE (created_at)) AS ORDER_DATE,
COUNT(DISTINCT user_id) as total_user,
COUNT(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by order_date
order by order_date

---2 Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select FORMAT_DATE('%Y %b', DATE (created_at)) AS ORDER_DATE, 
count(distinct user_id) as distinct_users, 
sum(sale_price)/count(order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by order_date
order by order_date

---3 Nhóm khách hàng theo độ tuổi
SELECT 
    first_name,
    last_name,
    gender,
    age,
    CASE 
        WHEN age = MIN(age) THEN 'youngest'
        WHEN age = MAX(age) THEN 'oldest'
    END AS tag
from bigquery-public-data.thelook_ecommerce.users
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by first_name, last_name, gender, age
