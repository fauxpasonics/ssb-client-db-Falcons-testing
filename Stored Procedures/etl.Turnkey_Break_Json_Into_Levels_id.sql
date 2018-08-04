SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [etl].[Turnkey_Break_Json_Into_Levels_id]
@schema VARCHAR(10), @tablename VARCHAR(100),  @ETL__multi_query_value_for_audit VARCHAR(50)
--EXEC [etl].[Break_Json_Into_Levels_id] 'stg', 'TurnKey_GetSurveyDataPaged', '1531058308'
AS

--declare 
--@schema varchar(10), @tablename varchar(100), @InsertDate Date
--Set @schema = 'stg'
--SET @tablename = 'TurnKey_GetSurveyInformation'
--SET @InsertDate = getdate()-3



Declare @counter int = 0
DECLARE @ISJson int = 1
DECLARE @sql  nvarchar(max)
DECLARE @sqlIsJson  nvarchar(max)
DECLARE @truncsql  nvarchar(max)


SET @truncsql ='TRUNCATE TABLE etl.'+ @tablename

exec(@truncsql)


Set @counter = 0


WHILE @ISJson > 0
BEGIN

--SET  @InsertDate  = CASE WHEN @tablename = 'TurnKey_GetSurveyDataPaged' THEN @InsertDate ELSE '1/1/1900' END

SET @sql = CASE WHEN @counter = 0 

THEN 
		'Insert into etl.['+ @tablename  + '] 
		SELECT   '''' , z.ETL__insert_datetime	,z.ETL__multi_query_value_for_audit, a.[key],a.[value] ,a.[type],IsJSON(a.[value]) IsJSON, ''' + CAST(@counter AS VARCHAR) + '''
		FROM ' + @schema  + '.[' + @tablename + '] z
		CROSS APPLY OPENJSON (json_payload)  a 
		WHERE z.ETL__multi_query_value_for_audit = ' + @ETL__multi_query_value_for_audit  +
		' AND z.ETL__session_id = ( Select top 1 ETL__session_id from ' + @schema  + '.[' + @tablename + '] x where x.ETL__multi_query_value_for_audit = ' + @ETL__multi_query_value_for_audit  + ' order by ETL__insert_datetime desc)'
		--AND z.ETL__insert_datetime < ''5/22/16'''  
		
	ELSE 
		'Insert into etl.['+ @tablename  + '] 
		SELECT  z.JID, z.ETL__insert_datetime	,z.ETL__multi_query_value_for_audit, a.[key],a.[value] ,a.[type],IsJSON(a.[value]) IsJSON, ''' + CAST(@counter AS VARCHAR) + '''
		FROM [etl].[' + @tablename + '] z
		CROSS APPLY OPENJSON (value)  a 
		WHERE IsJSON(z.[value]) = 1 and Level =''' + CAST(@counter -1 AS VARCHAR)  + ''' and z.[key] <> ''@xmlns''' 
		+ 'AND z.ETL__multi_query_value_for_audit = ' + @ETL__multi_query_value_for_audit 
	END

		----+ 'AND z.ETL__multi_query_value_for_audit = 1531058308'

		--ELSE 
		--'Insert into etl.['+ @tablename  + '] 
		--SELECT  z.JID, z.ETL__insert_datetime	,z.ETL__multi_query_value_for_audit, a.[key],a.[value] ,a.[type],IsJSON(a.[value]) IsJSON, ''' + CAST(@counter as varchar) + '''
		--FROM [etl].[' + @tablename + '] z
		--CROSS APPLY OPENJSON (value)  a 
		--WHERE IsJSON(z.[value]) = 1 and Level =''' + CAST(@counter -1 as varchar)  + ''' and z.[key] <> ''@xmlns''' 
		----+ 'AND z.ETL__multi_query_value_for_audit = 1531058308'
		--END



PRINT @sql
EXEC(@sql)

SET @sqlIsJson = 'Select @ISJson = max(IsJSON) FROM etl.[' + @tablename + ']  WHERE IsJSON = 1 and Level =''' + CAST(@counter AS VARCHAR)  + ''''

--Print @sqlIsJson

DECLARE @CommaString VARCHAR(MAX)
SET @CommaString = ''

EXEC sp_executesql @sqlIsJson, N'@ISJson int out', @CommaString OUT

SET @ISJson = @CommaString

--Print @ISJson


SET @counter = @counter + 1
--set @ISJson = 0

END


GO
