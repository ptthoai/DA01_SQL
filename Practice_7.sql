--EX1
WITH A AS 
(SELECT EXTRACT( YEAR FROM transaction_date) AS YEAR, PRODUCT_ID, SUM(SPEND) AS curr_year_spend	
FROM user_transactions
GROUP BY YEAR, PRODUCT_ID
ORDER BY YEAR)
SELECT *,
LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year),
ROUND((curr_year_spend - LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year))/LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year) * 100.0,2)
FROM A

--EX2
WITH ABC AS 
(SELECT CARD_NAME, ISSUED_AMOUNT,
  ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS STT
FROM monthly_cards_issued)
SELECT CARD_NAME, ISSUED_AMOUNT
FROM ABC
WHERE STT = 1
ORDER BY ISSUED_AMOUNT DESC

--EX3
WITH ABC AS
(SELECT *,
ROW_NUMBER () OVER (PARTITION BY USER_ID order by transaction_date) AS STT
FROM transactions)
SELECT user_id,spend, transaction_date
FROM ABC
WHERE STT = 3

--EX4
with abc as (SELECT transaction_date, user_id,
count(product_id) as purchase_count,
row_number() over(partition by user_id order by transaction_date desc) as stt
FROM user_transactions
group by user_id, transaction_date
order by transaction_date)
select transaction_date, user_id, purchase_count
from abc
where stt =1

--EX5
  WITH A AS (
SELECT *, 
lag(tweet_count) over (PARTITION BY user_id ORDER BY tweet_date) AS A1, 
lag(tweet_count, 2) over (PARTITION BY user_id ORDER BY tweet_date) AS A2
FROM tweets)
SELECT user_id, tweet_date,
(CASE
    WHEN A1 is NULL THEN ROUND(tweet_count, 2)
    WHEN A2 is NULL THEN ROUND((tweet_count+A1)/2.0, 2)
    ELSE ROUND((tweet_count+A1+A2)/3.0, 2)
  END) AS rolling_avg_3d
  FROM A;

--EX6
WITH ABC as (SELECT merchant_id, credit_card_id, amount, transaction_timestamp,
lag(transaction_timestamp)OVER(PARTITION BY merchant_id, credit_card_id, amount order by transaction_timestamp) 
as prev_transaction
FROM transactions
where EXTRACT(MINUTE from transaction_timestamp) <= 10)
select COUNT(merchant_id) as payment_count from ABC 
where  EXTRACT(MINUTE FROM transaction_timestamp)-EXTRACT(MINUTE FROM prev_transaction) <= 10

--EX7
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

--EX8
WITH A AS
(SELECT  a.artist_id,a.artist_name,b.song_id,c.rank,c.day
FROM artists as a  
join songs as b on a.artist_id=b.artist_id
join global_song_rank as c on b.song_id=c.song_id
WHERE rank <11),
B AS
(SELECT a.artist_name, a.artist_id,
COUNT(RANK) OVER(PARTITION BY ARTIST_Id) AS SO_LUONG
FROM A),
C AS (SELECT ARTIST_NAME, COUNT(SO_LUONG) AS SO_LAN,
DENSE_RANK () OVER( ORDER BY COUNT(SO_LUONG) DESC) AS ARTIST_RANK
FROM B 
GROUP BY ARTIST_NAME)
SELECT artist_name, ARTIST_RANK
FROM C
WHERE ARTIST_RANK <6
ORDER BY ARTIST_RANK ASC, ARTIST_NAME ASC
