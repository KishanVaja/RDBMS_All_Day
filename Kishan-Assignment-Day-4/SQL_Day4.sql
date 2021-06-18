/*=================================================================
				AGGREGATE FUNCTION 
===================================================================*/
/*SUM is a deterministic function when used without the OVER and ORDER BY clauses.*/
SELECT C.Cust_Country, SUM(C.Opening_Amt) AS Opening_Amount
FROM Learning.Customer C
GROUP BY Cust_Country
GO 

/*AVG () computes the average of a set of values by dividing the sum of those values by the count of nonnull values.*/
SELECT C.Cust_City, AVG(C.Payment_Amt) AS 'Payment Amount'
FROM Learning.Customer C
GROUP BY Cust_City
GO

SELECT CHECKSUM(Grade) 
FROM Learning.Customer 
ORDER BY Grade
GO

/*COUNT AGGREGATE*/
SELECT COUNT(*), AVG(Receive_Amt) AS 'Average Receive Amount'
FROM Learning.Customer
WHERE Receive_Amt > 4000;  
GO 

/*If STDEV is used on all items in a SELECT statement, 
Each value in the result set is included in the calculation. 
STDEV can be used with numeric columns only. 
Null values are ignored.*/
SELECT STDEV(Grade) 
FROM Learning.Customer
GO


/*GROUPING is used to distinguish the null values that are returned by ROLLUP, 
CUBE or GROUPING SETS from standard null values. 
The NULL returned as the result of a ROLLUP, CUBE or GROUPING SETS operation is a special use of NULL.*/
SELECT Cust_City, SUM(Opening_Amt) 'TotalSalesYTD', GROUPING(Cust_City) AS 'Grouping'  
FROM Learning.Customer
GROUP BY Cust_City WITH ROLLUP;  
GO  

/*MIN MAX AVG AGREGATES*/
SELECT DISTINCT Cust_City  
       , MIN(Payment_Amt) AS MinSalary  
       , MAX(Payment_Amt) AS MaxSalary  
       , AVG(Payment_Amt) AS AvgSalary  
	   , COUNT(Cust_City) AS CityCount
FROM Learning.Customer AS C
JOIN Learning.Agent AS A
     ON C.AgentID = A.AgentID  
GROUP BY Cust_City;
GO


/*==============================================================
					DATE TIMES FUNCTIONS
===============================================================*/
SELECT @@DATEFIRST  

SET DATEFIRST 3;
GO  
SELECT @@DATEFIRST; -- 3 (Wednesday)
GO

SELECT SYSDATETIME() AS 'System time'
    ,SYSDATETIMEOFFSET() AS 'System Date time Offset'
    ,SYSUTCDATETIME() AS 'System UTC Date Time'
    ,CURRENT_TIMESTAMP AS 'System Current Time stamp'
    ,GETDATE() AS 'Get Date'
    ,GETUTCDATE() AS 'Get UTC Date';
GO

SELECT CONVERT (DATE, SYSDATETIME()) AS 'System Date'
    ,CONVERT (DATE, SYSDATETIMEOFFSET()) AS 'System Date Date Offset'
    ,CONVERT (DATE, SYSUTCDATETIME()) AS 'System UTC Date'
    ,CONVERT (DATE, CURRENT_TIMESTAMP) AS 'System Current Date'
    ,CONVERT (DATE, GETDATE()) AS 'Get Date'
    ,CONVERT (DATE, GETUTCDATE()) AS 'Get UTC Date'; 
GO

SELECT CONVERT (TIME, SYSDATETIME()) AS 'System time'
    ,CONVERT (TIME, SYSDATETIMEOFFSET()) AS 'System Date time Offset'  
    ,CONVERT (TIME, SYSUTCDATETIME()) AS 'System UTC Date Time'
    ,CONVERT (TIME, CURRENT_TIMESTAMP) AS 'System Current Time stamp' 
    ,CONVERT (TIME, GETDATE()) AS 'Get Date'
    ,CONVERT (TIME, GETUTCDATE()) AS 'Get UTC Date'; 
GO

SELECT DATEDIFF(year,'2021-06-06 20:48:49.5420286', '2022-06-06 20:48:49.5420286');
GO

SELECT MONTH('2007-04-30T01:01:01.1234567 -07:00');  

SELECT YEAR(0), MONTH(0), DAY(0);
GO

/*=====================================================
				STRING FUNCTION
=======================================================*/
SELECT CONCAT ( 'Happy ', 'Birthday ', 07, 'th', ' Feb' ) AS Birthdate;

DECLARE @d DATE = '11/22/2020';
SELECT FORMAT( @d, 'd', 'en-US' ) 'US English'  
      ,FORMAT( @d, 'd', 'en-gb' ) 'Great Britain English'  
      ,FORMAT( @d, 'd', 'de-de' ) 'German'  
      ,FORMAT( @d, 'd', 'zh-cn' ) 'Simplified Chinese (PRC)';  
GO

DECLARE @columnName NVARCHAR(255)='User''s "custom" name'
DECLARE @sql NVARCHAR(MAX) = 'SELECT Cust_Name AS ' + QUOTENAME(@columnName) + ' FROM Learning.Customer'

EXEC sp_executesql @sql
GO

SELECT RTRIM(Cust_Name) + ',' + SPACE(2) +  LTRIM(Cust_City) AS TrimValue
FROM Learning.Customer
ORDER BY Cust_Name, Cust_City;  
GO

SELECT UPPER(RTRIM(Agent_Name)) + ', ' + Agent_Name AS 'Agent Name'
FROM Learning.Agent;  
GO

/*==============================================
				OTHER FUCTIONS
================================================*/
/*Connections are different from users. An application, for example, 
Can open multiple connections to SQL Server without user observation of those connections.*/
SELECT GETDATE() AS 'Today''s Date and Time',   
@@CONNECTIONS AS 'Login Attempts';  

/*This example returns SQL Server CPU activity, as of the current date and time. 
The example converts one of the values to the float data type. 
This avoids arithmetic overflow issues when calculating a value in microseconds. */
SELECT @@CPU_BUSY * CAST(@@TIMETICKS AS FLOAT) AS 'CPU microseconds',   
   GETDATE() AS 'As of' ; 

/*To display a report containing several SQL Server statistics, including packets sent and received.*/
SELECT @@PACK_SENT AS 'Pack Sent';

/*Referance: https://docs.microsoft.com/en-us/sql/t-sql/functions/functions?view=sql-server-ver15 */


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
/*==============================================================================================
								ASSIGNMENT DAY 3 & 4
================================================================================================*/

/*1) Create a view to get customerCity & Customer Name from customer table. 
Referance link
https://www.c-sharpcorner.com/UploadFile/860b29/concatenate-multiple-rows-within-single-row-in-sql-server-20/
*/

CREATE OR ALTER VIEW Learning.CustomerCityName AS
SELECT Cust_City,  
CustomerName=STUFF  
(  
    (  
      SELECT DISTINCT ', '+ CAST(C.Cust_Name AS VARCHAR(MAX))  
      FROM Learning.Agent A, Learning.Customer C  
      WHERE C.Cust_City = C2.Cust_City
      FOR XMl PATH('')  
    ),1,1,''  
)  
FROM Learning.Customer C2
GROUP BY Cust_City  
GO

SELECT * FROM Learning.CustomerCityName
GO

--=============================================================================--

/* 2) Create a view to get combined data from customer & agent table */

CREATE OR ALTER VIEW Learning.AgentCustomer AS
SELECT A.Agent_Name, C.Cust_Name, C.Cust_City, C.Cust_Country, C.Outstanding_Amt, A.Commission
FROM Learning.Agent A LEFT JOIN Learning.Customer C 
ON A.AgentID = C.AgentID;
GO

SELECT * FROM Learning.AgentCustomer
GO

/*==========================================================
					Creating Procedures
============================================================*/

/*1) Create Procedure to Insert data in Agent Table. Pass the value as an Input Parameter to Stored Procedure.*/
SELECT * FROM Learning.Agent
GO

IF OBJECT_ID('Learning.InsertAgnet') IS NOT NULL
BEGIN 
DROP PROC Learning.InsertAgnet
END 
GO
CREATE OR ALTER PROCEDURE Learning.InsertAgnet
(
    @Agent_Code CHAR(6),
	@Agent_Name CHAR(40),
	@Working_Area CHAR(35),
	@Commission DECIMAL(10,2),
	@Phone_No CHAR(15),
	@Country VARCHAR(25)
)
AS
BEGIN
SET NOCOUNT ON
	INSERT INTO Learning.Agent(Agent_Code, Agent_Name, Working_Area, Commission, Phone_No, Country) 
	VALUES (@Agent_Code, @Agent_Name, @Working_Area, @Commission, @Phone_No, @Country)

	SELECT * FROM Learning.Agent;
END
GO

EXEC Learning.InsertAgnet 
@Agent_Code = 'A013', 
@Agent_Name = 'Ram', 
@Working_Area = 'Delhi', 
@Commission = 0.15, 
@Phone_No = '091-98129812', 
@Country = 'INDIA';
GO

/* 2) Create Procedure to Insert Data in Customer Table. Pass the value as an Input Parameter to Store Procedure*/
IF OBJECT_ID('Learning.InsertCustomer') IS NOT NULL
BEGIN 
DROP PROC Learning.InsertCustomer
END 
GO
CREATE OR ALTER PROCEDURE Learning.InsertCustomer
(
        @Cust_Code VARCHAR(6),
		@Cust_Name VARCHAR(40),
		@Cust_City CHAR(35),
		@Working_Area VARCHAR(35),
		@Cust_Country VARCHAR(20),
		@Grade INT,
		@Opening_Amt DECIMAL(12,2),
		@Receive_Amt DECIMAL(12,2),
		@Payment_Amt DECIMAL(12,2),
		@Outstanding_Amt DECIMAL(12,2),
		@Phone_No VARCHAR(17),
		@AgentID INT
)
AS
BEGIN
SET NOCOUNT ON
	INSERT INTO Learning.Customer(Cust_Code, Cust_Name, Cust_City, Working_Area, Cust_Country, Grade, Opening_Amt, Receive_Amt, Payment_Amt, Outstanding_Amt, Phone_No, AgentID)
	VALUES (@Cust_Code, @Cust_Name, @Cust_City, @Working_Area, @Cust_Country, @Grade, @Opening_Amt, @Receive_Amt, @Payment_Amt, @Outstanding_Amt, @Phone_No, @AgentID)

	SELECT * FROM Learning.Customer;
END
GO

EXEC Learning.InsertCustomer 
@Cust_Code = 'C00027',
@Cust_Name = 'MUNNA',
@Cust_City = 'MUMBAI',
@Working_Area = 'MUMBAI',
@Cust_Country = 'INDIA',
@Grade = 3,
@Opening_Amt = 4000,
@Receive_Amt = 5000,
@Payment_Amt = 6000,
@Outstanding_Amt = 7000,
@Phone_No = '999999999',
@AgentID = 6
GO

--================================================================================--

/*3) Create Procedure to Update data from Agent Table. 
Pass the value as an Input parameter to
stored procedure. Update to be done based on AgentID.*/
IF OBJECT_ID('Learning.UpdateAgent') IS NOT NULL
BEGIN 
DROP PROC Learning.UpdateAgent
END 
GO
CREATE OR ALTER PROCEDURE Learning.UpdateAgent
    @AgentID INT,
	@Agent_Code CHAR(6),
	@Agent_Name CHAR(40),
	@Working_Area CHAR(35),
	@Commission DECIMAL(10,2),
	@Phone_No CHAR(15),
	@Country VARCHAR(25)
	   
  AS
    BEGIN
		UPDATE Learning.Agent 
		SET 
		Agent_Code = @Agent_Code,
		Agent_Name = @Agent_Name, 
		Working_Area = @Working_Area, 
		Commission = @Commission, 
		Phone_No = @Phone_No,
		Country = @Country
		WHERE AgentID = @AgentID
    END

	SELECT * FROM Learning.Agent WHERE AgentID = @AgentID;
GO

EXEC Learning.UpdateAgent
@AgentID = 13,
@Agent_Code = 'A013', 
@Agent_Name = 'LALU', 
@Working_Area = 'Delhi', 
@Commission = 0.15, 
@Phone_No = '091-98129812', 
@Country = 'INDIA';
GO

--=================================================================================================--

/*4) Create procedure to Delete data from customer table. Pass the value as an Input Parameter to
stored procedure. Delete to be done based on customerID*/
IF OBJECT_ID('Learning.DeleteCustomer') IS NOT NULL
BEGIN 
DROP PROC Learning.DeleteCustomer
END 
GO
CREATE OR ALTER PROCEDURE Learning.DeleteCustomer
    @CustID int
AS 
BEGIN 
DELETE
FROM   Learning.Customer
WHERE  CustID = @CustID

SELECT * FROM Learning.Customer
 
END
GO

EXEC Learning.DeleteCustomer @CustID = 26
GO

--=============================================================================================--

/*5) Create single procedure to Insert, Update & Delete data in Customer Table. Pass all the required
values as an input parameter to stored procedure. Update & Delete to be done based on AgentID.*/

IF OBJECT_ID('Learning.CRUDAgent') IS NOT NULL
BEGIN 
DROP PROC Learning.CRUDAgent
END 
GO
CREATE OR ALTER PROCEDURE Learning.CRUDAgent
    @AgentID INT,
	@Agent_Code CHAR(6),
	@Agent_Name CHAR(40),
	@Working_Area CHAR(35),
	@Commission DECIMAL(10,2),
	@Phone_No CHAR(15),
	@Country VARCHAR(25),
	@UserInput VARCHAR(25)
AS
BEGIN
IF @UserInput = 'SELECT'
	BEGIN
		SELECT * FROM Learning.Agent WHERE AgentID = @AgentID;
	END

IF @UserInput = 'INSERT'
	BEGIN
		SET NOCOUNT ON
		INSERT INTO Learning.Agent(Agent_Code, Agent_Name, Working_Area, Commission, Phone_No, Country) 
		VALUES (@Agent_Code, @Agent_Name, @Working_Area, @Commission, @Phone_No, @Country)
	END

IF @UserInput = 'UPDATE'
	BEGIN
		UPDATE Learning.Agent 
		SET 
		Agent_Code = @Agent_Code,
		Agent_Name = @Agent_Name, 
		Working_Area = @Working_Area, 
		Commission = @Commission, 
		Phone_No = @Phone_No,
		Country = @Country
		WHERE AgentID = @AgentID
	END

IF @UserInput = 'DELETE'
	BEGIN 
		DELETE
		FROM   Learning.Agent
		WHERE  AgentID = @AgentID
	END
END
GO

EXEC Learning.CRUDAgent 
@AgentID = 13, 
@Agent_Code = 'A013', 
@Agent_Name = 'Lalu', 
@working_Area = 'DELHI', 
@Commission = 0.15, 
@Phone_No = 'INDIA', 
@Country = '0919808900', 
@UserInput = 'SELECT'
GO


--============================================================================================--
/* 6) Create single procedure to Insert, Update & Delete data in Customer Table*/
IF OBJECT_ID('Learning.CRUDCustomer') IS NOT NULL
BEGIN 
DROP PROC Learning.CRUDCustomer
END 
GO
CREATE OR ALTER PROCEDURE Learning.CRUDCustomer
	@CustID INT,
	@Cust_Code VARCHAR(6),
	@Cust_Name VARCHAR(40),
	@Cust_City CHAR(35),
	@Working_Area VARCHAR(35),
	@Cust_Country VARCHAR(20),
	@Grade INT,
	@Opening_Amt DECIMAL(12,2),
	@Receive_Amt DECIMAL(12,2),
	@Payment_Amt DECIMAL(12,2),
	@Outstanding_Amt DECIMAL(12,2),
	@Phone_No VARCHAR(17),
	@AgentID INT,
	@UserInput VARCHAR(25)
AS
BEGIN
IF @UserInput = 'SELECT'
	BEGIN
		SELECT * FROM Learning.Customer WHERE CustID = @CustID;
	END

IF @UserInput = 'INSERT'
	BEGIN
		SET NOCOUNT ON
		INSERT INTO Learning.Customer(Cust_Code, Cust_Name, Cust_City, Working_Area, Cust_Country, Grade, Opening_Amt, Receive_Amt, Payment_Amt, Outstanding_Amt, Phone_No, AgentID)
		VALUES (@Cust_Code, @Cust_Name, @Cust_City, @Working_Area, @Cust_Country, @Grade, @Opening_Amt, @Receive_Amt, @Payment_Amt, @Outstanding_Amt, @Phone_No, @AgentID)
	END

IF @UserInput = 'UPDATE'
	BEGIN
		UPDATE Learning.Customer 
		SET 
	 	Cust_Code = @Cust_Code,
		Cust_Name = @Cust_Name,
		Cust_City = @Cust_City,
		Working_Area = @Working_Area,
		Cust_Country = @Cust_Country,
		Grade = @Grade,
		Opening_Amt = @Opening_Amt,
		Receive_Amt = @Receive_Amt,
		Payment_Amt = @Payment_Amt,
		Outstanding_Amt = @Outstanding_Amt,
		Phone_No = @Phone_No,
		AgentID = @AgentID
		WHERE CustID = @CustID
	END

IF @UserInput = 'DELETE'
	BEGIN 
		DELETE
		FROM   Learning.Customer
		WHERE  CustID = @CustID
	END
END
GO

EXEC Learning.CRUDCustomer
@CustID = 22,
@Cust_Code = 'C0026',
@Cust_Name = 'RAM',
@Cust_City = 'Mumbai',
@Working_Area = 'Mumbai',
@Cust_Country = 'India',
@Grade = 3,
@Opening_Amt = 3000,
@Receive_Amt = 4000,
@Payment_Amt = 5000,
@Outstanding_Amt = 6000,
@Phone_No = '999999999',
@AgentID = 8,
@UserInput = 'SELECT'
GO

--=============================================================================================--
/*7) Create procedure to select Customer / Agent records as per the Input Parameter*/

IF OBJECT_ID('Learning.AgentCustByID') IS NOT NULL
BEGIN 
DROP PROC Learning.AgentCustByID
END 
GO
CREATE OR ALTER PROCEDURE Learning.AgentCustByID
    @AgentID INT,
	@Agent_Name CHAR(40),
	@CustID INT,
	@Cust_Name VARCHAR(40),
	@UserInput VARCHAR(25)
AS
BEGIN
IF @UserInput = 'Agent Name'
	BEGIN
		SELECT * FROM Learning.Agent
		WHERE Agent_Name = @Agent_Name
	END

IF @UserInput = 'AgentID'
	BEGIN
		SELECT * FROM Learning.Agent
		WHERE AgentID = @AgentID
	END

IF @UserInput = 'Customer ID'
	BEGIN 
		SELECT *
		FROM   Learning.Customer
		WHERE  CustID = @CustID
	END
IF @UserInput = 'Customer Name'
	BEGIN 
		SELECT *
		FROM   Learning.Customer
		WHERE  Cust_Name = @Cust_Name
	END
END
GO

EXEC Learning.AgentCustByID 
@AgentID = 13, 
@Agent_Name = 'lalu', 
@CustID = 16, 
@Cust_Name = 'RAM', 
@UserInput = 'AgentID'

/*=====================================================================
					SCALAR VALUE FUNCTION
=======================================================================*/

/* 3) Create a scalar value function to calculate commission for each agent. */
IF OBJECT_ID('Learning.AgentCommition') IS NOT NULL
BEGIN 
DROP PROC Learning.AgentCommition
END 
GO

CREATE OR ALTER FUNCTION LEARNING.AgentCommition
(
	@AGENTID INT
)
RETURNS DECIMAL(10,2)
AS 
BEGIN
	DECLARE @CALCAULATEDAMOUNT DECIMAL (10,2)

	SELECT @CALCAULATEDAMOUNT = A.Commission
	FROM Learning.Agent A
	WHERE A.AgentID = @AGENTID

	RETURN @CALCAULATEDAMOUNT
END
GO

SELECT C.Cust_Name,A.Agent_Name, C.Outstanding_Amt, A.Commission, C.Outstanding_Amt * Learning.AgentCommition (A.AgentID)  AS 'Calculated Amount' 
FROM Learning.Agent A INNER JOIN Learning.Customer C 
ON A.AgentID = C.AgentID
GO


/*=============================================================
					TABLE VALUE FUNCTION
===============================================================*/
/**/
IF OBJECT_ID('Learning.TableValueFunction') IS NOT NULL
BEGIN 
DROP PROC Learning.TableValueFunction
END 
GO

CREATE OR ALTER FUNCTION LEARNING.TableValueFunction
(
	@AgentID INT
)
RETURNS TABLE
AS 
RETURN

	(SELECT C.CustID, C.Cust_Name, C.Outstanding_Amt, A.Agent_Name, A.Agent_Code, A.Commission 
	FROM Learning.Agent A JOIN Learning.Customer C
	ON A.AgentID = C.AgentID
	WHERE A.AgentID = @AGENTID);
GO

SELECT * FROM Learning.TableValueFunction (3)
GO


/*=============================================================
					NON CLUSTERED FUNCTION
===============================================================*/
    
/*Create NonClustered index on CustomerTable
Key Columns: CustomerCode, CustomerName
Included Columns: OpeningAmount, Outstanding Amount*/

CREATE NONCLUSTERED INDEX  Non_Cluster_Customer
ON learning.Customer (Cust_Code , Cust_Name)

SELECT Cust_Code, Cust_Name, Opening_Amt, Outstanding_Amt 
FROM learning.Customer

--=====================================================================--

/*Q.6) Create NonClustered Index on AgentTable
Key Columns: AgentCode
Included Columns: AgentName, Commission*/
CREATE NONCLUSTERED INDEX  Non_Cluster_Agent
ON learning.Agent (Agent_Code)
GO

SELECT A.Agent_Code, A.Agent_Name, A.Commission 
FROM learning.Agent A
GO

/*=================================================================
						TRIGGER
===================================================================*/
/*Create AuditAgentTable :*/
CREATE OR ALTER TABLE Learning.AuditAgentTable
(
	AgentID INT,
	Agent_Code CHAR(6),
	Agent_Name CHAR(40),
	Working_Area CHAR(35),
	Commission DECIMAL(10,2),
	Phone_No CHAR(15),
	Country VARCHAR(25),
	TransactionDate DATE,
	TransactionType VARCHAR(25)
)
GO

SELECT * FROM Learning.Agent;
SELECT * FROM Learning.AuditAgentTable;
GO


CREATE TRIGGER AgentCRUDTrigger ON Learning.Agent
    FOR INSERT, UPDATE, DELETE
AS		
    DECLARE
	@AgentID INT,
	@Agent_Code CHAR(6),
	@Agent_Name CHAR(40),
	@Working_Area CHAR(35),
	@Commission DECIMAL(10,2),
	@Phone_No CHAR(15),
	@Country VARCHAR(25),
	@Audit_Action VARCHAR(25);
    
	DECLARE @DELAgentID INT,
	@DELAgent_Code CHAR(6),
	@DELAgent_Name CHAR(40),
	@DELWorking_Area CHAR(35),
	@DELCommission DECIMAL(10,2),
	@DELPhone_No CHAR(15),
	@DELCountry VARCHAR(25),
	@DELAudit_Action VARCHAR(100),
	@Audit_Action_Delete VARCHAR(25);
	
	
	SELECT @AgentID = i.AgentID
	FROM inserted i
	SELECT  @Agent_Code = i.Agent_Code
	FROM inserted i;
	SELECT  @Agent_Name = i.Agent_Name
	FROM inserted i;
	SELECT  @Working_Area = i.Working_Area
	FROM inserted i;
	SELECT  @Commission = i.Commission  
	FROM inserted i;
	SELECT  @Phone_No = i.Phone_No  
	FROM inserted i;
	SELECT  @Country = i.Country
	FROM inserted i;
	SET @Audit_Action = 'Inserted Records After Insert Trigger';
	SET @Audit_Action_Delete = 'Dleted Records After Insert Trigger';
	
	
	
	SELECT  @DELAgentID = d.AgentID  
	FROM deleted d;
	SELECT  @DELAgent_Code = d.Agent_Code
	FROM deleted d;
	SELECT  @DELAgent_Name = d.Agent_Name
	FROM deleted d;
	SELECT  @DELWorking_Area = d.Working_Area
	FROM deleted d;
	SELECT  @DELCommission = d.Commission  
	FROM deleted d;
	SELECT  @DELPhone_No = d.Phone_No  
	FROM deleted d;
	SELECT  @DELCountry = d.Country
	FROM deleted d;
	
	IF UPDATE(Agent_Name)
		SET @Audit_Action = 'Updated Recored -- After Updating trigger';
	IF UPDATE(Agent_Code)
		SET @Audit_Action = 'Updated Recored -- After Updating trigger';
	IF UPDATE(Working_Area)
		SET @Audit_Action = 'Updated Recored -- After Updating trigger';
	IF UPDATE(Commission)
		SET @Audit_Action = 'Updated Recored -- After Updating trigger';
	IF UPDATE(Phone_No)
		SET @Audit_Action = 'Updated Recored -- After Updating trigger';
	IF UPDATE(Country)
		SET @Audit_Action = 'Updated Recored -- After Updating trigger';

		INSERT INTO Learning.AuditAgentTable
		(Agent_Code, Agent_Name, Working_Area, Commission, Phone_No, Country, TransactionDate, TransactionType) 
		VALUES (@Agent_Code, @Agent_Name, @Working_Area, @Commission, @Phone_No, @Country, getdate(), @Audit_Action);
		PRINT 'AFTER INSERT TRIGGER FIRED.'	


		INSERT INTO Learning.AuditAgentTable
		(Agent_Code, Agent_Name, Working_Area, Commission, Phone_No, Country, TransactionDate, TransactionType) 
		VALUES (@DELAgent_Code, @DELAgent_Name, @DELWorking_Area, @DELCommission, @DELPhone_No, @DELCountry, getdate(), @Audit_Action_Delete);
		PRINT 'AFTER DELETE TRIGGER FIRED.'	

		SELECT * FROM deleted
		

GO

INSERT INTO Learning.Agent
(Agent_Code, Agent_Name, Working_Area, Commission, Phone_No, Country) 
VALUES ('A015','Raj','MUMBAI', 0.14, '091-909090',NULL);
GO

SELECT * FROM Learning.Agent;
SELECT * FROM Learning.AuditAgentTable;

UPDATE Learning.Agent 
SET Working_Area = 'London'
WHERE Agent_Name = 'Raj'

DELETE FROM Learning.Agent 
WHERE Agent_Name = 'LALU'