SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Caeleon Work
-- Create date: 03/22/2017
-- Description:	TurnKey Question Processing
-- =============================================

Create PROCEDURE [apietl].[Load_Turnkey_QuestionIdCrosswalk]
AS

--==============================================
--Check For Temp Tables
--==============================================

        IF OBJECT_ID('tempdb..#questionTemp') IS NOT NULL
            DROP TABLE #questionTemp;

        IF OBJECT_ID('tempdb..#stgTemp') IS NOT NULL
            DROP TABLE #stgTemp;

--==============================================
--Select Question Columns And ID
--==============================================
CREATE TABLE #questionTemp
(
survey_id BIGINT NULL,
questionnumber NVARCHAR(max) NULL,
questionclass NVARCHAR(255) NULL,
questionsubclass NVARCHAR(255) NULL,
questioncolumn NVARCHAR(255) NULL)

INSERT INTO #questionTemp
        ( survey_id ,
          questionnumber ,
          questionclass ,
          questionsubclass ,
          questioncolumn
        )
SELECT si0.multi_query_value_for_audit survey_id, siq1.[@heading] questionnumber,siq1.[@class] questionclass, NULL questionsubclass,siq1.[@column] questioncolumn FROM [apietl].[TurnKey_GetSurveyInformation_0] si0
        JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON siq1.TurnKey_GetSurveyInformation_id = si0.TurnKey_GetSurveyInformation_id
		WHERE ISNULL(siq1.[@column],'')<>''
UNION ALL 
SELECT si0.multi_query_value_for_audit, siq1.[@heading],siq1.[@class], NULL,siqc2.[@column] FROM [apietl].[TurnKey_GetSurveyInformation_0] si0
        JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON siq1.TurnKey_GetSurveyInformation_id = si0.TurnKey_GetSurveyInformation_id
		LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Choice_2] siqc2 ON siqc2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
		WHERE ISNULL(siqc2.[@column],'')<>''
UNION ALL
SELECT si0.multi_query_value_for_audit, siq1.[@heading],siq1.[@class], NULL,siqc2.[@specify] FROM [apietl].[TurnKey_GetSurveyInformation_0] si0
        JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON siq1.TurnKey_GetSurveyInformation_id = si0.TurnKey_GetSurveyInformation_id
		LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Choice_2] siqc2 ON siqc2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
		WHERE ISNULL(siqc2.[@specify],'')<>''
UNION ALL
SELECT si0.multi_query_value_for_audit, siq1.[@heading],siq1.[@class], siqo2.[@type],siqo2.[@column] FROM [apietl].[TurnKey_GetSurveyInformation_0] si0
        JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON siq1.TurnKey_GetSurveyInformation_id = si0.TurnKey_GetSurveyInformation_id
		LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Option_2] siqo2 ON siqo2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
        WHERE ISNULL(siqo2.[@column],'')<>''
UNION ALL
SELECT si0.multi_query_value_for_audit, siq1.[@heading],siq1.[@class], siqs2.[@class],siqt3.[@column] FROM [apietl].[TurnKey_GetSurveyInformation_0] si0
        JOIN apietl.TurnKey_GetSurveyInformation_Question_1 siq1 ON siq1.TurnKey_GetSurveyInformation_id = si0.TurnKey_GetSurveyInformation_id
		LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Side_2] siqs2 ON siqs2.TurnKey_GetSurveyInformation_Question_id = siq1.TurnKey_GetSurveyInformation_Question_id
        LEFT JOIN [apietl].[TurnKey_GetSurveyInformation_Question_Side_Topic_3] siqt3 ON siqt3.TurnKey_GetSurveyInformation_Question_Side_id = siqs2.TurnKey_GetSurveyInformation_Question_Side_id
		WHERE ISNULL(siqt3.[@column],'')<>''   

--==============================================
--Stage Data
--==============================================
		
SELECT GETDATE() AS ETL__CreatedDate,
GETDATE() AS ETL__UpdatedDate,
survey_id,
questionnumber,
questionclass,
questionsubclass,
questioncolumn
INTO #stgTemp
FROM #questionTemp 

--==============================================
--Merge to ODS
--==============================================

 MERGE [ods].[TurnKey_QuestionIdCrosswalk] AS TARGET
        USING
            (
              SELECT    st.ETL__CreatedDate
                      , st.ETL__UpdatedDate
                      , st.survey_id
                      , st.questionnumber
					  , st.questionclass
					  , st.questionsubclass
					  , st.questioncolumn
              FROM      #stgTemp AS st
            ) AS SOURCE
        ON TARGET.survey_id = SOURCE.survey_id
            AND TARGET.questioncolumn = SOURCE.questioncolumn
        WHEN NOT MATCHED THEN
            INSERT ( ETL__CreatedDate
                   , ETL__UpdatedDate
                   , survey_id
                   , questionnumber
				   , questionclass
				   , questionsubclass
				   , questioncolumn
                   )
            VALUES ( SOURCE.ETL__CreatedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.survey_id
                   , SOURCE.questionnumber
				   , SOURCE.questionclass
				   , SOURCE.questionsubclass
				   , SOURCE.questioncolumn
                   );

        


GO
