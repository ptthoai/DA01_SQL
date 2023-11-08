--EX1
Select name from City
Where population > 120000
AND countrycode = 'USA';

--EX2
Select * from city
where countrycode = 'JPN';

--EX3
Select city,state from station;

--EX4 
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE 'a%'
OR CITY LIKE 'e%'
OR CITY LIKE 'i%'
OR CITY LIKE 'o%'
OR CITY LIKE 'u%';

--EX5
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u';

--EX6
SELECT DISTINCT CITY FROM STATION 
WHERE CITY NOT LIKE 'a%'
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'i%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'u%';

--EX7
Select name from employee
order by name ASC;

--EX8
Select name from employee
where salary > 2000 
AND months < 10
order by employee_id ASC;

--EX9
Select product_id from products
where low_fats = 'Y'
AND recyclable = 'Y';

--EX10
Select name from customer
where referee_id <> 2 OR referee_id is null;

--EX11
Select name, population, area from world
where area > 3000000 OR population > 25000000;

--EX12
SELECT distinct author_id AS id 
from views
where article_id > 1
order by author_id ASC;

--EX13
Select part, assembly_step
from parts_assembly
where finish_date IS null

--EX14
select * from lyft_drivers
WHERE yearly_salary not between 30001 and 69999;

--EX15
select advertising_channel from uber_advertising
where money_spent > 1000000
AND year = 2019;
