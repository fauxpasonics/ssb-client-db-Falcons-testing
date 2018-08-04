SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<JT Louviere>
-- Create date: <6/15/2016>
-- Description:	<Update adhoc.Waterfalldata table for the Atlanta Falcons Linechart Graph- Updatd to remove "unclassified" inventory from total available inventory>
-- =============================================
--TESTING Exec [adhoc].[waterfalldata_update_2017]
-- select * from adhoc.waterfalldata2017
CREATE PROCEDURE [adhoc].[waterfalldata_update_2017]


AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--//////////////Set Initial Parameters//////////////////////
	DECLARE @SeasonYear NVARCHAR (5)
	Set @SeasonYear = '2016'  --change year

	DECLARE @Tablename varchar (50) --increased table name to avoid truncation
	Set @Tablename = 'adhoc.WaterfallData2017'  --change table name

--//////////////Develop Loop Logic//////////////////////
	--Drop Table #LoopCounter

	CREATE TABLE #LoopCounter (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	ListCount DECIMAL (5,0)
    )

	Insert into #LoopCounter
	SELECT distinct (fts.DimEventId), de.eventname,  Row_number() Over (Order By fts.dimeventid) As ListCount
	FROM dbo.FactInventory fts
	INNER JOIN dbo.dimevent de ON fts.DimEventId = de.DimEventId

	---------------------------------------------------------------------------New add, needed to remove preseason games. 
	INNER JOIN 
			( SELECT 
					 dimeventid
					, rank() over (order by dimeventid) as nopre 
			  FROM dbo.dimevent where dimseasonid = '72'
			) prerank on prerank.dimeventid = de.dimeventid
     --------------------------------Event header was not created yet. Usually we use eventheaderL3 in that table to indicate preseason games. 
	 --------------------------------Once done so, I would flip this code to filter on that. 

	WHERE fts.IsSold = 0 AND fts.IsSaleable = 1 AND de.dimseasonid = '72' --changed dimseasonid  from 49 to 72 for the current season 2016 Falcons Season
	AND prerank.nopre >2
	AND de.eventdate >= (select dateadd(hour, UTCOffset, GETDATE()) from dbo.DimDate where CalDate = cast(getdate() as date)) 
	Group by fts.dimeventid , de.eventname

	DECLARE @Counter int
	SET @Counter = '1'

	While @Counter <= '11' --change counter to be larger than that of the highest row ranking (above)
	BEGIN



--//////////////Set Team and Team with Quotes////////////////
	DECLARE @Team NVARCHAR (50)  --first step is store the current eventname in the team paramenter
	SET @TEAM = (select eventname from #LoopCounter where ListCount = @Counter)
	--select @TEAM

	DECLARE @Team17 NVARCHAR (50) --next step is truncate the eventname to just the opponent. The falcons changed their naming syntax for the 2017 season
	SET @TEAM17 = (select RIGHT( eventname,charindex(' ', REVERSE(eventname))-1) from #LoopCounter where ListCount = @Counter)
	--select @TEAM17

	DECLARE @TEAMC NVARCHAR (50) --finally, we need to have single quotes around the opponent name for the update query to work
	SET @TEAMC = Char(39) + @TEAM17+ Char(39)
	--select @TEAMC

--/////////////Set Daysout by Opponent Event Date and Place Quotes////////////
	DECLARE @DaysOut VARCHAR(5)
	SET @DaysOut = (
	SELECT CAST(de.EventDateTime AS DECIMAL(12, 0))
        - CONVERT(DECIMAL(12, 0), GETDATE()) AS DaysOut
	FROM    dbo.DimEvent de
	WHERE   DimSeasonId = '72' AND de.EventCode <> 'SCOREBIG' AND de.EventName = @TEAM --changed dimseasonid  from 49 to 72 for the current season 2016 Falcons Season
	)

	DECLARE @DaysOutC NVARCHAR (10)
	SET @DaysOutC = '[' + @DaysOut + ']'
	--Select @DaysOutC

--///////////Develop Dynamic Query for calulating current available inventory//////////

	DECLARE @AvailIn NVARCHAR (20)
	SET @AvailIn = (SELECT 
	--fts.DimEventId,
		COUNT(*) Qty
	FROM dbo.FactInventory fts
		INNER JOIN dbo.dimevent de ON fts.DimEventId = de.DimEventId
		LEFT OUTER JOIN dbo.DimClassTM c ON fts.PostedDimClassTMId = ISNULL(c.DimClassTMId, fts.ManifestDimClassTMId)
	WHERE fts.IsSold = 0 AND fts.IsSaleable = 1 AND De.Eventname =  @Team AND c.classname is not null	
	--GROUP BY fts.DimEventId
	)

--////////////////////////////Run Update/////////////////////////////////////////////

	DECLARE @SQLRUN VARCHAR (Max)
	Set @SQLRun = 'Update ' + @Tablename + ' SET ' + @DaysOutC + ' = ' + @AvailIn + ' WHERE Opponent = ' + @TEAMC + ' AND [Season Year] = ' + @SeasonYear
	--Select @SQLRun

	EXEC (@sqlRun)

	SET @Counter += 1
	END


--Select * from adhoc.waterfalldata
--select @TEAM
--Select @TEamc
--select @daysout
--Select @DaysOutC
--Select @Tablename
--Select @AvailIn
--select @SQLRun
END


GO
