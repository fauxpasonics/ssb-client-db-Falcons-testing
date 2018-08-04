SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Caeleon Work
-- Create date: 7/11/2017
-- Description:	SilverPop GetList Load sProc
-- =============================================
CREATE PROCEDURE [apietl].[sp_Load_IMC_GetList]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.IMC_ContactLists AS TARGET
        USING
            (
              SELECT    GETDATE() AS ETL__InsertedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , CAST(sgl.ID AS NVARCHAR(255)) AS ID
                      , CAST(sgl.NAME AS NVARCHAR(255)) AS NAME
                      , CAST(sgl.TYPE AS NVARCHAR(255)) AS TYPE
                      , CAST(sgl.SIZE AS INT) AS SIZE
                      , CAST(sgl.NUM_OPT_OUTS AS INT) AS NUM_OPT_OUTS
                      , CAST(sgl.NUM_UNDELIVERABLE AS INT) AS NUM_UNDELIVERABLE
                      , CAST(sgl.LAST_MODIFIED AS DATETIME2) AS LAST_MODIFIED
                      , CAST(sgl.VISIBILITY AS NVARCHAR(255)) AS VISIBILITY
                      , CAST(sgl.PARENT_NAME AS NVARCHAR(255)) AS PARENT_NAME
                      , CAST(sgl.USER_ID AS NVARCHAR(255)) AS USER_ID
                      , CAST(sgl.PARENT_FOLDER_ID AS NVARCHAR(255)) AS PARENT_FOLDER_ID
                      , CAST(sgl.IS_FOLDER AS NVARCHAR(255)) AS IS_FOLDER
                      , CAST(sgl.FLAGGED_FOR_BACKUP AS NVARCHAR(255)) AS FLAGGED_FOR_BACKUP
                      , CAST(sgl.SUPPRESSION_LIST_ID AS NVARCHAR(255)) AS SUPPRESSION_LIST_ID
              FROM      apietl.silverpop_get_lists_0 AS sgl
            ) AS SOURCE
        ON TARGET.ID = SOURCE.ID
            AND TARGET.NAME = SOURCE.NAME
            AND TARGET.PARENT_FOLDER_ID = SOURCE.PARENT_FOLDER_ID
        WHEN MATCHED THEN
            UPDATE SET
                    TARGET.ETL__UpdatedDate = SOURCE.ETL__UpdatedDate
                  , TARGET.ID = SOURCE.ID
                  , TARGET.NAME = SOURCE.NAME
                  , TARGET.TYPE = SOURCE.TYPE
                  , TARGET.SIZE = SOURCE.SIZE
                  , TARGET.NUM_OPT_OUTS = SOURCE.NUM_OPT_OUTS
                  , TARGET.NUM_UNDELIVERABLE = SOURCE.NUM_UNDELIVERABLE
                  , TARGET.LAST_MODIFIED = SOURCE.LAST_MODIFIED
                  , TARGET.VISIBILITY = SOURCE.VISIBILITY
                  , TARGET.PARENT_NAME = SOURCE.PARENT_NAME
                  , TARGET.USER_ID = SOURCE.USER_ID
                  , TARGET.PARENT_FOLDER_ID = SOURCE.PARENT_FOLDER_ID
                  , TARGET.IS_FOLDER = SOURCE.IS_FOLDER
                  , TARGET.FLAGGED_FOR_BACKUP = SOURCE.FLAGGED_FOR_BACKUP
                  , TARGET.SUPPRESSION_LIST_ID = SOURCE.SUPPRESSION_LIST_ID
        WHEN NOT MATCHED THEN
            INSERT ( ETL__InsertedDate
                   , ETL__UpdatedDate
                   , ID
                   , NAME
                   , TYPE
                   , SIZE
                   , NUM_OPT_OUTS
                   , NUM_UNDELIVERABLE
                   , LAST_MODIFIED
                   , VISIBILITY
                   , PARENT_NAME
                   , USER_ID
                   , PARENT_FOLDER_ID
                   , IS_FOLDER
                   , FLAGGED_FOR_BACKUP
                   , SUPPRESSION_LIST_ID
                   )
            VALUES ( SOURCE.ETL__InsertedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.ID
                   , SOURCE.NAME
                   , SOURCE.TYPE
                   , SOURCE.SIZE
                   , SOURCE.NUM_OPT_OUTS
                   , SOURCE.NUM_UNDELIVERABLE
                   , SOURCE.LAST_MODIFIED
                   , SOURCE.VISIBILITY
                   , SOURCE.PARENT_NAME
                   , SOURCE.USER_ID
                   , SOURCE.PARENT_FOLDER_ID
                   , SOURCE.IS_FOLDER
                   , SOURCE.FLAGGED_FOR_BACKUP
                   , SOURCE.SUPPRESSION_LIST_ID
                   );

    END;



GO
