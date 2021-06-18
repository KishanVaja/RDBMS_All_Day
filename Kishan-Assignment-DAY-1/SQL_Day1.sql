/*Day 1 Assingment
Q.1) Write a Small Description on System Databases. Create .SQL File for it.*/

PRINT 'SQL Server includes the following system databases.';
DECLARE @SYSDB VARCHAR(500) = 
'1.) MASTER DATABASE: Records all the system-level information for an instance of SQL Server.
2.) MODEL DATABASE: Is used by SQL Server Agent for scheduling alerts and jobs.
3.) MSDB DATABASE: Is used as the template for all databases created on the instance of SQL Server.
4.) TEMPDB DATABASE: Is a workspace for holding temporary objects or intermediate result sets.
5.) RESOURECE DATABASE: Is a read-only database that contains system objects that are included with SQL Server.';
PRINT @SYSDB;
GO

--Q.2) Create Database Training
/*===========================================================
						CREATE DATABASE
=============================================================*/
 IF NOT EXISTS(
				 SELECT name 
				 FROM sys.databases 
				 WHERE name = 'Training'
			)
BEGIN
	CREATE DATABASE Training
END
ELSE 
BEGIN
	PRINT 'DATABASE IS ALREADY CREATED';
END
GO

/*DELETE THE DATABASE
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Training')
BEGIN
    DROP DATABASE Training;  
END;
	CREATE DATABASE Training;
GO*/
GO

--Q.3) Create Schema “Learning”, All the further assignment’s exercised need to be completed in Database = Training & Schema = “Learning” 
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
CREATE SCHEMA Learning
	AUTHORIZATION dbo;
GO

SELECT 
    s.name AS schema_name, 
    u.name AS schema_owner
FROM 
    sys.schemas s
	INNER JOIN sys.sysusers u ON u.uid = s.principal_id
WHERE
	S.name = 'Learning'
ORDER BY 
    s.name;
GO

--Q.4) Create Following Table and create SQL Script for the same.

USE Training
GO
/*================================================
				CREATE TABLE
==================================================*/
IF NOT EXISTS (
	SELECT name 
	FROM sysobjects 
	WHERE name='LearnDataType'
)
BEGIN
    CREATE TABLE Learning.LearnDataType (
        IDColumn INT NOT NULL,
        Column1 CHAR(10),
		Column2 NVARCHAR(10),
		Column3 BIGINT NOT NULL,
		Column4 DATETIME NOT NULL,
		Column5 DATE,
		Column6 TIMESTAMP NOT NULL,
		Column7 NVARCHAR(MAX) NOT NULL
    )
END
ELSE 
BEGIN
	PRINT 'TABLE IS ALREADY CREATED';
END
GO

SELECT * 
FROM Learning.LearnDataType;
GO

--Q.5) Create an INSERT script to Insert data in above table.
/*===================================================
					INSERT VALUES
=====================================================*/
INSERT INTO 
Learning.LearnDataType
VALUES 
(1, 'A', 'Abc', 255, '2021-06-01 19:45:00', '2021-06-01', DEFAULT,'This is varcharmax datatype');
INSERT INTO
Learning.LearnDataType 
VALUES
(3, '', 'XYZ', 123, '2021-06-01 20:11:50', '2021-06-01', DEFAULT,'This is varcharmax 3 datatype'),
(4, 'D', '', -56789, '2021-06-01 20:15:43', '2021-06-01', DEFAULT,'This is varcharmax 4 datatype'),
(5, 'E', 'Lmn', 123456, '2021-06-01 20:17:56', '2021-06-01', DEFAULT,'This is varcharmax 5 datatype'),
(6, '','', -98225, '2021-06-01 20:21:21', '', DEFAULT,'This is varcharmax 6 datatype');

SELECT * 
FROM Learning.LearnDataType;
GO