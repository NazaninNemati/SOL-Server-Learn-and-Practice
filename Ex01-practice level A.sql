USE MyPracticeDB



--تمرین20 نمایش پروژه ها به همراه تعداد کارمندانی که روی آن کار میکنند
SELECT ProjectName ,COUNT(EmployeeID) AS TotalEmploye
FROM Projects p
JOIN Employees e ON p.DepartmentID = e.DepartmentID

--تمرین19 نمایش  دپارتمان هایی که پروژه ندارند
-- چرا نات این جواب نمیده
SELECT p.DepartmentID ,DepartmentName,ProjectName
FROM Departments d
 JOIN Projects p ON d.DepartmentID =p.DepartmentID

WHERE p.DepartmentID IS NULL
/*NOT IN (
	SELECT p.DepartmentID 
	FROM Departments d
	JOIN Projects p ON d.DepartmentID =p.DepartmentID
)
*/


-- تمرین18 نمایش  دپارتمان هایی که پروژه دارند
SELECT p.DepartmentID ,DepartmentName,ProjectName
FROM Departments d
JOIN Projects p ON d.DepartmentID =p.DepartmentID


--تمرین17 نمایش کارمندانی که باهم زیر نظر یک مدیر هستند
SELECT e.FullName AS employee,
	   m.FullName AS manager
FROM Employees e
LEFT JOIN Employees m  ON e.ManagerID = m.EmployeeID
--????


--تمرین16 نمایش هرکارمند به همراه نام مدیرش
SELECT e.FullName AS employee ,m.FullName AS manager
FROM Employees e
LEFT JOIN Employees m  ON e.ManagerID = m.EmployeeID


-- تمرین15* نمایش کارمندانی که روی پروژه کار نمیکنند بدون انتساب

-- روش یک
SELECT FullName,
	e.DepartmentID,
	p.ProjectID,
	ProjectName 

FROM Employees e
LEFT JOIN Projects p ON p.DepartmentID = e.DepartmentID
--JOIN Assignments a ON a.EmployeeID = e.EmployeeID
WHERE e.DepartmentID  NOT IN (
	SELECT e.DepartmentID
	FROM Employees e
	JOIN Projects  p ON e.DepartmentID = p.DepartmentID
	)

--روش دو ????
SELECT FullName,
	e.DepartmentID 
FROM Employees e
JOIN Assignments a ON a.EmployeeID = a.EmployeeID
WHERE e.EmployeeID IS NULL


--  تمرین14 نمایش همه کارمندان  به همراه پروژه هایی که در آن کارمیکنند و وظیفه هایی ک دارند
--رابطه شان به ترتیب
-- employees - asssingments - projects
SELECT FullName,
	ProjectName,
	a.Role,
	a.HoursWorked
FROM Employees e
JOIN Assignments a ON a.EmployeeID = e.EmployeeID
JOIN Projects  p ON a.ProjectID = p.ProjectID;




--تمرین13 نمایش همه کارمندان حتی اگر دپارتمان نداشته باشد
SELECT e.FullName ,d.DepartmentName
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID =d.DepartmentID;


--تمرین12  نمایش کارمندان به همراه نام دپارتمانشان
SELECT e.FullName ,d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

--تمرین11 تعداد کل  کارمندان
SELECT COUNT(EmployeeID) AS Total_Employees
FROM Employees;

--تمرین10 کارمندان را بر اساس دپارتمان و سپس حقوق مرتب کنید
SELECT 
	FullName,
	e.DepartmentID,
	DepartmentName,
	Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID =d.DepartmentID
ORDER BY DepartmentName , Salary DESC;

--تمرین9 پروژه هایی که بودجه آنها بین 10000 تا 20000 است
SELECT *
FROM Projects
WHERE Budget BETWEEN 10000 AND 20000;
--تمرین8 کارمندانی که مدیر ندارند (مدیر کل)
SELECT *
FROM Employees 
WHERE ManagerID IS NULL;

--تمرین7 کارمندانی که بعد از سال 2021 استخدام شدند
SELECT *
FROM Employees 
WHERE HireDate > '2021-12-31'
-- تمرین6 کارمندانی که در دپارتمان آی تی هستند
SELECT FullName ,d.DepartmentID,d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT'

--تمرین5 کارمندانی که حقوقشان بالای 6000 است
SELECT *
FROM Employees
WHERE Salary > 6000;


--تمرین4 نمایش همه انتسابات ها
SELECT * FROM Assignments;
--تمرین3 نمایش همه پروژه ها
SELECT * FROM Projects;
-- تمرین نمایش همه دپارتمان ها
SELECT * FROM Departments;
-- تمرین1 نمایش همه کارمندان
SELECT * FROM Employees;


