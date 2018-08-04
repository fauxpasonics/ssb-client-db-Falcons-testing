CREATE TABLE [stg].[Infogroup_mlsliveorder]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customerid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date_mlslive] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subscription] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Currency] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[primary_customerid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
