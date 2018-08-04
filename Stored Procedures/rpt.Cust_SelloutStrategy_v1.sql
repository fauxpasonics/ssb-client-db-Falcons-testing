SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--EXEC [rpt].[Cust_SelloutStrategy] null, null ,10

CREATE PROCEDURE [rpt].[Cust_SelloutStrategy_v1] 
(
	@StartDate DATE = '2015-07-01',
	@EndDate DATE = '2016-06-30',
	@NumGames INT = 10
)

AS

 
IF (@StartDate IS NOT NULL)
BEGIN SET @NumGames = 0
end
BEGIN

--DROP TABLE #ReportOutput
--DROP TABLE #Events
--DROP TABLE #stgSales
--DROP TABLE #stgSales2



CREATE TABLE #Events (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	EventDate DATE,
	EventTime TIME,
	EventDayOfWeek NVARCHAR(255)
)

CREATE TABLE #ReportOutput (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	EventDate DATE,
	EventTime TIME,
	EventDayOfWeek NVARCHAR(255),
	Section1 NVARCHAR(255),
	Section2 NVARCHAR(255),	
	TicketType NVARCHAR(255),	
	Qty DECIMAL(18,6),	
	Rev DECIMAL(18,6),
	Capacity DECIMAL(18,6),
	PctSold DECIMAL(18,6),
)

IF ( ISNULL(@NumGames,0) > 0 )
BEGIN

	INSERT INTO #Events ( DimEventId, EventName, EventDate, EventTime, EventDayOfWeek )
	SELECT a.DimEventId, a.EventName, a.EventDate, a.EventTime, a.EventDayOfWeek		
	FROM (
		SELECT de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
		, ROW_NUMBER() OVER(ORDER BY de.EventDate) EventDateRank		
		FROM rpt.vw_DimEvent de
		INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
		WHERE DimSeasonId = 49 AND de.DimEventId NOT IN (170)
		--AND de.EventDate >  DATEADD(HOUR, (SELECT UTCOffset FROM dbo.DimDate WHERE CalDate = CAST(GETDATE() AS DATE)), GETDATE())
	) a
	WHERE a.EventDateRank <= @NumGames

END
ELSE BEGIN

	INSERT INTO #Events ( DimEventId, EventName, EventDate, EventTime, EventDayOfWeek )
	SELECT de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
	FROM rpt.vw_DimEvent de
	INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
	WHERE DimSeasonId = 49 AND de.DimEventId NOT IN (170)
	AND EventDate BETWEEN @StartDate AND @EndDate

END



SELECT f.DimEventId, dst.Config_Location, f.IsComp, fts.DimTicketTypeId, fts.DimPlanTypeId
	, SUM(CAST(IsSold AS INT)) Qty
	, SUM(f.TotalRevenue) Rev
	, COUNT(*) Capacity
INTO #stgSales
FROM dbo.FactInventory f
INNER JOIN #Events e ON f.DimEventId = e.DimEventId
INNER JOIN dbo.DimSeat dst ON f.DimSeatId = dst.DimSeatId
LEFT OUTER JOIN dbo.FactTicketSales fts ON f.FactTicketSalesId = fts.FactTicketSalesId
WHERE f.IsSaleable = 1
GROUP by f.DimEventId, dst.Config_Location, f.IsComp, fts.DimTicketTypeId, fts.DimPlanTypeId



SELECT SaleStatus, DimEventId, Config_Location, TicketType, Qty, Rev
INTO #stgSales2
FROM (
	SELECT 'Sold' SaleStatus, f.DimEventId
	, f.Config_Location
	, CASE
		WHEN f.IsComp = 1 THEN 'Comp'
		WHEN dtt.TicketTypeCode = 'FS' THEN dtt.TicketTypeName + ' ' + dpt.PlanTypeName
		ELSE dtt.TicketTypeName
	END TicketType
		, SUM(f.Qty) Qty
		, SUM(f.Rev) Rev
	FROM #stgSales f
	INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
	INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
	GROUP BY f.DimEventId, f.Config_Location
	, CASE
		WHEN f.IsComp = 1 THEN 'Comp'
		WHEN dtt.TicketTypeCode = 'FS' THEN dtt.TicketTypeName + ' ' + dpt.PlanTypeName
		ELSE dtt.TicketTypeName
	END

	UNION all

	SELECT 'Unsold' SaleStatus, f.DimEventId, dst.Config_Location, ISNULL(c.ClassName, 'Reserved') TicketType
	, COUNT(*) Qty
	, sum(ISNULL(f.PostedSeatValue, f.ManifestSeatValue)) Rev
	FROM dbo.FactInventory f
	INNER JOIN #Events e ON f.DimEventId = e.DimEventId
	INNER JOIN dbo.DimSeat dst ON f.DimSeatId = dst.DimSeatId
	LEFT OUTER JOIN dbo.DimClassTM c ON f.PostedDimClassTMId = ISNULL(c.DimClassTMId, f.ManifestDimClassTMId)
	WHERE f.IsSold = 0 AND f.IsSaleable = 1
	GROUP BY f.DimEventId, dst.Config_Location, ISNULL(c.ClassName, 'Reserved')
) a


INSERT INTO #ReportOutput (DimEventId, EventName, EventDate, EventTime, EventDayOfWeek, Section1, Section2, TicketType, Qty, Rev, Capacity, PctSold)

SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek
, f.Config_Location Section1
, CASE WHEN f.TicketType = 'Comp' THEN (f.Config_Location + '_Comp') 
       WHEN f.TicketType = 'Reserved' Then (f.Config_Location + '_Reserved') 
	ELSE (f.Config_Location + '_' + f.SaleStatus) 
	END Section2
, f.TicketType, f.Qty, f.Rev, l.Capacity
, CASE WHEN f.SaleStatus = 'Sold' THEN (CAST(f.Qty AS DECIMAL(18,6)) / CAST(l.Capacity AS DECIMAL(18,6))) ELSE 0 END PctSold
FROM #stgSales2 f
INNER JOIN #Events e ON f.DimEventId = e.DimEventId
INNER JOIN (
	SELECT DimEventId, Config_Location, SUM(Capacity) Capacity
	FROM #stgSales
	GROUP BY DimEventId, Config_Location
) l ON f.DimEventId = l.DimEventId AND f.Config_Location = l.Config_Location



INSERT INTO #ReportOutput (DimEventId, EventName, EventDate, EventTime, EventDayOfWeek, Section1, Section2, TicketType, Qty, Rev, Capacity, PctSold)

SELECT e.DimEventId, e.EventName, e.EventDate, e.EventTime, e.EventDayOfWeek, 'Total' Section1, 'Total' Section2, 'Total' TicketType
, (s.Qty_Sold / CASE WHEN s.Qty_Capacity = 0 THEN NULL ELSE s.Qty_Capacity END) Qty
, (s.Rev_Sold / CASE WHEN s.Rev_Capacity = 0 THEN NULL ELSE s.Rev_Capacity END) Rev
, NULL Capacity
, NULL PctSold
FROM (
	SELECT DimEventId
	, CAST(SUM(CASE WHEN SaleStatus = 'Sold' THEN Qty ELSE 0 END) AS DECIMAL(18,6)) Qty_Sold 
	, CAST(SUM(Qty) AS DECIMAL(18,6)) Qty_Capacity
	, SUM(CASE WHEN SaleStatus = 'Sold' THEN Rev ELSE 0 END) Rev_Sold
	, SUM(Rev) Rev_Capacity
	FROM #stgSales2 s
	GROUP BY s.DimEventId
) s
INNER JOIN #Events e ON s.DimEventId = e.DimEventId


SELECT a.SortOrder, a.TicketType
INTO #TicketTypeSort
FROM (
	SELECT 1 SortOrder,  'Full Season Renewal' TicketType
		UNION ALL
	SELECT 2 SortOrder,  'Full Season New' TicketType
		UNION ALL
	SELECT DimTicketTypeId + 100 , TicketTypeName
	FROM dbo.DimTicketType
	WHERE TicketTypeCode <> 'FS'
) a


SELECT
    ro.DimEventId, ro.EventName, ro.EventDate, ro.EventTime, ro.EventDayOfWeek, ro.Section1, ro.Section2, ro.TicketType, ro.Qty, ro.Rev, ro.Capacity, ro.PctSold, tts.SortOrder SortOrder_TicketType
FROM
    #ReportOutput ro
    LEFT OUTER JOIN #TicketTypeSort tts ON ro.TicketType = tts.TicketType
ORDER BY
    ro.EventDate, ro.Section1, ro.Section2, ro.Qty desc, tts.SortOrder ;


END









GO
