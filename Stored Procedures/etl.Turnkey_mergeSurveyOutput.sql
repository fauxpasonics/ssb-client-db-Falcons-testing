SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [etl].[Turnkey_mergeSurveyOutput]-- @ETL__multi_query_value_for_audit nvarchar(max)
AS

DECLARE @RunTime DATETIME = GETDATE()

DELETE T 
	FROM ODS.TurnkeySurveyOutput  T
	JOIN etl.vwTurnkeySurveyOutput S 
		ON t.ETL__multi_query_value_for_audit = s.ETL__multi_query_value_for_audit
		AND t.RecordID = s.RecordID
	--where ETL__multi_query_value_for_audit = @ETL__multi_query_value_for_audit
	--	AND 

INSERT INTO  ODS.TurnkeySurveyOutput 
	(ETL__multi_query_value_for_audit
	,SurveyName
	,RecordID
	,Question
	,SubQuestion
	,Response
	,Heading
	,[key]
	,Started
	,Completed
	,LastPageNumber
	,ETL_CreatedDate
	,ETL_UpdateddDate)
SELECT 
	s.ETL__multi_query_value_for_audit
	,s.SurveyName
	,s.RecordID
	,s.Question
	,s.SubQuestion
	,s.Response
	,s.Heading
	,s.[key]
	,s.Started
	,s.Completed
	,s.LastPageNumber
	,@RunTime
	,@RunTime
FROM etl.vwTurnkeySurveyOutput  S


GO
