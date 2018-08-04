CREATE TABLE [apietl].[silverpop_get_sent_mailings_for_list_0]
(
[ETL__silverpop_get_sent_mailings_for_list_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____5F016CC4] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduledTS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentListId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SentTS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumSent] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Visibility] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentTemplateId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactListId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactListName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_get_sent_mailings_for_list_0] ADD CONSTRAINT [PK__silverpo__18D8B9E8FD837E3E] PRIMARY KEY CLUSTERED  ([ETL__silverpop_get_sent_mailings_for_list_id])
GO
