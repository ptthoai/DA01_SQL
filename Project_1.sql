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
  SELECT *
FROM public.sales_dataset_rfm_prj
WHERE 
    ORDERNUMBER IS NULL OR
    QUANTITYORDERED IS NULL OR 
    PRICEEACH IS NULL OR
    ORDERLINENUMBER IS NULL OR 
    SALES IS NULL OR 
    ORDERDATE IS NULL ;

--Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
ALTER TABLE public.sales_dataset_rfm_prj
ADD CONTACTLASTNAME VARCHAR(20),
ADD CONTACTFIRSTNAME VARCHAR(20)
  
 UPDATE public.sales_dataset_rfm_prj
 SET 
    CONTACtlastname = UPPER(RIGHT(CONTACTFULLNAME,(LENGTH(CONTACTFULLNAME))-(POSITION('-'IN contactfullname)))),
	 CONTACTfirstname = UPPER(SUBSTRING(contactfullname FROM 1 FOR (POSITION('-'IN contactfullname) -1)))
	 WHERE CONTACTFULLNAME IS NOT NULL AND POSITION('-' IN CONTACTFULLNAME) > 0

--Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE public.sales_dataset_rfm_prj
ADD QTR_ID INT,
ADD MONTH_ID INT,
ADD YEAR_ID INT

UPDATE public.sales_dataset_rfm_prj
SET 
     QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

--Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) 
--CÁCH1
WITH min_max as 
  (select q1 -1.5*IQR AS min_value, q1 + 1.5*IQR AS max_value
  from  ( SELECT
  percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS q1,
  percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS q3,
  percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) - percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED)
  as IQR
  FROM sales_dataset_rfm_prj)
SELECT * FROM sales_dataset_rfm_prj
WHERE QUANTITYORDERED < (SELECT min_value from min_max)
  OR QUANTITYORDERED > (SELECT max_value from min_max)

  --CÁCH 2
with abc as (select orderdate, (select avg(QUANTITYORDERED) from sales_dataset_rfm_prj as avg),
  (select stddev(QUANTITYORDERED) from sales_dataset_rfm_prj as stddev)
  from sales_dataset_rfm_prj)
  select orderdate, (QUANTITYORDERED -avg)/stddev as z_score
  from abc
  where abs ((QUANTITYORDERED -avg)/stddev ) > 2

  -- CÁCH XỬ LÝ OUTLIER
    with abc as (select orderdate, (select avg(QUANTITYORDERED) from sales_dataset_rfm_prj as avg),
  (select stddev(QUANTITYORDERED) from sales_dataset_rfm_prj as stddev)
  from sales_dataset_rfm_prj),
  OUTLIER AS (select orderdate, (QUANTITYORDERED -avg)/stddev as z_score
  from abc
  where abs ((QUANTITYORDERED -avg)/stddev ) > 2)

  UPDATE public.sales_dataset_rfm_prj
  SET QUANTITYORDERED =(SELECT AVG(QUANTITYORDERED) FROM public.sales_dataset_rfm_prj)
  WHERE QUANTITYORDERED IN (SELECT QUANTITYORDERED FROM OUTLIER )

  --Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM public.sales_dataset_rfm_prj
WHERE ORDERNUMBER IS NOT NULL OR
    QUANTITYORDERED IS NOT NULL OR 
    PRICEEACH IS NOT NULL OR
    ORDERLINENUMBER IS NOT NULL OR 
    SALES IS NOT NULL OR 
    ORDERDATE IS NOT NULL
