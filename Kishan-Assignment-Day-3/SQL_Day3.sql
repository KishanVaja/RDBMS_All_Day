/*=============================================
				DAY - 3 PROCEDURES
================================================*/
/*================================================
				CREATE PROCEDURE
==================================================*/

CREATE OR ALTER PROCEDURE SELECTAGENTBYCITY
(
	@WorkingArea VARCHAR(100)
)
AS
BEGIN
	--IF OBJECT_ID('tempdb..#TempAgent','U') IS NOT NULL DROP TABLE #TempAgent;
	
	SELECT A.Agent_Code, A.Agent_Name, A.Working_Area
	INTO #TempAgent
	FROM Learning.Agent A
	WHERE A.Working_Area = @WorkingArea

	ALTER TABLE #TempAgent ADD AGENT_STAR VARCHAR(50)

	UPDATE #TempAgent SET AGENT_STAR = Agent_Name + @WorkingArea

	SELECT * FROM #TempAgent

EXEC SELECTAGENTBYCITY @WorkingArea = 'London'

END

SELECT * FROM Learning.Agent
SELECT * FROM Learning.Customer

GO

/*=========================================================
				AGENT-CUSTOMER LOCAL TEMP TABLE
===========================================================*/
    
CREATE OR ALTER PROCEDURE Learning.JoinProcedure @Grade int
AS
BEGIN
	--IF OBJECT_ID('tempdb..#TempAgent','U') IS NOT NULL DROP TABLE #TempAgent;
	SELECT @Grade AS SELECTED_GRADE

    SELECT A.Agent_Name, C.Cust_Name, C.Grade
	INTO #AgentCustomer
    FROM Learning.Customer C
    JOIN Learning.Agent A 
	ON C.AgentID = A.AgentID
    WHERE C.Grade = @grade;

	SELECT * FROM #AgentCustomer
END

EXEC Learning.JoinProcedure 3;

SELECT * FROM Learning.Agent
SELECT * FROM Learning.Customer
GO

/*=========================================================
				AGENT-CUSTOMER GLOBAL TEMP TABLE
===========================================================*/
CREATE OR ALTER PROCEDURE Learning.GlobalJoinProcedure 
AS
BEGIN
	IF OBJECT_ID('tempdb..##GlobalAgentCustomer','U') IS NOT NULL DROP TABLE ##GlobalAgentCustomer;

	DECLARE @COMMITION INT = 0
	DECLARE @CIYT VARCHAR(100) = 'MUMBAI'
	
	SELECT @COMMITION AS SELECTED_COMMITION, @CIYT AS SELCETED_CITY

    SELECT A.Agent_Name, A.Commission, C.Cust_Name, C.Working_Area
	INTO ##GlobalAgentCustomer
    FROM Learning.Customer C
    JOIN Learning.Agent A 
	ON C.AgentID = A.AgentID
    WHERE A.Commission >= @COMMITION  AND C.Working_Area = @CIYT ;

	SELECT * FROM ##GlobalAgentCustomer
END

EXEC Learning.GlobalJoinProcedure;

SELECT * FROM Learning.Agent
SELECT * FROM Learning.Customer

GO

/*=========================================================
				AGENT-CUSTOMER TEMP TABLE
===========================================================*/
CREATE OR ALTER PROCEDURE Learning.ConcateProcedure 
AS
BEGIN
	IF OBJECT_ID('tempdb..#CustomerData','U') IS NOT NULL DROP TABLE #CustomerData;

    SELECT A.Agent_Name, A.Phone_No, C.Cust_Name
	INTO #CustomerData
    FROM Learning.Customer C
    RIGHT JOIN Learning.Agent A 
	ON C.AgentID = A.AgentID;

	SELECT * FROM #CustomerData

	ALTER TABLE #CustomerData ADD ConcatePhone VARCHAR(50)

	UPDATE #CustomerData SET ConcatePhone = C.Phone_No + A.Phone_No;

	SELECT * FROM #CustomerData
END

EXEC Learning.ConcateProcedure;

SELECT * FROM Learning.Agent
SELECT * FROM Learning.Customer

GO
