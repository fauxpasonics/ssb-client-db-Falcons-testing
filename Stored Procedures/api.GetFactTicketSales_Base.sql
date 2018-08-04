SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<JT Louviere>
-- Create date: <10/8/2015>
-- Description:	<Stored Procedure for pulling rpt.vw_FactTicketSales_Base_NewFs
--               in Data Downloader>
-- =============================================
CREATE PROCEDURE [api].[GetFactTicketSales_Base]

AS
BEGIN
	Select * 
	From rpt.vw_FactTicketSales_Base_NewFs
	FOR XML Path ('FactTicketSales_Base_NewFs'),ROOT('FactTicketSales_Bases_NewFs')

END

GO
