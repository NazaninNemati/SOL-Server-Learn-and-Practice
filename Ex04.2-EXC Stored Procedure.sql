

--7
EXEC risk_factor

--6
EXEC make_payment 
	@invoice_id =1,
	@payment_amount = -200,
	@payment_date = '2019-01-01'

--5
EXEC make_payment 
	@invoice_id =1,
	@payment_amount = 50,
	@payment_date = '2019-01-01'




--4
EXEC get_client_with_state 



--3
EXEC get_client @state = NULL



--2
/*
USE sql_invoicing;
GO

DECLARE @invoice_count INT ;
DECLARE @invoice_total	DECIMAL(9,2);

EXEC get_unpaid_invoices_for_client
	@client_id = 1,
	@invoice_count = @invoice_count  OUTPUT  , 
	@invoice_total = @invoice_total OUTPUT;

SELECT 
	@invoice_count AS invoice_count , 
	@invoice_total AS invoice_total

*/


--1
--EXEC get_client @state = 'CA' ;















