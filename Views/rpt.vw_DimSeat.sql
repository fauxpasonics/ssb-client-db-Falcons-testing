SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [rpt].[vw_DimSeat] as (select * from dbo.DimSeat (nolock) where IsDeleted = 0) 

GO
