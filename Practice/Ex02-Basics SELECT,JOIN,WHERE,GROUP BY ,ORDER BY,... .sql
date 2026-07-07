USE MyPracticeDB;

-- 50) نام کارمندانی را نمایش بده که در بیش از 2 پروژه فعالیت دارند، میانگین حقوق دپارتمانشان از 8000 بیشتر باشد، فقط دپارتمان‌هایی را نمایش بده که حداقل 3 کارمند دارند و خروجی را بر اساس مجموع ساعات پروژه نزولی مرتب کن.
SELECT 
	DepartmentName,
	STRING_AGG(FullName,', ') AS mployee,
	SUM(HoursWorked) AS sum_of_hourswotked
FROM Departments D
JOIN Employees E
	ON E.DepartmentID = D.DepartmentID
JOIN Assignments A 
	ON A.EmployeeID=E.EmployeeID
GROUP BY
	DepartmentName
HAVING COUNT(FullName) >=1
ORDER BY SUM(HoursWorked) DESC
-- 49) با استفاده از Self Join مدیر هر کارمند را نمایش بده، سپس فقط مدیرانی را نشان بده که بیش از 2 کارمند دارند.
SELECT 
	M.FullName AS manager,
	STRING_AGG(E.FullName,', ') AS mployees
FROM Employees M
 JOIN Employees E 
	ON E.ManagerID = M.EmployeeID --or M.ManagerID IS NULL
GROUP BY M.FullName 
--فقط مدیرانی را نشان بده که بیش از 2 کارمند دارند
SELECT 
	M.FullName AS manager,
	STRING_AGG(E.FullName,', ') AS mployees
FROM Employees M
 JOIN Employees E 
	ON E.ManagerID = M.EmployeeID --or M.ManagerID IS NULL
GROUP BY M.FullName 
HAVING COUNT(E.FullName) > 2



-- 48) با استفاده از LEFT JOIN تمام پروژه‌ها را نمایش بده حتی اگر هیچ کارمندی روی آن‌ها کار نکرده باشد.
SELECT 
	ProjectID,
	ProjectName,
	STRING_AGG(FullName,', ') AS Employee

FROM Projects P
LEFT JOIN Employees E 
	ON P.DepartmentID = E.DepartmentID

GROUP BY 
	ProjectID,
	ProjectName

-- 47) با استفاده از RIGHT JOIN تمام کارمندان را نمایش بده حتی اگر هیچ پروژه‌ای نداشته باشند.
SELECT 
	FullName AS Employee,
	STRING_AGG(ProjectName,', ') AS ProjectName
FROM Projects P 
RIGHT JOIN  Employees E 
	ON E.DepartmentID = P.DepartmentID

GROUP BY FullName

-- 46) تعداد کارمندان هر دپارتمان را همراه با مجموع حقوق و WITH ROLLUP نمایش بده.
SELECT 
	DepartmentName,
	COUNT(EmployeeID) AS number_of_employees,
	SUM(Salary) AS sum_of_salary
FROM Departments D
JOIN Employees E
	ON E.DepartmentID = D.DepartmentID
GROUP BY DepartmentName WITH ROLLUP


-- 45) دپارتمان‌هایی را نمایش بده که مجموع حقوق آن‌ها بیشتر از 50000 باشد.
SELECT 
	DepartmentName,
	SUM(Salary) AS sum_of_salary
FROM Departments D
JOIN Employees E 
	ON D.DepartmentID = E.DepartmentID 
GROUP BY DepartmentName
HAVING SUM(Salary) > 50000

-- 44) 3 دپارتمان با بیشترین میانگین حقوق را نمایش بده.
 
 SELECT  TOP 1 DepartmentName, AVG(Salary) AS Average_of_Salary
FROM Departments D
JOIN Employees E 
	ON D.DepartmentID = E.DepartmentID 
GROUP BY DepartmentName 
ORDER BY Average_of_Salary DESC

-- 43) 5 کارمند با بیشترین تعداد پروژه را نمایش بده.
 --چون ماکسیمم تعداد پروژه هامون چند مورد برابر داشت کوئری پیچیده تری مجبوریم بزنیم
 
 
 
 SELECT FullName,number_of_project
FROM(
	SELECT 
		FullName,
		COUNT(ProjectID) As number_of_project
	FROM Employees E
	JOIN Projects P 
	ON P.DepartmentID = E.DepartmentID
	GROUP BY FullName
)AS count_project -- این جدول تعداد هر پروژه رو نشون میده

WHERE number_of_project = 
(
	SELECT MAX(number_of_project)
	FROM (	
		SELECT 
		COUNT(ProjectID) As number_of_project
		FROM Employees E
		JOIN Projects P 
		ON P.DepartmentID = E.DepartmentID
		GROUP BY FullName
	) AS CT
)-- شرط میزاریم جایی که ماکسیمم تعداد پروژه ها با تعداد پروژه ها برابره نشون بده

/*
 --تعداد پروژه ها
 SELECT FullName,COUNT(ProjectID)
 FROM Employees E
 JOIN Projects P 
	ON P.DepartmentID = E.DepartmentID
 GROUP BY FullName
 */


-- 42) نام کارمند، نام پروژه و نام دپارتمان را در یک Query با JOIN نمایش بده.
--*****
SELECT 
	FullName,
	STRING_AGG(ProjectName,', ') AS ProjectName, 
	DepartmentName
	--STRING_AGG(DepartmentName,',')
FROM Employees E
LEFT JOIN Projects P
	ON P.DepartmentID = E.DepartmentID
LEFT JOIN Departments D 
	ON D.DepartmentID = E.DepartmentID
GROUP BY FullName,DepartmentName
ORDER BY DepartmentName


SELECT 
	FullName,
	ProjectName,
	DepartmentName

FROM Employees E
LEFT JOIN Projects P
	ON P.DepartmentID = E.DepartmentID
LEFT JOIN Departments D 
	ON D.DepartmentID = E.DepartmentID
--GROUP BY FullName,DepartmentName
ORDER BY DepartmentName
-- 41) کارمندانی را نمایش بده که روی هیچ پروژه‌ای کار نکرده‌اند.
-- مثل سوال 40 هست
-- 40) پروژه‌هایی را نمایش بده که هیچ کارمندی ندارند.

SELECT
	FullName,
	ProjectName
FROM Employees E
LEFT JOIN Projects P
	ON P.DepartmentID = E.DepartmentID
WHERE E.DepartmentID NOT IN (
	SELECT P.DepartmentID
	FROM Projects P
	JOIN Employees E
		ON P.DepartmentID = E.DepartmentID 
	GROUP BY P.DepartmentID
)

--دپارتمان هایی که پروژه دارن
SELECT P.DepartmentID
FROM Projects P
JOIN Employees E
	ON P.DepartmentID = E.DepartmentID 
GROUP BY P.DepartmentID

-- 39) تعداد پروژه‌های هر کارمند را نمایش بده و فقط کسانی را نشان بده که بیشتر از یک پروژه دارند.
---***
SELECT *
FROM Employees E
LEFT JOIN Projects P
	ON E.DepartmentID = P.DepartmentID

SELECT 
	FullName, 
	COUNT(ProjectName) AS 'Number of project'
FROM Employees E
LEFT JOIN Projects P
	ON E.DepartmentID = P.DepartmentID
GROUP BY FullName
HAVING COUNT(ProjectName) > 1
ORDER BY 'Number of project' DESC

/*
--جوین شده
SELECT *
FROM Employees E
LEFT JOIN Projects P
	ON E.DepartmentID = P.DepartmentID

-- تعداد پروژه‌ های هر کارمند
SELECT 
	FullName, 
	COUNT(ProjectName) AS 'Number of project'
FROM Employees E
LEFT JOIN Projects P
	ON E.DepartmentID = P.DepartmentID
GROUP BY FullName
ORDER BY 'Number of project' DESC
*/
-- 38) میانگین حقوق هر دپارتمان را نمایش بده و بر اساس میانگین نزولی مرتب کن.
-- نمیتونم اسم رو انتخاب کنم
SELECT 
	E.DepartmentID,
	AVG(Salary) AS 'Mean Salary'
FROM Departments D
RIGHT JOIN Employees E 
	ON D.DepartmentID = E.EmployeeID
GROUP BY E.DepartmentID
ORDER BY 'Mean Salary' DESC


-- 37) مجموع ساعات کاری هر کارمند را محاسبه کن.
SELECT 
	A.EmployeeID,
	Fullname,
	SUM(HoursWorked) AS Total_Work
FROM Assignments A
JOIN Employees E 
	ON E.EmployeeID = A.EmployeeID
GROUP BY --گروه بندی باید بر اساس  امپلویی آیدی جدول اساینمنت انجام بشه
	A.EmployeeID,
	FullName





SELECT EmployeeID, SUM(HoursWorked)
FROM Assignments A
GROUP BY EmployeeID


	
--HAVING SUM(HoursWorked)
-- 36) کارمندانی را نمایش بده که مجموع ساعات کاری آن‌ها بیشتر از 100 ساعت است.
SELECT 
	E.EmployeeID,
	FullName AS Employee,
	HoursWorked
FROM Employees E
JOIN Assignments A
	ON E.EmployeeID = A.EmployeeID
GROUP BY 
	E.EmployeeID,
	HoursWorked,
	FullName

HAVING SUM(HoursWorked) > 100
-- 35) DISTINCT روی DepartmentID اجرا کن.
SELECT DISTINCT DepartmentID
FROM Departments
-- 34) DISTINCT روی ProjectID جدول Assignments اجرا کن.
SELECT DISTINCT ProjectID
FROM Assignments
-- 33) TOP 10 کارمند با بیشترین حقوق را نمایش بده.
SELECT TOP 10 FullName,Salary
FROM Employees
--ORDER BY Salary DESC;
-- 32) TOP 5 پروژه با بیشترین بودجه را نمایش بده.
SELECT TOP 5 ProjectName,Budget
FROM Projects
ORDER BY Budget DESC;
-- 31) کارمندانی را نمایش بده که بعد از سال 2020 استخدام شده‌اند.
SELECT 
	EmployeeID,
	FullName AS Employee,
	HireDate
FROM Employees
WHERE HireDate > '2020-01-01';
-- 30) پروژه‌هایی را نمایش بده که بودجه آن‌ها بیشتر از 100000 است.
SELECT 
	ProjectName,
	Budget
FROM Projects
WHERE Budget > 100000

-- 29) کارمندانی را نمایش بده که حقوقشان بین 7000 و 12000 است.
SELECT 
	employeeID,
	FullName AS Employee,
	Salary
FROM Employees
WHERE Salary BETWEEN 7000 AND 12000
-- 28) پروژه‌هایی را نمایش بده که بودجه آن‌ها کمتر از میانگین کل بودجه پروژه‌هاست.
SELECT 
	ProjectName,
	Budget,
	( SELECT AVG(Budget) FROM Projects ) AS 'Total Budget'
FROM Projects 
GROUP BY 
	ProjectID,
	ProjectName,
	Budget
HAVING Budget < (
	SELECT AVG(Budget)
	FROM Projects
	)



-- 27) نام کارمند و نام دپارتمان او را نمایش بده.
SELECT 
	FullName AS 'Employee',
	DepartmentName
FROM Employees E
JOIN Departments D
	 ON E.DepartmentID = D.DepartmentID

-- 26) نام پروژه و مدیر پروژه (در صورت وجود) را نمایش بده.
/*
--پبدا کردن مدیران
SELECT DISTINCT M.EmployeeID,M.FullName AS Name_of_Manager
FROM Employees E
JOIN Employees M
	ON M.EmployeeID =E.ManagerID OR M.ManagerID IS NULL
*/

SELECT 
	FullName AS Manager_Name,
	ProjectName
FROM Employees E
JOIN Departments D 
	ON E.DepartmentID = D.DepartmentID
JOIN Projects P
	ON D.DepartmentID = P.DepartmentID
WHERE Fullname IN (
	SELECT DISTINCT M.FullName AS Manager_Name
	FROM Employees E
	JOIN Employees M
	ON M.EmployeeID =E.ManagerID OR M.ManagerID IS NULL
)

-- 25) تمام کارمندان را همراه با دپارتمانشان به ترتیب حقوق نزولی نمایش بده.
SELECT FullName,DepartmentName,Salary
FROM Employees E
JOIN Departments D
	ON E.DepartmentID =D.DepartmentID
ORDER BY Salary DESC


-- 24) تمام دپارتمان‌ها را به ترتیب نام صعودی مرتب کن.
SELECT DepartmentName
FROM Departments
ORDER BY DepartmentName
-- 23) تعداد کارمندان هر دپارتمان را نمایش بده.
SELECT 
	D.DepartmentID,
	D.DepartmentName ,
	COUNT(E.EmployeeID) AS 'Number of employee'
FROM Departments D 
JOIN Employees E
	ON E.DepartmentID = D.DepartmentID
GROUP BY 
	D.DepartmentID,
	D.DepartmentName

-- 22) مجموع حقوق هر دپارتمان را نمایش بده.
SELECT 
	DepartmentName,
	SUM(Budget) AS 'Sum of Budet'

FROM Departments D
JOIN Projects P
	ON D.DepartmentID = P.DepartmentID
GROUP BY 
	P.DepartmentID,
	DepartmentName
-- 20) بیشترین حقوق هر دپارتمان را نمایش بده.
--تکراری
-- 21) میانگین حقوق هر دپارتمان را نمایش بده.
SELECT 
	P.DepartmentID,
	D.DepartmentName,
	CAST( AVG(Budget) AS DECIMAL(10,2) ) AS 'Miximum of Budet'
FROM Departments D
JOIN Projects P 
	ON D.DepartmentID = P.DepartmentID
GROUP BY 
	P.DepartmentID,
	D.DepartmentName
-- 20) بیشترین حقوق هر دپارتمان را نمایش بده.
SELECT 
	DepartmentName,
	MAX(Budget) AS 'Miximum of Budet'

FROM Departments D
JOIN Projects P
	ON D.DepartmentID = P.DepartmentID
GROUP BY 
	P.DepartmentID,
	DepartmentName
-- 19) کمترین حقوق هر دپارتمان را نمایش بده.
SELECT 
	DepartmentName,
	MIN(Budget) AS 'Minimum of Budet'

FROM Departments D
JOIN Projects P
	ON D.DepartmentID = P.DepartmentID
GROUP BY 
	P.DepartmentID,
	DepartmentName

-- 18) تعداد پروژه‌های هر دپارتمان را نمایش بده.
--******
SELECT
	D.DepartmentID,
	D.DepartmentName,
	COUNT(ProjectID) AS 'Number of projects'
	
FROM Departments D
LEFT JOIN Projects P 
	ON P.DepartmentID = D.DepartmentID

GROUP BY 
	D.DepartmentID,
	D.DepartmentName;

--
SELECT 
	P.DepartmentID,
	MAX(D.DepartmentName) AS Depatrments_name ,
	COUNT(P.DepartmentID) AS 'Number of projects'
FROM Departments D
JOIN Projects P 
	ON D.DepartmentID = p.DepartmentID
GROUP BY P.DepartmentID ;


-- 17) نام کارمندانی را نمایش بده که حقوقشان بیشتر از 9000 است.
SELECT FullName,Salary
FROM Employees
WHERE Salary >9000

-- 16) نام پروژه‌هایی را نمایش بده که قبل از سال 2023 شروع شده‌اند.
SELECT *
FROM Projects
--؟؟؟؟؟بازم اطلاعات مربوط ب سال مروژه هاوزو نداریم

-- 15) کارمندانی را نمایش بده که در دپارتمان شماره 2 هستند.

SELECT EmployeeID,FullName,E.DepartmentID,DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE E.DepartmentID = 2
-- 14) پروژه‌هایی را نمایش بده که هنوز پایان نیافته‌اند.

-- از کجا بدونم تموم شده یا ن اطلاعاتش نیس تو جدول یا من ندیدم؟؟؟؟

-- 13) نام تمام مدیران را با استفاده از Self Join نمایش بده.
SELECT DISTINCT M.EmployeeID,m.FullName
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID OR M.ManagerID IS NULL
ORDER BY M.EmployeeID;

-- 12) تمام ترکیب‌های ممکن بین Employees و Departments را با CROSS JOIN نمایش بده.
SELECT*
FROM Departments
CROSS JOIN Employees
--روش دیگر
SELECT*
FROM Departments, Employees;

-- 11) تعداد کل کارمندان را محاسبه کن.
SELECT COUNT(Salary) AS 'Number of Salery'
FROM Employees;
-- 10) مجموع حقوق تمام کارمندان را محاسبه کن.
SELECT SUM(Salary) AS 'Sum of Salery'
FROM Employees;
-- 9) میانگین حقوق کل کارمندان را محاسبه کن.
SELECT AVG(Salary) AS 'Avrage of Salery'
FROM Employees;
-- 8) بیشترین حقوق بین تمام کارمندان را نمایش بده.
SELECT MAX(Salary) AS 'Max of Salery'
FROM Employees;
-- 7) کمترین حقوق بین تمام کارمندان را نمایش بده.
SELECT MIN(Salary) AS 'Min of Salery'
FROM Employees;


-- 6) نام تمام کارمندان را به ترتیب الفبا نمایش بده.
SELECT FullName FROM Employees
ORDER BY FullName;
-- 5) نام تمام پروژه‌ها را نمایش بده.
SELECT ProjectName FROM Projects;
-- 4) نام تمام دپارتمان‌ها را نمایش بده.
SELECT DepartmentName FROM Departments
-- 3) تمام اطلاعات جدول Projects را نمایش بده.
SELECT * FROM Projects;
-- 2) تمام اطلاعات جدول Departments را نمایش بده.
SELECT * FROM Departments;
-- 1) تمام اطلاعات جدول Employees را نمایش بده.
SELECT * FROM Employees
































