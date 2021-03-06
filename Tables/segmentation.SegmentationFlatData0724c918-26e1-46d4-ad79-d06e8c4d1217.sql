CREATE TABLE [segmentation].[SegmentationFlatData0724c918-26e1-46d4-ad79-d06e8c4d1217]
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
ALTER TABLE [segmentation].[SegmentationFlatData0724c918-26e1-46d4-ad79-d06e8c4d1217] ADD CONSTRAINT [pk_SegmentationFlatData0724c918-26e1-46d4-ad79-d06e8c4d1217] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData0724c918-26e1-46d4-ad79-d06e8c4d1217] ON [segmentation].[SegmentationFlatData0724c918-26e1-46d4-ad79-d06e8c4d1217] ([_rn])
GO
