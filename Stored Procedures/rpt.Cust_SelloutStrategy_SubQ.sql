SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





--EXEC [rpt].[Cust_SelloutStrategy] null, null ,10

CREATE PROCEDURE [rpt].[Cust_SelloutStrategy_SubQ] 
(
	--DECLARE
	
	@StartDate DATE = '2015-07-01',
	@EndDate DATE = '2016-06-30'
	
)

AS
--DROP TABLE #ReportOutput
--DROP TABLE #Events
--DROP TABLE #stgSales
--DROP TABLE #stgSales2

	SELECT de.DimEventId, de.EventName, de.EventDate, de.EventTime, dd.[DayOfWeek] EventDayOfWeek
	FROM rpt.vw_DimEvent de
	INNER JOIN rpt.vw_DimDate dd ON de.EventDate = dd.CalDate
	WHERE DimSeasonId = 49 AND de.DimEventId NOT IN (170)
	AND EventDate BETWEEN @StartDate AND @EndDate


GO
