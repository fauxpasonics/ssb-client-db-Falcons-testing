SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [apietl].[Load_Turnkey_SurveyResponse]
AS
    BEGIN
        DECLARE @columnname NVARCHAR(255);
        DECLARE @i INT = 1;
        DECLARE @count INT;
        DECLARE @sql NVARCHAR(MAX);

-- new columns
        CREATE TABLE #ColumnAdd
            (
              num INT IDENTITY(1, 1)
            , columnname NVARCHAR(255)
            );

        INSERT  INTO #ColumnAdd
                ( columnname
                )
                SELECT  c.COLUMN_NAME
                FROM    INFORMATION_SCHEMA.COLUMNS AS c
                WHERE   c.TABLE_NAME = 'TurnKey_GetSurveyDataPaged_Table1_1'
                        AND c.COLUMN_NAME NOT IN (
                        'TurnKey_GetSurveyDataPaged_Table1_id',
                        'TurnKey_GetSurveyDataPaged_id' )
                        AND c.COLUMN_NAME NOT IN (
                        SELECT  c.COLUMN_NAME
                        FROM    INFORMATION_SCHEMA.COLUMNS AS c
                        WHERE   c.TABLE_NAME = 'Turnkey_SurveyResponse' );


        SELECT  @count = COUNT(ca.columnname)
        FROM    #ColumnAdd AS ca;

-- Add Columns to ODS
        WHILE ( @i <= @count )
            BEGIN

                SELECT  @columnname = ca.columnname
                FROM    #ColumnAdd AS ca
                WHERE   ca.num = @i;

                SET @sql = 'ALTER TABLE [ods].[Turnkey_SurveyResponse] ADD '
                    + '[' + @columnname + ']' + ' NVARCHAR(4000) NULL';    
                EXEC(@sql);       

                SELECT  @i = @i + 1;

            END;

        DROP TABLE #ColumnAdd;


-- =============================================
--  Add Data to ODS
-- =============================================

-- Insert Columns

        DECLARE @colMerge NVARCHAR(MAX) = '';

        SELECT  @colMerge = @colMerge + '[' + c.COLUMN_NAME + ']' + ' , '
        FROM    INFORMATION_SCHEMA.COLUMNS AS c
        WHERE   c.TABLE_NAME = 'Turnkey_SurveyResponse'
                AND c.COLUMN_NAME NOT IN ( 'ETL__ID' );


--PRINT ( @colMerge );

        SELECT  @colMerge = LEFT(@colMerge, LEN(@colMerge) - LEN(' , '));


-- Source Columns

        DECLARE @colSourceMerge NVARCHAR(MAX) = '';

        SELECT  @colSourceMerge = @colSourceMerge + 'Source.' + '['
                + c.COLUMN_NAME + ']' + ' , '
        FROM    INFORMATION_SCHEMA.COLUMNS AS c
        WHERE   c.TABLE_NAME = 'Turnkey_SurveyResponse'
                AND c.COLUMN_NAME NOT IN ( 'ETL__ID' );

        --PRINT ( @colSourceMerge );


        SELECT  @colSourceMerge = LEFT(@colSourceMerge,
                                       LEN(@colSourceMerge) - LEN(' , '));


-- Merge Statement

        DECLARE @mergeStatement NVARCHAR(MAX) = 'MERGE [ods].[Turnkey_SurveyResponse] AS TARGET'
            + '
USING'
            + '
    (
      SELECT    GETDATE() AS ETL__CreatedDate
              , GETDATE() AS ETL__UpdatedDate
              , sdp0.multi_query_value_for_audit AS survey_id
              , sdpt1.*
      FROM      apietl.TurnKey_GetSurveyDataPaged_0 AS sdp0
                JOIN apietl.TurnKey_GetSurveyDataPaged_Table1_1 sdpt1 ON sdpt1.TurnKey_GetSurveyDataPaged_id = sdp0.TurnKey_GetSurveyDataPaged_id
    ) AS SOURCE
ON TARGET.survey_id = SOURCE.survey_id
    AND TARGET.recordid = SOURCE.recordid
WHEN NOT MATCHED THEN
    INSERT (' + @colMerge + ')' + ' VALUES ' + '(' + @colSourceMerge + ');';


--PRINT @mergeStatement;
      
        EXEC (@mergeStatement);

/* Creating unique customer table to load to MDM and use as an in-between table to get back to surveys responses*/


--INSERT INTO ods.qualtrics_derived_customers (recipientlastname, recipientfirstname, recipientemail, externaldatareference, concat_fields)
--SELECT DISTINCT qsr.recipientlastname, qsr.recipientfirstname, qsr.recipientemail, qsr.externaldatareference, 
--CONCAT(LTRIM(RTRIM(ISNULL(qsr.recipientlastname,''))),LTRIM(RTRIM(ISNULL(qsr.recipientfirstname,''))),LTRIM(RTRIM(ISNULL(qsr.recipientemail,''))),
--LTRIM(RTRIM(ISNULL(qsr.externaldatareference,''))))
--FROM ods.qualtrics_surveyresponse qsr WITH (NOLOCK)
--LEFT JOIN ods.qualtrics_derived_customers qdc WITH (NOLOCK) ON CONCAT(LTRIM(RTRIM(ISNULL(qsr.recipientlastname,''))),LTRIM(RTRIM(ISNULL(qsr.recipientfirstname,''))),LTRIM(RTRIM(ISNULL(qsr.recipientemail,''))),
--LTRIM(RTRIM(ISNULL(qsr.externaldatareference,'')))) = qdc.concat_fields
--WHERE qsr.RecipientEmail IS NOT NULL AND qsr.RecipientEmail <> '' AND ( (qsr.RecipientFirstName IS NOT NULL AND qsr.RecipientFirstName <> '')
--	 OR (qsr.RecipientLastName IS NOT NULL AND qsr.RecipientLastName <> '') ) AND qdc.concat_fields IS NULL 

/* Unpivoting so that I can get question columns and display in Dynamics vertically */
	 
DECLARE 
  @table         NVARCHAR(257) = N'[ods].[Turnkey_SurveyResponse]', 
  @key_column    SYSNAME       = N'recordid';
DECLARE 
  @colNames  NVARCHAR(MAX) = N'',
  @colValues NVARCHAR(MAX) = N'',
  @sql1      NVARCHAR(MAX) = N'';
SELECT 
  @colNames += ', 
    ' + QUOTENAME(name), 
  @colValues += ', 
    ' + QUOTENAME(name) 
   + ' = CONVERT(VARCHAR(320), ' + QUOTENAME(name) + ')'
FROM sys.columns
WHERE [object_id] = OBJECT_ID(@table)
AND name <> @key_column;
SET @sql1 = N'
  INSERT INTO ods.Turnkey_pivot (recordid, property,value)
  SELECT recordid, property, Value --update first value after SELECT to the key column
FROM
(
  SELECT ' + @key_column + @colValues + '
   FROM ' + @table + ' table_alias
   LEFT JOIN (select distinct recordid pivot_recordid from ods.Turnkey_pivot) pivot_alias on table_alias.recordid = pivot_alias.pivot_recordid
   WHERE pivot_alias.pivot_recordid is null
) AS t
UNPIVOT
(
  Value FOR Property IN (' + STUFF(@colNames, 1, 1, '') + ')
) AS up ORDER BY recordid;';
--PRINT @sql1;
EXEC sp_executesql @sql1;

    END;




GO
