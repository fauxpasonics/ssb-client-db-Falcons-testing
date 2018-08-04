SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw_FactTicketSales_All] AS (
	SELECT * FROM dbo.FactTicketSales (NOLOCK)
		UNION ALL
	SELECT * FROM dbo.FactTicketSalesHistory (NOLOCK)
) 






GO
