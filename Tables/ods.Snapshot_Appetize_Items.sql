CREATE TABLE [ods].[Snapshot_Appetize_Items]
(
[Appetize_ItemsSK] [int] NOT NULL IDENTITY(1, 1),
[id] [int] NULL,
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
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_Appetize_Items] ADD CONSTRAINT [PK__Snapshot__42995369CCAB0BF3] PRIMARY KEY CLUSTERED  ([Appetize_ItemsSK])
GO
