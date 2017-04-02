USE GameProjectv3

/* Returns basic info about number of units in each army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Number of troops in each Army]') IS NOT NULL
DROP VIEW dbo.[Number of troops in each Army]

GO
CREATE VIEW [Number of troops in each Army]
AS
SELECT A.[Army Name], SUM(D.[Number of Infantry Units] ) AS [Total Number of Infantry Units],
 SUM(D.[Number of Cavalry Units] ) AS [Total Number of Cavalry Units],
 SUM(D.[Number of Archers Unit] ) AS [Total Number of Archer Units],
 (SUM(D.[Number of Infantry Units] ) + SUM(D.[Number of Cavalry Units] ) + SUM(D.[Number of Archers Unit] ) ) AS [Total number of Units]
FROM Detachments D
JOIN Armies A
ON D.[Main Army]=A.[Army Name]
GROUP BY A.[Army Name]*/


/* Shows bonuses from heroes for each army, also shows number of them in army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Bonuses From Heroes]') IS NOT NULL
DROP VIEW dbo.[Bonuses From Heroes]

GO
CREATE VIEW [Bonuses From Heroes]
AS
SELECT H.[Hero Army], COUNT( H.[Hero Army] ) AS [Number of Heroes], SUM (( CAST ( H.[Hero Level]*E.[Bonus To Infantry Damage]/100.00 AS float)  ) )AS [Bonus To Infantry]
,  SUM( ( CAST ( H.[Hero Level]*E.[Bonus To  Cavalry Damage]/100.00 AS float)  ) ) AS [Bonus To  Cavalry]
, SUM ( ( CAST ( H.[Hero Level]*E.[Bonus To  Archers Damage]/100.00 AS float)  ) ) AS [Bonus To  Archers]
FROM Heroes H 
JOIN Equipment E
ON H.[Hero Equipment]=E.[Equipment Name]
GROUP BY H.[Hero Army]
*/


/* Shows bonuses from location and wheather for each army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Bonuses From Location]') IS NOT NULL
DROP VIEW dbo.[Bonuses From Location]

GO
CREATE VIEW [Bonuses From Location]
AS
SELECT A.[Army Name], T1.[Locations Name], T1.[Weather Name], T1.[Bonus To Infantry], T1.[Bonus To Cavalry], T1.[Bonus To Archers] 
FROM Armies A
JOIN (
SELECT L.[Locations Name] ,( CAST ( L.[Bonus To Infantry Units] + W.[Bonus To Infantry Damage]/ 100.00 AS float) ) AS [Bonus To Infantry]
, ( CAST ( L.[Bonus To Cavalry Units] + W.[Bonus To Cavalry Damage]/ 100.00 AS float) ) AS [Bonus To Cavalry]
, ( CAST ( L.[Bonus To Archers Unit]  + W.[Bonus To Archers Damage]/ 100.00 AS float) ) AS [Bonus To Archers]
, W.[Weather Name]
FROM Locations L
JOIN Weather W
ON L.Weather=W.[Weather Name]
) AS T1
ON A.[Army Location]=T1.[Locations Name]*/

/*Counts possible battles for each army. Battle between armies is possible when locations are the same*/
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Possible Opponents]') IS NOT NULL
DROP VIEW dbo.[Possible Opponentss]

GO
CREATE VIEW [Possible Opponents]
AS
SELECT A1.[Army Name], ( COUNT ( A.ArmyID ) - 1) AS [Possible Oponnents]
FROM Armies A
JOIN Armies A1
ON A.[Army Location]=A1.[Army Location]
GROUP BY A1.[Army Name]*/

/*Shows possible battles for each army. */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Possible Opponents List]') IS NOT NULL
DROP VIEW dbo.[Possible Opponents List]

GO
CREATE VIEW [Possible Opponents List]
AS
SELECT A.[Army Name], 'VS' AS VERSUS, A1.[Army Name] AS Oponent
FROM Armies A
JOIN Armies A1
ON A.[Army Location]=A1.[Army Location]
WHERE A.[Army Name] != A1.[Army Name]*/


/* Statistics for armies and detachments */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Statistics]') IS NOT NULL
DROP VIEW dbo.[Statistics]

GO
CREATE VIEW [Statistics]
AS
SELECT SUM ( d.[Number of Infantry Units] ) / COUNT (DISTINCT A.ArmyID ) AS [Average Number of Infantry  Units In Army] ,
SUM ( d.[Number of Cavalry Units] ) / COUNT (DISTINCT A.ArmyID ) AS [Average Number of Cavalry Units In Army],
SUM ( d.[Number of Archers Unit] ) / COUNT (DISTINCT A.ArmyID ) AS [Average Number of Archers Units In Army], 
AVG ( d.[Number of Infantry Units] ) AS [Average Number of Infantry Units In Detachment ], 
AVG ( d.[Number of Cavalry Units] ) AS [Average Number of Cavalry Units In Detachment], 
AVG ( d.[Number of Archers Unit] ) AS [Average Number of Archers Units In Detachment]
FROM Detachments D
JOIN Armies A
ON D.[Main Army]=A.[Army Name]*/


/*Shows possible battles for heroes */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Possible Hero Battles]') IS NOT NULL
DROP VIEW dbo.[Possible Hero Battles]

GO
CREATE VIEW [Possible Hero Battles]
AS
SELECT H.[Hero Name], 'VS' AS VERSUS, M.[Monsters Name] 
FROM Heroes H
JOIN Monsters M
ON H.[Hero Location]=M.[Monster Location]*/


/* List of wearable equipment for heroes and list of monster having this weapon */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Wearable Equipment]') IS NOT NULL
DROP VIEW dbo.[Wearable Equipment]

GO
CREATE VIEW [Wearable Equipment]
AS
SELECT  T1.[Hero Name], T1.[Hero Level], T1.[Equipment Name], T1.[Required Level], t1.[Probality To Find], M.[Monsters Name], M.[Monster Location]
FROM Monsters M
FULL OUTER JOIN (
SELECT H.[Hero Name], H.[Hero Level], E.[Equipment Name], E.[Required Level], CAST ( E.[Probillity To Find]/100.00  AS FLOAT ) AS [Probality To Find]
FROM Equipment E 
JOIN Heroes H
ON H.[Hero Level] > E.[Required Level] ) AS T1
ON M.[Monster Equipment]=T1.[Equipment Name]*/

/* Returns biggest Detachment in the game */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Get Biggest Detachment]') IS NOT NULL
DROP VIEW dbo.[Get Biggest Detachment]
GO
CREATE VIEW [Get Biggest Detachment]
AS
	SELECT TOP(1) ( D.[Number of Infantry Units] + D.[Number of Cavalry Units] + D.[Number of Archers Unit] ) AS [Total Units], D.[Detachment Name], D.[Main Army], D.DetachmentID
	FROM Detachments D
	ORDER BY [Total Units] DESC
*/

/* Returns biggest army in the game */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Get Biggest Army]') IS NOT NULL
DROP VIEW dbo.[Get Biggest Army]
GO
CREATE VIEW [Get Biggest Army]
AS
	SELECT TOP(1) A.[Army Name], SUM( D.[Number of Infantry Units] + D.[Number of Cavalry Units] + D.[Number of Archers Unit] ) AS [Total Units]
	FROM Armies A 
	JOIN Detachments D
	ON A.[Army Name]=D.[Main Army]
	GROUP BY A.[Army Name]
	ORDER BY [Total Units] DESC*/

/*Shows total bonuses for each army */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Total bonuses]') IS NOT NULL
DROP VIEW dbo.[Total bonuses]

GO
CREATE VIEW [Total bonuses]
AS
SELECT H.[Hero Army],  (H.[Bonus To Infantry] + L.[Bonus To Infantry] ) AS [Total Bonus To Infantry]
, ( H.[Bonus To  Cavalry] + L.[Bonus To Cavalry] ) AS [Total Bonus To Cavalry]
, ( H.[Bonus To  Archers] + L.[Bonus To Archers] ) AS [Total Bonus To Archers]
FROM dbo.[Bonuses From Heroes] H
JOIN dbo.[Bonuses From Location] L
ON H.[Hero Army]=L.[Army Name]*/

/*Shows armies without detachments */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Army without detachments]') IS NOT NULL
DROP VIEW dbo.[Army without detachments]

GO
CREATE VIEW [Army without detachments]
AS
	SELECT *
	FROM Armies A
	WHERE A.[Army Name] NOT IN ( SELECT D.[Main Army] FROM Detachments D ) */

/*Shows players out of the game */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Players out of the game]') IS NOT NULL
DROP VIEW dbo.[Players out of the game]

GO
CREATE VIEW [Players out of the game]
AS
SELECT * FROM Players P
WHERE P.[In game]=0*/

/*Shows won battles */
/*-----------------------------------------------*/
/*IF OBJECT_ID('dbo.[Won Battles]') IS NOT NULL
DROP VIEW dbo.[Won Battles]

GO
CREATE VIEW [Won Battles]
AS
SELECT A.[Army Name], COUNT ( B.BattlesID ) AS 'Number'
FROM Armies A
FULL OUTER JOIN Battles B
ON A.[Army Name]=B.[Who Won]
GROUP BY A.[Army Name]*/
