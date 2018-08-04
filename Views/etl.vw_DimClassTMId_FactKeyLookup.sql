SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_DimClassTMId_FactKeyLookup] AS (
	SELECT DimClassTMId, ETL_SourceSystem, ETL_SSID, ETL_SSID_class_id, ClassName
	FROM (
		SELECT DimClassTMId, ETL_SourceSystem, ETL_SSID, ETL_SSID_class_id, ClassName
		, ROW_NUMBER() OVER (PARTITION BY ClassName, ETL_SourceSystem ORDER BY upd_datetime desc) RowRank
		FROM dbo.DimClassTM (NOLOCK)
	) a
	WHERE RowRank = 1
) 

GO
