USE sql_invoicing;

SELECT client_id,
	SUM(invoice_total) AS total_sales,
	COUNT(*) AS number_of_invoices
FROM invoices 
GROUP BY client_id WITH ROLLUP


--WITH ROLLUP
SELECT state,city, SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients  c ON c.client_id = i.client_id
GROUP BY state,city WITH ROLLUP



--having
SELECT client_id,
	SUM(invoice_total) AS total_sales,
	COUNT(*) AS number_of_invoices
FROM invoices 
GROUP BY client_id WITH ROLLUP
HAVING SUM(invoice_total) > 500 AND COUNT(*) >5



--group by
SELECT state,city, SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients  c ON c.client_id = i.client_id
GROUP BY state,city


SELECT state,city, SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients  c ON c.client_id = i.client_id
WHERE invoice_date >= '2019-07-01'--تنها فروش های بعد از نیمه دوم سال رو بخوایم
GROUP BY state,city
ORDER BY total_sales



--aggregate function
SELECT SUM(invoice_total *1.1) AS total
FROM invoices
WHERE invoice_date > '2019-07-01' --مربوط به نیمه سال
















