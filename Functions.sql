USE GameProjectv3


/* Return total number of infantry in army*/
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[GetSumOfInfantryUnits]') IS NOT NULL
DROP FUNCTION dbo.[GetSumOfInfantryUnits]
GO
CREATE FUNCTION GetSumOfInfantryUnits(
	@armyName NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @sum INT
	SET @sum = ( SELECT SUM ( D.[Number of Infantry Units] )
	FROM Detachments D
	WHERE D.[Main Army]=@armyName )
	RETURN (@sum)
END*/

/* Return total number of cavalry in army*/
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[GetSumOfCavalryUnits]') IS NOT NULL
DROP FUNCTION dbo.[GetSumOfCavalryUnits]
GO
CREATE FUNCTION GetSumOfCavalryUnits(
	@armyName NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @sum INT
	SET @sum = ( SELECT SUM ( D.[Number of Cavalry Units] )
	FROM Detachments D
	WHERE D.[Main Army]=@armyName )
	RETURN (@sum)
END*/

/* Return total number of infantry in army*/
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[GetSumOfArchersUnits]') IS NOT NULL
DROP FUNCTION dbo.[GetSumOfArchersUnits]
GO
CREATE FUNCTION GetSumOfArchersUnits(
	@armyName NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @sum INT
	SET @sum = ( SELECT SUM ( D.[Number of Archers Unit] )
	FROM Detachments D
	WHERE D.[Main Army]=@armyName )
	RETURN (@sum)
END*/


/* Returns  total strength of the army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Get Total Strength]') IS NOT NULL
DROP FUNCTION dbo.[Get Total Strength]
GO
CREATE FUNCTION [Get Total Strength](
	@armyName1 nvarchar(50)
)
RETURNS @TotalPower1stArmy  TABLE(
	[Total Infantry Power] INT,
	[Total Cavalry Power] INT,
	[Total Archers Power] INT
)
AS
BEGIN 
	/* Setting first and second army basic power  */
	INSERT INTO @TotalPower1stArmy VALUES(dbo.GetSumOfInfantryUnits(@armyName1), dbo.GetSumOfCavalryUnits(@armyName1), dbo.GetSumOfArchersUnits(@armyName1)) 
	/* Computing bonuses for each table */
	DECLARE @BonusesFor1stArmy TABLE(
	  [Total Infantry Bonus Power] FLOAT,
	  [Total Cavalry Bonus Power] FLOAT,
	  [Total Archers Bonus Power] FLOAT
	)
	INSERT INTO @BonusesFor1stArmy
	SELECT B.[Total Bonus To Infantry], B.[Total Bonus To Cavalry], B.[Total Bonus To Archers] FROM dbo.[Total Bonuses] B
	WHERE B.[Hero Army]=@armyName1

	/* without 'WHERE' it updates all rows */

	UPDATE @TotalPower1stArmy
	SET [Total Infantry Power] += [Total Infantry Power] * ( SELECT B.[Total Infantry Bonus Power] /100 FROM @BonusesFor1stArmy B ),
		[Total Cavalry Power] +=  [Total Cavalry Power] * ( SELECT B.[Total Cavalry Bonus Power] /100 FROM @BonusesFor1stArmy B ),
		[Total Archers Power] += [Total Archers Power]* ( SELECT B.[Total Archers Bonus Power] /100 FROM @BonusesFor1stArmy B )
	RETURN 
END */

/* Returns won battles of the army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Get Won Battles]') IS NOT NULL
DROP FUNCTION dbo.[Get Won Battles]
GO
CREATE FUNCTION [Get Won Battles](
	@armyName1 NVARCHAR(50)
)
RETURNS @wonBattles TABLE(
	[Army Name] NVARCHAR(50),
	[Losers] NVARCHAR(50),
	[Where it happened] NVARCHAR(50)
)
AS
BEGIN 
	INSERT INTO @wonBattles
	SELECT B.[Army Name 1], B.[Army Name 2], B.[Where It Happened] FROM Battles B
	WHERE B.[Who Won]=@armyName1
	RETURN 
END */
