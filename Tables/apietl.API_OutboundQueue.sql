CREATE TABLE [apietl].[API_OutboundQueue]
(
[QueueID] [bigint] NOT NULL IDENTITY(1, 1),
[APIName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[APIEntity] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EndpointName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Json_Payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[httpAction] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCompleted] [bit] NOT NULL CONSTRAINT [DF__API_OutBo__IsCom__604AC024] DEFAULT ((0)),
[IsVerified] [bit] NOT NULL CONSTRAINT [DF__API_OutBo__IsVer__613EE45D] DEFAULT ((0)),
[IsAttempted] [int] NULL CONSTRAINT [DF__API_OutBo__IsAtt__62330896] DEFAULT ((0)),
[OutcomeMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Queue_ProcessDate] [datetime] NULL,
[Queue_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__API_OutBo__Queue__63272CCF] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[Queue_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__API_OutBo__Queue__641B5108] DEFAULT (suser_sname()),
[Queue_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__API_OutBo__Queue__650F7541] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[Queue_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__API_OutBo__Queue__6603997A] DEFAULT (suser_sname()),
[IssueID] [bigint] NULL
)
GO
ALTER TABLE [apietl].[API_OutboundQueue] ADD CONSTRAINT [PK_API_OutboundQueue] PRIMARY KEY CLUSTERED  ([QueueID])
GO
