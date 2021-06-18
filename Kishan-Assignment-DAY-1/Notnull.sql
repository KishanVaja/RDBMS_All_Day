/*Q.6) Create Script to understand NOT NULL constraint. Script should contain following (Filename should
be Notnull.sql)
	1) Create TABLE
	2) Write Insert Statements showing success & error.*/

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
	WHERE name='Learning.NotNull'
)
BEGIN
    CREATE TABLE Learning.NotNull (
        IDColumn BIGINT NOT NULL,
		UName NVARCHAR(20) NOT NULL,
		Age INT NOT NULL 
    )
END
ELSE 
BEGIN
	PRINT 'TABLE IS ALREADY CREATED';
END
GO

SELECT * 
FROM Learning.NotNull;
GO

/*=============================================
				INSERT VALUES
===============================================*/
--SUCCESS
INSERT INTO 
Learning.NotNull(
	IDColumn,
	UName,
	Age
	)
VALUES 
(1, 'A', 20);
GO

--ERROR
INSERT INTO 
Learning.NotNull(IDColumn, UName) VALUES (2,'B');
GO

INSERT INTO 
Learning.NotNull VALUES (3,'C', 21);
GO

SELECT * 
FROM Learning.NotNull;
GO