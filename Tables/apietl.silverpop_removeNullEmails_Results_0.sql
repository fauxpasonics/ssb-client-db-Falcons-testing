CREATE TABLE [apietl].[silverpop_removeNullEmails_Results_0]
(
[ETL__silverpop_removeNullEmails_Results_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____515D58E3] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Success] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRMSyncID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Result] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SentObject] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_removeNullEmails_Results_0] ADD CONSTRAINT [PK__silverpo__955115EF93AC0CC4] PRIMARY KEY CLUSTERED  ([ETL__silverpop_removeNullEmails_Results_id])
GO
