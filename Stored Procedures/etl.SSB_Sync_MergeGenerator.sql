SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[SSB_Sync_MergeGenerator]
     @Target VARCHAR(256),
     @Source VARCHAR(256),
     @Target_Key VARCHAR(256),
     @Source_Key VARCHAR(256),
     @Proc_Name VARCHAR(256)
AS
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     ssbcloud\dschaller
Date:     01/19/2015
Comments: This sproc creates merge logic dynamically based on values passed into sproc.
*************************************************************************************/
--Variables that will need to be passed into the sproc
--DECLARE
--     @Target VARCHAR(256),
--     @Source VARCHAR(256),
--     @Target_Key VARCHAR(256),
--     @Source_Key VARCHAR(256),
--     @Proc_Name VARCHAR(256)

--SET @Target = 'ods.TI_PatronMDM_Athletics'
--SET @Source = 'etl.vw_src_TI_PatronMDM_Athletics'
--SET @Target_Key = 'Patron'
--SET @Source_Key = 'Patron'
--SET @Proc_Name = 'ETL.ods_Load_TI_PatronMDM_Athletics'

--Variables that will stay in sproc contents
DECLARE
     @SQL VARCHAR(MAX),
	 @SQL2 VARCHAR(MAX),
	 @SQL3 VARCHAR(MAX),
	 @SQL4 VARCHAR(MAX),
	 @SQL5 VARCHAR(MAX),
	 @SQL6 VARCHAR(MAX),
	 @SQL7 VARCHAR(MAX)

DECLARE
	 @ColString VARCHAR(MAX)
SET
	 @ColString = 
	 ( SELECT STUFF ((
                    SELECT ', ' + name 
                    FROM sys.columns
                    WHERE object_id = OBJECT_ID(@Source) and name not in ('ETL_ID')		
					order by column_id		
                    FOR XML PATH('')), 1, 1, '') 
	 )

DECLARE
	 @HashSyntax varchar(MAX)

DECLARE	 @HashTbl table (HashSyntax varchar(MAX))
INSERT @HashTbl (HashSyntax)
EXEC  [etl].[SSB_HashFieldSyntax] @Source, 'ETL_ID'

SET @HashSyntax = (select top 1 HashSyntax from @HashTbl)

DECLARE
	 @JoinString varchar(MAX)
SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			select a.id, 'myTarget.' + a.Item + ' = mySource.' + b.Item as match
			from dbo.Split_DS (@Target_Key, ',') a inner join
			dbo.Split_DS (@Source_Key, ',') b on a.ID = b.ID
		)	x	
		order by id		
        FOR XML PATH('')), 1, 5, '')
	)

	DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	DECLARE @SchemaName  AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,1)
	DECLARE @Table AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,2)

	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(mySource.' + COLUMN_NAME + ','''') <> ' + 'ISNULL(myTarget.' + COLUMN_NAME + ','''') '
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @Table
	AND ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0
	AND COLUMN_NAME NOT IN ('ETL_ID')

	
SELECT @SQL = 
'ALTER PROCEDURE ' + @Proc_Name + CHAR(10) + 
'(
	@BatchId NVARCHAR(50) = null,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     ' + CURRENT_USER + '
Date:     ' + CONVERT(VARCHAR, GETDATE(), 101) + '
Comments: Initial creation
*************************************************************************************/

SET @BatchId = ISNULL(@BatchId, CONVERT(NVARCHAR(50), NEWID()))

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + ''.'' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0''

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, ''='', '';'')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableDelete''),''true'')

BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Procedure Processing'', ''Start'', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Row Count'', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src DataSize'', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
, ' + @ColString + '
INTO #SrcData
FROM (
	SELECT ' + @ColString + '
	, ROW_NUMBER() OVER(PARTITION BY ' + @Source_Key + ' ORDER BY ETL_Sync_ID) RowRank
	FROM ' + @Source + '
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Table Setup'', ''Temp Table Loaded'', @ExecutionId
';


---------------------------------------------------------------------------------
	
SELECT @SQL2 = 
'UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = ' + @HashSyntax + '
';


---------------------------------------------------------------------------------
	
SELECT @SQL3 = 
'EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Table Setup'', ''ETL_Sync_DeltaHashKey Set'', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (' + @Source_Key + ')
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Src Table Setup'', ''Temp Table Indexes Created'', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Merge Statement Execution'', ''Start'', @ExecutionId

MERGE ' + @Target + ' AS myTarget
USING #SrcData AS mySource
ON ' + @JoinString + '

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 ' + @SqlStringMax + '
)
';


---------------------------------------------------------------------------------
	
SELECT @SQL4 = 
'THEN UPDATE SET
      ' +
          STUFF ((
                    SELECT ',myTarget.[' + name + '] = mySource.[' + name + ']' + CHAR(10) + '     '
                           
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
         --                AND (name NOT LIKE 'ETL[_]%'
         --                     OR name = 'ETL_Sync_DeltaHashKey'
							  --OR name = 'ETL_SourceFileName'
         --                     OR name = 'ETL_UpdatedDate')
						order by column_id
                    FOR XML PATH('')), 1, 1, '')  +
'
';


---------------------------------------------------------------------------------
	
SELECT @SQL5 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (' + 
          STUFF ((
                    SELECT ',[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND name <> 'ETL_ID'
					order by column_id
                    FOR XML PATH('')), 1, 1, '') + ')
';


---------------------------------------------------------------------------------
	
SELECT @SQL6 = 
'VALUES
     (' +
          STUFF ((
                    SELECT ',mySource.[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND name <> 'ETL_ID'
					order by column_id
                    FOR XML PATH('')), 1, 1, '') + ')
;
';


---------------------------------------------------------------------------------
	
SELECT @SQL7 = 
'
EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Merge Statement Execution'', ''Complete'', @ExecutionId

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, ''Error'', @ProcedureName, ''Merge Load'', ''Merge Error'', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Procedure Processing'', ''Complete'', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, ''Info'', @ProcedureName, ''Merge Load'', ''Procedure Processing'', ''Complete'', @ExecutionId


END

GO'

SELECT @SQL AS [SQL], @SQL2 AS [SQL2], @SQL3 AS [SQL3], @SQL4 AS [SQL4], @SQL5 AS [SQL5], @SQL6 AS [SQL6], @SQL7 AS [SQL7]

--EXEC sp_executesql @SQL




GO
