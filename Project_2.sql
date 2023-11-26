I- AD-HOC TASK
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

II- Tạo metric trước khi dựng dashboard
---1  
WITH CTE AS(select FORMAT_DATE('%Y-%m', DATE (a.created_at)) AS MONTH,
extract(year from a.created_at) as YEAR,
product_category, sum(SALE_PRICE) AS TPV, COUNT(c.ORDER_ID) AS TPO, SUM(COST) AS TOTAL_COST
from bigquery-public-data.thelook_ecommerce.inventory_items AS a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.inventory_item_id
join bigquery-public-data.thelook_ecommerce.orders as c on b.order_id=c.order_id
group by 1,2,3
ORDER BY MONTH),
CTE1 AS (SELECT *,
((LEAD(TPV) OVER(PARTITION BY PRODUCT_CATEGORY,YEAR ORDER BY MONTH) - TPV)/TPV)*100|| '%' AS Revenue_growth,
((LEAD(TPO) OVER(PARTITION BY PRODUCT_CATEGORY,YEAR ORDER BY MONTH)- TPO)/TPO)*100|| '%' AS Order_growth
FROM CTE)
SELECT MONTH, YEAR, PRODUCT_CATEGORY,TPV,TPO, Revenue_growth,Order_growth, TOTAL_COST,
TPV-TOTAL_COST AS Total_profit, TPV-TOTAL_COST/TOTAL_COST AS Profit_to_cost_ratio
FROM CTE1
ORDER BY YEAR

---2
WITH CTE AS(select created_at,user_id, sale_price,
min(created_at) over(partition by user_id) as first_chasing
from bigquery-public-data.thelook_ecommerce.order_items ),
cte2 as(
select FORMAT_DATE('%Y-%m', DATE (first_chasing)) AS cohort_date,
(extract(year from created_at)-extract(year from first_chasing))*12 + (extract(month from created_at)-extract(month from first_chasing)) + 1 as index, user_id, sale_price
from cte ),
cte3 as(select cohort_date, index, count(distinct user_id)as cnt, sum(sale_price)
from cte2
group by cohort_date, index),
cte4 as
(select cohort_date,
sum(case when index = 1 then cnt else 0 end) as t1,
sum(case when index = 2 then cnt else 0 end) as t2,
sum(case when index = 3 then cnt else 0 end) as t3,
sum(case when index = 4 then cnt else 0 end) as t4
from cte3
group by cohort_date
order by cohort_date)
select cohort_date,
round(100.00*t1/t1,2)|| '%' as m1,
round(100.00*t2/t1,2)||'%' as m2,
round(100.00*t3/t1,2)||'%'as m3,
round(100.00*t4/t1,2)||'%'as m4
from cte4
NHận xét:
- Giai đoạn từ 2019-2021, số lượng người tiêu dùng tăng lên sau mỗi tháng không ổn định và rất ít(2-5%)
- Từ 2022 trở đi, số lượng người tiêu dùng tăng lên đáng kể(6-18%)
- Có thể thấy tình hình kinh doanh của công ty đang ngày một cải thiện. Tuy nhiên công ty cần có thêm nhiều chương trình khuyến mãi hơn
để có thể thu hút thêm nhiều khách hàng mới hơn


