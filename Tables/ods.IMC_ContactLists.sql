CREATE TABLE [ods].[IMC_ContactLists]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__InsertedDate] [datetime] NULL,
[ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SIZE] [int] NULL,
[NUM_OPT_OUTS] [int] NULL,
[NUM_UNDELIVERABLE] [int] NULL,
[LAST_MODIFIED] [datetime2] NULL,
[VISIBILITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PARENT_NAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PARENT_FOLDER_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IS_FOLDER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FLAGGED_FOR_BACKUP] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUPPRESSION_LIST_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__UpdatedDate] [datetime2] NULL
)
GO
