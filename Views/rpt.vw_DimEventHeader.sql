SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [rpt].[vw_DimEventHeader] as (select * from dbo.DimEventHeader (nolock) where IsDeleted = 0) 

GO
