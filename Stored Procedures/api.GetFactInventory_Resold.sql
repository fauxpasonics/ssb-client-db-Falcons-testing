SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<JT Louviere>
-- Create date: <10/14/2015>
-- Description:	<Stored Procedure for pulling rpt.vw_FactInventory_Resold
--               in Data Downloader>
-- =============================================
CREATE PROCEDURE [api].[GetFactInventory_Resold]

AS
BEGIN
	Select * 
	From rpt.vw_FactInventory_Resold
	FOR XML Path ('FactInventory_Resold'),ROOT('FactInventory_Resold')

END

GO
