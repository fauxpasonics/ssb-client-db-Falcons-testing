CREATE TABLE [ods].[Infogroup_ecals]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logged_GMT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logged_USNY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OptIn] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[application] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Calendars] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Calendars_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
