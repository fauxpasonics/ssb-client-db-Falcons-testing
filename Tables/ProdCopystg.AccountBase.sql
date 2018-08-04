CREATE TABLE [ProdCopystg].[AccountBase]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__AccountBa__ETL_C__77FFC2B3] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__AccountBa__ETL_U__78F3E6EC] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__AccountBa__ETL_I__79E80B25] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[AccountId] [uniqueidentifier] NULL,
[AccountCategoryCode] [int] NULL,
[TerritoryId] [uniqueidentifier] NULL,
[DefaultPriceLevelId] [uniqueidentifier] NULL,
[CustomerSizeCode] [int] NULL,
[PreferredContactMethodCode] [int] NULL,
[CustomerTypeCode] [int] NULL,
[AccountRatingCode] [int] NULL,
[IndustryCode] [int] NULL,
[TerritoryCode] [int] NULL,
[AccountClassificationCode] [int] NULL,
[BusinessTypeCode] [int] NULL,
[OwningBusinessUnit] [uniqueidentifier] NULL,
[OriginatingLeadId] [uniqueidentifier] NULL,
[PaymentTermsCode] [int] NULL,
[ShippingMethodCode] [int] NULL,
[PrimaryContactId] [uniqueidentifier] NULL,
[ParticipatesInWorkflow] [bit] NULL,
[Name] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Revenue] [money] NULL,
[NumberOfEmployees] [int] NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SIC] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnershipCode] [int] NULL,
[MarketCap] [money] NULL,
[SharesOutstanding] [int] NULL,
[TickerSymbol] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StockExchange] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebSiteURL] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FtpSiteURL] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMailAddress1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMailAddress2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMailAddress3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotPhone] [bit] NULL,
[DoNotFax] [bit] NULL,
[Telephone1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotEMail] [bit] NULL,
[Telephone2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotPostalMail] [bit] NULL,
[DoNotBulkEMail] [bit] NULL,
[DoNotBulkPostalMail] [bit] NULL,
[CreditLimit] [money] NULL,
[CreditOnHold] [bit] NULL,
[IsPrivate] [bit] NULL,
[CreatedOn] [datetime] NULL,
[CreatedBy] [uniqueidentifier] NULL,
[ModifiedOn] [datetime] NULL,
[ModifiedBy] [uniqueidentifier] NULL,
[VersionNumber] [binary] (8) NULL,
[ParentAccountId] [uniqueidentifier] NULL,
[Aging30] [money] NULL,
[StateCode] [int] NULL,
[Aging60] [money] NULL,
[StatusCode] [int] NULL,
[Aging90] [money] NULL,
[PreferredAppointmentDayCode] [int] NULL,
[PreferredSystemUserId] [uniqueidentifier] NULL,
[PreferredAppointmentTimeCode] [int] NULL,
[Merged] [bit] NULL,
[DoNotSendMM] [bit] NULL,
[MasterId] [uniqueidentifier] NULL,
[LastUsedInCampaign] [datetime] NULL,
[PreferredServiceId] [uniqueidentifier] NULL,
[PreferredEquipmentId] [uniqueidentifier] NULL,
[ExchangeRate] [numeric] (23, 10) NULL,
[UTCConversionTimeZoneCode] [int] NULL,
[OverriddenCreatedOn] [datetime] NULL,
[TimeZoneRuleVersionNumber] [int] NULL,
[ImportSequenceNumber] [int] NULL,
[TransactionCurrencyId] [uniqueidentifier] NULL,
[CreditLimit_Base] [money] NULL,
[Aging30_Base] [money] NULL,
[Revenue_Base] [money] NULL,
[Aging90_Base] [money] NULL,
[MarketCap_Base] [money] NULL,
[Aging60_Base] [money] NULL,
[YomiName] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [uniqueidentifier] NULL,
[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
[CreatedOnBehalfBy] [uniqueidentifier] NULL,
[OwnerIdType] [int] NULL
)
GO
ALTER TABLE [ProdCopystg].[AccountBase] ADD CONSTRAINT [PK__AccountB__7EF6BFCD9B3B8DBF] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
