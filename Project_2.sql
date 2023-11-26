---1 Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
FORMAT_DATE('%Y - %m', DATE (created_at)) AS ORDER_DATE,
COUNT(DISTINCT user_id) as total_user,
COUNT(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by order_date
order by order_date
Nhận xét : Tổng lượng user và order tăng đều từ 1/1/2019 đến 30/4/2022. Có 6/2021 tổng lượng user và order có giảm xuống nhưng không đáng kể
---2 Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select FORMAT_DATE('%Y-%m', DATE (created_at)) AS ORDER_DATE, 
count(distinct user_id) as distinct_users, 
sum(sale_price)/count(order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by order_date
order by order_date
Nhận xét: Số lượng người dùng mới tăng dần theo thời gian, trung bình giá trị đơn hàng bình ổn đạt trung bình 50-60/ order
---3 Nhóm khách hàng theo độ tuổi
SELECT  first_name, last_name, gender, age,
    CASE 
        WHEN age = youngest_age THEN 'youngest'
        WHEN age = oldest_age THEN 'oldest'
    END AS tag
FROM ( SELECT first_name, last_name, gender,age,
        min(age) OVER(PARTITION BY gender ORDER BY age) AS youngest_age,
        max(age) OVER(PARTITION BY gender ORDER BY age DESC) AS oldest_age
    FROM bigquery-public-data.thelook_ecommerce.users  
   WHERE created_at between '2019-01-01' AND '2022-04-30') AS age_data
group by first_name, last_name, gender, age,youngest_age,oldest_age;

---4 Top 5 sản phẩm mỗi tháng
with cte as(select FORMAT_DATE('%Y-%m', DATE (b.created_at)) AS ORDER_DATE,
a.id as product_id, a.name as product_name,
sum(b.sale_price) as sales, sum(a.cost) as cost, sum(b.sale_price - a.cost) as profit
from bigquery-public-data.thelook_ecommerce.products as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.id=b.product_id
WHERE created_at between '2019-01-01' AND '2022-04-30'
group by 1,2,3),
CTE2 AS (select *,
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY profit) AS rank_per_month
from CTE)
SELECT * FROM CTE2 
where rank_per_month <=5
order by order_date;

---5 doanh thu theo ngày từng danh mục sản phẩm
with cte as(select FORMAT_DATE('%Y-%m-%d', DATE (a.created_at)) AS ORDER_DATE,
product_category, sum(num_of_item) as so_luong, product_retail_price
from bigquery-public-data.thelook_ecommerce.inventory_items AS a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.inventory_item_id
join bigquery-public-data.thelook_ecommerce.orders as c on b.order_id=c.order_id
WHERE a.created_at BETWEEN '2022-01-15' AND '2022-04-15'
group by product_category, ORDER_DATE, product_retail_price
ORDER BY ORDER_DATE)
select order_date, product_category, sum(product_retail_price*so_luong)
from cte
group by order_date, product_category
order by order_date




