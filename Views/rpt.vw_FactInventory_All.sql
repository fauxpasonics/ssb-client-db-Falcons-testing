SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_FactInventory_All] AS (
	SELECT * FROM dbo.FactInventory (NOLOCK)
		UNION ALL
	SELECT * FROM dbo.FactInventoryHistory (NOLOCK)
)
GO
