/*
Querying a restaurant database with multiple tables in it to manage employees
  Skills Used: Data Manipulation, Joins, Decimals, Arithmetic Operators 
*/

 CREATE TABLE Departments (
DepartmentCode CHAR(3) PRIMARY KEY,
DepartmentName VARCHAR(30)
)

CREATE TABLE Employees (
EmployeeID int PRIMARY KEY,
JobTitle VARCHAR(30),
FirstName VARCHAR(50),
LastName VARCHAR(50),
Age int,
Sex CHAR(1),
HireDate DATE
)

CREATE TABLE Salary (
DepartmentCode CHAR(3) FOREIGN KEY REFERENCES Departments(DepartmentCode),
EmployeeID int FOREIGN KEY REFERENCES Employees(EmployeeID),
HourlyWage DECIMAL(4,2)
)

INSERT INTO Departments 
VALUES ('UPM', 'Upper Management'), ('LWM', 'Lower Management'), ('FOH', 'Front of House'), ('BOH', 'Back of House')

INSERT INTO  Employees
VALUES (1001, 'Manager', 'Eugene', 'Krabs', 55, 'M', '1999-01-01'),
       (1002, 'Shift Lead', 'Squidward', 'Tentacles', 33, 'M', '1999-01-01'),
	   (1003, 'Hostess', 'Sandy', 'Cheeks', 23, 'F', '2001-02-14'),
	   (1004, 'Server', 'Patrick', 'Star', 30, 'M', '2006-11-23'),
	   (1005, 'Fry Cook', 'Spongebob', 'Squarepants', 31, 'M', '1999-01-01') 

INSERT INTO Salary
VALUES ('UPM', 1001, 25.12),
       ('LWM', 1002, 20.05),
	   ('FOH', 1003, 10.50),
	   ('FOH', 1004, 3.00),
	   ('BOH', 1005, 12.94)

--Show every employee along with their department name
SELECT E.*, D.DepartmentName
FROM Employees E
JOIN Salary S ON E.EmployeeID=S.EmployeeID
JOIN Departments D ON S.DepartmentCode=D.DepartmentCode

--New fry cook Sheldon Plankton was hired today, 12/06. Add him to the database
INSERT INTO  Employees (EmployeeID, JobTitle, FirstName, LastName, Sex, HireDate)
VALUES (1006, 'Fry Cook', 'Sheldon', 'Plankton', 'M', '2023-12-06')
INSERT INTO Salary
VALUES ('BOH', 1006, 12.94)

--Show the full name and wage of employees with a job title that starts with 'S'
SELECT S.HourlyWage,
CONCAT(E.FirstName,' ', E.LastName) as FullName
FROM Employees E
LEFT JOIN Salary S ON S.EmployeeID=E.EmployeeID
WHERE JobTitle LIKE 'S%'
ORDER BY FullName 

--As a holiday bonus, increase the salaries of Management by 5%, Back of House by 2%, and Front of House by 1%
--Round the new wage to the nearest hundreth
UPDATE Salary
SET HourlyWage =
CASE
    WHEN DepartmentCode IN ('UPM', 'LWM') THEN ROUND(HourlyWage + (HourlyWage * .05),2)
	WHEN DepartmentCode = 'BOH' THEN ROUND(HourlyWage + (HourlyWage * .02),2)
	WHEN DepartmentCode = 'FOH' THEN ROUND(HourlyWage + (HourlyWage * .01),2)
END 
FROM Salary

--Sheldon Plankton has provided his birthday as 10/08/1988. Update his records
UPDATE Employees
SET Age = 35
WHERE EmployeeID = 1006

-- Mr. Krabs has retired, effective immediately. Remove him from the database
DELETE FROM Employees 
WHERE EmployeeID = 1001
DELETE FROM Salary
WHERE EmployeeID = 1001
