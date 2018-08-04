SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw_FactTicketSalesHistory] AS (SELECT * FROM dbo.FactTicketSalesHistory (NOLOCK)) 






GO
