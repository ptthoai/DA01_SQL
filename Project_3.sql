---1
select productline, 
year_id,
dealsize,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by productline,year_id,dealsize
order by year_id

---2
with revenue_table as(select month_id, year_id,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by month_id, year_id)
select month_id,revenue, row_number_rank
from
(select month_id,revenue,
row_number() over(partition by year_id order by revenue desc) as row_number_rank
from revenue_table) as rank_table
where row_number_rank = 1
order by month_id

---3
SELECT MONTH_ID,PRODUCTLINE, SUM(SALES) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
WHERE MONTH_ID=11
GROUP BY MONTH_ID,PRODUCTLINE 
ORDER BY REVENUE DESC
LIMIT 1

---4
WITH CTE AS(select YEAR_ID, PRODUCTLINE,
sum(sales) as REVENUE,country
from public.sales_dataset_rfm_prj_clean
where country = 'UK'
group by YEAR_ID,PRODUCTLINE, country)
SELECT YEAR_ID, PRODUCTLINE,REVENUE,RANK
FROM
(SELECT YEAR_ID, PRODUCTLINE,REVENUE,
RANK() OVER(PARTITION BY YEAR_ID ORDER BY REVENUE DESC) AS RANK
FROM CTE) AS RANK_TABLE
WHERE RANK = 1

---5
WITH CTE AS(select
customername,
current_date - max(orderdate) as R,
COUNT(DISTINCT ORDERNUMBER) AS F,
SUM(SALES) AS M
from public.sales_dataset_rfm_prj_clean
GROUP BY CUSTOMERNAME),
RFM_SCORE AS (
SELECT CUSTOMERNAME,
NTILE(5) OVER( ORDER BY R DESC ) AS R_SCORE,
NTILE(5) OVER( ORDER BY F  ) AS F_SCORE,
NTILE(5) OVER( ORDER BY M DESC ) AS M_SCORE
FROM CTE),
RFM_FINAL AS(
SELECT CUSTOMERNAME,
CAST(R_SCORE AS VARCHAR) || CAST(F_SCORE AS VARCHAR)||CAST(M_SCORE AS VARCHAR) AS RFM_SCORE
FROM RFM_SCORE)
SELECT CUSTOMERNAME,SEGMENT FROM RFM_FINAL JOIN SEGMENT_SCORE
ON RFM_FINAL.RFM_SCORE=SEGMENT_SCORE.SCORES
WHERE SEGMENT = 'Champions'
