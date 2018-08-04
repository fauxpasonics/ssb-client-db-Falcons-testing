CREATE TABLE [dbo].[tmp_KORE_ExtSysToContact_Post]
(
[Id] [bigint] NULL,
[APIName] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APIEntity] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EndpointName] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceID] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Json_Payload] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[httpAction] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [idx_KORE_ExtSysToContact_Post_ID] ON [dbo].[tmp_KORE_ExtSysToContact_Post] ([Id])
GO
