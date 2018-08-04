SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[sp_StagetoRegularTable]
@DBName VARCHAR(50), @MainTblName VARCHAR(50), @StgTblName VARCHAR(50), @Variance FLOAT, @DefaultIDIndex BIT
AS
-- dbo.sp_StagetoRegularTable 'Texas_SFDC','ProdCopy.Account','ProdCopystg.Account',0.2, 1
DECLARE @AzureCheck BIT, @CleanDBName VARCHAR(50)
SET @AzureCheck = (SELECT CASE WHEN @@VERSION LIKE '%Azure%' THEN 1 ELSE 0 END)
SET @DBName = (SELECT CASE WHEN @AzureCheck = 1 THEN '' ELSE @DBName END)
SET @CleanDBName = (SELECT CASE WHEN @AzureCheck = 1 THEN @DBName ELSE @DBName + '.' END)

DECLARE @VariableCheck FLOAT, @MainTblSchema VARCHAR(50), @StgTblSchema VARCHAR(50)
, @TblNameONLY VARCHAR(50), @MainTblClean VARCHAR(50), @StgTblClean VARCHAR(50)
, @MainTblFound INT, @MainTblFoundSQL NVARCHAR(MAX)
, @StgTblFound INT, @StgTblFoundSQL NVARCHAR(MAX)
, @MainTblCount BIGINT, @MainSQL NVARCHAR(MAX)
, @StgTblCount BIGINT, @StgSQL NVARCHAR(MAX)
, @Count BIGINT	
, @ParmDefinition NVARCHAR(100)

SET @ParmDefinition = N' @CountOUT varchar(30) OUTPUT';
--SET @DBName = 'PSP_SFDC'
--SET @MainTblName = 'dbo.TestTable'
SET @TblNameONLY = (SELECT RIGHT(@MainTblName,LEN(@MainTblName) - CHARINDEX('.',@MainTblName,0)))
SET @MainTblSchema = (SELECT LEFT(@MainTblName,CHARINDEX('.',@MainTblName,0)-1))
--SET @StgTblName = 'stg.TestTable'
SET @StgTblSchema = (SELECT LEFT(@StgTblName,CHARINDEX('.',@StgTblName,0)-1))
SET @MainTblClean = REPLACE(REPLACE(@MainTblName,'[',''),']','')
SET @StgTblClean = REPLACE(REPLACE(@StgTblName,'[',''),']','')
SET @Variance = 0.2


PRINT @TblNameONLY

SET @MainTblFoundSQL = 'SET @CountOUT = (SELECT COUNT(schs.name + ''.'' + tbls.Name)
						FROM ' + @DBName + '.' + 'sys.tables tbls 
						INNER JOIN ' + @DBName + '.' + 'sys.schemas schs ON schs.schema_id = tbls.schema_id
						WHERE schs.name + ''.'' + tbls.Name = ''' + @MainTblClean + ''')'
PRINT @MaintblFoundSQL

BEGIN TRY
	EXEC sp_executeSQL @MainTblFoundSQL, @ParmDefinition, @CountOUT=@Count OUTPUT; 
	SET @MainTblFound = @Count
	PRINT @COUNT
END TRY
BEGIN CATCH
	PRINT 'No Main Table Found'
	SET @MainTblFound = 0
END CATCH

SET @StgTblFoundSQL = 'SET @CountOUT = (SELECT COUNT(schs.name + ''.'' + tbls.Name)
						FROM ' + @DBName + '.' + 'sys.tables tbls 
						INNER JOIN ' + @DBName + '.' + 'sys.schemas schs ON schs.schema_id = tbls.schema_id
						WHERE schs.name + ''.'' + tbls.Name = ''' + @StgTblClean + ''')'
PRINT @StgTblFoundSQL

BEGIN TRY
	EXEC sp_executeSQL @StgTblFoundSQL, @ParmDefinition, @CountOUT=@Count OUTPUT; 
	SET @StgTblFound = @Count
	PRINT @COUNT
END TRY	
BEGIN CATCH
	PRINT 'No Stg Table Found'
	SET @StgTblFound = 0
END CATCH

IF @StgTblFound = 0 AND @MainTblFound = 1
BEGIN
	IF @AzureCheck = 0 
	SET @MainSQL = 'Use ' + @DBName 
	
	SET @MainSQL = ' Select Top 0 * INTO ' + @StgTblName + ' from ' + @MainTblName
	PRINT @MainSQl

		EXEC sp_executeSQL @MainSQL
		SET @MainTblFound = 0
		RETURN
END

IF @StgTblFound = 0
BEGIN
	PRINT 'STG TBL NOT FOUND - CANNOT CONTINUE'
	RETURN
END

IF @MainTblFound = 1
BEGIN
BEGIN TRY
	PRINT 'Get Counts'
	IF @AzureCheck = 0 
	SET @MainSQL = 'Use [' + @DBName + '.' + ']' 

	SET @MainSQL = ' SET @CountOUT = (Select Count(*) from ' + @MainTblName + ')'
	PRINT @MainSQL

	IF @AzureCheck = 0 
	SET @StgSQL = 'Use [' + @DBName + '.' + ']'
	
	SET @StgSQL = ' SET @CountOUT = (Select Count(*) from ' + @StgTblName + ')'
	PRINT @StgSQL
	EXEC sp_executeSQL @MainSQL, @ParmDefinition, @CountOUT=@Count OUTPUT;
	SET @MainTblCount = @Count
	PRINT @MainTblCount
	EXEC sp_executeSQL @StgSQL, @ParmDefinition, @CountOUT=@Count OUTPUT;
	SET @StgTblCount = @Count
	PRINT @StgTblCount
END TRY
BEGIN CATCH
	PRINT @@ERROR
	DECLARE @SQL NVARCHAR(4000)

	--IF @AzureCheck = 0 
	--SET @SQL = 'USE ' + @DBName + '.' + ' CREATE SCHEMA ' + @MainTblSche
	--EXEC sp_executesql @SQL

END CATCH
END

SET @VariableCheck = 1-(ISNULL(@MainTblCount / NULLIF(@StgTblCount,0),@Variance))
SET @VariableCheck = 1
PRINT LTRIM(STR(@MainTblCount)) + ' Main Table Count'
PRINT LTRIM(STR(1-@VariableCheck)) + ' VariableCheck'
PRINT 1+ @Variance 
PRINT 1- @Variance

IF @VariableCheck BETWEEN 1 - @Variance AND 1 + @Variance OR @MainTblCount = 0
BEGIN
PRINT 'START TABLE SWAP'
	-- Drop Main Table
	IF @MainTblFound = 1
	BEGIN
		SET @MainSQL = ''
		IF @AzureCheck = 0 
		SET @MainSQL = 'Use ' + @DBName 
		
		SET @MainSQL = @MainSQL + ' DROP TABLE ' + @MainTblName
		PRINT @MainSQl
		EXEC sp_executeSQL @MainSQL
	END

	-- Rename Stg Table
	IF @MainTblSchema <> @StgTblSchema
	BEGIN
		SET @MainSQL = ''
		IF @AzureCheck = 0 
		SET @MainSQL = 'Use ' + @DBName 
		
		SET @MainSQL = @MainSQL + ' ALTER SCHEMA ' + @MainTblSchema + ' TRANSFER ' + @StgTblName
	END

	IF @MainTblSchema = @StgTblSchema
	BEGIN
		SET @MainSQL = ''
		IF @AzureCheck = 0 
		SET @MainSQL = 'Use ' + @DBName 
		
		SET @MainSQL = @MainSQL + ' Exec sp_Rename ''' + @StgTblName + ''', ''' + @MainTblName + ''', ''Table'''
	END
	PRINT @MainSQl
	EXEC sp_executeSQL @MainSQL

	-- Re-create Stg Table
	SET @MainSQL = ''
	IF @AzureCheck = 0 
	SET @MainSQL = 'Use ' + @DBName 
	
	SET @MainSQL = @MainSQL + ' Select Top 0 * INTO ' + @StgTblName + ' from ' + @MainTblName + 
					' ALTER TABLE ' + @StgTblName + ' ADD CONSTRAINT DF_' + REPLACE(@MainTblClean,'.','_') + ' DEFAULT GETDATE() FOR COPYLOADDATE'
	PRINT @MainSQl
	EXEC sp_executeSQL @MainSQL

DECLARE @TableID BIGINT
SET @TableID = (OBJECT_ID(@DBName + '.' + '.' + @MainTblName,'U'))

	IF @DefaultIDIndex = 1
	BEGIN
		PRINT 'Default Index Create - ID'
		SET @MainSQL = ''
		IF @AzureCheck = 0 
			SET @MainSQL = 'Use ' + @DBName 
		
		SET @MainSQL = @MainSQL + ' ALTER TABLE ' + @MainTblName + ' ALTER COLUMN ID NVARCHAR(18) NOT NULL'
		PRINT @MainSQL
		EXEC sp_executeSQL @MainSQL

		SET @MainSQL = ''
		IF @AzureCheck = 0 
			SET @MainSQL = 'Use ' + @DBName 
		
		SET @MainSQL = @MainSQL + ' ALTER TABLE ' + @MainTblName + ' ADD CONSTRAINT PK_' + REPLACE(@MainTblClean,'.','_') + ' PRIMARY KEY CLUSTERED (	Id	) '
		PRINT @MainSQL
		EXEC sp_executeSQL @MainSQL

		IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'SSB_CRMSYSTEM_ACCT_ID__c' AND Object_ID = @TableID)
		BEGIN
		PRINT 'Create AcctGUID Index'

		SET @MainSQL = ''
		IF @AzureCheck = 0 
			SET @MainSQL = 'USE ' + @DBName 
		
		SET @MainSQL = @MainSQL + ' CREATE NONCLUSTERED INDEX IDX_' + REPLACE(@MainTblClean,'.','_') + '_ACCTGUID ON ' + @MainTblName + ' ([SSB_CRMSYSTEM_ACCT_ID__c])'
		PRINT @MainSQL
		EXEC sp_executeSQL @MainSQL
		END

		IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'SSB_CRMSYSTEM_CONTACT_ID__c' AND Object_ID = @TableID)
		BEGIN
		PRINT 'Create ContactGUID Index'
		SET @MainSQL = ''
		IF @AzureCheck = 0 
			SET @MainSQL = 'USE ' + @DBName 
			
		SET @MainSQL = @MainSQL + ' CREATE NONCLUSTERED INDEX IDX_' + REPLACE(@MainTblClean,'.','_') + '_CONTACTGUID ON ' + @MainTblName + ' ([SSB_CRMSYSTEM_CONTACT_ID__c])'
		PRINT @MainSQL
		EXEC sp_executeSQL @MainSQL
		END
		
	END

	PRINT @MainTblSchema
	IF @MainTblSchema = 'ProdCopy'
	BEGIN
	
		IF( @TableID > 0 )
		BEGIN
			IF (OBJECT_ID(CASE WHEN @AzureCheck = 0 THEN @DBName + '.' ELSE '' END + @MainTblSchema + '.vw_' + REPLACE(REPLACE(@TblNameONLY,'[',''),']',''),'V') > 0)
			BEGIN
			PRINT 'SET UP PRODCOPY VIEW'			
			SET @SQL = 'DROP VIEW ' + @MainTblSchema + '.vw_' + REPLACE(REPLACE(@TblNameONLY,'[',''),']','')
			
			IF @AzureCheck = 0 
				SET @SQL = 'USE ' + @DBName + '.' + '  ' + @SQL

				PRINT @SQL
				EXEC sp_executesql @SQL
			END

			IF @AzureCheck = 0 
			BEGIN
				SET @SQL = 'Use ' + @DBName
				EXEC sp_executesql @SQL
			END


			SET @SQL = ' CREATE VIEW ' + @MainTblSchema + '.vw_' + REPLACE(REPLACE(@TblNameONLY,'[',''),']','') + ' AS 
						---- CREATED BY PROCESS ON ' + CAST(CONVERT(DATETIME, GETDATE(),102) AS VARCHAR(500)) + '
						Select * from ' + @MainTblName + ' Where 1=1 '
			IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'IsDeleted' AND Object_ID = @TableID)
			BEGIN
				SET @Sql = @SQL + 'and IsDeleted = 0'
			END

			IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'IsConverted' AND Object_ID = @TableID)
			BEGIN
				SET @SQL = @SQL + ' and IsConverted = 0'
			END

			PRINT @SQL
			IF @AzureCheck = 1
				SET @SQL = 'Exec ' + 'dbo.sp_executesql N''' + @SQL + ''''
			IF @AzureCheck = 0 
				SET @SQL = 'Exec ' + @DBName + '.' + 'dbo.sp_executesql N''' + @SQL + ''''
			PRINT @SQL
			
			EXEC sp_executesql @SQL
		END

	END

END


GO
