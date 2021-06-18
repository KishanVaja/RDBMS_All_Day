/*Q.9) Create Script to understand Primary Key constraint. Script should contain following (Filename
should be Primarykey.sql)
	1) Create TABLE
	2) Write Insert Statements showing success & error.*/


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

/*=============================================
				CREATE TABLE
===============================================*/
IF NOT EXISTS (
	SELECT name 
	FROM sysobjects 
	WHERE name='Learning.PrimaryKeyDemo'
)
BEGIN
		CREATE TABLE Learning.PrimaryKeyDemo (
        IDColumn INT PRIMARY KEY IDENTITY ,
		UName NVARCHAR(20) NULL DEFAULT 'VALUE IS NOT ASSIGNED'
    )
END
ELSE 
BEGIN
	PRINT 'TABLE IS ALREADY CREATED';
END
GO


SELECT * 
FROM Learning.PrimaryKeyDemo;
GO

/*=============================================
				INSERT VALUES
===============================================*/
--SUCCESS
INSERT INTO 
Learning.PrimaryKeyDemo VALUES ('A');
GO
--ERROR
INSERT INTO 
Learning.PrimaryKeyDemo(IDColumn) VALUES (2);
GO

INSERT INTO 
Learning.PrimaryKeyDemo VALUES (NULL);
GO

SELECT * 
FROM Learning.PrimaryKeyDemo;
GO