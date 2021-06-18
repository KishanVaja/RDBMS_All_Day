--Q.8) Create Script to understand Default constraint. Script should contain following (Filename should be
--Default.sql)
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
	WHERE name='Learning.DefaultDemo'
)
BEGIN
		CREATE TABLE Learning.DefaultDemo (
        IDColumn INT,
		UName NVARCHAR(20) DEFAULT 'NAME IS NOT ASSIGNED'
    )
END
ELSE 
BEGIN
	PRINT 'TABLE IS ALREADY CREATED';
END
GO


SELECT * 
FROM Learning.DefaultDemo;
GO

--DROP TABLE Learning.DefaultDemo
/*=============================================
				INSERT VALUES
===============================================*/
INSERT INTO 
Learning.DefaultDemo VALUES (1, 'A');
GO

INSERT INTO 
Learning.DefaultDemo(IDColumn) VALUES (2);
GO

INSERT INTO 
Learning.DefaultDemo VALUES (3, NULL);
GO

SELECT * 
FROM Learning.DefaultDemo;
GO