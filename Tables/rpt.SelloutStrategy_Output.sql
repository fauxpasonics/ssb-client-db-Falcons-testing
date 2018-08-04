CREATE TABLE [rpt].[SelloutStrategy_Output]
(
[DimEventId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [date] NULL,
[EventTime] [time] NULL,
[EventDayOfWeek] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qty] [decimal] (18, 6) NULL,
[Rev] [decimal] (18, 6) NULL,
[Capacity] [decimal] (18, 6) NULL,
[PctSold] [decimal] (18, 6) NULL,
[SortOrder_TicketType] [int] NULL
)
GO
