SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [etl].[vw_sync_ods_TM_SellLocation] AS (

	SELECT * FROM ods.TM_SellLocation (NOLOCK)

)







GO
