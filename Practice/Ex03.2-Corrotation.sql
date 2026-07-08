USE sql_invoicing
GO;
-- ==========================================
-- Correlated Subquery (10-1) ← آسان تا متوسط
-- ==========================================

-- 10. فاکتورهایی را نمایش بده که مبلغشان از میانگین فاکتورهای همان مشتری بیشتر باشد.

SELECT *
FROM invoices I
WHERE invoice_total >(
	SELECT AVG(invoice_total)
	FROM invoices I2
	WHERE I2.client_id = I.client_id

)

-- 9. فاکتورهایی را نمایش بده که مبلغشان از میانگین فاکتورهای همان مشتری کمتر باشد.

SELECT *
FROM invoices I
WHERE invoice_total < (
	SELECT AVG(invoice_total)
	FROM invoices I1
	WHERE I1.client_id =I.client_id

)



-- 8. برای هر مشتری، گران‌ترین فاکتور را نمایش بده.
-- بدون جوین  
SELECT 
	client_id,
	C.name,
	(
	SELECT MAX(invoice_total)
	FROM invoices I
	WHERE I.client_id = C.client_id
	) AS max_invoice
FROM clients C


--با جوین
SELECT DISTINCT
	C.client_id,
	C.name AS client_name,
	(
	SELECT MAX(invoice_total)
	FROM invoices I2
	WHERE I2.client_id = I.client_id
	) AS max_invoice

FROM clients C
JOIN invoices I
	ON C.client_id =I.client_id;





-- 7. برای هر مشتری، ارزان‌ترین فاکتور را نمایش بده.

SELECT DISTINCT
	C.client_id,
	(
	SELECT MIN(invoice_total)
	FROM invoices I2
	WHERE I2.client_id = C.client_id
	) AS min_invoice

FROM clients C




-- 6. مشتریانی را نمایش بده که حداقل یک فاکتور بالاتر از میانگین فاکتورهای خود دارند.
-- بدون جوین با EXISTS

SELECT *
FROM clients C
WHERE EXISTS (
	SELECT 1
	FROM invoices I1
	WHERE I1.client_id = C.client_id 
		AND  
		invoice_total  > (
			SELECT AVG(invoice_total)
			FROM invoices I2
			WHERE I2.client_id =C.client_id
	
		)
)






--با جوین
SELECT 
	C.client_id,
	name AS client_name,
	STRING_AGG( invoice_total,' , ') AS total_ivoice_more_than_average,
	AVG (invoice_total) AS average_invoice

FROM clients C

JOIN invoices I
	ON I.client_id = C.client_id

WHERE invoice_total > (
	SELECT AVG(invoice_total)
	FROM invoices I2
	WHERE I2.client_id = I.client_id 
)

GROUP BY C.client_id,name

-- 5. فاکتورهایی را نمایش بده که مبلغشان با بیشترین مبلغ فاکتور همان مشتری برابر باشد.

SELECT *
FROM invoices I1
WHERE invoice_total = (
	SELECT MAX(invoice_total)
	FROM invoices I2
	WHERE I2.client_id = I1.client_id
)



-- 4. فاکتورهایی را نمایش بده که مبلغشان با کمترین مبلغ فاکتور همان مشتری برابر باشد.


SELECT *
FROM invoices I1
WHERE invoice_total = (
	SELECT MIN(invoice_total)
	FROM invoices I2
	WHERE I2.client_id = I1.client_id

)

-- 3. فاکتورهایی را نمایش بده که تاریخ آن‌ها آخرین تاریخ فاکتور همان مشتری باشد.
SELECT *
FROM invoices I1
WHERE invoice_date = (
	SELECT MAX(invoice_date)
	FROM invoices I2
	WHERE I2.client_id = I1.client_id
)


-- 2. فاکتورهایی را نمایش بده که تاریخ آن‌ها اولین تاریخ فاکتور همان مشتری باشد.
SELECT *
FROM invoices I1
WHERE invoice_date =(
	SELECT MIN(invoice_date)
	FROM invoices I2
	WHERE I2.client_id = I1.client_id
)



-- 1. مشتریانی را نمایش بده که بیش از یک فاکتور دارند و یکی از فاکتورهایشان از میانگین فاکتورهای خودشان بیشتر است.
SELECT 
	C.client_id,
	C.name AS 'client_name',
	invoice_id,
	invoice_total
FROM clients C
JOIN invoices I1
	ON I1.client_id = C.client_id
WHERE  1 < (
	SELECT COUNT(invoice_id)
	FROM invoices I2
	WHERE I2.client_id = I1.client_id 
	)
	AND 
	invoice_total > (
	SELECT AVG(invoice_total)
	FROM invoices I3
	WHERE I3.client_id = I1.client_id
	
	)
ORDER BY C.client_id





