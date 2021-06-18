/*=====================================
			DAY 2 ASSINGMENT
=======================================*/

/*==============================================
				CREATING SCHEMA
================================================*/

IF EXISTS (
	SELECT name 
	FROM SYS.schemas 
	WHERE NAME = 'Learning'
)
BEGIN
	DROP SCHEMA [Learning]
END
GO
CREATE 
	SCHEMA Learning
	AUTHORIZATION dbo;
GO

USE Training
GO
/*================================================
				CREATE TABLE Agent
==================================================*/
IF OBJECT_ID('Training.Learning.Agent','U') IS NOT NULL DROP TABLE Training.Learning.Agent;
GO

BEGIN
    CREATE TABLE Learning.Agent (
        AgentID INT PRIMARY KEY IDENTITY,
        Agent_Code CHAR(6) UNIQUE NOT NULL,
		Agent_Name CHAR(40) NOT NULL,
		Working_Area CHAR(35),
		Commission DECIMAL(10,2),
		Phone_No CHAR(15),
		Country VARCHAR(25)
    )
END
GO

SELECT * 
FROM Learning.Agent;
GO

/*Insert Data*/

BEGIN
INSERT INTO Learning.Agent(Agent_Code, Agent_Name, Working_Area, Commission, Phone_No) 
VALUES ('A001', 'Subbarao', 'Bangalore', 0.14, '077-12346674'),
('A002', 'Mukesh', 'Mumbai', 0.11, '029-12358964'),
('A003', 'Alex', 'London', 0.13, '075-12458969'),
('A004', 'Ivan', 'Torento', 0.15, '008-22544166'),
('A005', 'Anderson', 'Brisban', 0.13, '045-21447739'),
('A006', 'McDen', 'London', 0.15, '078-22255588'),
('A007', 'Ramasundar', 'Bangalore', 0.15, '077-25814763'),
('A008', 'Alford', 'New York', 0.12, '044-25874365'),
('A009', 'Benjamin', 'Hampshair', 0.11, '008-22536178'),
('A010', 'Santakumar', 'Chennai', 0.14, '007-22388644'),
('A011', 'Ravi Kumar', 'Bangalore', 0.15, '077-45625874'),
('A012', 'Lucida', 'San Jose', 0.12, '044-52981425');
END;
GO

SELECT * 
FROM Learning.Agent;
GO



/*================================================
			CREATE TABLE CUSTOMER
==================================================*/
IF OBJECT_ID('Training.Learning.Customer','U') IS NOT NULL DROP TABLE Training.Learning.Customer;
GO

BEGIN
    CREATE TABLE Learning.Customer (
        CustID INT PRIMARY KEY IDENTITY,
        Cust_Code VARCHAR(6) NOT NULL,
		Cust_Name VARCHAR(40) NOT NULL,
		Cust_City CHAR(35),
		Working_Area VARCHAR(35),
		Cust_Country VARCHAR(20),
		Grade INT,
		Opening_Amt DECIMAL(12,2),
		Receive_Amt DECIMAL(12,2),
		Payment_Amt DECIMAL(12,2),
		Outstanding_Amt DECIMAL(12,2),
		Phone_No VARCHAR(17),
		AgentID INT,
		FOREIGN KEY(AgentID) REFERENCES Learning.Agent(AgentID)
    )
END
GO

SELECT * 
FROM Learning.Customer;
GO

/*Insert Data*/

BEGIN
INSERT INTO Learning.Customer 
(Cust_Code, Cust_Name, Cust_City, Working_Area, Cust_Country, Grade, Opening_Amt, Receive_Amt, Payment_Amt, Outstanding_Amt, Phone_No, AgentID)
VALUES ('C00001', 'Micheal', 'New York', 'New York', 'USA', 2, 3000, 5000, 2000, 6000, 'CCCCCCC', 8),
('C00002', 'Bolt', 'New York', 'New York', 'USA', 3, 5000, 7000, 9000, 3000, 'DDNRDRH', 8),
('C00003', 'Martin', 'Torento', 'Canada', 'USA', 2, 8000, 7000, 7000, 8000, 'MJYURFD', 10),
('C00004', 'Winston', 'Brisban', 'Brisban', 'Australia', 1, 5000, 8000, 7000, 6000, 'AAAAAAA', 11),
('C00005', 'Sasikant', 'Mumbai', 'Mumbai', 'India', 1, 7000, 11000, 7000, 11000, 'CCCCCCC', 2),
('C00006', 'Shilton', 'Torento', 'Torento York', 'Canada', 1, 1000, 7000, 6000, 11000, 'DDDDDDD', 10),
('C00007', 'Ramanathan', 'Chennai', 'Chennai', 'India', 1, 7000, 11000, 9000, 9000, 'GHRDWSD', 10),
('C00008', 'Karolina', 'Torento', 'Torento', 'Canada', 1, 7000, 7000, 9000, 5000, 'HJKORED', 10),
('C00009', 'Ramesh', 'Mumbai', 'Mumbai', 'India', 3, 8000, 7000, 3000, 12000, 'Phone No', 2),
('C00010', 'Charles', 'Hampshair', 'Hampshair', 'UK', 3, 6000, 4000, 5000, 5000, 'MMMMMMM', 9),
('C00011', 'Sundariya', 'Chennai', 'Chennai', 'India', 3, 7000, 11000, 7000, 11000, 'PPHGRTS', 10),
('C00012', 'Steven', 'San Jose', 'San Jose', 'USA', 1, 5000, 7000, 9000, 3000, 'KRFYGJK', 12),
('C00013', 'Holmes', 'London', 'London', 'UK', 2, 6000, 5000, 7000, 4000, 'BBBBBBB', 3),
('C00014', 'Rangarappa', 'Bangalore', 'Bangalore', 'India', 2, 8000, 11000, 7000, 12000, 'AAAATGF', 1),
('C00015', 'Stuart', 'London', 'London', 'UK', 1, 6000, 8000, 3000, 11000, 'GFSGERS', 3),
('C00016', 'Venkatpati', 'Bangalore', 'Bangalore', 'India', 2, 8000, 11000, 7000, 12000, 'JRTVFDD', 7),
('C00017', 'Srinivas', 'Bangalore', 'Bangalore', 'India', 2, 8000, 4000, 3000, 9000, 'AAAAAAB', 7),
('C00018', 'Fleming', 'Brisban', 'Brisban', 'Australia', 2, 7000, 7000, 9000, 5000, 'NHBGVFC', 11),
('C00019', 'Yearannaidu', 'Chennai', 'Chennai', 'India', 1, 8000, 7000, 7000, 8000, 'ZZZZBFV', 10),
('C00020', 'Albert', 'New York', 'New York', 'USA', 3, 5000, 7000, 6000, 6000, 'BBBBSBB', 8),
('C00021', 'Jacks', 'Brisban', 'Brisban', 'Australia', 1, 7000, 7000, 7000, 7000, 'WERTGDF', 11),
('C00022', 'Avinash', 'Mumbai', 'Mumbai', 'India', 2, 7000, 11000, 9000, 9000, '113-12345678', 2),
('C00023', 'Karl', 'London', 'London', 'UK', 0, 4000, 6000, 7000, 3000, 'AAAABAA', 6),
('C00024', 'Cook', 'London', 'London', 'UK', 2, 4000, 9000, 7000, 6000, 'FSDDSDF', 6),
('C00025', 'Ravindran', 'Bangalore', 'Bangalore', 'India', 2, 5000, 7000, 4000, 8000, 'AVAVAVA', 11);
END
GO

SELECT * 
FROM Learning.Customer;
GO

/*======================================================
	Create Script for following Select Statements.
========================================================*/
BEGIN
--1) List all the customers leaving in Bangalore
SELECT * 
FROM Learning.Customer 
WHERE Cust_City = 'Bangalore';
END
GO

BEGIN
--2) List all the customers leaving in Canada & UK
SELECT * 
FROM Learning.Customer 
WHERE Cust_Country = 'CANADA' OR Cust_Country = 'UK';
END
GO

--Blank
SELECT * 
FROM Learning.Customer 
WHERE Cust_Country = 'CANADA' AND Cust_Country = 'UK';
GO

BEGIN
--3) List all the customers leaving not in India
SELECT * 
FROM Learning.Customer 
WHERE Cust_Country NOT LIKE 'INDIA';
END
GO

SELECT * 
FROM Learning.Customer 
WHERE Cust_Country != 'INDIA';
GO

BEGIN
--4) List all the customer whose customer name starts with M
SELECT * 
FROM Learning.Customer 
WHERE Cust_Name LIKE 'M%';
END
GO

BEGIN
--5) List all the customer whose opening amount is greater than 7000
SELECT * 
FROM Learning.Customer 
WHERE Opening_Amt > 7000;
END
GO

BEGIN
--6) List all the customer whose opening amount is between 4000 & 6000
SELECT * 
FROM Learning.Customer 
WHERE Opening_Amt > 4000 AND Opening_Amt < 6000;
END
GO

BEGIN
--7) List all the customer whose Opening Amount + Receive Amount – Payment Amount is greater Than 3000
SELECT * 
FROM Learning.Customer 
WHERE ((Opening_Amt + Receive_Amt)- Payment_Amt) > 3000;
END
GO

BEGIN
--8) List all the data for agent whose customer opening amount is greater than 5000
SELECT DISTINCT A.AgentID, A.Agent_Name, A.Working_Area, C.Opening_Amt 
FROM Learning.Agent A INNER JOIN  Learning.Customer C
ON A.AgentID= C.AgentID
WHERE Opening_Amt > 5000;
END
GO

BEGIN
--9) List all the agent with total customer with each agent. Total customer columns should show 0 if no customer is present for the agent.
SELECT Agent.Agent_Name, COUNT(*) as TOTAL_CUSTOMER 
FROM Learning.Agent Agent JOIN Learning.Customer Cust 
ON Agent.AgentID = Cust.AgentID 
GROUP BY Agent.Agent_Name;
END
GO

BEGIN
--Q.10) List all the agent & Customer data whose customer are leaves in (Mumbai or Bangalore) and opening amount is greater than 5000 
SELECT * 
FROM Learning.Customer C 
WHERE (Cust_City = 'MUMBAI' OR Cust_Country = 'BANGALORE') AND Opening_Amt > 5000;
END
GO


/*===========================================================
		-Create script for following Update Statements
=============================================================*/

--1) Update all agents commission = 0.18 whose customers outstanding amount is greater than 8000.
SELECT A.Commission 
FROM Learning.Agent A INNER JOIN Learning.Customer C 
ON A.AgentID = C.AgentID 
WHERE C.Opening_Amt > 8000;
GO

BEGIN
UPDATE Learning.Agent 
SET Commission = 0.18 
FROM Learning.Agent A INNER JOIN Learning.Customer C
ON A.AgentID = C.AgentID 
WHERE C.Opening_Amt > 8000;
END
GO


--2) Update phoneNo = 99999 whose customer name starts with M and agent name is Alford
SELECT C.Phone_No
FROM Learning.Customer C JOIN Learning.Agent A
ON A.AgentID = C.AgentID 
WHERE C.Cust_Name LIKE 'M%' AND A.Agent_Name = 'ALFORD';
GO

BEGIN
UPDATE Learning.Customer 
SET Phone_No = 99999 
FROM Learning.Agent A INNER JOIN Learning.Customer C 
ON A.AgentID = C.AgentID 
WHERE C.Cust_Name LIKE 'M%' AND A.Agent_Name = 'ALFORD';
END
GO

--3) Update all the working area value in customer table same as the working area value of their agents.
SELECT * 
FROM Learning.Agent join Learning.Customer 
ON Agent.AgentID = Customer.AgentID 
WHERE Agent.Working_Area = 'BANGALORE';
GO

BEGIN
UPDATE Learning.Customer 
SET Working_Area = A.Working_Area
FROM Learning.Customer C JOIN Learning.Agent A 
ON A.AgentID= C.AgentID;
END
GO

BEGIN
SELECT * FROM Learning.Customer;
SELECT * FROM Learning.Agent;
END
GO


/*=================================================
 Create script for following Delete Statements
 ==================================================*/
 --Delete all customer records whose agent name is Alex.
 SELECT A.Agent_Name, C.Cust_Name
 FROM Learning.Customer C JOIN Learning.Agent A
 ON A.AgentID = C.AgentID
 WHERE A.Agent_Name = 'ALEX'
 GO

 BEGIN
 DELETE Learning.Customer
 FROM Learning.Customer C JOIN Learning.Agent A
 ON A.AgentID = C.AgentID
 WHERE A.Agent_Name = 'ALEX'
 END
 GO

--2) Delete all customer records whose outstanding amount is less than 5000 SELECT C.Cust_Name, C.Outstanding_Amt
 FROM Learning.Customer C JOIN Learning.Agent A
 ON A.AgentID = C.AgentID
 WHERE C.Outstanding_Amt < 5000
 GO

 BEGIN
 DELETE Learning.Customer
 FROM Learning.Customer C JOIN Learning.Agent A
 ON A.AgentID = C.AgentID
 WHERE C.Outstanding_Amt < 5000
 END
 GO


 /*===========================================================
	Q.5) Create script for following Truncate Statements.
 =============================================================*/
--1) Truncate all the records from agent.
--Not able to truncate due to Forgin key reference
BEGIN
TRUNCATE TABLE Learning.Agent;
END
GO

--2) Truncate all the records from Customer.
BEGIN
TRUNCATE TABLE Learning.Customer;
END
GO

/*tRIED SOME ALTERNATIVE TO TRUNCATE THE TABLE
 
 SELECT parent_object_id 
 FROM sys.foreign_keys
 WHERE referenced_object_id = OBJECT_ID('Learning.Agent')

 SELECT 
 'ALTER TABLE'
 + OBJECT_SCHEMA_NAME(parent_object_id)
 +'.[' + OBJECT_NAME(parent_object_id)
 +'] DROP CONSTRAINT '
 + name as DropFKConstraint
 FROM SYS.foreign_keys
 WHERE referenced_object_id = object_id('Learning.Agent')


 ALTER TABLE Learning.Customer DROP CONSTRAINT AgentID

 */