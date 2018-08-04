CREATE TABLE [rpt].[Archive_FalconsSalesByEvent]
(
[ArcYear] [int] NOT NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cnt] [int] NULL,
[qty] [int] NULL,
[rev] [decimal] (38, 6) NULL
)
GO
