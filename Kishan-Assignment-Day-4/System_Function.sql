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

SELECT YEAR(2000), MONTH(02), DAY(20);
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
   GETDATE() AS 'Date' ; 

/*To display a report containing several SQL Server statistics, including packets sent and received.*/
SELECT @@PACK_SENT AS 'Pack Sent';

/*Referance: https://docs.microsoft.com/en-us/sql/t-sql/functions/functions?view=sql-server-ver15 */