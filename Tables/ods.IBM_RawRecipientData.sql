CREATE TABLE [ods].[IBM_RawRecipientData]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_LoadDate] [datetime] NULL,
[ETL_UpdatedDate] [datetime] NULL,
[Recipient Id] [bigint] NULL,
[Recipient Type] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mailing Id] [int] NULL,
[Report Id] [int] NULL,
[Campaign Id] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event Type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event Timestamp] [datetime] NULL,
[Body Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Content Id] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Click Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[URL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conversion Action] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conversion Detail] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conversion Amount] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suppression Reason] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
