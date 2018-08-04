CREATE TABLE [apietl].[silverpop_exportList_errors_0]
(
[ETL__silverpop_exportList_errors_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____72144138] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorRowData] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KeysCount] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValuesCount] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_exportList_errors_0] ADD CONSTRAINT [PK__silverpo__98772E2F7BCA3030] PRIMARY KEY CLUSTERED  ([ETL__silverpop_exportList_errors_id])
GO
