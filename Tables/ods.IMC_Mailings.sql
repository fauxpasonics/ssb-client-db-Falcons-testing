CREATE TABLE [ods].[IMC_Mailings]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__InsertedDate] [datetime2] NULL,
[ETL__UpdatedDate] [datetime2] NULL,
[MailingId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mailingName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subject] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentListId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[listName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactListId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactListName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduledTS] [datetime2] NULL,
[SentTS] [datetime2] NULL,
[NumSent] [int] NULL,
[Visibility] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentTemplateId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryId] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueryName] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
