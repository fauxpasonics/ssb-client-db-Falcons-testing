SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_Falcons_TestField] AS

SELECT dimseatid SoldSeatID
  FROM [Falcons].[dbo].[FactInventory] (NOLOCK)
  WHERE issold = 1
  --AND dimseasonid = 73
  AND IsAttended=1
  AND dimeventid IN (148,149)
GO
