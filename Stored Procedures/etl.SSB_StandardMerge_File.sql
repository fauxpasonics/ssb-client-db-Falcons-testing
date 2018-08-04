SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[SSB_StandardMerge_File]
(
	@BatchId NVARCHAR(50),
	@Target VARCHAR(256),
	@Source VARCHAR(256),
	@BusinessKey VARCHAR(256),
	@Options NVARCHAR(MAX)
)

AS
BEGIN

/**************************************Comments***************************************
**************************************************************************************
Mod #:		1
Name:		ssbcloud\zfrick
Date:		04/17/2016
Comments:	Dynamically generates and executes standard SSB Merge from source table to destination table.

*************************************************************************************/

DECLARE
     @SQL VARCHAR(MAX),
	 @SQL2 VARCHAR(MAX),
	 @SQL3 VARCHAR(MAX),
	 @SQL4 VARCHAR(MAX)


DECLARE @JoinString varchar(MAX)

DECLARE @LoadArchiveTable bit = 0
DECLARE @ArchiveTableName NVARCHAR(255)
DECLARE @DedupeStage bit = 0
DECLARE @DedupeSortPriority NVARCHAR(255)
DECLARE @PartitionedKeyDelete bit = 0
DECLARE @PartitionedKey NVARCHAR(255)
DECLARE @FullLoadWithDelete bit = 0


DECLARE @OptionsXML XML = TRY_CAST(@Options AS XML)

SELECT @LoadArchiveTable = CAST(CASE WHEN t.x.value('LoadArchiveTable[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @ArchiveTableName = t.x.value('ArchiveTableName[1]','nvarchar(255)')
, @DedupeStage = CAST(CASE WHEN t.x.value('DedupeStage[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @DedupeSortPriority = t.x.value('DedupeSortPriority[1]','nvarchar(255)')
, @PartitionedKeyDelete = CAST(CASE WHEN t.x.value('PartitionedKeyDelete[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @PartitionedKey = t.x.value('PartitionedKey[1]','nvarchar(255)')
, @FullLoadWithDelete = CAST(CASE WHEN t.x.value('FullLoadWithDelete[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @JoinString = t.x.value('JoinString[1]','nvarchar(2000)')
FROM @OptionsXML.nodes('options') t(x)

SELECT *
INTO #SourceColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@Source, 2) AND TABLE_NAME = PARSENAME(@Source, 1)

SELECT *
INTO #TargetColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@Target, 2) AND TABLE_NAME = PARSENAME(@Target, 1)

SELECT *
INTO #ArchiveColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@ArchiveTableName, 2) AND TABLE_NAME = PARSENAME(@ArchiveTableName, 1)


SELECT t.*
INTO #SharedColumns
FROM #SourceColumns s
INNER JOIN #TargetColumns t ON s.COLUMN_NAME = t.COLUMN_NAME
WHERE ISNULL(s.COLUMN_NAME,'') NOT LIKE 'ETL__%'
AND ISNULL(t.COLUMN_NAME,'') NOT LIKE 'ETL__%'

SELECT t.*
INTO #SharedColumnsArchive
FROM #SourceColumns s
INNER JOIN #ArchiveColumns t ON s.COLUMN_NAME = t.COLUMN_NAME
WHERE ISNULL(s.COLUMN_NAME,'') NOT LIKE 'ETL__%'
AND ISNULL(t.COLUMN_NAME,'') NOT LIKE 'ETL__%'


DECLARE @ColString AS VARCHAR(MAX) = ''

SELECT @ColString = @ColString + '' +
CASE
	WHEN DATA_TYPE IN ('bit') THEN 'TRY_CAST([' + COLUMN_NAME + '] AS ' + DATA_TYPE + ') [' + COLUMN_NAME + ']'
	WHEN DATA_TYPE like '%int%' THEN 'TRY_CAST([' + COLUMN_NAME + '] AS DECIMAL(19,0)) [' + COLUMN_NAME + ']'
	WHEN DATA_TYPE IN ('decimal', 'numeric') THEN 'TRY_CAST([' + COLUMN_NAME + '] AS ' + DATA_TYPE + '(18,6)) [' + COLUMN_NAME + ']'
	WHEN DATA_TYPE IN ('date', 'datetime', 'datetime2', 'time')	THEN 'TRY_CAST([' + COLUMN_NAME + '] AS ' + DATA_TYPE + ') [' + COLUMN_NAME + ']'
	ELSE '[' + COLUMN_NAME + ']'
END + ', '
FROM #SharedColumns

SET @ColString = left(@ColString, LEN(@ColString) - 1)


DECLARE @DeltaHashKeySyntax AS VARCHAR(MAX) = ''

	SELECT @DeltaHashKeySyntax = @DeltaHashKeySyntax +
	CASE DATA_TYPE 
	WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),[' + COLUMN_NAME + '])),''DBNULL_INT'')'
	WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),[' + COLUMN_NAME + '])),''DBNULL_BIGINT'')'
	WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),[' + COLUMN_NAME + '])),''DBNULL_DATETIME'')'  
	WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),[' + COLUMN_NAME + '])),''DBNULL_DATETIME'')'
	WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),[' + COLUMN_NAME + '],112)),''DBNULL_DATE'')' 
	WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),[' + COLUMN_NAME + '])),''DBNULL_BIT'')'  
	WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),['+ COLUMN_NAME + '])),''DBNULL_NUMBER'')' 
	WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),['+ COLUMN_NAME + '])),''DBNULL_NUMBER'')' 
	ELSE 'ISNULL(RTRIM([' + COLUMN_NAME + ']),''DBNULL_TEXT'')'
	END + ' COLLATE SQL_Latin1_General_CP1_CS_AS + '
	FROM #SharedColumns
	WHERE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) >= 0
	ORDER BY COLUMN_NAME

SET @DeltaHashKeySyntax = 'HASHBYTES(''sha2_256'', ' + LEFT(@DeltaHashKeySyntax, (LEN(@DeltaHashKeySyntax) - 2)) + ')'



IF (ISNULL(@JoinString,'') = '')
BEGIN

SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			select 't.[' + a.Item + '] = s.[' + a.Item + ']' as match
			from dbo.Split (@BusinessKey, ',') a 
		)	x	
        FOR XML PATH('')), 1, 5, '')
	)


END

	DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(s.[' + COLUMN_NAME + '],'''') <> ' + 'ISNULL(t.[' + COLUMN_NAME + '],'''') '
	FROM #SharedColumns	
	WHERE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0



DECLARE @ColumnListArchive NVARCHAR(max) = ''

SET @ColumnListArchive = (
select STUFF ((
    SELECT ', [' + COLUMN_NAME + ']' 
	FROM #SharedColumnsArchive
	ORDER BY ORDINAL_POSITION
    FOR XML PATH('')), 1, 1, ''
))

DECLARE @DeleteLogXMLColumns AS VARCHAR(MAX) = ''

SELECT @DeleteLogXMLColumns = @DeleteLogXMLColumns + 't.[' + COLUMN_NAME + '], '
FROM #TargetColumns
WHERE DATA_TYPE NOT LIKE '%binary'

SET @DeleteLogXMLColumns = LEFT(@DeleteLogXMLColumns, LEN(@DeleteLogXMLColumns) - 1)


DECLARE @SqlUpdateToNull NVARCHAR(MAX) = ''

SELECT @SqlUpdateToNull = @SqlUpdateToNull + '
UPDATE ' + @Source + ' SET ' + COLUMN_NAME + ' = NULL WHERE ' + COLUMN_NAME + ' = '''';
'
--, *
FROM #SharedColumns
WHERE DATA_TYPE NOT LIKE '%char%'
	

SELECT @SQL = 
'

DECLARE @BatchId NVARCHAR(50) = ''' + @BatchId + ''';
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = ''TM_StandardMerge - ' + @Target + '''
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0'';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting(''ClientName''), DB_NAME()));

BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)


DECLARE @RecordCount INT = (SELECT COUNT(*) FROM ' + @Source + ')
DECLARE @StartIndex INT = 1, @PageCount INT = 10000000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)

'

SELECT @SQL2 = '

DECLARE @MaxId INT = (SELECT MAX(ETL__ID) FROM ' + @Source +')


WHILE @StartIndex <= @MaxId
BEGIN

SELECT ETL__SourceFileName
, CAST(' + @DeltaHashKeySyntax + ' as binary(32)) ETL__DeltaHashKey
, ' + @ColString + '
INTO #SrcData
FROM ' + @Source + '
WHERE ETL__ID BETWEEN @StartIndex AND @EndIndex

CREATE NONCLUSTERED INDEX IDX_Key ON #SrcData (' + @BusinessKey + ')
CREATE NONCLUSTERED INDEX IDX_ETL__DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

';

-------------------------------------------------------------------------------------------------

SELECT @SQL3 = 
'
MERGE ' + @Target + ' AS t

USING #SrcData s
    
	ON ' + @JoinString + '

WHEN MATCHED AND (
     ISNULL(s.[ETL__DeltaHashKey],-1) <> ISNULL(t.[ETL__DeltaHashKey], -1)
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
     t.[ETL__UpdatedDate] = GETDATE()
     , t.[ETL__SourceFileName] = s.[ETL__SourceFileName]
     , t.[ETL__DeltaHashKey] = s.[ETL__DeltaHashKey]
     , ' +
          STUFF ((
                    SELECT ',t.[' + COLUMN_NAME + '] = s.[' + COLUMN_NAME + ']' + CHAR(10) + '     '                           
						FROM #SharedColumns
						ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '')  +
'

';

-------------------------------------------------------------------------------------------------

SELECT @SQL4 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [ETL__CreatedDate]
     , [ETL__UpdatedDate]
     , [ETL__SourceFileName]
     , [ETL__DeltaHashKey]
	 , ' + 
          STUFF ((
                    SELECT ',[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')
VALUES
     (
     GETDATE() --s.[ETL__CreatedDate]
     , GETDATE() --s.[[ETL__UpdatedDate]]
     , s.[ETL__SourceFileName]
     , s.[ETL__DeltaHashKey]
	 , ' +
          STUFF ((
                    SELECT ',s.[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns					
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')
;


DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

'

SELECT @SQL
	UNION ALL
SELECT @SQL2
	UNION ALL
SELECT @SQL3
	UNION ALL
SELECT @SQL4

DECLARE @Full_SQL NVARCHAR(MAX) = @SQL + @SQL2 + @SQL3 + @SQL4;


--SELECT @Full_SQL

--EXEC (@Full_SQL)

END





















GO
