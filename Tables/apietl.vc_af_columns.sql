CREATE TABLE [apietl].[vc_af_columns]
(
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__vc_af_col__ETL____31C0EB10] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1),
[IsLoaded] [bit] NULL CONSTRAINT [DF__vc_af_col__IsLoa__1AA4E66F] DEFAULT ((0))
)
GO
