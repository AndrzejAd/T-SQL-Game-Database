USE GameProjectv3

IF OBJECT_ID('dbo.Players') IS NOT NULL
	DROP TABLE dbo.Players
GO
CREATE TABLE Players(
PlayerID INT IDENTITY(1,1) PRIMARY KEY,
[Player NickName] NVARCHAR(50) UNIQUE NOT NULL,
[Player name] NVARCHAR(50) NOT NULL,
[Birth Date] DATE,
[Player Country] NVARCHAR(50),
[In game] BIT
)

IF OBJECT_ID('dbo.Armies') IS NOT NULL
	DROP TABLE dbo.Armies
GO
CREATE TABLE Armies(
ArmyID INT IDENTITY(1,1) PRIMARY KEY,
[Army Name] NVARCHAR(50) UNIQUE NOT NULL,
[Army Location] NVARCHAR(50) REFERENCES Locations([Locations Name]) NOT NULL,
[Owner] NVARCHAR(50) REFERENCES Players([Player NickName]) NOT NULL
)

IF OBJECT_ID('dbo.Heroes') IS NOT NULL
	DROP TABLE dbo.Heroes
GO
CREATE TABLE Heroes(
HeroID INT IDENTITY(1,1) PRIMARY KEY,
[Hero Name] NVARCHAR(50) UNIQUE NOT NULL,
[Hero Level] INT,
[Hero Type] NVARCHAR(50) NOT NULL,
[Hero Army] NVARCHAR(50) REFERENCES Armies([Army Name]) NOT NULL,
[Hero Location] NVARCHAR(50) REFERENCES Locations([Locations Name]) NOT NULL,
[Hero Equipment] NVARCHAR(50) REFERENCES Equipment([Equipment Name]) NOT NULL,
HeroHP INT NOT NULL
)


IF OBJECT_ID('dbo.Detachments') IS NOT NULL
	DROP TABLE dbo.Detachments
GO
CREATE TABLE Detachments(
DetachmentID INT IDENTITY(1,1) PRIMARY KEY,
[Detachment Name] NVARCHAR(50) UNIQUE NOT NULL,
[Number of Infantry Units] INT,
[Number of Cavalry Units] INT,
[Number of Archers Unit] INT,
[Main Adrmy] NVARCHAR(50) REFERENCES Armies([Army Name]) NOT NULL,
INDEX [Detachment Index] ([Detachment Name])
)


IF OBJECT_ID('dbo.Locations') IS NOT NULL
	DROP TABLE dbo.Locations
GO
CREATE TABLE Locations(
LocationsID INT IDENTITY(1,1) PRIMARY KEY,
[Locations Name] NVARCHAR(50) UNIQUE NOT NULL,
[Bonus To Infantry Units] INT,
[Bonus To Cavalry Units] INT,
[Bonus To Archers Unit] INT,
Weather NVARCHAR(50) REFERENCES Weather([Weather Name])
)

IF OBJECT_ID('dbo.Monsters') IS NOT NULL
	DROP TABLE dbo.Monsters
GO
CREATE TABLE Monsters(
MonstersID INT IDENTITY(1,1) PRIMARY KEY,
[Monsters Name] NVARCHAR(50) UNIQUE NOT NULL,
[Damage To Infantry Units] INT,
[Damage To  Cavalry Units] INT,
[Damage To  Archers Unit] INT,
[Monster Equipment] NVARCHAR(50) REFERENCES Equipment([Equipment Name]) NOT NULL,
[Monster Location] NVARCHAR(50) REFERENCES Locations([Locations Name]) NOT NULL
)


IF OBJECT_ID('dbo.Equipment') IS NOT NULL
	DROP TABLE dbo.Equipment
GO
CREATE TABLE Equipment(
EquipmentID INT IDENTITY(1,1) PRIMARY KEY,
[Equipment Name] NVARCHAR(50) UNIQUE NOT NULL,
Damage INT,
[Bonus To Infantry Damage] INT,
[Bonus To  Cavalry Damage] INT,
[Bonus To  Archers Damage] INT,
[Required Level] INT,
[Probillity To Find] INT NOT NULL
)


IF OBJECT_ID('dbo.Weather') IS NOT NULL
	DROP TABLE dbo.Weather
GO
CREATE TABLE Weather(
WeatherID INT IDENTITY(1,1) PRIMARY KEY,
[Weather Name] NVARCHAR(50) UNIQUE NOT NULL,
[Bonus To Infantry Damage] INT,
[Bonus To Cavalry Damage] INT,
[Bonus To Archers Damage] INT,
)


IF OBJECT_ID('dbo.Battles') IS NOT NULL
	DROP TABLE dbo.Battles
GO
CREATE TABLE Battles(
BattlesID INT IDENTITY(1,1) PRIMARY KEY,
[Battles Name] NVARCHAR(50),
[Army Name 1] NVARCHAR(50) NOT NULL,
[Army Name 2] NVARCHAR(50)NOT NULL,
[Where It Happened] NVARCHAR(50) REFERENCES Locations([Locations Name]) NOT NULL,
[Who Won] NVARCHAR(50),
)

IF OBJECT_ID('dbo.RandomEvents') IS NOT NULL
	DROP TABLE dbo.RandomEvents
GO
CREATE TABLE RandomEvents(
EventID INT IDENTITY(1,1) PRIMARY KEY,
[Event Name] CHAR(50),
[Proballity Of Event] INT NOT NULL,
[Change Of Infantry] INT,
[Change Of Cavalry] INT,
[Change Of Archers] INT,
[Change Of HeroLvl] INT,
[Change Of HeroHP] INT,
[Change Of Equipment] INT,
[Change Of Weather] INT,
[Change Of Location] INT
)


IF OBJECT_ID('dbo.[Units Stats]') IS NOT NULL
	DROP TABLE dbo.[Units Stats]
GO
CREATE TABLE [Units Stats](
StatID INT IDENTITY(1,1) PRIMARY KEY,
[Unit Type] CHAR(50),
[Attack Strength] SMALLINT,
[Defence Strength] SMALLINT
)