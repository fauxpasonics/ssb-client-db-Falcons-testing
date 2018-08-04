CREATE TABLE [stg].[Facebook_Leads]
(
[SessionId] [uniqueidentifier] NULL,
[RecordCreateDate] [datetime] NOT NULL CONSTRAINT [DF__Facebook___Recor__48730D27] DEFAULT (getutcdate()),
[Processed] [bit] NOT NULL CONSTRAINT [DF__Facebook___Proce__49673160] DEFAULT ((0)),
[DynamicData] [xml] NULL,
[id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_time] [datetime] NULL,
[ad_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ad_name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adset_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adset_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[campaign_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[campaign_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[form_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_organic] [bit] NULL,
[email] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[full_name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip_code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_number] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
