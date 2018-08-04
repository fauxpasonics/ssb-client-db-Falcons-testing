SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [etl].[SSB_MergeGenerator_Falcons]
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
     @SQL VARCHAR(MAX)

DECLARE
	 @ColString VARCHAR(MAX)
SET
	 @ColString = 
	 ( SELECT STUFF ((
                    SELECT ', ' + name 
                    FROM sys.columns
                    WHERE object_id = OBJECT_ID(@Source) and name not in ('ETL_ID', 'ETL_CreatedDate')		
					order by column_id		
                    FOR XML PATH('')), 1, 1, '') 
	 )

DECLARE
	 @HashSyntax varchar(MAX)

DECLARE	 @HashTbl table (HashSyntax varchar(MAX))
INSERT @HashTbl (HashSyntax)
EXEC  [etl].[SSB_TableHashGenerator] @Source, 'ETL_ID, ETL_CreatedDate'

SET @HashSyntax = (SELECT TOP 1 HashSyntax FROM @HashTbl)

DECLARE
	 @JoinString VARCHAR(MAX)
SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			SELECT a.id, 'myTarget.' + a.Item + ' = mySource.' + b.Item AS match
			FROM dbo.Split_DS (@Target_Key, ',') a INNER JOIN
			dbo.Split_DS (@Source_Key, ',') b ON a.ID = b.ID
		)	x	
		ORDER BY id		
        FOR XML PATH('')), 1, 5, '')
	)

	DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	DECLARE @SchemaName  AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,1)
	DECLARE @Table AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,2)

	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(mySource.' + COLUMN_NAME + ','''') <> ' + 'ISNULL(myTarget.' + COLUMN_NAME + ','''') '
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @Table
	AND ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0
	AND COLUMN_NAME NOT IN ('ETL_ID', 'ETL_CreatedDate')

	
SELECT @SQL = 
'CREATE PROCEDURE ' + @Proc_Name + CHAR(10) + 
'(
	@BatchId INT = 0,
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

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + ''.'' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0''

BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey,' + @ColString + '
INTO #SrcData
FROM ' + @Source + '

UPDATE #SrcData
SET ETL_DeltaHashKey = ' + @HashSyntax + '


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (' + @Source_Key + ')
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ' + @Target + ' AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON ' + @JoinString + '

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
      ' +
          STUFF ((
                    SELECT CASE WHEN name = 'ETL_UpdatedDate'
                                THEN ',myTarget.[' + name + '] = @RunTime' + CHAR(10) + '     '
                                ELSE ',myTarget.[' + name + '] = mySource.[' + name + ']' + CHAR(10) + '     '
                           END
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND (name NOT LIKE 'ETL[_]%'
                              OR name = 'ETL_DeltaHashKey'
                              OR name = 'ETL_UpdatedDate')
						ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '')  +
'
WHEN NOT MATCHED BY TARGET
THEN INSERT
     (' + 
          STUFF ((
                    SELECT ',[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND name <> 'ETL_ID'
					ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '') + ')
VALUES
     (@RunTime --ETL_CreatedDate'+ CHAR(10) + '     ' +
     ',@RunTime --ETL_UpdateddDate'+ CHAR(10) + '     ' +
     ',0 --ETL_DeletedDate'+ CHAR(10) + '     ' +
     ',NULL --ETL_DeletedDate' + CHAR(10) + '     ,' +
          STUFF ((
                    SELECT ',mySource.[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Target)
                         AND (name NOT LIKE 'ETL[_]%'
                              OR name = 'ETL_DeltaHashKey')
					ORDER BY column_id
                    FOR XML PATH('')), 1, 1, '') + ')
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Target + ' WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),''0'');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Target + ' WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),''0'');	


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END

GO'

SELECT @SQL AS [SQL]





GO
