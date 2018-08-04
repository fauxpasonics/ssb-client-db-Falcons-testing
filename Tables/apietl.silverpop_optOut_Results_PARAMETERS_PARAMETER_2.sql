CREATE TABLE [apietl].[silverpop_optOut_Results_PARAMETERS_PARAMETER_2]
(
[ETL__silverpop_optOut_Results_PARAMETERS_PARAMETER_id] [uniqueidentifier] NOT NULL,
[ETL__silverpop_optOut_Results_PARAMETERS_id] [uniqueidentifier] NULL,
[NAME] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VALUE] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_optOut_Results_PARAMETERS_PARAMETER_2] ADD CONSTRAINT [PK__silverpo__CC68B4D8A6EB9000] PRIMARY KEY CLUSTERED  ([ETL__silverpop_optOut_Results_PARAMETERS_PARAMETER_id])
GO
