SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_ProdCopy_ContactExtensionBase] AS (

SELECT * FROM ProdCopy.ContactExtensionBase (NOLOCK)

)

GO
