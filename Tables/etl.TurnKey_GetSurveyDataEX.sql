CREATE TABLE [etl].[TurnKey_GetSurveyDataEX]
(
[JID] [int] NOT NULL,
[ParentJID] [int] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL,
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[key] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [tinyint] NOT NULL,
[IsJSON] [int] NULL,
[Level] [int] NOT NULL
)
GO
