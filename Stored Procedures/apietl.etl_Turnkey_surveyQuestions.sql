SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		Caeleon Work
-- Create date: 03/22/2017
-- Description:	TurnKey Question Processing
-- =============================================
Create PROCEDURE [apietl].[etl_Turnkey_surveyQuestions]
AS
    BEGIN

-- =============================================
--  Check for Temp Table
-- =============================================

        IF OBJECT_ID('tempdb..#questionTemp') IS NOT NULL
            DROP TABLE #questionTemp;


        IF OBJECT_ID('tempdb..#stgTemp') IS NOT NULL
            DROP TABLE #stgTemp;
			


-- =============================================
--  Union all the question tables
-- =============================================

        --DECLARE @Query NVARCHAR(MAX)   = '';

        --SELECT  @Query = @Query + 'SELECT *, ' + '''' + SUBSTRING(t.TABLE_NAME,
        --                                                      CHARINDEX('_',
        --                                                      t.TABLE_NAME, 36)
        --                                                      + 1,
        --                                                      LEN(SUBSTRING(t.TABLE_NAME,
        --                                                      CHARINDEX('_',
        --                                                      t.TABLE_NAME, 36)
        --                                                      + 1, 100))
        --                                                      - LEN(SUBSTRING(t.TABLE_NAME,
        --                                                      CHARINDEX('_',
        --                                                      t.TABLE_NAME, 38),
        --                                                      100))) + ''''
        --        + ' as question' + ' FROM ' + t.TABLE_SCHEMA + '.'
        --        + TABLE_NAME + ' UNION ALL '
        --FROM    INFORMATION_SCHEMA.TABLES AS t
        --WHERE   ( t.TABLE_NAME LIKE '%result_questions_QID[0-9]_%[0-9]'
        --          OR t.TABLE_NAME LIKE '%result_questions_QID[0-9]_[0-9]'
        --        )
        --        AND t.TABLE_NAME NOT LIKE '%choices%'
        --        AND t.TABLE_NAME NOT LIKE '%subQuestions%'
        --        AND t.TABLE_NAME NOT LIKE '%questionType%'
        --        AND t.TABLE_NAME NOT LIKE '%validation%'
        --        AND t.TABLE_NAME NOT LIKE '%randomization%'
        --ORDER BY t.TABLE_NAME ASC;

        --SELECT  @Query = LEFT(@Query, LEN(@Query) - LEN(' UNION ALL '));

        --PRINT ( @Query );
		--EXECUTE (@Query)

-- =============================================
--  Insert Result into Temp Table
-- =============================================
        CREATE TABLE #questionTemp
            (
              TurnKey_GetSurveyFieldInformation_id NVARCHAR(255) ,
              TurnKey_GetSurveyFieldInformation_SurveyField_Body_ID
                NVARCHAR(255) ,
              TurnKey_GetSurveyFieldInformation_SurveyField_Heading_id
                NVARCHAR(255) ,
			  survey_id NVARCHAR(4000),
              questionText NVARCHAR(4000) ,
              questionnumber NVARCHAR(400)
            );

        INSERT  INTO #questionTemp
                ( TurnKey_GetSurveyFieldInformation_id ,
                  TurnKey_GetSurveyFieldInformation_SurveyField_Body_ID ,
                  TurnKey_GetSurveyFieldInformation_SurveyField_Heading_id ,
				  survey_id ,
                  questionText ,
                  questionnumber
                )
                SELECT  sfi0.TurnKey_GetSurveyFieldInformation_id ,
                        sfb2.TurnKey_GetSurveyFieldInformation_SurveyField_Body_id ,
                        sfh2.TurnKey_GetSurveyFieldInformation_SurveyField_Heading_id ,
						sfi0.multi_query_value_for_audit ,
                        sfb2.Text ,
                        sfh2.Text
                FROM    apietl.TurnKey_GetSurveyFieldInformation_0 sfi0
                        JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_1 sfi1 ON sfi1.TurnKey_GetSurveyFieldInformation_id = sfi0.TurnKey_GetSurveyFieldInformation_id
                        LEFT JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_Body_2 sfb2 ON sfb2.TurnKey_GetSurveyFieldInformation_SurveyField_id = sfi1.TurnKey_GetSurveyFieldInformation_SurveyField_id
                        LEFT JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_Heading_2 sfh2 ON sfh2.TurnKey_GetSurveyFieldInformation_SurveyField_id = sfi1.TurnKey_GetSurveyFieldInformation_SurveyField_id;

        --PRINT @tempQuery;

        --EXEC(@tempQuery);

        --SELECT  *
        --FROM    #questionTemp AS qt;

-- =============================================
--  Prep Staging Data
-- =============================================

        SELECT  GETDATE() ETL__CreatedDate
              , GETDATE() AS ETL__UpdatedDate
              , survey_id 
              , qt.questionText
              , qt.questionnumber
        INTO    #stgTemp
        FROM    #questionTemp qt
                
-- =============================================
--  Strip HTML from questionText
-- =============================================

        UPDATE  #stgTemp
        SET     questionText = dbo.udf_StripHTML(questionText);


		--SELECT * FROM #stgTemp AS st

-- =============================================
--  Insert into ODS
-- =============================================

        MERGE [ods].[TurnKey_SurveyQuestions] AS TARGET
        USING
            (
              SELECT    st.ETL__CreatedDate
                      , ETL__UpdatedDate
                      , st.survey_id
                      , st.questionText
                      , st.questionnumber
              FROM      #stgTemp AS st
            ) AS SOURCE
        ON TARGET.survey_id = SOURCE.survey_id
            AND TARGET.questionText = SOURCE.questionText
        WHEN NOT MATCHED THEN
            INSERT ( ETL__CreatedDate
                   , ETL__UpdatedDate
                   , survey_id
                   , questionText
                   , questionnumber
                   )
            VALUES ( SOURCE.ETL__CreatedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.survey_id
                   , SOURCE.questionText
                   , SOURCE.questionnumber
                   );




    END;







GO
