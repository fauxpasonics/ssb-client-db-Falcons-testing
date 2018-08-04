SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [mdm].[vw_TM_STH]
AS
(
SELECT dc.dimcustomerid 
			,CASE WHEN dc.CustomerType = 'Primary' THEN 1 ELSE 0 END AS PrimaryCustomer
			,sth
			,sthmd.MaxSTHPurchaseDate
			,mud.MaxUpdatedDate 
			,dc.accountid
			,sgl.Single
			,sglmd.MaxSGLPurchaseDate
			,fsth
			,usth
			,Fsgl.FSingle
			,Usgl.USingle
FROM dbo.DimCustomer dc (NOLOCK)
LEFT JOIN (
			SELECT DISTINCT d.dimcustomerid, 1 AS 'STH' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			WHERE a.DimPlanTypeId IN (1,2,6)
		   ) sth ON dc.dimcustomerid = sth.dimcustomerid
LEFT JOIN (
			SELECT d.dimcustomerid, MAX(dd.CalDate) AS 'MaxSTHPurchaseDate' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			WHERE a.DimPlanTypeId IN (1,2,6)
			GROUP BY d.DimCustomerId
		   ) sthmd ON dc.dimcustomerid = sthmd.dimcustomerid
LEFT JOIN (
			SELECT d.dimcustomerid, MAX(dd.CalDate) AS 'MaxSGLPurchaseDate' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON  a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			WHERE a.DimPlanTypeId IN (7)
			GROUP BY d.DimCustomerId
		   ) sglmd ON dc.dimcustomerid = sglmd.dimcustomerid
LEFT JOIN (
			SELECT DISTINCT d.dimcustomerid, 1 AS 'Single' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON  a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			WHERE a.DimPlanTypeId IN (7)) sgl ON dc.dimcustomerid = sgl.dimcustomerid
LEFT JOIN (
			SELECT dimcustomerid, MAX(a.UpdatedDate) AS 'MaxUpdatedDate' 
			FROM dbo.DimCustomer a (NOLOCK)
			GROUP BY a.DimCustomerId
		   ) mud ON dc.dimcustomerid = mud.dimcustomerid
LEFT JOIN (
			SELECT DISTINCT d.dimcustomerid, 1 AS 'FSTH' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			JOIN dbo.DimSeason ds (NOLOCK) ON ds.DimSeasonId = a.DimSeasonId
			WHERE a.DimPlanTypeId IN (1,2,6)
			AND ds.SeasonName LIKE '%Falcons%'
			) fsth ON fsth.DimCustomerId = dc.DimCustomerId
LEFT JOIN (
			SELECT DISTINCT d.dimcustomerid, 1 AS 'USTH' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			JOIN dbo.DimSeason ds (NOLOCK) ON ds.DimSeasonId = a.DimSeasonId
			WHERE a.DimPlanTypeId IN (1,2,6)
			AND ds.SeasonName LIKE '%United%'
			) usth ON usth.DimCustomerId = dc.DimCustomerId
LEFT JOIN (
		    SELECT DISTINCT d.dimcustomerid, 1 AS 'FSingle' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON  a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			JOIN dbo.DimSeason ds (NOLOCK) ON ds.DimSeasonId = a.DimSeasonId
			WHERE a.DimPlanTypeId IN (7)
			AND ds.SeasonName LIKE '%Falcons%'
			) Fsgl ON dc.dimcustomerid = fsgl.dimcustomerid
LEFT JOIN (
		    SELECT DISTINCT d.dimcustomerid, 1 AS 'USingle' FROM dbo.FactTicketSales a (NOLOCK)
			JOIN dbo.DimCustomer d (NOLOCK) ON  a.DimCustomerId = d.DimCustomerId AND d.SourceSystem = 'TM'
			LEFT JOIN dbo.dimdate dd (NOLOCK) ON a.DimDateId = dd.DimDateId
			JOIN dbo.DimSeason ds (NOLOCK) ON ds.DimSeasonId = a.DimSeasonId
			WHERE a.DimPlanTypeId IN (7)
			AND ds.SeasonName LIKE '%United%'
			) Usgl ON dc.dimcustomerid = usgl.dimcustomerid

)

GO
