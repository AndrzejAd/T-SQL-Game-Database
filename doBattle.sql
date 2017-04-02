/* Does battle between 2 armies */
/*-----------------------------------------------*/
IF OBJECT_ID('dbo.[Do Battle]') IS NOT NULL
DROP PROC dbo.[Do Battle]
GO
CREATE PROCEDURE [Do Battle](
	@armyName1 nvarchar(50),
	@armyName2 nvarchar(50)
)
AS
BEGIN TRY
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName1 )
		RAISERROR('There is no army named %s', 16,1, @armyName1)
	IF NOT EXISTS ( SELECT A.[Army Name] FROM Armies A WHERE A.[Army Name]=@armyName2 )
		RAISERROR('There is no army named %s', 16,1, @armyName2)
	IF ( SELECT A.[Army Location] FROM Armies A WHERE A.[Army Name]=@armyName1 ) NOT IN 
		( SELECT A.[Army Location] FROM Armies A WHERE A.[Army Name]=@armyName2 )
		RAISERROR('Locations differ, cant make a battle', 16, 1) 


	DECLARE @TotalPower1stArmy TABLE(
	  [Total Infantry Power] INT,
	  [Total Cavalry Power] INT,
	  [Total Archers Power] INT,
	  [Total Attack Power] INT,
	  [Total Defense Power] INT
	)
	DECLARE @TotalPower2stArmy TABLE(
	  [Total Infantry Power] INT,
	  [Total Cavalry Power] INT,
	  [Total Archers Power] INT,
	  [Total Attack Power] INT,
	  [Total Defense Power] INT
	)

	INSERT INTO @TotalPower1stArmy([Total Infantry Power] , [Total Cavalry Power], [Total Archers Power] )
		SELECT * FROM dbo.[Get Total Strength](@armyName1)
	INSERT INTO @TotalPower2stArmy([Total Infantry Power] , [Total Cavalry Power], [Total Archers Power])
		SELECT * FROM dbo.[Get Total Strength](@armyName2)

	UPDATE @TotalPower1stArmy 
	SET	[Total Attack Power] = ( ( [Total Infantry Power] * ( SELECT [Attack Strength] FROM [Units Stats] U WHERE U.StatID = 1 ) ) 
		+ ( [Total Cavalry Power] * ( SELECT [Attack Strength] FROM [Units Stats] U WHERE U.StatID = 2 ) )
		+ ( [Total Archers Power] * ( SELECT [Attack Strength] FROM [Units Stats] U WHERE U.StatID = 3 ) ) ),
		[Total Defense Power] = ( ( [Total Infantry Power] * ( SELECT [Defence Strength] FROM [Units Stats] U WHERE U.StatID = 1 ) ) 
		+ ( [Total Cavalry Power] * ( SELECT [Defence Strength] FROM [Units Stats] U WHERE U.StatID = 2 ) )
		+ ( [Total Archers Power] * ( SELECT [Defence Strength] FROM [Units Stats] U WHERE U.StatID = 3 ) ) )
		
	UPDATE @TotalPower2stArmy 
	SET	[Total Attack Power] = ( ( [Total Infantry Power] * ( SELECT [Attack Strength] FROM [Units Stats] U WHERE U.StatID = 1 ) ) 
		+ ( [Total Cavalry Power] * ( SELECT [Attack Strength] FROM [Units Stats] U WHERE U.StatID = 2 ) )
		+ ( [Total Archers Power] * ( SELECT [Attack Strength] FROM [Units Stats] U WHERE U.StatID = 3 ) ) ),
		[Total Defense Power] = ( ( [Total Infantry Power] * ( SELECT [Defence Strength] FROM [Units Stats] U WHERE U.StatID = 1 ) ) 
		+ ( [Total Cavalry Power] * ( SELECT [Defence Strength] FROM [Units Stats] U WHERE U.StatID = 2 ) )
		+ ( [Total Archers Power] * ( SELECT [Defence Strength] FROM [Units Stats] U WHERE U.StatID = 3 ) ) )

	SELECT @armyName1 AS 'Name', * FROM @TotalPower1stArmy
	SELECT @armyName2 AS 'Name', * FROM @TotalPower2stArmy

	DECLARE @defence1 INT SET @defence1 = ( SELECT A.[Total Defense Power]  FROM @TotalPower1stArmy A )
	DECLARE @attack1 INT SET @attack1 = ( SELECT A.[Total Attack Power]  FROM @TotalPower1stArmy A )
	DECLARE @defence2 INT SET @defence2 = ( SELECT A.[Total Defense Power]  FROM @TotalPower2stArmy A )
	DECLARE @attack2 INT SET @attack2 = ( SELECT A.[Total Attack Power]  FROM @TotalPower2stArmy A )

	--SELECT @defence1, @attack1, @defence2, @attack2 
	-- variable @help decides the outcome if 2 - there is a draw
	DECLARE @help INT SET @help = 0 
	DECLARE @help1 INT SET @help1 = 0

	IF ( @defence1 < @attack2 ) 
		BEGIN
			SELECT @armyName1 AS 'Name', 'This army is destroyed! ' AS [ ] 
			EXEC dbo.[Destroy Army] @armyName1
			SET @help += 1
		END

	IF ( @defence2 < @attack1 ) 
		BEGIN
			SELECT @armyName2 AS 'Name', 'This army is destroyed! ' AS [ ]
			EXEC dbo.[Destroy Army] @armyName2
			SET @help += 1
		END

	DECLARE @loc NVARCHAR(50) SET @loc = ( SELECT A.[Army Location] FROM Armies A WHERE A.[Army Name]=@armyName1 )

	IF @help = 2
		BEGIN
			INSERT INTO Battles VALUES
			('', @armyName1, @armyName2, @loc, 'DRAW' )
		END		

	SET @help = 0

	IF ( @defence1 > @attack2 ) 
		BEGIN
			-- Destroy some of the detachments8
			SELECT * FROM dbo.[Number of troops in each Army] A WHERE A.[Army Name] = @armyName1
			DECLARE @lostUnits FLOAT SET @lostUnits = ( ( CAST ( @defence1 AS FLOAT ) - CAST ( @attack2 AS FLOAT )) / CAST ( @defence1 AS FLOAT ) *100  ) 
			SELECT ROUND( @lostUnits, 2 ) AS [ Survivors ], 'Of' AS [ ],  @armyName1 AS [ Army 1 ], 'Survived' AS [ ] 
			SET @lostUnits = 100 - @lostUnits
			EXEC dbo.[Destroy Part of Army] @armyName1, @lostUnits
			SELECT * FROM dbo.[Number of troops in each Army] A WHERE A.[Army Name] = @armyName1
			SET @help += 1
		END

	IF ( @defence2 > @attack1 ) 
		BEGIN
			-- Destroy some of the detachments
			SELECT * FROM dbo.[Number of troops in each Army] A WHERE A.[Army Name] = @armyName2
			DECLARE @lostUnits1 FLOAT SET @lostUnits = ( ( CAST ( @defence2 AS FLOAT ) - CAST ( @attack1 AS FLOAT )) / CAST ( @defence2 AS FLOAT ) *100  ) 
			SELECT ROUND( @lostUnits1, 2 ) AS [ Survivors ], 'Of' AS [ ],  @armyName2 AS [ Army 2 ], 'Survived'	AS [ ]	
			SET @lostUnits1 = 100 - @lostUnits1
			EXEC dbo.[Destroy Part of Army] @armyName2, @lostUnits1
			SELECT * FROM dbo.[Number of troops in each Army] A WHERE A.[Army Name] = @armyName2
			SET @help1 += 1
		END
	
	/* decide who won */
	IF @help = 1 AND @help1 = 1
		BEGIN
			INSERT INTO Battles VALUES
			('', @armyName1, @armyName2, @loc, 'DRAW' )
		END
	ELSE
		IF @help = 1
			BEGIN
				INSERT INTO Battles VALUES
				('', @armyName1, @armyName2, @loc, @armyName1 )
			END
		IF @help1 = 1
			BEGIN
				INSERT INTO Battles VALUES
				('', @armyName1, @armyName2, @loc, @armyName2 )
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