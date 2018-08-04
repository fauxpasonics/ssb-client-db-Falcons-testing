SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













--EXEC [api].[CRM_Attendance] @SSB_CRMSYSTEM_ACCT_ID = 'BA6CE8C5-56A7-4306-AB8E-0087FDF7C14F'
--EXEC [api].[CRM_Attendance] @SSB_CRMSYSTEM_CONTACT_ID = 'F7FC148D-3EC3-49EF-8BA8-96AA05F0760F'

CREATE PROCEDURE [api].[CRM_Attendance]
    @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test' ,
    @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test' ,
    @DisplayTable INT = 0 ,
    @RowsPerPage INT = 500 ,
    @PageNumber INT = 0
AS
    BEGIN


-- =========================
-- Init vars needed for API
-- =========================

        DECLARE @totalCount INT ,
            @xmlDataNode XML ,
            @recordsInResponse INT ,
            @remainingCount INT ,
            @rootNodeName NVARCHAR(100) ,
            @responseInfoNode NVARCHAR(MAX) ,
            @finalXml XML;

        PRINT 'Acct-' + @SSB_CRMSYSTEM_ACCT_ID;
        PRINT 'Contact-' + @SSB_CRMSYSTEM_CONTACT_ID;

-- ==========================
-- GUIDS
-- ==========================

        DECLARE @GUIDTable TABLE ( GUID VARCHAR(50) );

        IF ( @SSB_CRMSYSTEM_ACCT_ID NOT IN ( 'None', 'Test' ) )
            BEGIN
                INSERT  INTO @GUIDTable
                        ( GUID
                        )
                        SELECT DISTINCT
                                z.SSB_CRMSYSTEM_CONTACT_ID
                        FROM    Falcons.dbo.vwDimCustomer_ModAcctId z
                        WHERE   z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID;
            END;

        IF ( @SSB_CRMSYSTEM_CONTACT_ID NOT IN ( 'None', 'Test' ) )
            BEGIN
                INSERT  INTO @GUIDTable
                        ( GUID
                        )
                        SELECT  @SSB_CRMSYSTEM_CONTACT_ID;
            END;

-- ============================
-- Base Table Set
-- ============================

        DECLARE @baseData TABLE
            (
              Season_Name NVARCHAR(255) ,
              Event_Code NVARCHAR(255) ,
              Event_Name NVARCHAR(255) ,
              Event_Date DATE ,
              Event_Time TIME ,
              Section_Name NVARCHAR(50) ,
              Row_Name NVARCHAR(50) ,
              Seat NVARCHAR(50) ,
              Scan_Time TIME ,
              Game_Scan_Time_Difference NVARCHAR(255) ,
              Scan_Gate NVARCHAR(255) ,
              Is_Attended BIT
            );

-- ==============================
-- Procedure
-- ==============================

        SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
                Season_Name ,
                Event_Code ,
                Event_Name ,
                Event_Date ,
                Event_Time ,
                Section_Name ,
                Row_Name ,
                Seat ,
                Scan_Time ,
                Game_Scan_Time_Difference ,
                Scan_Gate ,
                IsAttended
        INTO    #tmpbase
        FROM    ( SELECT    COALESCE(fi.ResoldDimCustomerId,
                                     fi.SoldDimCustomerId) AS AttendedDimcustomerID ,
                            DimSeason.SeasonName AS Season_Name ,
                            DimEvent.EventCode AS Event_Code ,
                            DimEvent.EventName AS Event_Name ,
                            DimEvent.EventDate AS Event_Date ,
                            DimEvent.EventTime Event_Time ,
                            DimSeat.SectionName AS Section_Name ,
                            DimSeat.RowName AS Row_Name ,
                            DimSeat.Seat AS Seat ,
                            CAST(fi.ScanDateTime AS TIME) Scan_Time ,
                            DATEDIFF(MINUTE, DimEvent.EventTime,
                                     CAST(fi.ScanDateTime AS TIME)) Game_Scan_Time_Difference ,
                            fi.ScanGate AS Scan_Gate ,
                            fi.IsAttended --hide from api view on front end		
                  FROM      dbo.FactInventory fi (NOLOCK)
                            INNER JOIN dbo.DimEvent DimEvent WITH ( NOLOCK ) ON DimEvent.DimEventId = fi.DimEventId
                            INNER JOIN dbo.DimSeason DimSeason WITH ( NOLOCK ) ON DimSeason.DimSeasonId = DimEvent.DimSeasonId
                            INNER JOIN dbo.DimSeat DimSeat WITH ( NOLOCK ) ON DimSeat.DimSeatId = fi.DimSeatId
                            INNER JOIN dbo.DimEventHeader DimEventHeader
                            WITH ( NOLOCK ) ON DimEventHeader.DimEventHeaderId = DimEvent.DimEventHeaderId
                            INNER JOIN dbo.DimSeasonHeader DimSeasonHeader
                            WITH ( NOLOCK ) ON DimSeasonHeader.DimSeasonHeaderId = DimEventHeader.DimSeasonHeaderId
                  WHERE     DimEvent.EventDate <= CAST(GETDATE() + 1 AS DATE)
				  AND DATEDIFF(YEAR,DimEvent.EventDate,GETDATE())<=2
                ) x
                INNER JOIN dbo.DimCustomer DimCustomer WITH ( NOLOCK ) ON DimCustomer.DimCustomerId = x.AttendedDimcustomerID
                                                              AND DimCustomer.CustomerType = 'Primary'
                                                              AND DimCustomer.SourceSystem = 'TM'
                INNER JOIN dbo.dimcustomerssbid ssbid WITH ( NOLOCK ) ON ssbid.DimCustomerId = DimCustomer.DimCustomerId
        WHERE   ssbid.SSB_CRMSYSTEM_CONTACT_ID IN (
                SELECT GUID FROM @GUIDTable );


-- =========================================
-- API Pagination
-- =========================================
-- Cap returned results at 1000

        IF @RowsPerPage > 1000
            BEGIN

                SET @RowsPerPage = 1000;

            END;

-- Pull total count

        SELECT  @totalCount = COUNT(*)
        FROM    #tmpbase AS c;
-- =========================================
-- API Loading
-- =========================================

-- Load base data

        INSERT  INTO @baseData
                ( Season_Name ,
                  Event_Code ,
                  Event_Name ,
                  Event_Date ,
                  Event_Time ,
                  Section_Name ,
                  Row_Name ,
                  Seat ,
                  Scan_Time ,
                  Game_Scan_Time_Difference ,
                  Scan_Gate ,
                  Is_Attended
                )
                SELECT  ISNULL(Season_Name, '') Season_Name ,
                        ISNULL(Event_Code, '') Event_Code ,
                        ISNULL(Event_Name, '') Event_Name ,
                        ISNULL(Event_Date, '') Event_Date ,
                        ISNULL(Event_Time, '') Event_Time ,
                        ISNULL(Section_Name, '') Section_Name ,
                        ISNULL(Row_Name, '') Row_Name ,
                        ISNULL(Seat, '') Seat ,
                        ISNULL(Scan_Time, '') Scan_Time ,
        --( CASE WHEN IsAttended = 1 THEN Game_Scan_Time_Difference
        --       ELSE NULL
        --  END ) True_GameScanDiff ,
                        ISNULL(CAST(LTRIM(RTRIM(STR(ABS(CASE WHEN IsAttended = 1
                                                             THEN Game_Scan_Time_Difference
                                                             ELSE NULL
                                                        END)))) + ' minute'
                               + CASE WHEN Game_Scan_Time_Difference = 0
                                      THEN ''
                                      ELSE 's'
                                 END
                               + CASE WHEN Game_Scan_Time_Difference < 0
                                      THEN ' early'
                                      ELSE ' late'
                                 END AS VARCHAR(50)), '') Game_Scan_Time_Difference ,
                        ISNULL(Scan_Gate, '') Scan_Gate ,
                        ISNULL(IsAttended, '') Is_Attended
                FROM    #tmpbase
                ORDER BY Event_Date DESC ,
                        Row_Name ASC ,
                        Seat ASC
                        OFFSET ( @PageNumber ) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY;

-- DROP TABLE #tmpParent

-- Pull counts
        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;


        SET @xmlDataNode = ( SELECT p.Season_Name ,
                                    p.Event_Code ,
                                    p.Event_Name ,
                                    p.Event_Date ,
                                    p.Event_Time ,
                                    p.Section_Name ,
                                    p.Row_Name ,
                                    p.Seat ,
                                    p.Scan_Time ,
                                    p.Game_Scan_Time_Difference ,
                                    p.Scan_Gate ,
                                    p.Is_Attended
                             FROM   @baseData p
                             ORDER BY p.Event_Date DESC, p.Season_Name DESC
                           FOR
                             XML PATH('Parent') ,
                                 ROOT('Parents')
                           );

        SET @rootNodeName = 'Parents';

-- Calculate remaining count
        SET @remainingCount = @totalCount - ( @RowsPerPage * ( @PageNumber + 1 ) );
        IF @remainingCount < 0
            BEGIN
                SET @remainingCount = 0;
            END;

-- Create response info node
        SET @responseInfoNode = ( '<ResponseInfo>' + '<TotalCount>'
                                  + CAST(@totalCount AS NVARCHAR(20))
                                  + '</TotalCount>' + '<RemainingCount>'
                                  + CAST(@remainingCount AS NVARCHAR(20))
                                  + '</RemainingCount>'
                                  + '<RecordsInResponse>'
                                  + CAST(@recordsInResponse AS NVARCHAR(20))
                                  + '</RecordsInResponse>'
                                  + '<PagedResponse>true</PagedResponse>'
                                  + '<RowsPerPage>'
                                  + CAST(@RowsPerPage AS NVARCHAR(20))
                                  + '</RowsPerPage>' + '<PageNumber>'
                                  + CAST(@PageNumber AS NVARCHAR(20))
                                  + '</PageNumber>' + '<RootNodeName>'
                                  + @rootNodeName + '</RootNodeName>'
                                  + '</ResponseInfo>' );

        PRINT @responseInfoNode;
	
-- Wrap response info and data, then return	
        IF @xmlDataNode IS NULL
            BEGIN
                SET @xmlDataNode = '<' + @rootNodeName + ' />'; 
            END;
		
        SET @finalXml = '<Root>' + @responseInfoNode
            + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>';

        IF @DisplayTable = 1
            SELECT  *
            FROM    #tmpbase;

        --IF @DisplayTable = 0
            SELECT  CAST(@finalXml AS XML);

        DROP TABLE #tmpbase;

        
    END;





















GO
