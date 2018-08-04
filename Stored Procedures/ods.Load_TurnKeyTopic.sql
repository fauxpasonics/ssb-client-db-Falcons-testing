SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Caeleon Work
-- Create date: 03/22/2017
-- Description:	TurnKey Question Processing
-- =============================================
CREATE PROCEDURE [ods].[Load_TurnKeyTopic]
AS

--=============================================
--Check For Temp Tables
--=============================================

    IF OBJECT_ID('tempdb..#questionTemp') IS NOT NULL
        DROP TABLE #questionTemp;


    IF OBJECT_ID('tempdb..#stgTemp') IS NOT NULL
        DROP TABLE #stgTemp;

--============================================
-- Questions Temp Table
--============================================

    CREATE TABLE #questionTemp
        (
          survey_id BIGINT NULL ,
          questionnumber NVARCHAR(MAX) NULL ,
          questiontopic NVARCHAR(MAX) NULL ,
          questioncolumn NVARCHAR(255) NULL
        );

    INSERT  INTO #questionTemp
            ( survey_id ,
              questionnumber ,
              questiontopic ,
              questioncolumn
            )
            SELECT  sfi0.multi_query_value_for_audit survey_id ,
                    siq1.[@heading] questionnumber ,
                    sft2.Text questiontopic ,
                    siqt3.[@column]
            FROM    apietl.TurnKey_GetSurveyFieldInformation_0 sfi0
                    JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_1 sfi1 ON sfi1.TurnKey_GetSurveyFieldInformation_id = sfi0.TurnKey_GetSurveyFieldInformation_id
                    LEFT JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_Topic_2 sft2 ON sft2.TurnKey_GetSurveyFieldInformation_SurveyField_id = sfi1.TurnKey_GetSurveyFieldInformation_SurveyField_id
                    LEFT JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_Heading_2 sfh2 ON sfh2.TurnKey_GetSurveyFieldInformation_SurveyField_id = sfi1.TurnKey_GetSurveyFieldInformation_SurveyField_id
                    JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON sfh2.Text = siq1.[@heading]
                    JOIN [apietl].[TurnKey_GetSurveyInformation_0] si0 ON si0.TurnKey_GetSurveyInformation_id = siq1.TurnKey_GetSurveyInformation_id
                    LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Side_2] siqs2 ON siqs2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
                    LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Side_Topic_3] siqt3 ON siqt3.TurnKey_GetSurveyInformation_Question_Side_id = siqs2.TurnKey_GetSurveyInformation_Question_Side_id
            WHERE   sft2.Text IS NOT NULL
                    AND siqt3.[@column] IS NOT NULL
            UNION ALL
            SELECT  sfi0.multi_query_value_for_audit survey_id ,
                    siq1.[@heading] questionnumber ,
                    sft2.Text questiontopic ,
                    siqo2.[@column]
            FROM    apietl.TurnKey_GetSurveyFieldInformation_0 sfi0
                    JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_1 sfi1 ON sfi1.TurnKey_GetSurveyFieldInformation_id = sfi0.TurnKey_GetSurveyFieldInformation_id
                    LEFT JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_Topic_2 sft2 ON sft2.TurnKey_GetSurveyFieldInformation_SurveyField_id = sfi1.TurnKey_GetSurveyFieldInformation_SurveyField_id
                    LEFT JOIN apietl.TurnKey_GetSurveyFieldInformation_SurveyField_Heading_2 sfh2 ON sfh2.TurnKey_GetSurveyFieldInformation_SurveyField_id = sfi1.TurnKey_GetSurveyFieldInformation_SurveyField_id
                    JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON sfh2.Text = siq1.[@heading]
                    JOIN [apietl].[TurnKey_GetSurveyInformation_0] si0 ON si0.TurnKey_GetSurveyInformation_id = siq1.TurnKey_GetSurveyInformation_id
                    LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Side_2] siqs2 ON siqs2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
                    LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Option_2] siqo2 ON siqo2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
            WHERE   sft2.Text IS NOT NULL
                    AND siqo2.[@column] IS NOT NULL;

--=============================================
--Stage data
--=============================================

    SELECT  GETDATE() ETL__CreatedDate ,
            GETDATE() AS ETL__UpdatedDate ,
            survey_id ,
            qt.questionnumber ,
            qt.questiontopic ,
            qt.questioncolumn
    INTO    #stgTemp
    FROM    #questionTemp qt;

--===========================================
--Merge Data
--===========================================
    MERGE [ods].[Turnkey_QuestionTopic] AS TARGET
    USING
        ( SELECT    st.ETL__CreatedDate ,
                    st.ETL__UpdatedDate ,
                    st.survey_id ,
                    st.questionnumber ,
					st.questiontopic ,
					st.questioncolumn
          FROM      #stgTemp AS st
        ) AS SOURCE
    ON TARGET.survey_id = SOURCE.survey_id
        AND TARGET.questioncolumn = SOURCE.questioncolumn
    WHEN NOT MATCHED THEN
        INSERT ( ETL__CreatedDate ,
                 ETL__UpdatedDate ,
                 survey_id ,
				 questionnumber ,
				 questiontopic ,
				 questioncolumn
               )
        VALUES ( SOURCE.ETL__CreatedDate ,
                 SOURCE.ETL__UpdatedDate ,
                 SOURCE.survey_id ,
                 SOURCE.questionnumber ,
				 SOURCE.questiontopic ,
				 SOURCE.questioncolumn
               );
GO
