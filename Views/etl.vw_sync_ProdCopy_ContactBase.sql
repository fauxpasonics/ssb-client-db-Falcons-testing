SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_sync_ProdCopy_ContactBase] AS (

SELECT * FROM ProdCopy.ContactBase (NOLOCK)

)

GO
