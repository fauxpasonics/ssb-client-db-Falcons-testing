SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/************************************
	Updated By: Caeleon Work
	Updated On: 2018-07-11
	Update Notes: Adjusted sort order to sort the length correctly as we were getting a bad sort.
	Reviewed By: Keegan Schmitt
	Reviewed Date: 2018-07-13
	Review Notes:coolio

**************************************/

/************************************
	Updated By: Caeleon Work
	Updated On: 2018-06-13
	Update Notes: Changed sort order for data being loaded to @basedata table (changed from date to mailing id since date was being converted to varchar for readability but sorting incorrectly)
	Reviewed By: 
	Reviewed Date: 
	Review Notes:

**************************************/

/************************************
	Updated By: Caeleon Work
	Updated On: 5/8/18
	Update Notes: Removed URL, Added Subject, Cleaned up datetimes
	Reviewed By: Jeff Barberio
	Reviewed Date: 5/15/18
	Review Notes:this looks good for the most part, but the NULL handling seems a bit off for some of the columns. 
	at least the Min_Open_Time/Min_Click_Time are showing "0" where I would assume you want ''. not sure if you want counts to be blank vs 0, but included those here as well just in case.

**************************************/


--exec api.getemailbycontactguid_Dev @ssb_crmsystem_contact_id = '0000298A-8DE4-4B61-BAB7-3100EAD1AF4A'

CREATE   PROCEDURE [api].[GetEmailByContactGUID]
    (
      @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test'
	, @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test'
    , @RowsPerPage INT = 500
    , --APIification
      @PageNumber INT = 0 --APIification
    )
AS
    BEGIN

-- =========================================
-- Initial Variables for API
-- =========================================

        DECLARE @totalCount INT
          , @xmlDataNode XML
          , @recordsInResponse INT
          , @remainingCount INT
          , @rootNodeName NVARCHAR(100)
          , @responseInfoNode NVARCHAR(MAX)
          , @finalXml XML;

-- =========================================
-- GUID Table for GUIDS
-- =========================================
DECLARE @GUIDTable TABLE ( GUID VARCHAR(50) );

IF ( @SSB_CRMSYSTEM_ACCT_ID NOT IN ( 'None', 'Test' ) )
    BEGIN
        INSERT  INTO @GUIDTable
                ( GUID
                )
                SELECT DISTINCT
                        z.SSB_CRMSYSTEM_CONTACT_ID
                FROM    dbo.vwDimCustomer_ModAcctId z
                WHERE   z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID;
    END;

IF ( @SSB_CRMSYSTEM_CONTACT_ID NOT IN ( 'None', 'Test' ) )
    BEGIN
        INSERT  INTO @GUIDTable
                ( GUID
                )
                SELECT  @SSB_CRMSYSTEM_CONTACT_ID;
    END;

-- =========================================
-- Base Table Set
-- =========================================


        DECLARE @baseData TABLE
            (
				[MemberID] [NVARCHAR](100),
				[EmailAddress] [NVARCHAR](255),
				[MailingID] [NVARCHAR](100),
				[MailingName] [NVARCHAR](255),
				[Subject] [NVARCHAR](500),
				[DeliveryResult] [NVARCHAR](100),
				[DeliveryCount] [INT],
				[MinDeliveryTime] VARCHAR(100),
				[OpenCount] [INT],
				[MinOpenTime] VARCHAR(100),
				[ClickCount] [INT],
				[MinClickTime] VARCHAR(100)
            );

-- =========================================
-- Procedure
-- =========================================
SELECT MailingId, subject
INTO #IMC_Mailings
FROM ods.IMC_Mailings

SELECT DISTINCT
        MemberID
      , EmailAddress
	  , imc.MailingID
	  , imc.MailingName
	  , m.subject
	  , DeliveryResult
	  , DeliveryCount
	  , CONVERT(VARCHAR,MinDeliveryTime,100) AS MinDeliveryTime
	  , OpenCount
	  , CONVERT(VARCHAR, MinOpenTime,100) AS MinOpenTime
	  , ClickCount
	  , CONVERT(VARCHAR,MinClickTime, 100) AS MinClickTime
INTO #Emails
--SELECT *
FROM    etl.IMC_EmailSummary_MSCRM imc (NOLOCK)
JOIN #IMC_Mailings m (NOLOCK) ON m.MailingId = imc.MailingID
WHERE   SSB_CRMSYSTEM_CONTACT_ID IN (SELECT GUID FROM @GUIDTable);



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
        FROM    #Emails AS c;

-- =========================================
-- API Loading
-- =========================================

-- Load base data

        INSERT  INTO @baseData
                SELECT  *
                FROM    #Emails AS c
                ORDER BY  LEN(c.MailingID) DESC,c.MailingID DESC --Edit made here by CTW 2018-06-13
                      OFFSET ( @PageNumber ) * @RowsPerPage ROWS

FETCH NEXT @RowsPerPage ROWS ONLY;

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

        SET @xmlDataNode = (
                             SELECT ISNULL(MemberID, '') AS Member_ID
                                  , ISNULL(EmailAddress,'') AS Email_Address
                                  , ISNULL(MailingID,'') AS Mailing_ID
                                  , ISNULL(MailingName,'') AS Mailing_Name
                                  , ISNULL(Subject,'') AS Subject
                                  , ISNULL(DeliveryResult,'') AS Delivery_Result
                                  , ISNULL(DeliveryCount,0) AS Delivery_Count
                                  , ISNULL(MinDeliveryTime,'') AS Min_Delivery_Time
								  , ISNULL(OpenCount,0) AS Open_Count                                 
                                  , ISNULL(MinOpenTime,'') AS Min_Open_Time                               
                                  , ISNULL(ClickCount,0) AS Click_Count
                                  , ISNULL(MinClickTime,'') AS Min_Click_Time
                             FROM   @baseData
                           FOR
                             XML PATH('Parent')
                               , ROOT('Parents')
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
    END;

-- Wrap response info and data, then return    

    IF @xmlDataNode IS NULL
        BEGIN

            SET @xmlDataNode = '<' + @rootNodeName + ' />';

        END;

    SET @finalXml = '<Root>' + @responseInfoNode
        + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>';

    SELECT  CAST(@finalXml AS XML);

GO
