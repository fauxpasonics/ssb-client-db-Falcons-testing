SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<JT Louviere>
-- Create date: <11/23/2015>
-- Description:	<Stored Procedure for pulling rpt.vw_FactInventory_Resold
--               in Data Downloader>
-- =============================================
CREATE PROCEDURE [api].[AvailInventory_byPC]

AS
BEGIN
	select * 
	from [adhoc].[rptAvailInventory_byPC]
	FOR XML Path ('AvailInventory_byPC'),ROOT('AvailInventory_byPCs')

END


GO
