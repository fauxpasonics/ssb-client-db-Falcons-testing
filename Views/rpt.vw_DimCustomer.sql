SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [rpt].[vw_DimCustomer] as (select * from dbo.DimCustomer (nolock) where IsDeleted = 0)
GO
