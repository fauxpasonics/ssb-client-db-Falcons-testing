CREATE TABLE [ods].[Facebook_Leads]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[id] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_time] [datetime] NULL,
[ad_id] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ad_name] [varchar] (66) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adset_id] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adset_name] [varchar] (34) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[campaign_id] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[campaign_name] [varchar] (38) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[form_id] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_organic] [bit] NULL,
[email] [varchar] (72) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[full_name] [varchar] (58) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip_code] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_number] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
