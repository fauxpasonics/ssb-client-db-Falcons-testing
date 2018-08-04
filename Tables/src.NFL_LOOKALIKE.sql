CREATE TABLE [src].[NFL_LOOKALIKE]
(
[ID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXISTING_SSB (Y N)] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IF_YES_CREATE_DATE] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_ID ] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRST_NM] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NM] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL_ADDR] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_PRIM_ADDR] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_SEC_ADDR] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_CITY] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_STATE] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_POSTAL_CODE] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_ZIP4] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ATL_FAVE_TEAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNKNOWN_FAVE_TEAM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[atl_ticket_purchaser] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[atl_distance_from_stadium] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rank] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[likelihood] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [NFL_Lookalike_Main] ON [src].[NFL_LOOKALIKE] ([ID])
GO
CREATE NONCLUSTERED INDEX [NFL_Lookalike] ON [src].[NFL_LOOKALIKE] ([SSB_ID ], [FIRST_NM], [LAST_NM], [EMAIL_ADDR], [PHONE])
GO
