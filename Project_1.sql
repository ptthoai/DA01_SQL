--Chuyển đổi kiểu dữ liệu
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE INTEGER USING (trim(ordernumber)::integer),
ALTER COLUMN quantityordered TYPE INTEGER USING (trim(quantityordered)::integer),
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric),
ALTER COLUMN orderlinenumber TYPE integer USING (trim(orderlinenumber)::integer),
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric), 
ALTER COLUMN msrp TYPE integer USING (trim(msrp)::integer);

SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)
--Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.



