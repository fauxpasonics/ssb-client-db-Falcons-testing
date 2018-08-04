CREATE TABLE [etl].[Log_TurnkeySurvey]
(
[ETL__multi_query_value_for_audit] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[logdatetime] [datetime] NULL,
[id] [int] NOT NULL IDENTITY(1, 1)
)
GO
