SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_DimPriceCode] as (
	SELECT [DimPriceCodeId]
     ,[DimSeasonId]
     ,[DimItemId]
     ,[PriceCode]
     ,[PriceCodeDesc]
     ,[PriceCodeClass]
     ,[PC1]
     ,[PC2]
     ,[PC3]
     ,[PC4]
     ,[IsEnabled]
     ,[EventSallable]
     ,[PcSellable]
     ,[InetPcSellable]
     ,[TotalEvents]
     ,[Price]
     ,[ParentPriceCode]
     ,[TicketTypeCode]
     ,[FullPriceTicketTypeCode]
     ,[TtCode]
     ,[TicketType]
     ,[TicketTypeDesc]
     ,[TicketTypeCategory]
     ,[CompIndicator]
     ,[DefaultHostOfferId]
     ,[TicketTypeRelationship]
     ,[PricingMethod]
     ,[TmPriceLevel]
     ,[TmTicketType]
     ,[TicketTemplateOverride]
     ,[TicketTemplate]
     ,[Code]
     ,[PriceCodeGroup]
     ,[PriceCodeInfo1]
     ,[PriceCodeInfo2]
     ,[PriceCodeInfo3]
     ,[PriceCodeInfo4]
     ,[PriceCodeInfo5]
     ,[Color]
     ,[PrintedPrice]
     ,[PcTicket]
     ,[PcTax]
     ,[PcLicenseFee]
     ,[PcOther1]
     ,[PcOther2]
     ,[TaxRateA]
     ,[TaxRateB]
     ,[TaxRateC]
     ,[OnsaleDatetime]
     ,[OffsaleDatetime]
     ,[InetOnSaleDatetime]
     ,[InetOffSaleDatetime]
     ,[InetPriceCodeName]
     ,[InetOfferText]
     ,[InetFullPrice]
     ,[InetMinTicketsPerTran]
     ,[InetMaxTicketsPerTran]
     ,[TidFamilyId]
     ,[OnPurchAddToAcctGroupId]
     ,[AutoAddMembershipName]
     ,[RequiredMembershipList]
     ,[CardTemplateOverride]
     ,[CardTemplate]
     ,[LedgerId]
     ,[LedgerCode]
     ,[MerchantId]
     ,[MerchantCode]
     ,[MerchantColor]
     ,[MembershipRequiredForPurpose]
     ,[MembershipIdForMembership]
     ,[MembershipName]
     ,[MembershipExpirationDate]
     ,[ClubGroupEnabled]
     ,[IsRenewal]
     ,[SSCreatedBy]
     ,[SSUpdatedBy]
     ,[SSCreatedDate]
     ,[SSUpdatedDate]
     ,[SSID]
     ,[SSID_event_id]
     ,[SSID_price_code]
     ,[SourceSystem]
     ,[DeltaHashKey]
     ,[CreatedBy]
     ,[UpdatedBy]
     ,[CreatedDate]
     ,[UpdatedDate]
     ,[IsDeleted]
     ,[DeleteDate]
     FROM dbo.DimPriceCode (NOLOCK)
)
GO
