USE GameProjectv3

/* Moves army to another location */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.MoveArmy') IS NOT NULL
DROP PROCEDURE dbo.MoveArmy
GO
CREATE PROCEDURE MoveArmy(
	@armyName nvarchar(50),
	@newLocation nvarchar(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName )
		RAISERROR('There is no army named %d', 16,1, @armyName) 
	IF NOT EXISTS ( SELECT L.[Locations Name] FROM Locations L WHERE L.[Locations Name]=@newLocation )
		RAISERROR('There is no location named %d', 16,1, @newLocation) 
	UPDATE Armies 
	SET [Army Location]=@newLocation
	WHERE [Army Name]=@armyName
END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH*/

/* Moves hero to another location */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.MoveHero') IS NOT NULL
DROP PROC dbo.MoveHero
GO
CREATE PROCEDURE MoveHero(
	@HeroName nvarchar(50),
	@newLocation nvarchar(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT H.[Hero Name] FROM Heroes H WHERE H.[Hero Name]=@HeroName )
		RAISERROR('There is no hero named %d', 16,1, @HeroName) 
	IF NOT EXISTS ( SELECT L.[Locations Name] FROM Locations L WHERE L.[Locations Name]=@newLocation )
		RAISERROR('There is no location named %d', 16,1, @newLocation) 
	UPDATE Heroes 
	SET [Hero Location]=@newLocation
	WHERE [Hero Name]=@HeroName
END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH*/

/* Returns total strength of the army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Get Total Strength]') IS NOT NULL
DROP PROCEDURE dbo.[Get Total Strength]
GO
CREATE PROCEDURE [Get Total Strength](
	@armyName1 nvarchar(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName1 )
		RAISERROR('There is no army named %d', 16,1, @armyName1)
	DECLARE @TotalPower1stArmy TABLE(
	  [Total Infantry Power] INT,
	  [Total Cavalry Power] INT,
	  [Total Archers Power] INT
	)
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
	SET [Total Infantry Power] -= ABS ( [Total Infantry Power] * ( SELECT B.[Total Infantry Bonus Power] /100 FROM @BonusesFor1stArmy B )),
		[Total Cavalry Power] -=  ABS ( [Total Cavalry Power] * ( SELECT B.[Total Cavalry Bonus Power] /100 FROM @BonusesFor1stArmy B )),
		[Total Archers Power] -= ABS([Total Archers Power]* ( SELECT B.[Total Archers Bonus Power] /100 FROM @BonusesFor1stArmy B ))

	SELECT * FROM @TotalPower1stArmy

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH
*/

/* Destroys Army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Destroy Army]') IS NOT NULL
DROP PROCEDURE dbo.[Destroy Army]
GO
CREATE PROCEDURE [Destroy Army](
	@armyName nvarchar(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName )
		RAISERROR('There is no army named %d', 16,1, @armyName) 
	DELETE FROM Detachments
	WHERE [Main Army] = @armyName

	DELETE FROM Heroes
	WHERE [Hero Army] = @armyName

	DELETE FROM Armies
	WHERE [Army Name] = @armyName

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH*/

/* Destroys % of the one detachment */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Decimate Detachment]') IS NOT NULL
DROP PROCEDURE dbo.[Decimate Detachment]
GO
CREATE PROCEDURE [Decimate Detachment](
	@detName NVARCHAR(50),
	@percentage FLOAT
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT D.[Detachment Name] FROM Detachments D WHERE D.[Detachment Name] = @detName  )
		RAISERROR('There is no detachment named %d', 16,1, @detName ) 

	UPDATE Detachments 
	SET [Number of Infantry Units] -= [Number of Infantry Units] * @percentage/100.00
		,[Number of Cavalry Units]  -= [Number of Cavalry Units] * @percentage/100.00
		,[Number of Archers Unit]  -= [Number of Archers Unit] * @percentage/100.00
	WHERE [Detachment Name] = @detName

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH*/

/* Destroys % of all detachments in army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Destroy Part of Army]') IS NOT NULL
DROP PROCEDURE dbo.[Destroy Part of Army]
GO
CREATE PROCEDURE [Destroy Part of Army](
	@armyName NVARCHAR(50),
	@percentage FLOAT
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName )
		RAISERROR('There is no army named %d', 16,1, @armyName) 
	/* Computes total number of units to destroy */
	DECLARE @numberOfTroops INT SET @numberOfTroops = 0
	DECLARE @totalNumberOfTroops INT SET @totalNumberOfTroops = 0
	SET @totalNumberOfTroops += dbo.GetSumOfInfantryUnits(@armyName)
	SET @totalNumberOfTroops += dbo.GetSumOfCavalryUnits(@armyName)
	SET @totalNumberOfTroops += dbo.GetSumOfArchersUnits(@armyName)

	DECLARE @unitsToDestroy INT SET @unitsToDestroy = @totalNumberOfTroops * @percentage/100.00 
	
	/* ----------- */

	--SELECT @totalNumberOfTroops AS [Total Number Of Troops]
	--SELECT @unitsToDestroy AS [Number of Troops to Destroy]

	DECLARE @detName NVARCHAR(50)
	DECLARE @sum INT SET @sum = 0
	DECLARE @tmp INT SET @tmp = 0
	DECLARE @tmp1 INT SET @tmp1 = 0
	DECLARE @tmp2 INT SET @tmp2 = 0
	DECLARE @itNumb INT SET @itNumb = 0
	-- cursor iterates for each detachment

	DECLARE MY_CURSOR CURSOR 
	LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
	SELECT D.[Detachment Name], D.[Number of Infantry Units], D.[Number of Cavalry Units], D.[Number of Archers Unit]
	FROM Detachments D
	WHERE D.[Main Army] = @armyName

	OPEN MY_CURSOR
	FETCH NEXT FROM MY_CURSOR INTO @detName, @tmp, @tmp1, @tmp2
	SET @sum += @tmp
	SET @sum += @tmp1 
	SET @sum += @tmp2
	WHILE @@FETCH_STATUS = 0 AND @sum < @unitsToDestroy
	BEGIN 
		SELECT @detName AS [Detachment to destroy], @tmp, @tmp1, @tmp2, @sum
		DELETE FROM Detachments 
		WHERE [Detachment Name] = @detName
		SET @itNumb += 1
		SET @sum += @tmp
		SET @sum += @tmp1 
		SET @sum += @tmp2
		FETCH NEXT FROM MY_CURSOR INTO @detName, @tmp, @tmp1, @tmp2
	END
	
	/* First detachment is bigger than units to kill, so decrease it by @percantage */
	IF @itNumb = 0
		BEGIN
			EXEC dbo.[Decimate Detachment] @detName, @percentage
		END 

	CLOSE MY_CURSOR
	DEALLOCATE MY_CURSOR

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH
*/

/* Does battle against monster */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Battle Monster]') IS NOT NULL
DROP PROCEDURE dbo.[Battle Monster]
GO
CREATE PROCEDURE [Battle Monster](
	@heroName NVARCHAR(50)
)
AS
BEGIN TRY
	SELECT * FROM Heroes

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH*/

/* Performs random encounter */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Random Event]') IS NOT NULL
DROP PROCEDURE dbo.[Random Event]
GO
CREATE PROCEDURE [Random Event](
	@armyName NVARCHAR(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName )
		RAISERROR('There is no army named %d', 16,1, @armyName) 
	DECLARE @randNumb INT
	SET @randNumb = ABS(CHECKSUM(NewId())) % ( SELECT COUNT(*) FROM [Random Events] ) 
	UPDATE Detachments
	SET [Number of Infantry Units] += ( SELECT R.[Change Of Infantry] FROM [Random Events] R WHERE R.EventID = @randNumb),
	 [Number of Cavalry Units]  += ( SELECT R.[Change Of Cavalry] FROM [Random Events] R WHERE R.EventID = @randNumb),
	 [Number of Archers Unit]  += ( SELECT R.[Change Of Archers] FROM [Random Events] R WHERE R.EventID = @randNumb)
	WHERE [Main Army] = @armyName

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH*/

/* Does battle against monster */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Battle Monster]') IS NOT NULL
DROP PROCEDURE dbo.[Battle Monster]
GO
CREATE PROCEDURE [Battle Monster](
	@heroName NVARCHAR(50),
	@monsterName NVARCHAR(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Hero Name] FROM Heroes A WHERE A.[Hero Name]=@heroName  )
		RAISERROR('There is no hero named %d', 16,1, @heroName)
		IF NOT EXISTS ( SELECT a.[Monsters Name] FROM Monsters A WHERE A.[Monsters Name] =@monsterName )
		RAISERROR('There is no monster named %d', 16,1, @monsterName)
	DECLARE @heroLvl INT
	SET @heroLvl = ( SELECT H.[Hero Level] FROM Heroes H WHERE H.[Hero Name]=@heroName )
	DECLARE @monsterLvl INT
	SET @monsterLvl = ( SELECT M.[Monster Level] FROM Monsters M WHERE M.[Monsters Name]=@monsterName )

	IF ( @heroLvl >= @monsterLvl ) 
		BEGIN
			UPDATE Heroes
			SET [Hero Level] += @monsterLvl
			WHERE [Hero Name]=@heroName
		END
	ELSE
		BEGIN
			UPDATE Heroes
			SET [Hero Level]=  0
			WHERE [Hero Name]=@heroName
		END

END TRY
BEGIN CATCH
SELECT
	ERROR_NUMBER() AS ErrorNumber,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_STATE() AS ErrorState,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_LINE() AS ErrorLine,
	ERROR_MESSAGE() AS ErrorMessage;
	Return(5) 
END CATCH
*/