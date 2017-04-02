USE GameProjectv3

/*Checks if heroes equipment level is appropiate */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Check Requirements]') IS NOT NULL
DROP TRIGGER dbo.[Check Requirements]

GO
CREATE TRIGGER [Check Requirements] ON Heroes
FOR INSERT
AS
DECLARE @equipmentName NVARCHAR(50), @heroLevel INT
SELECT @equipmentName = I.[Hero Equipment], @heroLevel = I.[Hero Level] FROM inserted I
IF ( @heroLevel < ( SELECT  E.[Required Level] FROM Equipment E WHERE E.[Equipment Name] = @equipmentName ) )
BEGIN
	ROLLBACK
	RAISERROR('Hero level is too low for that weapon!',1,2) 
END*/

/*Checks if monster equipment level is appropiate */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Check Requirements]') IS NOT NULL
DROP TRIGGER dbo.[Check Requirements]

GO
CREATE TRIGGER [Check Requirements] ON Monsters
FOR INSERT
AS
DECLARE @equipmentName NVARCHAR(50), @monsterLevel INT
SELECT @equipmentName = I.[Monster Equipment], @monsterLevel = I.[Monster Level] FROM inserted I
IF ( @monsterLevel < ( SELECT  E.[Required Level] FROM Equipment E WHERE E.[Equipment Name] = @equipmentName ) )
BEGIN
	ROLLBACK
	RAISERROR('Hero level is too low for that weapon!',1,2) 
END*/

/*Checks player data */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Check Player]') IS NOT NULL
DROP TRIGGER dbo.[Check Player]

GO
CREATE TRIGGER [Check Players] ON Players
FOR INSERT
AS
DECLARE @playerBirth DATE
SELECT @playerBirth = I.[Birth Date] FROM inserted I
IF ( DATEDIFF ( year, @playerBirth , CONVERT(DATE, GETDATE())) > 100 )
BEGIN
	ROLLBACK
	RAISERROR('Player is too old! Player age is: ', 1,2) 
END*/

/*If player has no armies throw him out of the game*/
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Has Army]') IS NOT NULL
DROP TRIGGER dbo.[Has Army]

GO
CREATE TRIGGER [Has Army] ON Armies
FOR DELETE
AS
DECLARE @playerName NVARCHAR(50)
SELECT @playerName = D.Owner FROM deleted D
IF NOT EXISTS ( SELECT * FROM Armies A WHERE A.Owner=@playerName )  
BEGIN
	UPDATE Players
	SET [In Game]=0
	WHERE [Player NickName]=@playerName
	RAISERROR('Player %s has no armies, removing him from the game!', 0,1, @playerName ) 
END*/

/*If army has detachment*/
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Has Detachment]') IS NOT NULL
DROP TRIGGER dbo.[Has Detachment]

GO
CREATE TRIGGER [Has Detachment] ON Detachments
FOR DELETE
AS
DECLARE @armyName NVARCHAR(50)
SELECT @armyName = D.[Main Army] FROM deleted D
IF NOT EXISTS ( SELECT * FROM Detachments A WHERE A.[Main Army]=@armyName )  
BEGIN
	EXEC dbo.[Destroy Army] @armyName
	RAISERROR('Army %s has no detachments, removing it from the game!', 0,1, @armyName ) 
END
*/