CREATE TABLE [segmentation].[SegmentationFlatDatab9de3cb1-df0e-4efc-9d02-de36fa4796a1]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDatab9de3cb1-df0e-4efc-9d02-de36fa4796a1] ADD CONSTRAINT [pk_SegmentationFlatDatab9de3cb1-df0e-4efc-9d02-de36fa4796a1] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatab9de3cb1-df0e-4efc-9d02-de36fa4796a1] ON [segmentation].[SegmentationFlatDatab9de3cb1-df0e-4efc-9d02-de36fa4796a1] ([_rn])
GO
