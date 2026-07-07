
USE sql_invoicing
GO


/*==========================================================
سوال 1

یک Stored Procedure به نام CheckClientInvoices بنویس.

ورودی:
@ClientId INT

اگر مشتری فاکتور داشت:

پیام:
Client Has Invoices

اگر نداشت:

پیام:
No Invoice Found


راهنمایی:
از EXISTS استفاده کن.

==========================================================*/

CREATE OR ALTER PROCEDURE CheckClientInvoices

	@ClientId INT
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM invoices I
		WHERE I.client_id = @ClientId
	)
	BEGIN
		PRINT 'Client Has Invoices'
	END

	ELSE
	BEGIN
		PRINT 'No Invoice Found'
	END


END



EXEC CheckClientInvoices 3


GO

/*==========================================================
سوال 2 

یک Stored Procedure به نام GetClientInvoiceCount بنویس.

ورودی:
@ClientId INT

خروجی:
تعداد فاکتورهای مشتری را نمایش بده.

اگر مشتری وجود نداشت:

پیام:
Client Not Found


راهنمایی:
اول EXISTS بررسی کن.

==========================================================*/

CREATE OR ALTER PROCEDURE GetClientInvoiceCount
	@ClientId INT
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (
		SELECT 1
		FROM clients
		WHERE client_id = @ClientId
	)
	BEGIN 
		PRINT 'Client Not Found'
	END

	ELSE
	BEGIN
		SELECT COUNT(*) AS invoice_count
		FROM invoices
		WHERE client_id = @ClientId

	END

END

EXEC GetClientInvoiceCount 90

GO

/*==========================================================
سوال 3 (آسان)

یک Stored Procedure به نام UpdateInvoicePayment بنویس.

ورودی:

@InvoiceId INT
@PaymentAmount DECIMAL(10,2)


مبلغ پرداختی یک فاکتور را تغییر بده.

اگر فاکتور وجود نداشت:

پیام:
Invoice Not Found


راهنمایی:
بعد از UPDATE از @@ROWCOUNT استفاده کن.

==========================================================*/

CREATE OR ALTER PROCEDURE UpdateInvoicePayment
	@InvoiceId INT,
	@PaymentAmount DECIMAL(10,2)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE invoices
		SET payment_total = @PaymentAmount
		WHERE invoice_id = @InvoiceId

		IF @@ROWCOUNT > 0
		BEGIN
			PRINT 'Updated Successfully'
		END
		ELSE
		BEGIN
			PRINT 'Invoice Not Found'
		END

	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH

END
--نیازی نبود ترای کچ بزنیم چون اگه اینویس نباشه خطا نیست ولی خب باشه هم عیب نداره



EXEC UpdateInvoicePayment 200,8.7

GO


/*
--با EXISRS میخواستم برم خوب در نیومد
CREATE OR ALTER PROCEDURE UpdateInvoicePayment
	@InvoiceId INT,
	@PaymentAmount DECIMAL(10,2)
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (
		SELECT *
		FROM invoices
		WHERE invoice_id = @InvoiceId
	)
	BEGIN
		UPDATE invoices
		SET payment_total = @PaymentAmount
		WHERE invoice_id = @InvoiceId
	END
	IF @@ROWCOUNT > 0
		BEGIN
			PRINT 'Updated Successfully'
		END
		ELSE
		BEGIN
			PRINT 'Client Not Found'
		END


END
*/

/*==========================================================
سوال 4 (آسان)

یک Stored Procedure به نام GetClientTotalInvoices بنویس.

ورودی:

@ClientId INT

خروجی OUTPUT:

@TotalAmount


جمع مبلغ invoice_total مشتری را برگردان.


==========================================================*/

CREATE OR ALTER PROCEDURE GetClientTotalInvoices
	@ClientId INT,
	@TotalAmount DECIMAL(9,2) OUTPUT
AS
BEGIN
	SELECT @TotalAmount = SUM(invoice_total)
	FROM invoices
	WHERE client_id = @ClientId
END

--اجرا
DECLARE @total_amount DECIMAL(9,2)
EXEC GetClientTotalInvoices 
	@ClientId =3,
	@TotalAmount = @total_amount OUTPUT

SELECT @total_amount


GO
/*==========================================================
سوال 5 (متوسط)

یک Stored Procedure به نام AddInvoice بنویس.

ورودی:

@ClientId INT
@InvoiceDate DATE
@InvoiceTotal DECIMAL(10,2)


یک فاکتور جدید ثبت کن.

قبل از INSERT بررسی کن مشتری وجود داشته باشد.

اگر مشتری نبود:

پیام:
Client Not Found


==========================================================*/

CREATE OR ALTER PROCEDURE AddInvoice
	@invoice_id INT,
	@ClientId INT,
	@InvoiceDate DATE,
	@InvoiceTotal DECIMAL(10,2),
	@number	VARCHAR(50),
	@due_date DATE
AS
BEGIN
	IF EXISTS(
		SELECT *
		FROM clients C
		WHERE C.client_id = @ClientId
	)
	BEGIN
		INSERT INTO invoices(invoice_id,client_id,invoice_date,invoice_total,due_date,number)
		VALUES (@invoice_id,@ClientId,@InvoiceDate,@InvoiceTotal,@due_date,@number)
	END

	ELSE
	BEGIN
		PRINT 'Client Not Found'
	END





END


EXEC AddInvoice 19,3,'2024-04-03',56.9,'094384382','2023-04-01'

GO
--راه دوم
/*
AS
BEGIN
	IF EXISTS (
		SELECT *
		FROM clients C
		WHERE C.client_id = @ClientId
	)
	BEGIN
	INSERT INTO invoices(invoice_id,client_id,invoice_date,invoice_total,due_date,number)
	VALUES (@invoice_id,@ClientId,@InvoiceDate,@InvoiceTotal,@due_date,@number)
	END

	ELSE
	BEGIN
		PRINT 'Client Not Found'
	END


END
*/

/*==========================================================
سوال 6 (متوسط)

یک Stored Procedure به نام DeleteClientSafe بنویس.


ورودی:

@ClientId INT


با TRY...CATCH مشتری را حذف کن.


قبل از حذف بررسی کن:

اگر مشتری فاکتور داشت:

پیام:
Cannot Delete Client


اگر نداشت:

حذف شود.


راهنمایی:
از EXISTS استفاده کن.


==========================================================*/
CREATE OR ALTER PROCEDURE DeleteClientSafe
	@ClientId INT
AS
BEGIN
	BEGIN TRY
		IF  NOT EXISTS (
		SELECT *
		FROM invoices I
		WHERE I.client_id = @ClientId
		)BEGIN
			DELETE C FROM clients C
			WHERE C.client_id = @ClientId
		 END

		ELSE
		BEGIN
			PRINT 'Cannot Delete Client'
		END

	END TRY

	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH


END


EXEC DeleteClientSafe 5

GO




/*==========================================================
سوال 7 (متوسط)

یک Stored Procedure به نام GetClientInvoices بنویس.


ورودی:

@ClientId INT


خروجی:

نام مشتری
شماره فاکتور
تاریخ فاکتور
مبلغ فاکتور


راهنمایی:
از JOIN بین clients و invoices استفاده کن.


==========================================================*/

CREATE OR ALTER PROCEDURE GetClientInvoices
	@ClientId INT
AS
BEGIN
	SELECT 
		name,
		invoice_id,
		invoice_date,
		invoice_total,
		(
			SELECT STRING_AGG(invoice_id,', ')
			FROM invoices INV
			WHERE INV.client_id = C.client_id
		) AS 'all_invoce_ids'
	FROM clients C
	JOIN invoices I
		ON C.client_id =I.client_id
	WHERE C.client_id =@ClientId

END

EXEC GetClientInvoices 3


GO

/*==========================================================
سوال 8 (سخت)

یک Stored Procedure به نام TransferPayment بنویس.


ورودی:

@FromInvoice INT
@ToInvoice INT
@Amount DECIMAL(10,2)


مبلغی را از یک فاکتور کم کن
و به فاکتور دیگر اضافه کن.


شرایط:

اگر هر خطایی رخ داد هیچ تغییری ثبت نشود.


راهنمایی:
از Transaction استفاده کن.


==========================================================*/


CREATE OR ALTER PROCEDURE TransferPayment
	@FromInvoice INT,
	@ToInvoice INT,
	@Amount DECIMAL(10,2)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE invoices
			SET  payment_total = payment_total  - @Amount 
			WHERE @FromInvoice = invoice_id;

			UPDATE invoices
			SET	payment_total=  payment_total + @Amount
			FROM invoices I
			WHERE @ToInvoice = invoice_id;

		COMMIT
	END TRY

	BEGIN CATCH
		ROLLBACK
	END CATCH
END


EXEC TransferPayment 3,5,10

GO
/*==========================================================
سوال 9 (متوسط رو به سخت)

یک Stored Procedure به نام CreateInvoiceWithPayment بنویس.


ورودی:

@ClientId INT
@InvoiceTotal DECIMAL(10,2)
@PaymentAmount DECIMAL(10,2)


کارها:

1- یک Invoice ایجاد کن

2- پرداخت اولیه را ثبت کن


اگر مرحله دوم خطا داشت:

مرحله اول هم نباید باقی بماند.


راهنمایی:
BEGIN TRANSACTION
COMMIT
ROLLBACK


==========================================================*/

CREATE OR ALTER PROCEDURE CreateInvoiceWithPayment
	@InvoiceId INT,
	@ClientId INT,
	@InvoiceDate DATE,
	@InvoiceTotal DECIMAL(10,2),
	@PaymentAmount DECIMAL(10,2),
	@Number	VARCHAR(50),
	@DueDate DATE,
	@PaymentId INT,
	@PaymentDate DATE,
	@PaymentMethod VARCHAR(50)
AS
BEGIN
	BEGIN TRY

		BEGIN TRANSACTION
		INSERT INTO invoices(invoice_id,client_id,invoice_total,payment_total,invoice_date,due_date,number)
		VALUES (@InvoiceId,@ClientId,@InvoiceTotal,@PaymentAmount,@InvoiceDate,@DueDate,@Number);

		INSERT INTO payments(payment_id,client_id,invoice_id,date,amount,payment_method)
		VALUES (@PaymentId,@ClientId,@InvoiceId,@paymentDate,@PaymentAmount,@PaymentMethod)
		COMMIT
		PRINT 'invoce created successfully'
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		ROLLBACK
		PRINT ERROR_MESSAGE()
	END CATCH

END


GO

/*==========================================================
سوال 10 نسبتاًسخت

یک Stored Procedure به نام SafeUpdateInvoice بنویس.


ورودی:

@InvoiceId INT
@NewTotal DECIMAL(10,2)


با TRY...CATCH و TRANSACTION:

- فاکتور را آپدیت کن
- اگر موفق بود:

Updated Successfully

- اگر خطا رخ داد:

ROLLBACK شود و متن خطا چاپ شود.


==========================================================*/

CREATE OR ALTER PROCEDURE SafeUpdateInvoice
	@InvoiceId INT,
	@NewTotal DECIMAL(10,2)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION 
			UPDATE invoices
			SET invoice_total = @NewTotal
			WHERE invoice_id = @InvoiceId

			IF @@ROWCOUNT > 0
			BEGIN
				PRINT 'Updated Successfully'
			END
			ELSE
			BEGIN
				PRINT 'Update Unuccessfully'
			END
		COMMIT
	END TRY

	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK
	END CATCH

END





EXEC SafeUpdateInvoice 500,17



GO








/*==========================================================
سوال 11

یک Stored Procedure به نام GetClient بنویس.

ورودی:
@ClientId INT

اگر مشتری وجود داشت، اطلاعاتش را نمایش بده.
اگر وجود نداشت، عبارت زیر را چاپ کن:

Client Not Found

==========================================================*/
CREATE OR ALTER PROCEDURE GetClient
	@ClientId INT
AS
BEGIN

	IF EXISTS (
		SELECT *
		FROM clients
		WHERE client_id = @ClientId
	)
	BEGIN
		SELECT *
		FROM clients
		WHERE client_id = @ClientId
	END
	ELSE
	BEGIN
		PRINT 'Client Not Found'
	END


END


EXEC GetClient 2
GO
/*==========================================================
1سوال 2

یک Stored Procedure به نام DeleteClientIfExists بنویس.

ورودی:
@ClientId INT

اگر مشتری وجود داشت، حذفش کن.
اگر وجود نداشت، پیام مناسب چاپ کن.

==========================================================*/
CREATE OR ALTER PROCEDURE DeleteClientIfExists
	@ClientId INT
AS

BEGIN
	IF EXISTS (
		SELECT *
		FROM clients
		WHERE client_id = @ClientId
	)	
	BEGIN
		DELETE FROM clients
			WHERE client_id =@ClientId
	END

	ELSE
	BEGIN
		PRINT 'the client does not exist'
	END

END
GO


/*==========================================================
سوال 13

یک Stored Procedure به نام CountInvoices بنویس.

ورودی:
@ClientId INT

یک پارامتر OUTPUT به نام @InvoiceCount داشته باشد.

تعداد فاکتورهای مشتری را داخل آن قرار بده.

==========================================================*/


CREATE OR ALTER PROCEDURE CountInvoices
	@ClientId INT,
	@InvoiceCount INT OUTPUT
AS

BEGIN
	SELECT @InvoiceCount = COUNT(*)
	FROM invoices
	WHERE client_id = @ClientId


END

GO

--
DECLARE @InvoiceCount INT

EXEC CountInvoices 5, @InvoiceCount OUTPUT
SELECT  @InvoiceCount

GO
/*==========================================================
1سوال 4

یک Stored Procedure به نام TotalPayments بنویس.

ورودی:
@ClientId INT

یک پارامتر OUTPUT به نام @TotalPayment داشته باشد.

جمع payment_total مشتری را داخل آن قرار بده.

==========================================================*/
CREATE OR ALTER PROCEDURE TotalPayments
	@ClientId INT,
	@TotalPayment INT OUTPUT
AS
BEGIN
	SELECT @TotalPayment = SUM(payment_total)
	FROM invoices
	WHERE client_id = @ClientId
END

--اجرا
DECLARE @total INT
EXEC TotalPayments 2,@total OUTPUT 
SELECT 2 AS client_id
	,@total AS total_payment


GO
/*==========================================================
سوال 15

یک Stored Procedure به نام ClientExists بنویس.

ورودی:
@ClientId INT

اگر مشتری وجود داشت

RETURN 1

اگر وجود نداشت

RETURN 0

==========================================================*/

CREATE OR ALTER PROCEDURE ClientExists
	@ClientId INT
AS
BEGIN
	IF EXISTS(
	SELECT 1 -- * هم میشه ولی برای خوانایی بیشتر یک میزاریم
	FROM clients C
	WHERE C.client_id =@ClientId
	)
	BEGIN
		RETURN 1
	END

	ELSE
	BEGIN
		RETURN 0
	END

END

--اجرا
EXEC ClientExists 9

GO
/*==========================================================
سوال 16

یک Stored Procedure به نام DeleteInvoice بنویس.

ورودی:
@InvoiceId INT

عملیات حذف را داخل TRY...CATCH انجام بده.

اگر خطایی رخ داد، متن خطا را چاپ کن.

==========================================================*/


CREATE OR ALTER PROCEDURE DeleteInvoice
	@InvoiceId INT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DELETE FROM invoices 
		WHERE invoice_id = @InvoiceId

		/*
		--alias
		DELETE I
		FROM invoices I
		WHERE I.invoice_id = @InvoiceId
		*/
	END TRY
	BEGIN CATCH
		PRINT 'can not delete'
		PRINT ERROR_MESSAGE()
	END CATCH



END

--اجرا
EXEC DeleteInvoice 3

GO


/*==========================================================
1سوال 7

یک Stored Procedure به نام UpdatePhoneIfExists بنویس.

ورودی:

@ClientId INT
@Phone VARCHAR(50)

اگر مشتری وجود داشت، شماره تلفنش را تغییر بده.

در غیر این صورت پیام مناسبی چاپ کن.

==========================================================*/

CREATE OR ALTER PROCEDURE UpdatePhoneIfExists
	@ClientId INT,
	@Phone VARCHAR(50)
AS
BEGIN
	IF EXISTS (
		SELECT *
		FROM clients C
		WHERE C.client_id = @ClientId
	)
	BEGIN
		UPDATE clients
		SET phone = @Phone
		WHERE client_id =@ClientId
	END

	ELSE
	BEGIN
		PRINT 'CAN NOT CHANGE THE  PHONE NUMBER'
	END
END


--اجرا

EXEC UpdatePhoneIfExists 2,'0923939'


GO


/*==========================================================
1سوال 8

یک Stored Procedure به نام GetInvoiceCount بنویس.

ورودی:
@ClientId INT

اگر مشتری وجود نداشت

RETURN -1

در غیر این صورت

تعداد فاکتورهایش را با SELECT نمایش بده.

==========================================================*/
CREATE OR ALTER PROCEDURE GetInvoiceCount
	@ClientId INT
AS
BEGIN
	SET NOCOUNT ON ;

	IF NOT EXISTS (
	SELECT *
	FROM clients
	WHERE client_id =@ClientId
	)
	BEGIN
		RETURN -1
	END

	ELSE
	BEGIN
		SELECT COUNT(*)
		FROM invoices
		WHERE client_id = @ClientId
	END

END
	
	

EXEC GetInvoiceCount 3



GO



/*==========================================================
سوال 19

یک Stored Procedure به نام GetClientName بنویس.

ورودی:
@ClientId INT

یک پارامتر OUTPUT به نام @ClientName داشته باشد.

نام مشتری را داخل آن قرار بده.

اگر مشتری وجود نداشت

مقدار NULL داخل OUTPUT قرار بگیرد.

==========================================================*/

CREATE OR ALTER PROCEDURE GetClientName
	@ClientId INT,
	@ClientName VARCHAR(50) OUTPUT
AS
BEGIN
	IF NOT EXISTS (
		SELECT *
		FROM clients
		WHERE client_id = @ClientId
	)
	BEGIN
	SELECT @ClientName = NULL
	FROM clients
	WHERE client_id = @ClientId
	END

	ELSE
	BEGIN
		SELECT @ClientName = name
		FROM clients
		WHERE client_id = @ClientId

	END


END
	
--اجرا

DECLARE @client_name VARCHAR(50)

EXEC GetClientName 2 , @client_name OUTPUT

SELECT @client_name AS client_name

GO


/*==========================================================
سوال 20

یک Stored Procedure به نام SafeUpdatePhone بنویس.

ورودی:

@ClientId INT
@Phone VARCHAR(50)

با استفاده از TRY...CATCH شماره تلفن مشتری را تغییر بده.

اگر عملیات موفق بود عبارت زیر را چاپ کن:

Updated Successfully

اگر خطا رخ داد، متن خطا را چاپ کن.

==========================================================*/

CREATE OR ALTER PROCEDURE  SafeUpdatePhone
	@ClientId INT,
	@Phone VARCHAR(50)
AS
BEGIN 
	BEGIN TRY
		UPDATE clients
		SET phone = @Phone
		WHERE client_id = @ClientId

		PRINT 'Updated Successfully'
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH


END


EXEC SafeUpdatePhone 2,'78787870'

GO






--  10 سوال سطح اسان

/*===================================
سوال 21
یک Stored Procedure به نام GetAllClients بنویس.

- هیچ پارامتری نگیرد.
- تمام اطلاعات جدول clients را نمایش دهد.
==================================*/

GO

CREATE OR ALTER PROCEDURE GetAllClients

AS 

BEGIN
	SET NOCOUNT ON;
	SELECT *
	FROM clients

END
GO


--EXEC GetAllClients;

/*==========================================================
سوال 22
یک Stored Procedure به نام GetClientById بنویس.
خروجی:
اطلاعات مشتری با شناسه وارد شده را نمایش دهد.
==========================================================*/
CREATE OR ALTER PROCEDURE GetClientById
	@client_id INT
 AS

 BEGIN
	SELECT *
	FROM clients
	WHERE client_id = @client_id

 END


EXEC GetClientById 3

GO



/*
سوال 23
یک Stored Procedure به نام GetInvoicesByClient بنویس.

ورودی:
@ClientId INT

خروجی:
تمام فاکتورهای مربوط به آن مشتری را نمایش دهد.



==========================================================*/

CREATE OR ALTER PROCEDURE GetInvoicesByClient
	@client_id INT
AS
BEGIN
	SELECT 
		client_id,
		invoice_id,
		invoice_total,
		payment_total
		
	FROM invoices I

	WHERE @client_id =  I.client_id 
END


EXEC GetInvoicesByClient 3;

GO

/*==========================================================
سوال 24
یک Stored Procedure به نام GetUnpaidInvoices بنویس.
ورودی ندارد.
خروجی:
تمام فاکتورهایی که پرداخت کامل نشده‌اند را نمایش دهد.


==========================================================*/

CREATE OR ALTER PROCEDURE GetUnpaidInvoices

AS
BEGIN
	SELECT *
	FROM invoices I
	WHERE invoice_total > payment_total

END

EXEC GetUnpaidInvoices

GO

/*==========================================================
سوال 25
یک Stored Procedure به نام CountInvoicesByClient بنویس.

خروجی:
تعداد فاکتورهای آن مشتری را نمایش دهد.



راهنمایی:
از COUNT(*) استفاده کن.
==========================================================*/

CREATE OR ALTER PROCEDURE CountInvoicesByClient
	@client_id INT

AS
BEGIN 
	SELECT 
		client_id,
		COUNT(invoice_id) AS invoice_count
	FROM invoices I
	WHERE @client_id = client_id
	GROUP BY client_id
END


EXEC CountInvoicesByClient 3;
GO

/*==========================================================
سوال 26
یک Stored Procedure به نام TotalInvoiceAmount بنویس.

ورودی:
@ClientId INT

خروجی:
جمع مبلغ تمام فاکتورهای آن مشتری را نمایش دهد.

مثال اجرا:


==========================================================*/

CREATE OR ALTER PROCEDURE TotalInvoiceAmount
	@client_id INT
AS
BEGIN
	SET NOCOUNT ON;
	SELECT SUM(invoice_total) AS invoices_sum
	FROM invoices
	WHERE @client_id = client_id

END


EXEC TotalInvoiceAmount 3;

GO
/*==========================================================
سوال 27
یک Stored Procedure به نام InvoicesBetweenDates بنویس.
خروجی:
تمام فاکتورهایی که بین این دو تاریخ ثبت شده‌اند.

مثال اجرا:
EXEC InvoicesBetweenDates
'2019-01-01',
'2019-06-30';

==========================================================*/

CREATE OR ALTER PROCEDURE InvoicesBetweenDates
	@start_date DATE,
	@end_date DATE
AS
	
BEGIN

	SELECT *
	FROM invoices
	WHERE invoice_date BETWEEN @start_date AND @end_date ;

END

EXEC InvoicesBetweenDates '2019-01-01' ,'2019-06-30'

GO
/*==========================================================
سوال 28
یک Stored Procedure به نام AddClient بنویس.

ورودی‌ها:
@ClientId
@Name
@Address
@City
@State
@Phone

خروجی:
یک مشتری جدید داخل جدول clients ثبت شود.


==========================================================*/
CREATE OR ALTER PROCEDURE AddClient
	@ClientId  INT ,
	@Name      VARCHAR(50),
	@Address   VARCHAR(60),
	@City      VARCHAR(10),
	@State     VARCHAR(10),
	@Phone     VARCHAR(10)

AS
BEGIN

	INSERT INTO clients(client_id,name,address,city,state,phone)
	VALUES (
	@ClientId ,
	@Name,
	@Address,
	@City,
	@State,
	@Phone
	)


END

EXEC AddClient 12,'NAZ','CAAR','SN','CA','21939101'

GO
/*==========================================================
سوال 29
یک Stored Procedure به نام UpdateClientPhone بنویس.

ورودی:
@ClientId
@Phone

خروجی:
شماره تلفن مشتری تغییر کند.

مثال اجرا:
EXEC UpdateClientPhone 3,'09123456789';


==========================================================*/
CREATE OR ALTER PROCEDURE UpdateClientPhone
	@ClientId INT,
	@Phone VARCHAR(50)
AS
BEGIN

UPDATE clients
	SET phone =@Phone
	WHERE client_id = @ClientId

END

EXEC UpdateClientPhone @ClientId =2,@phone =123456 

GO
/*==========================================================
سوال 30
یک Stored Procedure به نام DeleteClient بنویس.

ورودی:
@ClientId

خروجی:
مشتری حذف شود.

مثال اجرا:
EXEC DeleteClient 8;

نکته:
اگر مشتری فاکتور داشته باشد ممکن است به دلیل Foreign Key خطا بگیری.
==========================================================*/
CREATE OR ALTER PROCEDURE DeleteClient
	@ClientId INT
AS
BEGIN
	DELETE FROM clients
	WHERE client_id = @ClientId


END

EXEC DeleteClient 3;