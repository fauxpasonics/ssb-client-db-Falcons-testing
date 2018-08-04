CREATE TABLE [apietl].[silverpop_importList_Results_0]
(
[ETL__silverpop_importList_Results_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____015684C8] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUCCESS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_STATUS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_DESCRIPTION] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_importList_Results_0] ADD CONSTRAINT [PK__silverpo__495EB2EDCB1F3286] PRIMARY KEY CLUSTERED  ([ETL__silverpop_importList_Results_id])
GO
