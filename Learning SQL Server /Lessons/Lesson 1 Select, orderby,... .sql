USE sql_store;

--13 OFFSET   FETCH
SELECT *
FROM customers
ORDER BY customer_id
OFFSET 1 ROWS
FETCH NEXT 3 ROWS ONLY

SELECT *
FROM customers
--12 TOP ( LIMIT in MY SQL)

SELECT TOP 10 *
FROM customers
ORDER BY points DESC



--11 order by
SELECT *, quantity*unit_price AS total
FROM order_items
ORDER BY quantity*unit_price DESC


SELECT first_name,last_name,10 AS points
FROM customers
ORDER BY state DESC,first_name DESC





--10
SELECT * 
FROM customers
WHERE phone IS NOT NULL


--9 REGEXP
SELECT * 
FROM customers
--WHERE last_name LIKE '%field%'
--WHERE last_name REGEXP 'field'

--8 like %  , _
SELECT * 
FROM customers
WHERE address LIKE '%tril%' OR address LIKE '%avenue'




--7 BETWEEN 
SELECT * 
FROM customers
--WHERE points >=1000 AND points<= 3000 --راه بهتر در خط بعدی
--WHERE points BETWEEN 1000 AND 3000
WHERE birth_date BETWEEN  '1990-01-01' AND '2000-01-01'


-- 6 IN
SELECT * 
FROM customers
--WHERE state='VA' OR state='SA' OR state='FL' --راه خلاصه تر در خط بعد
WHERE state IN ('VA','GA','FL' )


--5 END OR
SELECT * 
FROM order_items
WHERE order_id=6 AND unit_price*quantity > 30

SELECT * 
FROM customers
WHERE NOT ( birth_date > '1990-01-01' OR points > 1000 ) --also we can say 
--WHERE birth_date < '1990-01-01' AND points < 1000 



--  4 WHERE فیلتر کردن داده ها
SELECT * 
FROM customers
WHERE state != 'VA' -- وقتی داده ما متنی هست حتما باید سینگل کوت بزاریم


--3
SELECT name,unit_price,unit_price*1.1 AS new_price
FROM products



--2
SELECT 
	first_name ,
	last_name,
	points,
	(points* 10), --experetion
	(points* 10)+100 AS 'discount factor' --اگ بخوایم تو اسمی که میزاریم فاصله وجود داشته باشه از سینگل کوت استفاده میکنیم
FROM customers
--1
SELECT * FROM customers
WHERE customer_id=1 
--sort kardan
ORDER BY first_name




