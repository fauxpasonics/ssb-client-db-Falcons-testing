CREATE TABLE [ods].[IMC_RawRecipientData]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__InsertedDate] [datetime] NULL,
[ETL__UpdatedDate] [datetime2] NULL,
[RecipientID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CampaignID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventTimestamp] [datetime2] NULL,
[BodyType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContentId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClickName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[URL] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionAction] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionDetail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConversionAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SuppressionReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FILE_PATH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_EventTimestamp] ON [ods].[IMC_RawRecipientData] ([EventTimestamp])
GO
CREATE NONCLUSTERED INDEX [IX_EventType] ON [ods].[IMC_RawRecipientData] ([EventType])
GO
CREATE NONCLUSTERED INDEX [IX_MailingID] ON [ods].[IMC_RawRecipientData] ([MailingID])
GO
CREATE NONCLUSTERED INDEX [IX_RecipientID] ON [ods].[IMC_RawRecipientData] ([RecipientID])
GO
CREATE NONCLUSTERED INDEX [IX_ReportID] ON [ods].[IMC_RawRecipientData] ([ReportID])
GO
