--EX1
SELECT 
sum(CASE 
  WHEN device_type = 'laptop' THEN 1
  ELSE 0
END) AS laptop_views,
sum(CASE 
  WHEN device_type IN ('phone','tablet') THEN 1
  ELSE 0
END) AS mobile_views
from viewership;

--EX2
Select x,y,z,
CASE
    WHEN ((x+y) > z ) AND ((x+z) > y) AND ((y+z) > x) THEN 'Yes'
    ELSE 'No'
END AS triangle
FROM triangle;

--EX3
SELECT 
ROUND((SUM( CASE
          WHEN call_category IS NULL OR call_category = 'n/a' THEN 1
          ELSE 0
      END))/COUNT(*),1) AS call_percentage
FROM callers;

--EX4
SELECT name
FROM customer
where COALESCE(referee_id,0) <> 2;

--EX5
select survived, 
SUM(CASE WHEN pclass = 1 then 1 ELSE 0 END) AS first_class,
SUM( CASE WHEN pclass = 2 then 1 ELSE 0 END) AS second_class,
SUM( CASE WHEN pclass = 3 then 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived;
