SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_ProdCopy_AccountExtensionBase] AS (

SELECT * FROM ProdCopy.AccountExtensionBase (NOLOCK)

)

GO
