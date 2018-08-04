CREATE TABLE [etl].[IMC_EmailSummary_MSCRM]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublicWebviewURL] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryResult] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryCount] [int] NULL,
[MinDeliveryTime] [datetime] NULL,
[OpenCount] [int] NULL,
[MinOpenTime] [datetime] NULL,
[ClickCount] [int] NULL,
[MinClickTime] [datetime] NULL,
[ETL_CreatedDate] [datetime] NULL,
[ETL_UpdatedDate] [datetime] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_CustID] ON [etl].[IMC_EmailSummary_MSCRM] ([SSB_CRMSYSTEM_CONTACT_ID])
GO
