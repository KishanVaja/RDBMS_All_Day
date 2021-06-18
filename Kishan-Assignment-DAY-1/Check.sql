--Q.7) Create Script to understand Check constraint. Script should contain following (Filename should be
--Check.sql)
	--1) Create TABLE
	--2) Write Insert Statements showing success & error.

/*==============================================
				CREATING SCHEMA
================================================*/

IF EXISTS (SELECT 1 FROM SYS.schemas WHERE NAME = 'Learning')
BEGIN
	DROP SCHEMA [Learning]
END
GO
CREATE SCHEMA Learning
	AUTHORIZATION dbo;
GO

/*=============================================
				CREATE TABLE
===============================================*/
IF NOT EXISTS (
	SELECT name 
	FROM sysobjects 
	WHERE name='Learning.CheckDemo'
)
BEGIN
    CREATE TABLE Learning.CheckDemo (
        IDColumn INT,
		UName NVARCHAR(20),
		Age INT CHECK (Age >=18)
    )
END
ELSE 
BEGIN
	PRINT 'TABLE IS ALREADY CREATED';
END
GO

SELECT * 
FROM Learning.CheckDemo;
GO

/*=============================================
				INSERT VALUES
===============================================*/
--SUCCESS
INSERT INTO 
Learning.CheckDemo VALUES (1,'A',20);
GO

--ERROR
INSERT INTO 
Learning.CheckDemo VALUES (2, 'B', 17);
GO

SELECT * 
FROM Learning.CheckDemo;
GO