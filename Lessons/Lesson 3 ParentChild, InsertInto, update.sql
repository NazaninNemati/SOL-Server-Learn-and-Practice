/*
--update
USE sql_invoicing
UPDATE invoices
SET payment_total =invoice_total*0.5 , invoice_date = due_date
WHERE client_id =3



--ایجاد و کپی کردن جدول قدیمی در جدولی جدید
USE sql_store
SELECT *
INTO new_table_nazi
FROM orders	



--رابطه والد و و فرزند
USE sql_store

INSERT INTO orders(customer_id,order_date,status)
VALUES(1,'2022-01-01',1);

DECLARE @OrderId INT;
SET @OrderId = SCOPE_IDENTITY()

INSERT INTO order_items(order_id,product_id,quantity,unit_price)
VALUES 
	(@OrderId,1,1,2.95),
	(@OrderId,2,3,2.5)


---اضافه کردن سطر
 USE sql_store

INSERT INTO customers(first_name,last_name,birth_date,address,city,state)
VALUES('neon',
	'learn',
	'1990-01-01',
	'address',
	'city',
	'CA')
*/
