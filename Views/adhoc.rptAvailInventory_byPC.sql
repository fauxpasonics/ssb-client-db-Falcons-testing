SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [adhoc].[rptAvailInventory_byPC] AS
SELECT
	 de.eventcode, 
	 dc.pc1,
		COUNT(*) Qty
	FROM dbo.FactInventory fts
		INNER JOIN dbo.dimevent de ON fts.DimEventId = de.DimEventId
		INNER JOIN dbo.dimpricecode dc on fts.ManifestDimPriceCodeid = dc.DimPriceCodeId
		LEFT OUTER JOIN dbo.DimClassTM c ON fts.PostedDimClassTMId = ISNULL(c.DimClassTMId, fts.ManifestDimClassTMId)
	WHERE fts.IsSold = 0 AND fts.IsSaleable = 1
	--AND c.classname is not null	
	AND eventcode like 'GM%'
	group by de.eventcode, dc.pc1

GO
