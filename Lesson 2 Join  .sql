--UNION
USE sql_store;
SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers

USE sql_store;
SELECT order_id,order_date,'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'

UNION

SELECT order_id,order_date,'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01'




--CROSS JOIN

USE sql_store;

SELECT c.first_name AS customer , p.name AS 'product'
FROM customers c, products	P
ORDER BY c.first_name
-- یا روش دیگر
USE sql_store;

SELECT c.first_name AS customer , p.name AS 'product'
FROM customers c
CROSS JOIN products	P
ORDER BY c.first_name




--using 
USE sql_store
SELECT c.customer_id,c.first_name,o.order_id
FROM customers c
JOIN orders o 
ON o.customer_id = c.customer_id 




--جدول اوردرز با جدول شیپرز جوین کنیم تا اسم تحویل دهنده نشون داده بشه بهمون

-- outer join (left/right)
--left join
USE sql_store;

SELECT c.customer_id,c.first_name,o.order_id,sh.name AS shipper
FROM customers c
LEFT JOIN orders o 
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id =sh.shipper_id
ORDER BY c.customer_id


--جوین عادی
USE sql_store;

SELECT c.customer_id,c.first_name,o.order_id
FROM customers c
JOIN orders o 
	ON o.customer_id = c.customer_id
ORDER BY c.customer_id


--جوین ضمنی
USE sql_store
SELECT *
FROM orders o,customers c
WHERE o.customer_id = c.customer_id




--جوین کردن بیشتر از دو جدول
--  دیتابیس اینویسینگ جدول پیمنتس با جدول کلاینتس در همین دیتابیس جوین کنیم تا بجای دیدن کلاینت ایدی اسم اون مشتری رو مشاهده کنم 
--با پیمنت متد هم جوین کنم
USE sql_invoicing 
SELECT p.date ,p.invoice_id,p.amount, c.name,pm.name
FROM payments p
JOIN clients c ON p.client_id=c.client_id
JOIN  payment_methods pm ON p.payment_method=pm.payment_method_id


--جدول اوردرز را با جدول کاستومرز و استتوس
USE sql_store
SELECT o.order_id,o.order_date,c.first_name,c.last_name,os.name AS status
FROM orders o
JOIN customers c 
	ON o.customer_id = c.customer_id
JOIN order_statuses  os 
	ON o.status = os.order_status_id

--self join
USE sql_hr
SELECT e.employee_id ,e.first_name AS 'name of employee',m.first_name AS 'name of manager'
FROM employees e
JOIN employees m
ON e.reports_to=m.employee_id 

/*
-- دو روش جوین کردن دوتا دیتابیس
--الف
USE sql_inventory
SELECT *
FROM products p
JOIN sql_store.dbo.order_items oi
ON p.product_id = oi.product_id


--ب
USE sql_store
--جوین کردن چندین دیابیس
SELECT *
FROM order_items oi
JOIN sql_inventory.dbo.products  p
ON oi.product_id = p.product_id

----
SELECT order_id,oi.product_id, name,quantity,oi.unit_price
FROM order_items oi
JOIN products  p
ON oi.product_id = p.product_id



--خلاصه تر کردن اسم جدول ها

SELECT order_id,o.customer_id, first_name,last_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id


--
SELECT order_id,orders.customer_id, first_name,last_name
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id

--
SELECT *
FROM orders
JOIN customers
ON orders.customer_id = customers.customer_id
*/
