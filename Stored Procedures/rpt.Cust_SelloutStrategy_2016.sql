SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--Trying to sort by total column (unsold tickets). 

--EXEC [rpt].[Cust_SelloutStrategy] null, null ,10

create PROCEDURE [rpt].[Cust_SelloutStrategy_2016] 

(
--DECLARE
	@StartDate DATE = '2016-07-01',
	@EndDate DATE = '2017-06-30',
	@NumGames INT = 10,
	@DataType varchar(10) = 'Qty'
) AS

DECLARE @Season INT = 72--'72' ---2016 Season
 
IF (@StartDate IS NOT NULL)
BEGIN SET @NumGames = 0
end
BEGIN

--DROP TABLE #ReportOutput
--Drop Table #ReportOutput2
--DROP TABLE #Events
--DROP TABLE #stgSales
--DROP TABLE #stgSales2
--DROP Table #tickettypesort



CREATE TABLE #Events (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	EventDate NVARCHAR(30),
	EventTime NVARCHAR(30),
	EventDayOfWeek NVARCHAR(255)
)

CREATE TABLE #ReportOutput (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	EventDate NVARCHAR(30),
	EventTime NVARCHAR(30),
	EventDayOfWeek NVARCHAR(255),
	Section1 NVARCHAR(255),
	Section2 NVARCHAR(255),	
	TicketType NVARCHAR(255),	
	Qty DECIMAL(18,6),	
	Rev DECIMAL(18,6),
	Capacity DECIMAL(18,6),
	PctSold DECIMAL(18,6),
)


CREATE TABLE #ReportOutput2 (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	EventDate NVARCHAR(30),
	EventTime NVARCHAR(30),
	EventDayOfWeek NVARCHAR(255),
	Section1 NVARCHAR(255),
	Section2 NVARCHAR(255),	
	TicketType NVARCHAR(255),	
	Qty DECIMAL(18,6),	
	Rev DECIMAL(18,6),
	Capacity DECIMAL(18,6),
	PctSold DECIMAL(18,6),
	Sort DECIMAL(18,6)
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
		WHERE DimSeasonId = @Season
		--AND de.DimEventId NOT IN (170)
		--AND de.EventDate >  DATEADD(HOUR, (SELECT UTCOffset FROM dbo.DimDate WHERE CalDate = CAST(GETDATE() AS DATE)), GETDATE())
	) a
	WHERE a.EventDateRank <= @NumGames

END
ELSE BEGIN

	INSERT INTO #Events ( DimEventId, EventName, EventDate, EventTime, EventDayOfWeek )
	SELECT de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
	FROM rpt.vw_DimEvent de 
	INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
	WHERE DimSeasonId = @Season
	--AND de.DimEventId NOT IN (170)
	AND EventDate BETWEEN @StartDate AND @EndDate
--SELECT * FROM #events
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
--SELECT * FROM #stgSales2


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

--Below are the Totals Addition/////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

INSERT INTO #ReportOutput (DimEventId, EventName, EventDate, EventTime, EventDayOfWeek, Section1, Section2, TicketType, Qty, Rev, Capacity, PctSold)

Select '999999' as DimEventId, 'Season Total' as EventName, ' ' as EventDate, ' ' as EventTime, ' ' as EventDayOfWeek, Section1, Section2, TicketType, sum(Qty), sum(Rev), sum(Capacity), avg(PctSold)
From 
(
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
) a
Group by a.Section1, a.Section2 , a.TicketType

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

--Below is the Totals Addition
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
INSERT INTO #ReportOutput (DimEventId, EventName, EventDate, EventTime, EventDayOfWeek, Section1, Section2, TicketType, Qty, Rev, Capacity, PctSold)

SELECT  '999999' as DimEventId, 'Season Total' as EventName, ' ' as EventDate, ' ' as EventTime, ' ' as EventDayOfWeek, 'Total' Section1, 'Total' Section2, 'Total' TicketType
, (s.Qty_Sold / CASE WHEN s.Qty_Capacity = 0 THEN NULL ELSE s.Qty_Capacity END) Qty
, (s.Rev_Sold / CASE WHEN s.Rev_Capacity = 0 THEN NULL ELSE s.Rev_Capacity END) Rev
, NULL Capacity
, NULL PctSold
FROM (
	SELECT 
	 CAST(SUM(CASE WHEN SaleStatus = 'Sold' THEN Qty ELSE 0 END) AS DECIMAL(18,6)) Qty_Sold 
	, CAST(SUM(Qty) AS DECIMAL(18,6)) Qty_Capacity
	, SUM(CASE WHEN SaleStatus = 'Sold' THEN Rev ELSE 0 END) Rev_Sold
	, SUM(Rev) Rev_Capacity
	FROM #stgSales2 s
) s
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

Update #ReportOutput 
Set pctSold = '0'
Where  section2 like '%Unsold'


INSERT INTO #ReportOutput2 
(DimEventId, EventName, EventDate, EventTime, EventDayOfWeek, Section1, Section2, TicketType, Qty, Rev, Capacity, PctSold, Sort)
SELECT 
    ro.DimEventId, ro.EventName, ro.EventDate, ro.EventTime, ro.EventDayOfWeek, ro.Section1, ro.Section2, ro.TicketType, ro.Qty, ro.Rev, ro.Capacity, ro.PctSold, tts.SortOrder SortOrder_TicketType

FROM
    #ReportOutput ro
    LEFT OUTER JOIN #TicketTypeSort tts ON ro.TicketType = tts.TicketType
ORDER BY
    ro.EventDate, ro.Section1, ro.Section2, ro.Qty desc, tts.SortOrder
/*	
Update #ReportOutput2
Set Sort = SeasonQty
FROM #ReportOutput2 r JOIN 
(SELECT Qty AS SeasonQty, section2, tickettype FROM #ReportOutput2 r 
where section2 like '%unsold' and eventname = 'Season Total'
) a ON r.section2 = a.section2 AND r.tickettype = a.tickettype
*/

SELECT 
    a.SeasonDimEventId DimEventId, a.SeasonEventName EventName, a.SeasonEventDate EventDate, a.SeasonEventTime EventTime, 
	a.SeasonEventDayOfWeek EventDayOfWeek, a.SeasonSection1 Section1, 
	a.SeasonSection2 Section2, a.SeasonTicketType TicketType, ISNULL(ro.Qty,0) Qty, ISNULL(ro.Rev,0) Rev, ro.Capacity, ro.PctSold, 
	CASE 
		WHEN @DataType = 'Qty' THEN SeasonQty 
		ELSE SeasonRev
	END AS SortOrder_TicketType

FROM
(
	SELECT DISTINCT
		section1 SeasonSection1, Section2 SeasonSection2, TicketType SeasonTicketType, Qty SeasonQty, Rev SeasonRev,
		ev.DimEventId SeasonDimEventId, ev.EventName SeasonEventName, ev.EventDate SeasonEventDate,
		ev.EventTime SeasonEventTime, ev.EventDayOfWeek SeasonEventDayOfWeek
	FROM #ReportOutput2 ro2
	CROSS JOIN
    (
		SELECT DimEventId, EventName, EventDate, EventTime, EventDayOfWeek
		FROM #ReportOutput
		--WHERE eventname <> 'Season Total'	
	)ev
	WHERE ro2.EventName = 'Season Total'
	--AND ro2.Section2 = '100 Level_Unsold'
)a
LEFT join #ReportOutput2 ro
	ON a.SeasonSection1 = ro.Section1
	AND a.SeasonSection2 = ro.Section2
	AND a.SeasonTicketType = ro.TicketType
	AND a.SeasonDimEventId = ro.DimEventId
ORDER BY
    dimeventid,EventDate, 
	CASE WHEN @DataType = 'Qty' THEN SeasonQty 
	ELSE SeasonRev
	End DESC
	 --Section1, Section2, , Sort; 


END













GO
