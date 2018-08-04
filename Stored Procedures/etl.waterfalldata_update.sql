SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<JT Louviere>
-- Create date: <10/21/2015>
-- Description:	<Update adhoc.Waterfalldata table for the Atlanta Falcons Linechart Graph- Updatd to remove "unclassified" inventory from total available inventory>
-- =============================================
CREATE PROCEDURE [etl].[waterfalldata_update]
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--//////////////Set Initial Parameters//////////////////////
	DECLARE @SeasonYear NVARCHAR (5)
	Set @SeasonYear = '2015'

	DECLARE @Tablename varchar (30)
	Set @Tablename = 'adhoc.waterfalldata'

--//////////////Develop Loop Logic//////////////////////
	--Drop Table #LoopCounter

	CREATE TABLE #LoopCounter (
	DimEventId NVARCHAR(255),
	EventName NVARCHAR(255),
	ListCount DECIMAL (5,0)
    )

	Insert into #LoopCounter
	SELECT distinct (fts.DimEventId), de.eventname , Row_number() Over (Order By fts.dimeventid) As ListCount
	FROM dbo.FactInventory fts
	INNER JOIN dbo.dimevent de ON fts.DimEventId = de.DimEventId
	WHERE fts.IsSold = 0 AND fts.IsSaleable = 1 AND de.dimseasonid = '49' 
	AND de.eventdate >= (select dateadd(hour, UTCOffset, GETDATE()) from dbo.DimDate where CalDate = cast(getdate() as date)) 
	Group by fts.dimeventid , de.eventname

	DECLARE @Counter int
	SET @Counter = '1'

	While @Counter <= '5'
	BEGIN

--//////////////Set Team and Team with Quotes////////////////
	DECLARE @Team NVARCHAR (15)
	SET @TEAM = (select eventname from #LoopCounter where ListCount = @Counter)

	DECLARE @TEAMC NVARCHAR (15)
	SET @TEAMC = Char(39) + @Team+ Char(39)

--/////////////Set Daysout by Opponent Event Date and Place Quotes////////////
	DECLARE @DaysOut VARCHAR(5)
	SET @DaysOut = (
	SELECT CAST(de.EventDateTime AS DECIMAL(12, 0))
        - CONVERT(DECIMAL(12, 0), GETDATE()) AS DaysOut
	FROM    dbo.DimEvent de
	WHERE   DimSeasonId = 49 AND de.EventCode <> 'SCOREBIG' AND de.EventName = @TEAM
	)

	DECLARE @DaysOutC NVARCHAR (10)
	SET @DaysOutC = '[' + @DaysOut + ']'

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
