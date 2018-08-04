CREATE TABLE [stg].[FB_Leads_20180104]
(
[id] [nvarchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_time] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ad_id] [nvarchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ad_name] [nvarchar] (99) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adset_id] [nvarchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adset_name] [nvarchar] (63) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[campaign_id] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[campaign_name] [nvarchar] (69) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[form_id] [nvarchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[form_name] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_organic] [bit] NULL,
[email] [nvarchar] (111) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[first_name] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_name] [nvarchar] (63) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip_code] [nvarchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_number] [nvarchar] (54) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
