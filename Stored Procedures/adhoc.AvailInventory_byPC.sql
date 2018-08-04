SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<JT Louviere>
-- Create date: <11/12/2015>
-- Description:	<--//Query to help automate the Game by Game General tab of the 2015 Budget Projections and Left to Sell Report--///
--//              L.Prime = A
--                L. Prime 31+ = B
--                L.Sideline = C
--                L.Sideline RZ = D
--                L. Corner = E
--                Lower Level EZ (14+) = F
--                Mezzanine Level - corners = G
--                Mezzanine Level - endzone = H
--                Upper Prime (rows 1-13) = I
--                Upper Prime (rows 14+) = J
--                Upper Side (rows 1-13) = K
--                Upper Side (rows 14-26) = M 
--                Upper Corner (rows 1-13) = L
--                Upper End Zone (rows 1-13) = N
--                Upper End Zone = O>
-- =============================================
CREATE PROCEDURE [adhoc].[AvailInventory_byPC]
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
	 de.eventcode, 
	 dc.pc1,
		COUNT(*) Qty
	FROM dbo.FactInventory fts
		INNER JOIN dbo.dimevent de ON fts.DimEventId = de.DimEventId
		INNER JOIN dbo.dimpricecode dc on fts.ManifestDimPriceCodeid = dc.DimPriceCodeId
		LEFT OUTER JOIN dbo.DimClassTM c ON fts.PostedDimClassTMId = ISNULL(c.DimClassTMId, fts.ManifestDimClassTMId)
	WHERE fts.IsSold = 0 AND fts.IsSaleable = 1 AND c.classname is not null	
	group by de.eventcode, dc.pc1

	--COALESCE(SoldDimPriceCodeId, HeldDimPriceCodeId, PostedDimPriceCodeId, ManifestDimPriceCodeId) 

END



GO
