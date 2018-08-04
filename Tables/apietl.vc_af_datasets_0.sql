CREATE TABLE [apietl].[vc_af_datasets_0]
(
[ETL__vc_af_datasets_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__vc_af_dat__ETL____18129287] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[href] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsLoaded] [bit] NULL CONSTRAINT [DF__vc_af_dat__IsLoa__1C8D2EE1] DEFAULT ((0)),
[alternateId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[vc_af_datasets_0] ADD CONSTRAINT [PK__vc_af_da__D42329810BAD17F8] PRIMARY KEY CLUSTERED  ([ETL__vc_af_datasets_id])
GO
