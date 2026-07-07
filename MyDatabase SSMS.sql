-- ============================================
-- اسکریپت نهایی - ایجاد ۴ دیتابیس
-- ============================================

USE master;
GO

-- ============================================
-- حذف دیتابیس‌های قبلی
-- ============================================

DECLARE @dbName NVARCHAR(128);
DECLARE @sqlCmd NVARCHAR(MAX);
DECLARE db_cursor CURSOR FOR 
SELECT name FROM sys.databases 
WHERE name IN ('sql_invoicing', 'sql_store', 'sql_hr', 'sql_inventory');

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @dbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        SET @sqlCmd = '
            IF EXISTS (SELECT name FROM sys.databases WHERE name = ''' + @dbName + ''')
            BEGIN
                ALTER DATABASE [' + @dbName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                DROP DATABASE [' + @dbName + '];
            END';
        EXEC sp_executesql @sqlCmd;
        PRINT 'Database ' + @dbName + ' dropped successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error dropping database ' + @dbName + ': ' + ERROR_MESSAGE();
    END CATCH
    
    FETCH NEXT FROM db_cursor INTO @dbName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
GO

PRINT '==========================================';
PRINT '    All old databases have been removed';
PRINT '==========================================';
GO

-- ============================================
-- 1. دیتابیس sql_invoicing
-- ============================================

CREATE DATABASE sql_invoicing;
GO

USE sql_invoicing;
GO

CREATE TABLE payment_methods (
    payment_method_id tinyint NOT NULL IDENTITY(1,1),
    name varchar(50) NOT NULL,
    CONSTRAINT PK_payment_methods PRIMARY KEY (payment_method_id)
);
GO

SET IDENTITY_INSERT payment_methods ON;
INSERT INTO payment_methods (payment_method_id, name) VALUES 
(1, 'Credit Card'),
(2, 'Cash'),
(3, 'PayPal'),
(4, 'Wire Transfer');
SET IDENTITY_INSERT payment_methods OFF;
GO

CREATE TABLE clients (
    client_id int NOT NULL,
    name varchar(50) NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state char(2) NOT NULL,
    phone varchar(50) NULL,
    CONSTRAINT PK_clients PRIMARY KEY (client_id)
);
GO

INSERT INTO clients (client_id, name, address, city, state, phone) VALUES 
(1, 'Vinte', '3 Nevada Parkway', 'Syracuse', 'NY', '315-252-7305'),
(2, 'Myworks', '34267 Glendale Parkway', 'Huntington', 'WV', '304-659-1170'),
(3, 'Yadel', '096 Pawling Parkway', 'San Francisco', 'CA', '415-144-6037'),
(4, 'Kwideo', '81674 Westerfield Circle', 'Waco', 'TX', '254-750-0784'),
(5, 'Topiclounge', '0863 Farmco Road', 'Portland', 'OR', '971-888-9129');
GO

CREATE TABLE invoices (
    invoice_id int NOT NULL,
    number varchar(50) NOT NULL,
    client_id int NOT NULL,
    invoice_total decimal(9,2) NOT NULL,
    payment_total decimal(9,2) NOT NULL DEFAULT 0.00,
    invoice_date date NOT NULL,
    due_date date NOT NULL,
    payment_date date NULL,
    CONSTRAINT PK_invoices PRIMARY KEY (invoice_id),
    CONSTRAINT FK_invoices_clients FOREIGN KEY (client_id) REFERENCES clients(client_id)
);
GO

CREATE INDEX IX_invoices_client_id ON invoices(client_id);
GO

INSERT INTO invoices (invoice_id, number, client_id, invoice_total, payment_total, invoice_date, due_date, payment_date) VALUES
(1, '91-953-3396', 2, 101.79, 0.00, '2019-03-09', '2019-03-29', NULL),
(2, '03-898-6735', 5, 175.32, 8.18, '2019-06-11', '2019-07-01', '2019-02-12'),
(3, '20-228-0335', 5, 147.99, 0.00, '2019-07-31', '2019-08-20', NULL),
(4, '56-934-0748', 3, 152.21, 0.00, '2019-03-08', '2019-03-28', NULL),
(5, '87-052-3121', 5, 169.36, 0.00, '2019-07-18', '2019-08-07', NULL),
(6, '75-587-6626', 1, 157.78, 74.55, '2019-01-29', '2019-02-18', '2019-01-03'),
(7, '68-093-9863', 3, 133.87, 0.00, '2019-09-04', '2019-09-24', NULL),
(8, '78-145-1093', 1, 189.12, 0.00, '2019-05-20', '2019-06-09', NULL),
(9, '77-593-0081', 5, 172.17, 0.00, '2019-07-09', '2019-07-29', NULL),
(10, '48-266-1517', 1, 159.50, 0.00, '2019-06-30', '2019-07-20', NULL),
(11, '20-848-0181', 3, 126.15, 0.03, '2019-01-07', '2019-01-27', '2019-01-11'),
(13, '41-666-1035', 5, 135.01, 87.44, '2019-06-25', '2019-07-15', '2019-01-26'),
(15, '55-105-9605', 3, 167.29, 80.31, '2019-11-25', '2019-12-15', '2019-01-15'),
(16, '10-451-8824', 1, 162.02, 0.00, '2019-03-30', '2019-04-19', NULL),
(17, '33-615-4694', 3, 126.38, 68.10, '2019-07-30', '2019-08-19', '2019-01-15'),
(18, '52-269-9803', 5, 180.17, 42.77, '2019-05-23', '2019-06-12', '2019-01-08'),
(19, '83-559-4105', 1, 134.47, 0.00, '2019-11-23', '2019-12-13', NULL);
GO

CREATE TABLE payments (
    payment_id int NOT NULL IDENTITY(1,1),
    client_id int NOT NULL,
    invoice_id int NOT NULL,
    date date NOT NULL,
    amount decimal(9,2) NOT NULL,
    payment_method tinyint NOT NULL,
    CONSTRAINT PK_payments PRIMARY KEY (payment_id),
    CONSTRAINT FK_payments_clients FOREIGN KEY (client_id) REFERENCES clients(client_id),
    CONSTRAINT FK_payments_invoices FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    CONSTRAINT FK_payments_payment_methods FOREIGN KEY (payment_method) REFERENCES payment_methods(payment_method_id)
);
GO

CREATE INDEX IX_payments_client_id ON payments(client_id);
CREATE INDEX IX_payments_invoice_id ON payments(invoice_id);
CREATE INDEX IX_payments_payment_method ON payments(payment_method);
GO

INSERT INTO payments (client_id, invoice_id, date, amount, payment_method) VALUES
(5, 2, '2019-02-12', 8.18, 1),
(1, 6, '2019-01-03', 74.55, 1),
(3, 11, '2019-01-11', 0.03, 1),
(5, 13, '2019-01-26', 87.44, 1),
(3, 15, '2019-01-15', 80.31, 1),
(3, 17, '2019-01-15', 68.10, 1),
(5, 18, '2019-01-08', 32.77, 1),
(5, 18, '2019-01-08', 10.00, 2);
GO

PRINT '==========================================';
PRINT '  sql_invoicing created successfully!';
PRINT '==========================================';
GO

-- ============================================
-- 2. دیتابیس sql_store
-- ============================================

CREATE DATABASE sql_store;
GO

USE sql_store;
GO

CREATE TABLE products (
    product_id int NOT NULL IDENTITY(1,1),
    name varchar(50) NOT NULL,
    quantity_in_stock int NOT NULL,
    unit_price decimal(4,2) NOT NULL,
    CONSTRAINT PK_products PRIMARY KEY (product_id)
);
GO

INSERT INTO products (name, quantity_in_stock, unit_price) VALUES
('Foam Dinner Plate', 70, 1.21),
('Pork - Bacon,back Peameal', 49, 4.65),
('Lettuce - Romaine, Heart', 38, 3.35),
('Brocolinni - Gaylan, Chinese', 90, 4.53),
('Sauce - Ranch Dressing', 94, 1.63),
('Petit Baguette', 14, 2.39),
('Sweet Pea Sprouts', 98, 3.29),
('Island Oasis - Raspberry', 26, 0.74),
('Longan', 67, 2.26),
('Broom - Push', 6, 1.09);
GO

CREATE TABLE shippers (
    shipper_id smallint NOT NULL IDENTITY(1,1),
    name varchar(50) NOT NULL,
    CONSTRAINT PK_shippers PRIMARY KEY (shipper_id)
);
GO

INSERT INTO shippers (name) VALUES
('Hettinger LLC'),
('Schinner-Predovic'),
('Satterfield LLC'),
('Mraz, Renner and Nolan'),
('Waters, Mayert and Prohaska');
GO

CREATE TABLE customers (
    customer_id int NOT NULL IDENTITY(1,1),
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    birth_date date NULL,
    phone varchar(50) NULL,
    address varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state char(2) NOT NULL,
    points int NOT NULL DEFAULT 0,
    CONSTRAINT PK_customers PRIMARY KEY (customer_id)
);
GO

INSERT INTO customers (first_name, last_name, birth_date, phone, address, city, state, points) VALUES
('Babara', 'MacCaffrey', '1986-03-28', '781-932-9754', '0 Sage Terrace', 'Waltham', 'MA', 2273),
('Ines', 'Brushfield', '1986-04-13', '804-427-9456', '14187 Commercial Trail', 'Hampton', 'VA', 947),
('Freddi', 'Boagey', '1985-02-07', '719-724-7869', '251 Springs Junction', 'Colorado Springs', 'CO', 2967),
('Ambur', 'Roseburgh', '1974-04-14', '407-231-8017', '30 Arapahoe Terrace', 'Orlando', 'FL', 457),
('Clemmie', 'Betchley', '1973-11-07', NULL, '5 Spohn Circle', 'Arlington', 'TX', 3675),
('Elka', 'Twiddell', '1991-09-04', '312-480-8498', '7 Manley Drive', 'Chicago', 'IL', 3073),
('Ilene', 'Dowson', '1964-08-30', '615-641-4759', '50 Lillian Crossing', 'Nashville', 'TN', 1672),
('Thacher', 'Naseby', '1993-07-17', '941-527-3977', '538 Mosinee Center', 'Sarasota', 'FL', 205),
('Romola', 'Rumgay', '1992-05-23', '559-181-3744', '3520 Ohio Trail', 'Visalia', 'CA', 1486),
('Levy', 'Mynett', '1969-10-13', '404-246-3370', '68 Lawn Avenue', 'Atlanta', 'GA', 796);
GO

CREATE TABLE order_statuses (
    order_status_id tinyint NOT NULL,
    name varchar(50) NOT NULL,
    CONSTRAINT PK_order_statuses PRIMARY KEY (order_status_id)
);
GO

INSERT INTO order_statuses (order_status_id, name) VALUES
(1, 'Processed'),
(2, 'Shipped'),
(3, 'Delivered');
GO

CREATE TABLE orders (
    order_id int NOT NULL IDENTITY(1,1),
    customer_id int NOT NULL,
    order_date date NOT NULL,
    status tinyint NOT NULL DEFAULT 1,
    comments varchar(2000) NULL,
    shipped_date date NULL,
    shipper_id smallint NULL,
    CONSTRAINT PK_orders PRIMARY KEY (order_id),
    CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK_orders_order_statuses FOREIGN KEY (status) REFERENCES order_statuses(order_status_id),
    CONSTRAINT FK_orders_shippers FOREIGN KEY (shipper_id) REFERENCES shippers(shipper_id)
);
GO

CREATE INDEX IX_orders_customer_id ON orders(customer_id);
CREATE INDEX IX_orders_shipper_id ON orders(shipper_id);
CREATE INDEX IX_orders_status ON orders(status);
GO

INSERT INTO orders (customer_id, order_date, status, comments, shipped_date, shipper_id) VALUES
(6, '2019-01-30', 1, NULL, NULL, NULL),
(7, '2018-08-02', 2, NULL, '2018-08-03', 4),
(8, '2017-12-01', 1, NULL, NULL, NULL),
(2, '2017-01-22', 1, NULL, NULL, NULL),
(5, '2017-08-25', 2, '', '2017-08-26', 3),
(10, '2018-11-18', 1, 'Aliquam erat volutpat. In congue.', NULL, NULL),
(2, '2018-09-22', 2, NULL, '2018-09-23', 4),
(5, '2018-06-08', 1, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', NULL, NULL),
(10, '2017-07-05', 2, 'Nulla mollis molestie lorem. Quisque ut erat.', '2017-07-06', 1),
(6, '2018-04-22', 2, NULL, '2018-04-23', 2);
GO

CREATE TABLE order_items (
    order_id int NOT NULL,
    product_id int NOT NULL,
    quantity int NOT NULL,
    unit_price decimal(4,2) NOT NULL,
    CONSTRAINT PK_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT FK_order_items_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);
GO

CREATE INDEX IX_order_items_product_id ON order_items(product_id);
GO

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 4, 4, 3.74),
(2, 1, 2, 9.10),
(2, 4, 4, 1.66),
(2, 6, 2, 2.94),
(3, 3, 10, 9.12),
(4, 3, 7, 6.99),
(4, 10, 7, 6.40),
(5, 2, 3, 9.89),
(6, 1, 4, 8.65),
(6, 2, 4, 3.28),
(6, 3, 4, 7.46),
(6, 5, 1, 3.45),
(7, 3, 7, 9.17),
(8, 5, 2, 6.94),
(8, 8, 2, 8.59),
(9, 6, 5, 7.28),
(10, 1, 10, 6.01),
(10, 9, 9, 4.28);
GO

CREATE TABLE order_item_notes (
    note_id int NOT NULL,
    order_id int NOT NULL,
    product_id int NOT NULL,
    note varchar(255) NOT NULL,
    CONSTRAINT PK_order_item_notes PRIMARY KEY (note_id)
);
GO

INSERT INTO order_item_notes (note_id, order_id, product_id, note) VALUES
(1, 1, 2, 'first note'),
(2, 1, 2, 'second note');
GO

PRINT '==========================================';
PRINT '    sql_store created successfully!';
PRINT '==========================================';
GO

-- ============================================
-- 3. دیتابیس sql_hr
-- ============================================

CREATE DATABASE sql_hr;
GO

USE sql_hr;
GO
CREATE TABLE offices (
    office_id int NOT NULL,
    address varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state varchar(50) NOT NULL,
    CONSTRAINT PK_offices PRIMARY KEY (office_id)
);
GO

INSERT INTO offices (office_id, address, city, state) VALUES
(1, '03 Reinke Trail', 'Cincinnati', 'OH'),
(2, '5507 Becker Terrace', 'New York City', 'NY'),
(3, '54 Northland Court', 'Richmond', 'VA'),
(4, '08 South Crossing', 'Cincinnati', 'OH'),
(5, '553 Maple Drive', 'Minneapolis', 'MN'),
(6, '23 North Plaza', 'Aurora', 'CO'),
(7, '9658 Wayridge Court', 'Boise', 'ID'),
(8, '9 Grayhawk Trail', 'New York City', 'NY'),
(9, '16862 Westend Hill', 'Knoxville', 'TN'),
(10, '4 Bluestem Parkway', 'Savannah', 'GA');
GO

CREATE TABLE employees (
    employee_id int NOT NULL,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    job_title varchar(50) NOT NULL,
    salary int NOT NULL,
    reports_to int NULL,
    office_id int NOT NULL,
    CONSTRAINT PK_employees PRIMARY KEY (employee_id),
    CONSTRAINT FK_employees_offices FOREIGN KEY (office_id) REFERENCES offices(office_id),
    CONSTRAINT FK_employees_managers FOREIGN KEY (reports_to) REFERENCES employees(employee_id)
);
GO

CREATE INDEX IX_employees_office_id ON employees(office_id);
CREATE INDEX IX_employees_reports_to ON employees(reports_to);
GO

INSERT INTO employees (employee_id, first_name, last_name, job_title, salary, reports_to, office_id) VALUES
(37270, 'Yovonnda', 'Magrannell', 'Executive Secretary', 63996, NULL, 10),
(33391, 'D''arcy', 'Nortunen', 'Account Executive', 62871, 37270, 1),
(37851, 'Sayer', 'Matterson', 'Statistician III', 98926, 37270, 1),
(40448, 'Mindy', 'Crissil', 'Staff Scientist', 94860, 37270, 1),
(56274, 'Keriann', 'Alloisi', 'VP Marketing', 110150, 37270, 1),
(63196, 'Alaster', 'Scutchin', 'Assistant Professor', 32179, 37270, 2),
(67009, 'North', 'de Clerc', 'VP Product Management', 114257, 37270, 2),
(67370, 'Elladine', 'Rising', 'Social Worker', 96767, 37270, 2),
(68249, 'Nisse', 'Voysey', 'Financial Advisor', 52832, 37270, 2),
(72540, 'Guthrey', 'Iacopetti', 'Office Assistant I', 117690, 37270, 3),
(72913, 'Kass', 'Hefferan', 'Computer Systems Analyst IV', 96401, 37270, 3),
(75900, 'Virge', 'Goodrum', 'Information Systems Manager', 54578, 37270, 3),
(76196, 'Mirilla', 'Janowski', 'Cost Accountant', 119241, 37270, 3),
(80529, 'Lynde', 'Aronson', 'Junior Executive', 77182, 37270, 4),
(80679, 'Mildrid', 'Sokale', 'Geologist II', 67987, 37270, 4),
(84791, 'Hazel', 'Tarbert', 'General Manager', 93760, 37270, 4),
(95213, 'Cole', 'Kesterton', 'Pharmacist', 86119, 37270, 4),
(96513, 'Theresa', 'Binney', 'Food Chemist', 47354, 37270, 5),
(98374, 'Estrellita', 'Daleman', 'Staff Accountant IV', 70187, 37270, 5),
(115357, 'Ivy', 'Fearey', 'Structural Engineer', 92710, 37270, 5);
GO

PRINT '==========================================';
PRINT '    sql_hr created successfully!';
PRINT '==========================================';
GO

-- ============================================
-- 4. دیتابیس sql_inventory
-- ============================================

CREATE DATABASE sql_inventory;
GO

USE sql_inventory;
GO

CREATE TABLE products (
    product_id int NOT NULL IDENTITY(1,1),
    name varchar(50) NOT NULL,
    quantity_in_stock int NOT NULL,
    unit_price decimal(4,2) NOT NULL,
    CONSTRAINT PK_products PRIMARY KEY (product_id)
);
GO

INSERT INTO products (name, quantity_in_stock, unit_price) VALUES
('Foam Dinner Plate', 70, 1.21),
('Pork - Bacon,back Peameal', 49, 4.65),
('Lettuce - Romaine, Heart', 38, 3.35),
('Brocolinni - Gaylan, Chinese', 90, 4.53),
('Sauce - Ranch Dressing', 94, 1.63),
('Petit Baguette', 14, 2.39),
('Sweet Pea Sprouts', 98, 3.29),
('Island Oasis - Raspberry', 26, 0.74),
('Longan', 67, 2.26),
('Broom - Push', 6, 1.09);
GO

PRINT '==========================================';
PRINT '  sql_inventory created successfully!';
PRINT '==========================================';
GO

-- ============================================
-- گزارش نهایی
-- ============================================
PRINT '==========================================';
PRINT '         ALL DATABASES CREATED!';
PRINT '==========================================';
PRINT '';
PRINT 'Databases created:';
PRINT '  1. sql_invoicing';
PRINT '  2. sql_store';
PRINT '  3. sql_hr';
PRINT '  4. sql_inventory';
PRINT '';
PRINT 'Total tables:';
PRINT '  - sql_invoicing: 4 tables';
PRINT '  - sql_store: 7 tables';
PRINT '  - sql_hr: 2 tables';
PRINT '  - sql_inventory: 1 table';
PRINT '';
PRINT '==========================================';
PRINT '         ALL DONE!';
PRINT '==========================================';
GO
