CREATE TABLE [apietl].[TurnKey_GetResponseCount_0]
(
[ETL__TurnKey_GetResponseCount_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL,
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SurveyId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseCount] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsLoaded] [bit] NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
)
GO
