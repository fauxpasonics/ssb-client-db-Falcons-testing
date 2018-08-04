SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Ismail Fuseini
-- Create date: 12/20/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [apietl].[Load_TurnKey_SurveyList]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE [ods].[TurnKey_SurveyList] AS TARGET
        USING
            (
              SELECT    GETDATE() AS ETL__CreatedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , CAST(slp1.[@id] AS BIGINT) AS id
					  , slp1.Name AS Name
					  FROM      apietl.TurnKey_GetSurveyList_Project_1 AS slp1
            ) AS SOURCE
        ON TARGET.id = SOURCE.id
        WHEN NOT MATCHED THEN
            INSERT ( ETL__CreatedDate
                   , ETL__UpdatedDate
                   , id
                   , name
                   )
            VALUES ( SOURCE.ETL__CreatedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.id
                   , SOURCE.name
                   );
    END;



GO
