CREATE TABLE [apietl].[silverpop_get_lists_0]
(
[ETL__silverpop_get_lists_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____5948936E] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SIZE] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_OPT_OUTS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUM_UNDELIVERABLE] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_MODIFIED] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VISIBILITY] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PARENT_NAME] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PARENT_FOLDER_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_FOLDER] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FLAGGED_FOR_BACKUP] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUPPRESSION_LIST_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_DATABASE_TEMPLATE] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_get_lists_0] ADD CONSTRAINT [PK__silverpo__FE4B0AB4107A8A42] PRIMARY KEY CLUSTERED  ([ETL__silverpop_get_lists_id])
GO
