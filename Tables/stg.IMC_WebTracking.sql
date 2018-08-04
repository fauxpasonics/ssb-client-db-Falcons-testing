CREATE TABLE [stg].[IMC_WebTracking]
(
[ETL__ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[DATABASE_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECIPIENT_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VISITOR_KEY] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SESSION_KEY] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SESSION_START_TS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SESSION_LEAD_SOURCE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_MAILING_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REFERRER_KEYWORDS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_TS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_TYPE_CODE] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_TYPE_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_HYPERLINK_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAGE_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAGE_PARENT_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAGE_PARENT_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_DOMAIN_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_TYPE_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SITE_URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[IMC_WebTracking] ADD CONSTRAINT [PK__IMC_WebT__C4EA2445ACD6FA63] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
