CREATE TABLE [ods].[Appetize_Items]
(
[id] [int] NOT NULL,
[item_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parentItemId] [int] NULL,
[category_id] [int] NULL,
[category_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item_group_id] [int] NULL,
[item_group_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item_group2_id] [int] NULL,
[item_group2_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[item_group3_id] [int] NULL,
[item_group3_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__Appetize___ETL_C__6255A054] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Appetize___ETL_C__6349C48D] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__Appetize___ETL_U__643DE8C6] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Appetize___ETL_U__65320CFF] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_Appetize_ItemsUpdate] ON [ods].[Appetize_Items]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[Appetize_Items] t
	JOIN inserted i ON  t.[id] = i.[id]

INSERT INTO [ods].[Snapshot_Appetize_Items] ([id],[item_name],[parentItemId],[category_id],[category_name],[item_group_id],[item_group_name],[item_group2_id],[item_group2_name],[item_group3_id],[item_group3_name],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END
GO
ALTER TABLE [ods].[Appetize_Items] ADD CONSTRAINT [PK__Appetize__3213E83F26F9861B] PRIMARY KEY CLUSTERED  ([id])
GO
