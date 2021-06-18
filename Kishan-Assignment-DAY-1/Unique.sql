--Q.8) Create Script to understand Unique constraint. Script should contain following (Filename should be
--Unique.sql)
	--1) Create TABLE
	--2) Write Insert Statements showing success & error./*==============================================
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
	WHERE name='Learning.UniqueDemo'
)
BEGIN
    CREATE TABLE Learning.UniqueDemo (
        IDColumn INT IDENTITY(1,1),
		UName NVARCHAR(20)
    )
END
ELSE 
BEGIN
	PRINT 'TABLE IS ALREADY CREATED';
END
GO

SELECT * 
FROM Learning.UniqueDemo;
GO

/*=============================================
				INSERT VALUES
===============================================*/
--SUCCESS
INSERT INTO 
Learning.UniqueDemo VALUES ('A');
GO

--ERROR
INSERT INTO 
Learning.UniqueDemo(IDColumn, UName) VALUES (2,'B');
GO

SELECT * 
FROM Learning.UniqueDemo;
GO