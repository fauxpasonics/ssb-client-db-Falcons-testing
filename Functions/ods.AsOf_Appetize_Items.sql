SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Get the status of your table 20 minutes ago...
DECLARE @AsOfDate DATETIME = (SELECT [etl].[ConvertToLocalTime](DATEADD(MINUTE,-20,GETDATE())))
SELECT * FROM [ods].[AsOf_Appetize_Items] (@AsOfDate)
*/

CREATE FUNCTION [ods].[AsOf_Appetize_Items] (@AsOfDate DATETIME)

RETURNS @Results TABLE
(
[id] [int] NULL,
[item_name] [nvarchar](255) NULL,
[parentItemId] [int] NULL,
[category_id] [int] NULL,
[category_name] [nvarchar](255) NULL,
[item_group_id] [int] NULL,
[item_group_name] [nvarchar](255) NULL,
[item_group2_id] [int] NULL,
[item_group2_name] [nvarchar](255) NULL,
[item_group3_id] [int] NULL,
[item_group3_name] [nvarchar](255) NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] NVARCHAR(400) NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] NVARCHAR(400) NOT NULL
)

AS
BEGIN

DECLARE @EndDate DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS datetime2(0))))
SET @AsOfDate = (SELECT CAST(@AsOfDate AS datetime2(0)))

INSERT INTO @Results
SELECT [id],[item_name],[parentItemId],[category_id],[category_name],[item_group_id],[item_group_name],[item_group2_id],[item_group2_name],[item_group3_id],[item_group3_name],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy]
FROM
	(
	SELECT [id],[item_name],[parentItemId],[category_id],[category_name],[item_group_id],[item_group_name],[item_group2_id],[item_group2_name],[item_group3_id],[item_group3_name],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],@EndDate [RecordEndDate]
	FROM [ods].[Appetize_Items] t
	UNION ALL
	SELECT [id],[item_name],[parentItemId],[category_id],[category_name],[item_group_id],[item_group_name],[item_group2_id],[item_group2_name],[item_group3_id],[item_group3_name],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate]
	FROM [ods].[Snapshot_Appetize_Items]
	) a
WHERE
	@AsOfDate BETWEEN [ETL_UpdatedOn] AND [RecordEndDate]
	AND [ETL_CreatedOn] <= @AsOfDate

RETURN

END
GO
