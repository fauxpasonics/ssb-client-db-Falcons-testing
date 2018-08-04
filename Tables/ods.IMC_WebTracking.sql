CREATE TABLE [ods].[IMC_WebTracking]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[DATABASE_ID] [bigint] NULL,
[RECIPIENT_ID] [bigint] NULL,
[VISITOR_KEY] [uniqueidentifier] NULL,
[SESSION_KEY] [uniqueidentifier] NULL,
[SESSION_START_TS] [datetime] NULL,
[SESSION_LEAD_SOURCE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_MAILING_ID] [bigint] NULL,
[REFERRER_KEYWORDS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_ID] [bigint] NULL,
[EVENT_TS] [datetime] NULL,
[EVENT_TYPE_CODE] [bigint] NULL,
[EVENT_TYPE_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_HYPERLINK_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAGE_ID] [bigint] NULL,
[EVENT_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAGE_PARENT_ID] [bigint] NULL,
[PAGE_PARENT_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_DOMAIN_ID] [bigint] NULL,
[SITE_ID] [bigint] NULL,
[SITE_TYPE_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[IMC_WebTracking] ADD CONSTRAINT [PK_ods__IMC_WebTracking] PRIMARY KEY NONCLUSTERED  ([ETL__ID])
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__IMC_WebTracking] ON [ods].[IMC_WebTracking]
GO
CREATE NONCLUSTERED INDEX [IX_Key] ON [ods].[IMC_WebTracking] ([EVENT_ID], [DATABASE_ID]) INCLUDE ([ETL__DeltaHashKey])
GO
