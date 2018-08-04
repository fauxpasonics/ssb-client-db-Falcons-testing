SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [etl].[Turnkey_loadSurveyOutput_fromStg] --[etl].[loadTurnkeySurveyOutput_fromStg] 9
--@daysback int
AS

INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(NULL, 'Start Load')

--Declare @startdate date 
--set @startdate = CAST((Select dateadd(dd,-ABS(@daysback), GETDATE())) as date)

CREATE TABLE #loop (id INT IDENTITY(1,1), ETL__multi_query_value_for_audit NVARCHAR(MAX),xcount INT)
INSERT INTO #loop (ETL__multi_query_value_for_audit)
SELECT DISTINCT a.ETL__multi_query_value_for_audit FROM apietl.TurnKey_GetSurveyDataEx a
JOIN (SELECT TOP 1 ETL__session_id FROM apietl.TurnKey_GetSurveyDataEx  ORDER BY ETL__insert_datetime DESC) b
	ON a.ETL__session_id = b.ETL__session_id

DECLARE @counter INT = 1
DECLARE @maxc INT SET @maxc = (SELECT MAX(id) FROM #loop)
DECLARE @ETL__multi_query_value_for_audit NVARCHAR(MAX)


WHILE @counter <= @maxc

BEGIN
SET @ETL__multi_query_value_for_audit = (SELECT ETL__multi_query_value_for_audit FROM #loop WHERE id = @counter)

--Create table etl.Log_TurnkeySurvey (id int identity(1,1), ETL__multi_query_value_for_audit nvarchar(50), Item varchar(500), logdatetime datetime default Getdate())
PRINT @ETL__multi_query_value_for_audit
PRINT @counter

INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'Start Loop -- Startetl TurnKey_GetParticipantDataEX')

EXEC etl.[Turnkey_Break_Json_Into_Levels_id] 'apietl', 'TurnKey_GetParticipantDataEX',  @ETL__multi_query_value_for_audit;
INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'END etl TurnKey_GetParticipantDataEX Start TurnKey_GetResponseCount')
EXEC etl.[Turnkey_Break_Json_Into_Levels_id] 'apietl', 'TurnKey_GetResponseCount',  @ETL__multi_query_value_for_audit;
INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'END etl TurnKey_GetResponseCount Start TurnKey_GetSurveyDataEX')
EXEC [dbo].[sp_EnableDisableIndexes] 0, 'etl.TurnKey_GetSurveyDataEX'
EXEC etl.[Turnkey_Break_Json_Into_Levels_id] 'apietl', 'TurnKey_GetSurveyDataEX',  @ETL__multi_query_value_for_audit;
EXEC [dbo].[sp_EnableDisableIndexes] 1, 'etl.TurnKey_GetSurveyDataEX'
INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'END etl TurnKey_GetSurveyDataEX Start TurnKey_GetSurveyFieldInformation')
EXEC etl.[Turnkey_Break_Json_Into_Levels_id] 'apietl', 'TurnKey_GetSurveyFieldInformation',  @ETL__multi_query_value_for_audit;
INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'END etl TurnKey_GetSurveyFieldInformation Start TurnKey_GetSurveyInformation')
EXEC etl.[Turnkey_Break_Json_Into_Levels_id] 'apietl', 'TurnKey_GetSurveyInformation',  @ETL__multi_query_value_for_audit;

INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'END etl TurnKey_GetSurveyInformation')


EXEC etl.[Turnkey_mergeSurveyOutput] --@ETL__multi_query_value_for_audit;
INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(@ETL__multi_query_value_for_audit, 'END Merge - END Loop')

SET @counter = @counter + 1

END

INSERT INTO etl.Log_TurnkeySurvey (ETL__multi_query_value_for_audit,Item) VALUES(NULL, 'End Load')

GO
