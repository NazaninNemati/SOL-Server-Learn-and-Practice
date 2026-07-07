/*===========================================================
 تمرین‌های SQL Server (سطح آسان تا متوسط)
 Database: sql_invoicing
 ترتیب از 60 تا 1
===========================================================*/
USE sql_invoicing

-- ==========================================
-- IN / NOT IN (60-51)  
-- ==========================================

-- 60. مشتریانی را نمایش بده که شناسه آن‌ها در جدول invoices وجود دارد. (IN)

SELECT *
FROM clients
WHERE client_id IN(
	SELECT DISTINCT client_id
	FROM invoices
)

-- 59. مشتریانی را نمایش بده که شناسه آن‌ها در جدول invoices وجود ندارد. (NOT IN)

SELECT *
FROM clients C
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
	FROM invoices
	)
-- 58. فاکتورهایی را نمایش بده که مربوط به مشتریان ایالت CA هستند. (IN)
--********

SELECT *, (SELECT state FROM clients WHERE client_id=3 )
FROM invoices I
WHERE client_id IN (
	SELECT client_id
	FROM clients
	WHERE state = 'CA'
)

--GROUP BY C.client_id,name,state



--بدون IN

SELECT I.*
FROM clients C
JOIN invoices I 
	ON C.client_id = I.client_id

WHERE state = 'CA'
--GROUP BY C.client_id,name,state


-- 57. فاکتورهایی را نمایش بده که مربوط به مشتریان ایالت NY یا CA هستند. (IN)

SELECT invoice_id,name,state
FROM invoices I
JOIN clients  C
	ON C.client_id = I.client_id
WHERE state IN('CA','NY')

-- 56. روش‌های پرداختی را نمایش بده که در جدول payments استفاده شده‌اند. (IN)

SELECT *
FROM payment_methods
WHERE payment_method_ID IN (
	SELECT payment_method
	FROM payments)

--بدون IN
SELECT payment_method,name
FROM payments P
JOIN payment_methods P_M
	ON P.payment_method =P_M.payment_method_id
GROUP BY payment_method,name

-- 55. روش‌های پرداختی را نمایش بده که هیچ‌وقت استفاده نشده‌اند. (NOT IN)
SELECT *
FROM payment_methods
WHERE payment_method_ID  NOT IN (
	SELECT payment_method
	FROM payments)


--راه قبلیم ک درس نبود
SELECT payment_method_id,name
FROM payments P
RIGHT JOIN payment_methods P_M
	ON P.payment_id =P_M.payment_method_id
WHERE payment_method NOT IN ( payment_method_id)

-- 54. مشتریانی را نمایش بده که حداقل یک پرداخت انجام داده‌اند. (IN)

SELECT C.client_id,name

--,COUNT(payment_id) AS 'number_of_payments'
FROM clients C

WHERE  C.client_id IN (
	SELECT DISTINCT client_id
	FROM payments
) 


--جواب قبلیم
SELECT C.client_id,name,COUNT(payment_id) AS 'number_of_payments'
FROM clients C
JOIN payments P
	ON P.client_id = C.client_id
GROUP BY C.client_id,name

-- 

-- 53. فاکتورهایی را نمایش بده که هنوز پرداخت نشده‌اند. (NOT IN)
--***
SELECT *
FROM invoices
WHERE invoice_id NOT IN (
	SELECT invoice_id
	FROM payments
)


---جواب قبلیم
SELECT payment_id,COUNT(payment_id) AS 'number_of_payments'
FROM clients C
JOIN payments P
	ON P.client_id = C.client_id
WHERE  P.client_id NOT IN (C.client_id)
GROUP BY payment_id



-- 52. مشتریانی را نمایش بده که حداقل یک فاکتور با مبلغ بیشتر از 100 دارند. (IN)

SELECT *
FROM clients 
WHERE client_id IN (
	SELECT client_id
	FROM invoices
	WHERE invoice_total > 100
		)

--راه دیگه	

SELECT I.client_id,invoice_total
FROM clients C
JOIN invoices I
	ON I.client_id = C.client_id
WHERE invoice_id IN (
	SELECT invoice_id
	FROM invoices
	WHERE invoice_total> 100
	)

-- 51. مشتریانی را نمایش بده که هیچ فاکتوری با مبلغ بیشتر از 100 ندارند. (NOT IN)


SELECT *
FROM clients
WHERE  client_id NOT IN (
	SELECT DISTINCT client_id
	FROM invoices
	WHERE invoice_total > 100
)

-- ==========================================
-- ALL (50-41) ← متوسط
-- ==========================================

-- 50. فاکتورهایی را نمایش بده که مبلغشان از تمام فاکتورهای مشتری شماره 1 بیشتر باشد.

SELECT *
FROM invoices
WHERE  invoice_total > ALL (
	SELECT invoice_total
	FROM invoices
	WHERE client_id = 1
	
)


--راه دیگ
SELECT *
FROM invoices
WHERE  invoice_total >  (
	SELECT MAX(invoice_total)
	FROM invoices
	WHERE client_id = 1
	
)

-- 49. فاکتورهایی را نمایش بده که مبلغشان از تمام فاکتورهای مشتری شماره 2 کمتر باشد.
SELECT *
FROM invoices
WHERE invoice_total < ALL(
	SELECT invoice_total
	FROM invoices
	WHERE client_id = 2
)


-- 48. مشتریانی را پیدا کن که تمام فاکتورهایشان(فاکتور های خودشان) بیشتر از 100 باشد.

SELECT *
FROM clients C
WHERE 100 < ALL (
	SELECT invoice_total
	FROM invoices
	WHERE client_id = C.client_id
)

-- 47. مشتریانی را پیدا کن که تمام فاکتورهایشان کمتر از 500 باشد.

SELECT *
FROM clients C
WHERE 500 > ALL(
	SELECT invoice_total
	FROM invoices
	WHERE client_id = C.client_id
)


-- 46. فاکتورهایی را نمایش بده که از تمام فاکتورهای مشتری خود بزرگ‌تر باشند.
--****************
SELECT *
FROM invoices I
WHERE invoice_total > ALL(
	SELECT invoice_total
	FROM invoices
	WHERE client_id = I.client_id AND  invoice_id <> I.invoice_id
)





SELECT *
FROM invoices I
WHERE invoice_total >= ALL(
	SELECT invoice_total
	FROM invoices
	WHERE client_id = I.client_id
)


SELECT *
FROM invoices I
WHERE invoice_total  = (
	SELECT MAX(invoice_total)
	FROM invoices
	WHERE client_id = I.client_id
)
-- 45. مشتریانی را پیدا کن که تمام فاکتورهایشان پرداخت شده باشد.
--**************

SELECT *
FROM clients C
WHERE  NOT EXISTS (
	SELECT *
	FROM invoices I
	WHERE  I.client_id = C.client_id AND I.payment_total < I.invoice_total 
	--حتی اگر یک فاکتور پرداخت نشده پیدا شود ان مشتری حذف شود

)

-- 44. فاکتورهایی را نمایش بده که مبلغشان از تمام فاکتورهای پرداخت‌شده بیشتر باشد.

SELECT *
FROM invoices
WHERE invoice_total > ALL(
	SELECT invoice_total
	FROM invoices
	WHERE invoice_total = payment_total
)

-- 43. فاکتورهایی را نمایش بده که مبلغشان از تمام فاکتورهای پرداخت‌نشده کمتر باشد.
SELECT *
FROM invoices
WHERE invoice_total < ALL(
	SELECT invoice_total
	FROM invoices
	WHERE invoice_total != payment_total
)
-- 42. مشتریانی را پیدا کن که تمام فاکتورهایشان بیشتر از میانگین کل باشند.


SELECT *
FROM clients C
WHERE (
	SELECT AVG(invoice_total)
	FROM invoices
	) < ALL(
	SELECT invoice_total
	FROM invoices
	WHERE client_id = C.client_id
	)


--راه حل اولم ک خوب نبود
--میانگین مشتری رو نخواسته
SELECT 
	client_id,
	AVG(invoice_total) AS average 
FROM invoices
GROUP BY client_id
HAVING AVG(invoice_total) < ALL(
	SELECT invoice_total
	FROM invoices
)


-- 41. فاکتورهایی را نمایش بده که مبلغشان از تمام فاکتورهای مشتریان ایالت CA بیشتر باشد.
--***
SELECT *
FROM invoices
WHERE invoice_total > ALL(
	SELECT invoice_total
	FROM invoices
	WHERE client_id IN (
		SELECT client_id
		FROM clients
		WHERE state ='CA'
		)--مشتریان ایالت CA
)--تمام فاکتورهای مشتری ایالت مورد نظر


-- ==========================================
-- ANY (40-31) ← آسان تا متوسط
-- ==========================================

-- 40. فاکتورهایی را نمایش بده که مبلغشان از یکی از فاکتورهای مشتری شماره 1 بیشتر باشد.

SELECT *
FROM invoices
WHERE invoice_total > ANY (
	SELECT invoice_total
	FROM invoices
	WHERE client_id = 1
)

--راه دیگه
SELECT *
FROM invoices
WHERE invoice_total >  (
	SELECT MIN(invoice_total)
	FROM invoices
	WHERE client_id = 1
)



--فاکتور های مشتری یک
SELECT invoice_total
	FROM invoices
	WHERE client_id = 1
-- 39. فاکتورهایی را نمایش بده که مبلغشان از یکی از فاکتورهای مشتری شماره 3 کمتر باشد.

SELECT *
FROM invoices
WHERE invoice_total < ANY (
	SELECT invoice_total
	FROM invoices
	WHERE client_id = 3
)


--فاکتور های مشتری شماره 3
SELECT *
FROM invoices
WHERE client_id = 3

-- 38. فاکتورهایی را نمایش بده که مبلغشان از یکی از فاکتورهای پرداخت‌شده بیشتر باشد.
SELECT *
FROM invoices
WHERE invoice_total > ANY(
	SELECT invoice_total
	FROM invoices
	WHERE invoice_total = payment_total

) 


-- 37. فاکتورهایی را نمایش بده که مبلغشان از یکی از فاکتورهای پرداخت‌نشده کمتر باشد.
SELECT *
FROM invoices
WHERE invoice_total < ANY (
	SELECT invoice_total
	FROM invoices
	WHERE payment_total < invoice_total
)



-- 36. مشتریانی را نمایش بده که حداقل یک فاکتورشان از یکی از فاکتورهای مشتری شماره 1 بیشتر باشد.
--******
SELECT *
FROM clients C
WHERE client_id IN (
	SELECT client_id 
	FROM invoices
	WHERE client_id = C.client_id AND invoice_total > ANY (
		SELECT invoice_total 
		FROM invoices
		WHERE client_id = 1
	)
)
	
--- راه دیگه با EXIXTS
SELECT *
FROM clients C
WHERE EXISTS (
	SELECT client_id 
	FROM invoices
	WHERE client_id = C.client_id AND invoice_total > ANY (
		SELECT invoice_total 
		FROM invoices
		WHERE client_id = 1
	)
)
	



---

SELECT client_id,invoice_total
FROM invoices
WHERE invoice_total > ANY( 
	SELECT invoice_total
	FROM invoices
	WHERE client_id =1
)

-- 35. مشتریانی را نمایش بده که حداقل یک فاکتورشان بیشتر از 200 باشد. (ANY)

SELECT *
FROM  clients C
WHERE 200 < ANY (
	SELECT invoice_total
	FROM invoices
	WHERE client_id = C.client_id

)
-- 34. فاکتورهایی را نمایش بده که از یکی از فاکتورهای ایالت CA بیشتر باشند.

SELECT *
FROM invoices
WHERE invoice_total > ANY (
	SELECT invoice_total
	FROM invoices I
	JOIN clients C
		ON I.client_id =C.client_id
	WHERE state = 'CA' 
	--فاکتور های ایالت CA
)

-- 33. فاکتورهایی را نمایش بده که از یکی از فاکتورهای ایالت NY کمتر باشند.

SELECT *
FROM invoices 
WHERE invoice_total < ANY(
	SELECT invoice_total
	FROM invoices I
	JOIN clients C
		ON I.client_id =C.client_id
	WHERE state = 'NY'

)

-- 32. مشتریانی را نمایش بده که حداقل یک فاکتورشان از یکی از میانگین‌های فاکتور های خودشان بیشتر باشد.
--*****
SELECT *
FROM clients
WHERE client_id IN (
	SELECT client_id
	FROM invoices I
	WHERE invoice_total  > ANY (
		SELECT AVG(invoice_total)
		FROM invoices
		WHERE client_id = I.client_id
	)
)


SELECT *
FROM clients C
WHERE EXISTS (
	SELECT client_id
	FROM invoices I
	WHERE I.client_id = C.client_id AND  invoice_total  > ANY (
		SELECT AVG(invoice_total)
		FROM invoices
		WHERE client_id = I.client_id
	)
)




-- 31. فاکتورهایی را نمایش بده که مبلغشان از یکی از سه فاکتور اول جدول بیشتر باشد.
SELECT *
FROM invoices
WHERE invoice_total > ANY(
	SELECT TOP 3 invoice_total
	FROM invoices
)



-- ==========================================
-- Subquery in SELECT (30-21) ← آسان
-- ==========================================

-- 30. کنار هر مشتری، تعداد فاکتورهای او را نمایش بده.

SELECT * ,
	(
	SELECT COUNT(*) 
	FROM invoices I
	WHERE I.client_id = C.client_id --کورولیشن داریم
	) AS invoice_count
FROM clients C


-- 29. کنار هر مشتری، مجموع مبلغ فاکتورهای او را نمایش بده.

SELECT *,
	(
	SELECT SUM(invoice_total) 
	FROM invoices I
	WHERE I.client_id = C.client_id
	) AS total_invoices


FROM clients C


-- 28. کنار هر مشتری، میانگین مبلغ فاکتورهای او را نمایش بده.

SELECT *,
	(SELECT AVG (invoice_total) 
	FROM invoices I 
	WHERE I.client_id = C.client_id
	) AS average_invoices
FROM clients C

-- 27. کنار هر مشتری، بیشترین مبلغ فاکتور او را نمایش بده.
SELECT *,
	(SELECT MAX(invoice_total) 
	FROM invoices I
	WHERE I.client_id =C.client_id
	) AS max_invoices
FROM clients C



-- 26. کنار هر مشتری، کمترین مبلغ فاکتور او را نمایش بده.
SELECT *,
	(
	SELECT MIN (invoice_total)
	FROM invoices I
	WHERE I.client_id = C.client_id
	) AS min_invoices
FROM clients C


-- 25. کنار هر مشتری، آخرین تاریخ فاکتور او را نمایش بده.

SELECT *,
	(
	 SELECT MAX(invoice_date)
	 FROM invoices I 
	 WHERE I.client_id = C.client_id
	) AS max_invoice_date
FROM clients C



-- 24. کنار هر مشتری، اولین تاریخ فاکتور او را نمایش بده.

SELECT *,
	(
	SELECT MIN (invoice_date)
	FROM invoices I 
	WHERE I.client_id = C.client_id
	) AS min_invoice_date
FROM clients C


-- 23. کنار هر فاکتور، تعداد فاکتورهای همان مشتری را نمایش بده.

SELECT *,
	(SELECT COUNT(client_id)
	FROM invoices I2
	WHERE I2.client_id = I1.client_id
	) AS count_invoices_of_clients
FROM  invoices I1



-- 22. کنار هر فاکتور، میانگین مبلغ فاکتورهای همان مشتری را نمایش بده.

SELECT *,
	(
	SELECT AVG(invoice_total)
	FROM invoices I2
	WHERE I1.client_id = I2.client_id
	) AS average_invoice_of_clients
FROM invoices I1


-- 21. کنار هر فاکتور، بیشترین مبلغ فاکتورهای همان مشتری را نمایش بده.


SELECT *,
	(
	SELECT MAX(invoice_total)
	FROM invoices I2
	WHERE I1.client_id = I2.client_id
	) AS max_invoice_of_clients
FROM invoices I1


-- ==========================================
-- EXISTS (20-11) ← آسان تا متوسط
-- ==========================================

-- 20. مشتریانی را نمایش بده که حداقل یک فاکتور دارند.

SELECT *
FROM clients C
WHERE EXISTS(
	SELECT *
	FROM invoices I
	WHERE C.client_id = I.client_id
)

-- 19. مشتریانی را نمایش بده که هیچ فاکتوری ندارند.
SELECT *
FROM clients C
WHERE  NOT EXISTS (
	SELECT *
	FROM invoices I
	WHERE I.client_id = C.client_id
)

-- 18. فاکتورهایی را نمایش بده که پرداخت شده‌اند.

SELECT *
FROM invoices I1
WHERE EXISTS (
	SELECT *
	FROM invoices I2
	WHERE I1.invoice_total = I2.payment_total
)


-- 17. فاکتورهایی را نمایش بده که پرداخت نشده‌اند.
SELECT *
FROM invoices I1
WHERE  NOT EXISTS (
	SELECT *
	FROM invoices I2
	WHERE I2.invoice_total = I1.payment_total
)



-- 16. مشتریانی را نمایش بده که حداقل یک پرداخت انجام داده‌اند.
SELECT *
FROM clients C
WHERE EXISTS(
	SELECT *
	FROM invoices I
	WHERE C.client_id = I.client_id AND payment_total != 0
)


-- 15. مشتریانی را نمایش بده که هیچ پرداختی انجام نداده‌اند.
--*****
SELECT *
FROM clients C
WHERE NOT EXISTS(
	SELECT *
	FROM invoices I
	WHERE I.client_id =C.client_id AND  payment_total != 0
)



-- 14. روش‌های پرداختی را نمایش بده که حداقل یک بار استفاده شده‌اند.
SELECT *
FROM payment_methods P_M
WHERE EXISTS (
	SELECT *
	FROM payments P
	WHERE P_M.payment_method_id = P.payment_method
)


-- 13. روش‌های پرداختی را نمایش بده که هیچ‌وقت استفاده نشده‌اند.
SELECT *
FROM payment_methods P_M
WHERE NOT EXISTS(
	SELECT *
	FROM payments P
	WHERE P.payment_method = P_M.payment_method_id 
)

-- 12. مشتریانی را نمایش بده که حداقل یک فاکتور با مبلغ بیشتر از 200 دارند.
SELECT *
FROM clients C
WHERE EXISTS(
	SELECT *
	FROM invoices I
	WHERE C.client_id = I.client_id AND invoice_total >200
)

-- 11. مشتریانی را نمایش بده که حداقل یک فاکتور در سال 2019 دارند.

SELECT *
FROM clients C
WHERE EXISTS (
	SELECT *
	FROM invoices I
	WHERE  C.client_id = I.client_id AND  YEAR(invoice_date) = 2019

)





