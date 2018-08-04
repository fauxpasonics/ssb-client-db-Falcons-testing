SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[sp_Load_ods_IMC_SourceData]
AS
IF OBJECT_ID('tempdb..#AllEmails') IS NOT NULL
    DROP TABLE #AllEmails;

SELECT DISTINCT
        dc.EmailPrimary ,
        ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
        dc.EmailPrimaryDirtyHash ,
        MAX(ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG) SSB_CRMSYSTEM_PRIMARY_FLAG
		--,ROW_NUMBER() OVER (PARTITION BY dc.EmailPrimary ORDER BY ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG DESC) EmailRank 
INTO    #AllEmails
FROM    dbo.DimCustomer dc ( NOLOCK )
        JOIN dbo.dimcustomerssbid ssbid ON ssbid.DimCustomerId = dc.DimCustomerId
WHERE   ISNULL(dc.EmailPrimary, '') <> ''
        AND dc.EmailPrimaryIsCleanStatus NOT LIKE 'Invalid%'
GROUP BY dc.EmailPrimary ,
        ssbid.SSB_CRMSYSTEM_CONTACT_ID ,
        dc.EmailPrimaryDirtyHash 
		 --,ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG
		 ; 

IF OBJECT_ID('tempdb..#BaseData') IS NOT NULL
    DROP TABLE #BaseData;
SELECT  ae.EmailPrimary ,
        ae.SSB_CRMSYSTEM_CONTACT_ID ,
        ae.EmailPrimaryDirtyHash ,
        dcm.FirstName ,
        dcm.LastName ,
        dcm.AddressPrimaryStreet ,
        dcm.AddressPrimarySuite ,
        dcm.AddressPrimaryCity ,
        dcm.AddressPrimaryState ,
        dcm.AddressPrimaryZip ,
        dcm.AddressPrimaryCounty ,
        dcm.AddressPrimaryCountry ,
        dcm.PhonePrimary ,
        dcm.PhoneCell ,
        dcm.Gender ,
        dcm.Birthday
INTO    #BaseData
FROM    dbo.vwCompositeRecord_ModAcctID dcm
        JOIN #AllEmails ae ON ae.SSB_CRMSYSTEM_CONTACT_ID = dcm.SSB_CRMSYSTEM_CONTACT_ID
                              AND ae.EmailPrimary = dcm.EmailPrimary;

IF OBJECT_ID('tempdb..#FinalData') IS NOT NULL
    DROP TABLE #FinalData;
SELECT DISTINCT
    bd.*,
    dc.SSID,
    dc.CreatedDate,
    dc.UpdatedDate,
    ROW_NUMBER() OVER (PARTITION BY dc.EmailPrimary
                       ORDER BY ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG DESC,
                                dc.AccountId ASC,
                                dc.SSCreatedDate DESC
                      ) EmailRank
INTO #FinalData
FROM #BaseData bd
    LEFT JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
        ON ssbid.SSB_CRMSYSTEM_CONTACT_ID = bd.SSB_CRMSYSTEM_CONTACT_ID
           AND ssbid.SourceSystem = 'Legacy_Dynamics_Contact'
    LEFT JOIN dbo.DimCustomer dc (NOLOCK)
        ON dc.DimCustomerId = ssbid.DimCustomerId
           AND dc.EmailPrimaryDirtyHash = bd.EmailPrimaryDirtyHash;
--SELECT * FROM #FinalData WHERE EmailPrimary = 'vickieedenny@yahoo.com'
--TRUNCATE TABLE ods.IMC_SourceData

CREATE TABLE #Staged
    (
      [Opt In Details] NVARCHAR(500) ,
      [Email Type] NVARCHAR(500) ,
      [CRM Account ID] NVARCHAR(500) ,
      [CRM Enable Sync] NVARCHAR(500) ,
      [Opted Out Date] NVARCHAR(500) ,
      [CRM Sync ID] NVARCHAR(500) ,
      [EMAIL] NVARCHAR(500) ,
      [CRM Lead Source] NVARCHAR(500) ,
      [Last Modified Date] NVARCHAR(500) ,
      [Opt Out Details] NVARCHAR(500) ,
      [CRM Contact Type] NVARCHAR(500) ,
      [Opt In Date] NVARCHAR(500) ,
      [CREATED_FROM] NVARCHAR(500) ,
      [21 or older] VARCHAR(3) ,
      [Academy Team] VARCHAR(3) ,
      [Academy Tried Out] VARCHAR(3) ,
      [Address1_City] NVARCHAR(500) ,
      [Address1_Country] NVARCHAR(500) ,
      [Address1_County] NVARCHAR(500) ,
      [Address1_Line1] NVARCHAR(500) ,
      [Address1_Line2] NVARCHAR(500) ,
      [Address1_Line3] NVARCHAR(500) ,
      [Address1_PostalCode] NVARCHAR(500) ,
      [Address1_StateOrProvince] NVARCHAR(500) ,
      [AF Season Schedule] NVARCHAR(500) ,
      [Agree Official Rules] VARCHAR(3) ,
      [AllowSMS] VARCHAR(3) ,
      [Appointment Time] NVARCHAR(500) ,
      [AssistantName] NVARCHAR(500) ,
      [AssistantPhone] NVARCHAR(500) ,
      [AUExclusiveContentNotifications] INT ,
      [AUInTheStadiumNotifications] INT ,
      [AUMatchStartNotifications] INT ,
      [AUParkingAndTransitNotifications] INT ,
      [AUScoringNotifications] INT ,
      [AUTeamNewsNotifications] INT ,
      [BirthDate] VARCHAR(25) ,
      [cdi_facebook] NVARCHAR(500) ,
      [cdi_linkedin] NVARCHAR(500) ,
      [cdi_twitter] NVARCHAR(500) ,
      [client_ambffsuppression] VARCHAR(3) ,
      [client_BWContactId] NVARCHAR(500) ,
      [Company] NVARCHAR(500) ,
      [Corporate Entertainment] VARCHAR(3) ,
      [CRM_Contact_ID] NVARCHAR(500) ,
      [Current Stadium Employee] VARCHAR(3) ,
      [DoNotBulkEMail] VARCHAR(3) ,
      [DoNotBulkPostalMail] VARCHAR(3) ,
      [DoNotEMail] VARCHAR(3) ,
      [DoNotPostalMail] VARCHAR(3) ,
      [Falcons Group] VARCHAR(3) ,
      [Falcons Home Opponents] NVARCHAR(500) ,
      [Falcons Insider] VARCHAR(3) ,
      [Falcons Season Ticket Holder] NVARCHAR(500) ,
      [Falcons Season Tix Due] NVARCHAR(500) ,
      [Falcons Seating Preference] NVARCHAR(500) ,
      [Falcons SGB TE TF] VARCHAR(3) ,
      [FirstName] NVARCHAR(500) ,
      [Founding Members no seats] VARCHAR(3) ,
      [Founding Members with seats] VARCHAR(3) ,
      [FullName] NVARCHAR(500) ,
      [GA Dome Premium Events] NVARCHAR(500) ,
      [GA Dome Seating Preferences] NVARCHAR(500) ,
      [GenderCode] NVARCHAR(500) ,
      [Group Size] NVARCHAR(500) ,
      [Group Type] NVARCHAR(500) ,
      [HasChildrenCode] INT ,
      [JobTitle] NVARCHAR(500) ,
      [KIA Account] VARCHAR(3) ,
      [kore_accountaliasidName] NVARCHAR(500) ,
      kore_address1milesfromfacility DECIMAL ,
      kore_BWBaseDate NVARCHAR(500) ,
      kore_BWCompanyId NVARCHAR(500) ,
      kore_BWContactId NVARCHAR(500) ,
      kore_BWSequence INT ,
      kore_CheckedOutById NVARCHAR(500) ,
      kore_CheckedOutByIdName NVARCHAR(500) ,
      kore_InvoiceBalance MONEY ,
      kore_PrimaryAccountNumber NVARCHAR(500) ,
      kore_SinceDate VARCHAR(25) ,
      KORE_Type INT ,
      Last_Click VARCHAR(24) ,
      Last_Open VARCHAR(24) ,
      Last_Sent VARCHAR(24) ,
      LastName NVARCHAR(500) ,
      [MBS Hiring Emails] VARCHAR(3) ,
      MiddleName NVARCHAR(500) ,
      [Mobile User Id] NVARCHAR(500) ,
      MobilePhone NVARCHAR(500) ,
      [My Finder] NVARCHAR(500) ,
      new_Address1_MetroArea NVARCHAR(500) ,
      new_AFYFNetwork VARCHAR(3) ,
      new_AMBFFNewsletter VARCHAR(3) ,
      new_AMBFFTrustees VARCHAR(3) ,
      new_AmericanExplorers VARCHAR(3) ,
      new_AtlantaFalconsNationalFootballLeague VARCHAR(3) ,
      new_AtlantaUnitedFCEventsFanPerksa VARCHAR(3) ,
      new_AtlantaUnitedFCMajorLeagueSoccer VARCHAR(3) ,
      new_BrokerFlag VARCHAR(3) ,
      new_FalconsNASSurveyLink NVARCHAR(500) ,
      new_FanCouncilURL NVARCHAR(500) ,
      new_FoundationSubscription NVARCHAR(500) ,
      new_HasKidsunder18 VARCHAR(3) ,
      new_MLSFoundersSurveyLink NVARCHAR(500) ,
      new_MLSLiveCode NVARCHAR(500) ,
      new_new_subscription_MLSOfficialGearMail NVARCHAR(500) ,
      new_NFLAccount NVARCHAR(500) ,
      new_NFLAccountPassword NVARCHAR(500) ,
      new_NFLMC1 NVARCHAR(500) ,
      new_NFLMCCode1 NVARCHAR(500) ,
      new_NFLMCCode2 NVARCHAR(500) ,
      new_NFLMCCode3 NVARCHAR(500) ,
      new_NFLMCCode4 NVARCHAR(500) ,
      new_NFLMCURL2 NVARCHAR(500) ,
      new_NSCheckedOutBy NVARCHAR(500) ,
      new_NSCheckedOutByName NVARCHAR(500) ,
      new_NSLicenseeName NVARCHAR(500) ,
      new_RelocationDateTime NVARCHAR(500) ,
      new_SponsorshipCheckedOutBy NVARCHAR(500) ,
      new_SponsorshipCheckedOutByName NVARCHAR(500) ,
      new_Subscription_MLSSubscription VARCHAR(3) ,
      new_Subscription_PreferredPartner VARCHAR(3) ,
      new_Subscription_Ticket_Offers VARCHAR(3) ,
      new_subscriptionNewStadiumInformationOffers VARCHAR(3) ,
      new_UnitedCheckedOutBy NVARCHAR(500) ,
      new_UnitedCheckedOutByName NVARCHAR(500) ,
      new_VirtualseatView NVARCHAR(500) ,
      new_WNPFNetwork VARCHAR(3) ,
      [Opt Out of Arthur M Blank Foundation Email Communication] VARCHAR(3) ,
      [Opt Out of Atlanta Falcons Email Communication] VARCHAR(3) ,
      [Opt Out of Atlanta United Email Communication] VARCHAR(3) ,
      [Part Time Positions] NVARCHAR(500) ,
      [Phone Call Opt In] VARCHAR(3) ,
      [Playoff Payment] VARCHAR(3) ,
      [Preferred Partner] VARCHAR(3) ,
      [Preferred Ticket Price] NVARCHAR(500) ,
      [PreferredLanguage] NVARCHAR(500) ,
      [Primary Rep] NVARCHAR(500) ,
      [Primary Rep Email] NVARCHAR(500) ,
      [Primary Rep Name] NVARCHAR(500) ,
      [Primary Rep Phone] NVARCHAR(500) ,
      [PSL Owner] VARCHAR(3) ,
      [Question or Comment] NVARCHAR(500) ,
      [Salutation] NVARCHAR(500) ,
      [Seating Level Preference] NVARCHAR(500) ,
      [Send Hour] NVARCHAR(500) ,
      [StateCode] NVARCHAR(500) ,
      [Suffix] NVARCHAR(500) ,
      [Team Member Referral] NVARCHAR(500) ,
      [Team Member Requirements] NVARCHAR(500) ,
      [Telephone1] NVARCHAR(500) ,
      [Telephone2] NVARCHAR(500) ,
      [United Season Ticket Holder] NVARCHAR(500) ,
      [United Seating Preference] NVARCHAR(500) ,
      [UnitedStayConnected] VARCHAR(3) ,
      [UTD Acct Number] NVARCHAR(500) ,
      [UTD Event Sign Up] NVARCHAR(500) ,
      [UTD Group] VARCHAR(3) ,
      [UTD Multi Game] VARCHAR(3) ,
      [UTD Season Schedule] NVARCHAR(500) ,
      [UTD Season Tix Due] MONEY ,
      [UTD SGB TE TF] VARCHAR(3) ,
      [UTD Test_Behavior] NVARCHAR(500) ,
      [UTD Test_Rank] NVARCHAR(500) ,
      [UTD Test_Score] NVARCHAR(500) ,
      [MOBILE_USER_ID] NVARCHAR(500) ,
      [MBS Seating Interest] NVARCHAR(500),
	  PSL_Owner_SSB VARCHAR(3),
	  [2017_United_STM_Paid] VARCHAR(3),
	  United_MultiPack_SSB VARCHAR(3), 
	  United_SingleGameBuyer_SSB VARCHAR(3),
	  [2017_Falcons_STM_Paid] VARCHAR(3),
	  Falcons_SingleGameBuyer_SSB VARCHAR(3)
    );
INSERT  INTO #Staged
        ( [Opt In Details] ,
          [Email Type] ,
          [CRM Account ID] ,
          [CRM Enable Sync] ,
          [Opted Out Date] ,
          [CRM Sync ID] ,
          EMAIL ,
          [CRM Lead Source] ,
          [Last Modified Date] ,
          [Opt Out Details] ,
          [CRM Contact Type] ,
          [Opt In Date] ,
          CREATED_FROM ,
          [21 or older] ,
          [Academy Team] ,
          [Academy Tried Out] ,
          Address1_City ,
          Address1_Country ,
          Address1_County ,
          Address1_Line1 ,
          Address1_Line2 ,
          Address1_Line3 ,
          Address1_PostalCode ,
          Address1_StateOrProvince ,
          [AF Season Schedule] ,
          [Agree Official Rules] ,
          AllowSMS ,
          [Appointment Time] ,
          AssistantName ,
          AssistantPhone ,
          AUExclusiveContentNotifications ,
          AUInTheStadiumNotifications ,
          AUMatchStartNotifications ,
          AUParkingAndTransitNotifications ,
          AUScoringNotifications ,
          AUTeamNewsNotifications ,
          BirthDate ,
          cdi_facebook ,
          cdi_linkedin ,
          cdi_twitter ,
          client_ambffsuppression ,
          client_BWContactId ,
          Company ,
          [Corporate Entertainment] ,
          CRM_Contact_ID ,
          [Current Stadium Employee] ,
          DoNotBulkEMail ,
          DoNotBulkPostalMail ,
          DoNotEMail ,
          DoNotPostalMail ,
          [Falcons Group] ,
          [Falcons Home Opponents] ,
          [Falcons Insider] ,
          [Falcons Season Ticket Holder] ,
          [Falcons Season Tix Due] ,
          [Falcons Seating Preference] ,
          [Falcons SGB TE TF] ,
          FirstName ,
          [Founding Members no seats] ,
          [Founding Members with seats] ,
          FullName ,
          [GA Dome Premium Events] ,
          [GA Dome Seating Preferences] ,
          GenderCode ,
          [Group Size] ,
          [Group Type] ,
          HasChildrenCode ,
          JobTitle ,
          [KIA Account] ,
          kore_accountaliasidName ,
          kore_address1milesfromfacility ,
          kore_BWBaseDate ,
          kore_BWCompanyId ,
          kore_BWContactId ,
          kore_BWSequence ,
          kore_CheckedOutById ,
          kore_CheckedOutByIdName ,
          kore_InvoiceBalance ,
          kore_PrimaryAccountNumber ,
          kore_SinceDate ,
          KORE_Type ,
          Last_Click ,
          Last_Open ,
          Last_Sent ,
          LastName ,
          [MBS Hiring Emails] ,
          MiddleName ,
          [Mobile User Id] ,
          MobilePhone ,
          [My Finder] ,
          new_Address1_MetroArea ,
          new_AFYFNetwork ,
          new_AMBFFNewsletter ,
          new_AMBFFTrustees ,
          new_AmericanExplorers ,
          new_AtlantaFalconsNationalFootballLeague ,
          new_AtlantaUnitedFCEventsFanPerksa ,
          new_AtlantaUnitedFCMajorLeagueSoccer ,
          new_BrokerFlag ,
          new_FalconsNASSurveyLink ,
          new_FanCouncilURL ,
          new_FoundationSubscription ,
          new_HasKidsunder18 ,
          new_MLSFoundersSurveyLink ,
          new_MLSLiveCode ,
          new_new_subscription_MLSOfficialGearMail ,
          new_NFLAccount ,
          new_NFLAccountPassword ,
          new_NFLMC1 ,
          new_NFLMCCode1 ,
          new_NFLMCCode2 ,
          new_NFLMCCode3 ,
          new_NFLMCCode4 ,
          new_NFLMCURL2 ,
          new_NSCheckedOutBy ,
          new_NSCheckedOutByName ,
          new_NSLicenseeName ,
          new_RelocationDateTime ,
          new_SponsorshipCheckedOutBy ,
          new_SponsorshipCheckedOutByName ,
          new_Subscription_MLSSubscription ,
          new_Subscription_PreferredPartner ,
          new_Subscription_Ticket_Offers ,
          new_subscriptionNewStadiumInformationOffers ,
          new_UnitedCheckedOutBy ,
          new_UnitedCheckedOutByName ,
          new_VirtualseatView ,
          new_WNPFNetwork ,
          [Opt Out of Arthur M Blank Foundation Email Communication] ,
          [Opt Out of Atlanta Falcons Email Communication] ,
          [Opt Out of Atlanta United Email Communication] ,
          [Part Time Positions] ,
          [Phone Call Opt In] ,
          [Playoff Payment] ,
          [Preferred Partner] ,
          [Preferred Ticket Price] ,
          PreferredLanguage ,
          [Primary Rep] ,
          [Primary Rep Email] ,
          [Primary Rep Name] ,
          [Primary Rep Phone] ,
          [PSL Owner] ,
          [Question or Comment] ,
          Salutation ,
          [Seating Level Preference] ,
          [Send Hour] ,
          StateCode ,
          Suffix ,
          [Team Member Referral] ,
          [Team Member Requirements] ,
          Telephone1 ,
          Telephone2 ,
          [United Season Ticket Holder] ,
          [United Seating Preference] ,
          UnitedStayConnected ,
          [UTD Acct Number] ,
          [UTD Event Sign Up] ,
          [UTD Group] ,
          [UTD Multi Game] ,
          [UTD Season Schedule] ,
          [UTD Season Tix Due] ,
          [UTD SGB TE TF] ,
          [UTD Test_Behavior] ,
          [UTD Test_Rank] ,
          [UTD Test_Score] ,
          MOBILE_USER_ID ,
          [MBS Seating Interest],
		  PSL_Owner_SSB ,
		  [2017_United_STM_Paid] ,
		  United_MultiPack_SSB , 
		  United_SingleGameBuyer_SSB ,
		  [2017_Falcons_STM_Paid] ,
		  Falcons_SingleGameBuyer_SSB
        )
        SELECT  CASE WHEN imc.[Opt In Details] IS NOT NULL
                     THEN imc.[Opt In Details]
                     ELSE 'Added Via SSB API'
                END AS OptInDetails ,
                CASE WHEN imc.[Email Type] IS NOT NULL THEN imc.[Email Type]
                     ELSE 0
                END AS EmailType ,
                pcc.accountid ,
                0 CRMEnabledSync , --CRM ENABLED SYNC
                CASE WHEN imc.[Opted Out Date] IS NOT NULL
                     THEN imc.[Opted Out Date]
                     ELSE ''
                END OptedOutDate ,
                pcc.contactid ,
                dc.EmailPrimary Email ,
                ISNULL(pcc.new_source, '') NewSource ,
                '' LastModifiedDate , --Last Modified Date
                CASE WHEN imc.[Opt Out Details] IS NOT NULL
                     THEN imc.[Opt Out Details]
                     ELSE ''
                END OptOutDetails ,
                CASE WHEN imc.[CRM Contact Type] IS NOT NULL
                     THEN imc.[CRM Contact Type]
                     WHEN dc.SSID IS NOT NULL THEN 2
                     ELSE 1
                END ContactType ,
                CASE WHEN imc.[Opt In Date] IS NOT NULL
                          AND imc.[Opt In Date] <> '' THEN imc.[Opt In Date]
                     ELSE CONVERT(VARCHAR(10), GETDATE(), 101)
                END OptInDate ,
                '' CreatedFrom , --Created From
                CASE WHEN DATEADD(YEAR, 21, pcc.birthdate) <= GETDATE()
                          AND pcc.birthdate <> '1900-01-01 00:00:00.000'
                     THEN 'Yes'
                     WHEN DATEADD(YEAR, 21, imc.BirthDate) <= GETDATE()
                          AND imc.BirthDate <> '' THEN 'Yes'
                     WHEN DATEADD(YEAR, 21, pcc.birthdate) > GETDATE()
                          AND pcc.birthdate <> '1900-01-01 00:00:00.000'
                     THEN 'No'
                     WHEN DATEADD(YEAR, 21, imc.BirthDate) > GETDATE()
                          AND imc.BirthDate <> '' THEN 'No'
                     WHEN DATEADD(YEAR, 21, dc.Birthday) <= GETDATE()
                          AND dc.Birthday <> '1900-01-01 00:00:00.000'
                     THEN 'Yes'
                     WHEN DATEADD(YEAR, 21, dc.Birthday) > GETDATE() THEN 'No'
                     ELSE ''
                END AS Is21 ,
                CASE WHEN pcc.client_academyteam = '1' THEN 'Yes'
                     WHEN pcc.client_academyteam = '0' THEN 'No'
                     ELSE ''
                END AS AcademyTeam ,
                CASE WHEN pcc.client_academytriedout = '1' THEN 'Yes'
                     WHEN imc.[Academy Tried Out] = '0' THEN 'No'
                     ELSE ''
                END AS AcademyTriedOut ,
                CASE WHEN ISNULL(dc.AddressPrimaryCity, '') <> ''
                     THEN dc.AddressPrimaryCity
                     WHEN ISNULL(dc.AddressPrimaryCity, '') = ''
                          AND ISNULL(pcc.address1_city, '') <> ''
                     THEN pcc.address1_city
                     WHEN ISNULL(dc.AddressPrimaryCity, '') = ''
                          AND ISNULL(pcc.address1_city, '') = ''
                          AND ISNULL(imc.Address1_City, '') <> ''
                     THEN imc.Address1_City
                     ELSE ''
                END AS Address1_city ,
                CASE WHEN ISNULL(dc.AddressPrimaryCountry, '') <> ''
                     THEN dc.AddressPrimaryCountry
                     WHEN ISNULL(dc.AddressPrimaryCountry, '') = ''
                          AND ISNULL(pcc.address1_country, '') <> ''
                     THEN pcc.address1_country
                     WHEN ISNULL(dc.AddressPrimaryCountry, '') = ''
                          AND ISNULL(pcc.address1_country, '') = ''
                          AND ISNULL(imc.Address1_Country, '') <> ''
                     THEN imc.Address1_Country
                     ELSE ''
                END AS Address1_Country ,
                CASE WHEN ISNULL(dc.AddressPrimaryCounty, '') <> ''
                     THEN dc.AddressPrimaryCounty
                     WHEN ISNULL(dc.AddressPrimaryCounty, '') = ''
                          AND ISNULL(pcc.address1_county, '') <> ''
                     THEN pcc.address1_county
                     WHEN ISNULL(dc.AddressPrimaryCounty, '') = ''
                          AND ISNULL(pcc.address1_county, '') = ''
                          AND ISNULL(imc.Address1_County, '') <> ''
                     THEN imc.Address1_County
                     ELSE ''
                END AS Address1_County ,
                CASE WHEN ISNULL(dc.AddressPrimaryStreet, '') <> ''
                     THEN dc.AddressPrimaryStreet
                     WHEN ISNULL(dc.AddressPrimaryStreet, '') = ''
                          AND ISNULL(pcc.address1_line1, '') <> ''
                     THEN pcc.address1_line1
                     WHEN ISNULL(dc.AddressPrimaryStreet, '') = ''
                          AND ISNULL(pcc.address1_line1, '') = ''
                          AND ISNULL(imc.Address1_Line1, '') <> ''
                     THEN imc.Address1_Line1
                     ELSE ''
                END AS Address1_Line1 ,
                CASE WHEN ISNULL(dc.AddressPrimarySuite, '') <> ''
                     THEN dc.AddressPrimarySuite
                     WHEN ISNULL(dc.AddressPrimarySuite, '') = ''
                          AND ISNULL(pcc.address1_line2, '') <> ''
                     THEN pcc.address1_line2
                     WHEN ISNULL(dc.AddressPrimarySuite, '') = ''
                          AND ISNULL(pcc.address1_line2, '') = ''
                          AND ISNULL(imc.Address1_Line2, '') <> ''
                     THEN imc.Address1_Line2
                     ELSE ''
                END AS Address1_Line2 ,
                CASE WHEN ISNULL(dc.AddressPrimaryStreet, '') <> '' THEN ''
                     WHEN ISNULL(dc.AddressPrimaryStreet, '') = ''
                          AND ISNULL(pcc.address1_line3, '') <> ''
                     THEN pcc.address1_line3
                     WHEN ISNULL(dc.AddressPrimaryStreet, '') = ''
                          AND ISNULL(pcc.address1_line3, '') = ''
                          AND ISNULL(imc.Address1_Line3, '') <> ''
                     THEN imc.Address1_Line3
                     ELSE ''
                END AS Address1_Line3 ,
                CASE WHEN ISNULL(dc.AddressPrimaryZip, '') <> ''
                     THEN dc.AddressPrimaryZip
                     WHEN ISNULL(dc.AddressPrimaryZip, '') = ''
                          AND ISNULL(pcc.address1_postalcode, '') <> ''
                     THEN pcc.address1_postalcode
                     WHEN ISNULL(dc.AddressPrimaryZip, '') = ''
                          AND ISNULL(pcc.address1_postalcode, '') = ''
                          AND ISNULL(imc.Address1_PostalCode, '') <> ''
                     THEN imc.Address1_PostalCode
                     ELSE ''
                END AS Address1_PostalCode ,
                CASE WHEN ISNULL(dc.AddressPrimaryState, '') <> ''
                     THEN dc.AddressPrimaryState
                     WHEN ISNULL(dc.AddressPrimaryState, '') = ''
                          AND ISNULL(pcc.address1_stateorprovince, '') <> ''
                     THEN pcc.address1_stateorprovince
                     WHEN ISNULL(dc.AddressPrimaryState, '') = ''
                          AND ISNULL(pcc.address1_stateorprovince, '') = ''
                          AND ISNULL(imc.Address1_StateOrProvince, '') <> ''
                     THEN imc.Address1_StateOrProvince
                     ELSE ''
                END AS Address1_StateorProvince ,
                pcc.client_falcons2016schedule ,
                '' OfficialRules ,--Agree Official Rules
                CASE WHEN pcc.client_sp_allowsms = '1' THEN 'Yes'
                     WHEN pcc.client_sp_allowsms = '0' THEN 'No'
                     ELSE ''
                END AllowSMS ,
                '' ApptTime , --appointment time
                pcc.assistantname ,
                pcc.assistantphone ,
                ISNULL(imc.AUExclusiveContentNotifications, '') AUExclusiveNotifications ,
                ISNULL(imc.AUInTheStadiumNotifications, '') AUInTheStadiumNotifications ,
                ISNULL(imc.AUMatchStartNotifications, '') AUMatchStartNotifications ,
                ISNULL(imc.AUParkingAndTransitNotifications, '') AUParkingAndTransitNotifications ,
                ISNULL(imc.AUScoringNotifications, '') AUScoringNotifications ,
                ISNULL(imc.AUTeamNewsNotifications, '') AUTeamNewsNotifications ,
                CASE WHEN ISNULL(dc.Birthday, '') <> ''
                     THEN CONVERT(VARCHAR(10), dc.Birthday, 101)
                     WHEN ISNULL(dc.Birthday, '') = ''
                          AND ISNULL(pcc.birthdate, '') <> ''
                     THEN CONVERT(VARCHAR(10), pcc.birthdate, 101)
                     WHEN ISNULL(dc.Birthday, '') = ''
                          AND ISNULL(pcc.birthdate, '') = ''
                          AND ISNULL(imc.BirthDate, '') <> ''
                     THEN imc.BirthDate
                     ELSE ''
                END AS Birthdate ,
                pcc.cdi_facebook ,
                pcc.cdi_linkedin ,
                pcc.cdi_twitter ,
                CASE WHEN pcc.client_ambffsuppression = '1' THEN 'Yes'
                     WHEN imc.client_ambffsuppression = '0' THEN 'No'
                     ELSE ''
                END AS client_ambffsuppression ,
                pcc.client_bwcontactid ,
                REPLACE(pcc.company, ',', '') company ,
                ISNULL(imc.[Corporate Entertainment], '') corporateentertainment ,
                pcc.contactid ,
                ISNULL(imc.[Current Stadium Employee], '') currentstadiumemployee ,
                CASE WHEN pcc.donotbulkemail = '1' THEN 'Yes'
                     WHEN pcc.donotbulkemail = '0' THEN 'No'
                     ELSE ''
                END donotbulkemail ,
                CASE WHEN pcc.donotbulkpostalmail = '1' THEN 'Yes'
                     WHEN pcc.donotbulkpostalmail = '0' THEN 'No'
                     ELSE ''
                END donotbulkpostalmail ,
                CASE WHEN pcc.donotemail = '1' THEN 'Yes'
                     WHEN pcc.donotemail = '0' THEN 'No'
                     ELSE ''
                END donotemail ,
                CASE WHEN pcc.donotpostalmail = '1' THEN 'Yes'
                     WHEN pcc.donotpostalmail = '0' THEN 'No'
                     ELSE ''
                END donotpostalmail ,
                CASE WHEN pcc.client_falconsgroup = '1' THEN 'Yes'
                     WHEN pcc.client_falconsgroup = '0' THEN 'No'
                     ELSE ''
                END client_falconsgroup ,
                pcc.client_falconshomeopponents ,
                CASE WHEN pcc.new_subscription_ereport = '1' THEN 'Yes'
                     WHEN pcc.new_subscription_ereport = 0 THEN 'No'
                     ELSE ''
                END new_subscription_ereport ,
                pcc.client_falconssth ,
                ISNULL(imc.[Falcons Season Tix Due], '') [Falcons Season Tix Due] ,
                pcc.client_gadomeseatingpreferences ,
                CASE WHEN pcc.client_falconssgbtetf = '1' THEN 'Yes'
                     WHEN pcc.client_falconssgbtetf = '0' THEN 'No'
                     ELSE ''
                END client_falconssgbtetf ,
                CASE WHEN ISNULL(dc.FirstName, '') <> '' THEN dc.FirstName
                     WHEN ISNULL(dc.FirstName, '') = ''
                          AND ISNULL(pcc.firstname, '') <> ''
                     THEN pcc.firstname
                     WHEN ISNULL(dc.FirstName, '') = ''
                          AND ISNULL(pcc.firstname, '') = ''
                          AND ISNULL(imc.FirstName, '') <> ''
                     THEN imc.FirstName
                     ELSE ''
                END AS FirstName ,
                CASE WHEN pcc.client_foundingmembersnoseats = '1' THEN 'Yes'
                     WHEN pcc.client_foundingmembersnoseats = '0' THEN 'No'
                     ELSE ''
                END client_foundingmembersnoseats ,
                CASE WHEN pcc.client_foundingmember = '1' THEN 'Yes'
                     WHEN pcc.client_foundingmember = '0' THEN 'No'
                     ELSE ''
                END client_foundingmember ,
                pcc.fullname ,
                client_gadomepremiumevents ,
                pcc.client_gadomeseatingpreferences ,
                dc.Gender ,
                pcc.client_groupsize ,
                CASE WHEN ISNULL(pcc.new_typeofgroup, '') <> ''
                     THEN pcc.new_typeofgroup
                     WHEN ISNULL(pcc.new_typeofgroup, '') = ''
                          AND ISNULL(pcc.client_grouptype, '') <> ''
                     THEN pcc.client_grouptype
                     ELSE ''
                END ,
                pcc.haschildrencode ,
                pcc.jobtitle ,
                CASE WHEN pcc.client_kiabuyer = '1' THEN 'Yes'
                     WHEN pcc.client_kiabuyer = '0' THEN 'No'
                     ELSE ''
                END client_kiabuyer ,
                pcc.kore_accountaliasidname ,
                pcc.kore_address1milesfromfacility ,
                pcc.kore_bwbasedate ,
                pcc.kore_bwcompanyid ,
                pcc.kore_bwcontactid ,
                pcc.kore_bwsequence ,
                pcc.kore_checkedoutbyid ,
                pcc.kore_checkedoutbyidname ,
                pcc.kore_invoicebalance ,
                pcc.kore_primaryaccountnumber ,
                CONVERT(VARCHAR(10), pcc.kore_sincedate, 101) kore_sincedate ,
                pcc.kore_type ,
                '' client_sp_lastclick ,
                '' client_sp_lastopen ,
                '' client_sp_lastsend ,
                CASE WHEN ISNULL(dc.LastName, '') <> '' THEN dc.LastName
                     WHEN ISNULL(dc.LastName, '') = ''
                          AND ISNULL(pcc.lastname, '') <> '' THEN pcc.lastname
                     WHEN ISNULL(dc.LastName, '') = ''
                          AND ISNULL(pcc.lastname, '') = ''
                          AND ISNULL(imc.LastName, '') <> '' THEN imc.LastName
                     ELSE ''
                END AS LastName ,
                ISNULL(imc.[MBS Hiring Emails], '') [MBS Hiring Emails] ,
                pcc.middlename ,
                ISNULL(imc.[Mobile User Id], '') [Mobile User Id] ,
                CASE WHEN ISNULL(dc.PhoneCell, '') <> '' THEN dc.PhoneCell
                     ELSE pcc.mobilephone
                END AS mobilephone ,
                CASE WHEN pcc.new_myfinder = '1' THEN 'Yes'
                     WHEN pcc.new_myfinder = '0' THEN 'No'
                     ELSE ''
                END new_myfinder ,
                pcc.new_address1_metroarea ,
                CASE WHEN pcc.new_afyfnetwork = '1' THEN 'Yes'
                     WHEN pcc.new_afyfnetwork = '0' THEN 'No'
                     ELSE ''
                END new_afyfnetwork ,
                CASE WHEN pcc.new_ambffnewsletter = '1' THEN 'Yes'
                     WHEN pcc.new_ambffnewsletter = '0' THEN 'No'
                     ELSE ''
                END new_ambffnewsletter ,
                CASE WHEN pcc.new_ambfftrustees = '1' THEN 'Yes'
                     WHEN pcc.new_ambfftrustees = '0' THEN 'No'
                     ELSE ''
                END new_ambfftrustees ,
                CASE WHEN pcc.new_americanexplorers = '1' THEN 'Yes'
                     WHEN pcc.new_americanexplorers = '0' THEN 'No'
                     ELSE ''
                END new_americanexplorers ,
                CASE WHEN pcc.new_atlantafalconsnationalfootballleague = '1'
                     THEN 'Yes'
                     WHEN pcc.new_atlantafalconsnationalfootballleague = '0'
                     THEN 'No'
                     ELSE ''
                END new_atlantafalconsnationalfootballleague ,
                CASE WHEN pcc.new_atlantaunitedfceventsfanperksa = '1'
                     THEN 'Yes'
                     WHEN pcc.new_atlantaunitedfceventsfanperksa = '0'
                     THEN 'No'
                     ELSE ''
                END new_atlantaunitedfceventsfanperksa ,
                CASE WHEN pcc.new_atlantaunitedfcmajorleaguesoccer = '1'
                     THEN 'Yes'
                     WHEN pcc.new_atlantaunitedfcmajorleaguesoccer = '0'
                     THEN 'No'
                     ELSE ''
                END new_atlantaunitedfcmajorleaguesoccer ,
                CASE WHEN pcc.new_brokerflag = '1' THEN 'Yes'
                     WHEN pcc.new_brokerflag = '0' THEN 'No'
                     ELSE ''
                END new_brokerflag ,
                pcc.new_falconsnassurveylink ,
                pcc.new_fancouncilurl ,
                pcc.new_foundationsubscription ,
                CASE WHEN pcc.new_haskidsunder18 = '1' THEN 'Yes'
                     WHEN pcc.new_haskidsunder18 = '0' THEN 'No'
                     ELSE ''
                END new_haskidsunder18 ,
                pcc.new_mlsfounderssurveylink ,
                pcc.new_mlslivecode ,
                CASE WHEN imc.new_new_subscription_MLSOfficialGearMail = '1'
                     THEN 'Yes'
                     WHEN imc.new_new_subscription_MLSOfficialGearMail = '0'
                     THEN 'No'
                     ELSE ''
                END new_new_subscription_MLSOfficialGearMail ,
                pcc.new_nflaccount ,
                pcc.new_nflaccountpassword ,
                pcc.new_nflmc1 ,
                pcc.new_nflmccode1 ,
                pcc.new_nflmccode2 ,
                pcc.new_nflmccode3 ,
                pcc.new_nflmccode4 ,
                pcc.new_nflmcurl2 ,
                pcc.new_nscheckedoutby ,
                pcc.new_nscheckedoutbyname ,
                pcc.new_nslicenseename ,
                CASE WHEN pcc.new_relocationdatetime LIKE '[0-9]%/%'
                     THEN CONCAT(CONVERT(VARCHAR(10), pcc.new_relocationdatetime, 101),
                                 ' ',
                                 CONVERT(VARCHAR, pcc.new_relocationdatetime, 108))
                     ELSE ''
                END AS new_relocationdatetime ,
                pcc.new_sponsorshipcheckedoutby ,
                pcc.new_sponsorshipcheckedoutbyname ,
                CASE WHEN pcc.new_subscription_mlssubscription = '1'
                     THEN 'Yes'
                     WHEN pcc.new_subscription_mlssubscription = '0' THEN 'No'
                     ELSE ''
                END new_subscription_mlssubscription ,
                CASE WHEN pcc.new_subscription_preferredpartner = '1'
                     THEN 'Yes'
                     WHEN pcc.new_subscription_preferredpartner = '0'
                     THEN 'No'
                     ELSE ''
                END new_subscription_preferredpartner ,
                CASE WHEN pcc.new_subscription_ticket_offers = '1' THEN 'Yes'
                     WHEN pcc.new_subscription_ticket_offers = '0' THEN 'No'
                     ELSE ''
                END new_subscription_ticket_offers ,
                CASE WHEN pcc.new_subscriptionnewstadiuminformationoffers = '1'
                     THEN 'Yes'
                     WHEN pcc.new_subscriptionnewstadiuminformationoffers = '0'
                     THEN 'No'
                     ELSE ''
                END new_subscriptionnewstadiuminformationoffers ,
                pcc.new_unitedcheckedoutby ,
                pcc.new_unitedcheckedoutbyname ,
                pcc.new_virtualseatview ,
                CASE WHEN pcc.new_wnpfnetwork = '1' THEN 'Yes'
                     WHEN pcc.new_wnpfnetwork = '0' THEN 'No'
                     ELSE ''
                END new_wnpfnetwork ,
                CASE WHEN pcc.client_sp_optoutambff = '1' THEN 'Yes'
                     WHEN pcc.client_sp_optoutambff = '0' THEN 'No'
                     ELSE ''
                END client_sp_optoutambff ,
                CASE WHEN pcc.client_sp_optoutfalcons = '1' THEN 'Yes'
                     WHEN pcc.client_sp_optoutfalcons = '0' THEN 'No'
                     ELSE ''
                END client_sp_optoutfalcons ,
                CASE WHEN pcc.client_sp_optoutatlutd = '1' THEN 'Yes'
                     WHEN pcc.client_sp_optoutatlutd = '0' THEN 'No'
                     ELSE ''
                END client_sp_optoutatlutd ,
                pcc.client_parttimepositioninterest ,
                ISNULL(imc.[Phone Call Opt In], '') [Phone Call Opt In] ,
                CASE WHEN pcc.client_playoffpayment = '1' THEN 'Yes'
                     WHEN pcc.client_playoffpayment = '0' THEN 'No'
                     ELSE ''
                END client_playoffpayment ,
                CASE WHEN pcc.new_subscription_preferredpartner = '1'
                     THEN 'Yes'
                     WHEN pcc.new_subscription_preferredpartner = '0'
                     THEN 'No'
                     ELSE ''
                END new_Subscription_PreferredPartner ,
                pcc.client_preferredprice ,
                client_preferredlanguage ,
                client_primaryrep ,
                client_primaryrepemail ,
                client_primaryrepname ,
                client_primaryrepphone ,
                CASE WHEN pcc.client_pslowner = '1' THEN 'Yes'
                     WHEN pcc.client_pslowner = '0' THEN 'No'
                     ELSE ''
                END client_pslowner ,
                pcc.client_questionorcomment ,
                pcc.salutation ,
                pcc.client_seatinglevelpreference ,
                ISNULL(imc.[Send Hour], '') [Send Hour] ,
                pcc.statecode ,
                pcc.suffix ,
                pcc.client_referredby ,
                ISNULL([Team Member Requirements], '') [Team Member Requirements] ,
                CASE WHEN ISNULL(dc.PhonePrimary, '') <> ''
                     THEN dc.PhonePrimary
                     ELSE pcc.telephone1
                END AS telephone1 ,
                pcc.telephone2 ,
                CASE WHEN pcc.client_utdseasonticketholder = '1' THEN 'Yes'
                     WHEN pcc.client_utdseasonticketholder = '0' THEN 'No'
                     ELSE ''
                END client_utdseasonticketholder ,
                client_utdseatingpreferences ,
                CASE WHEN pcc.new_atlantaunitedfceventsfanperksa = '1'
                     THEN 'Yes'
                     WHEN pcc.new_atlantaunitedfceventsfanperksa = '0'
                     THEN 'No'
                     ELSE ''
                END new_atlantaunitedfceventsfanperksa ,
                new_utdacct ,
                client_utdeventsignup ,
                CASE WHEN pcc.client_utdgroup = '1' THEN 'Yes'
                     WHEN pcc.client_utdgroup = '0' THEN 'No'
                     ELSE ''
                END client_utdgroup ,
                CASE WHEN pcc.client_utdmultigame = '1' THEN 'Yes'
                     WHEN pcc.client_utdmultigame = '0' THEN 'No'
                     ELSE ''
                END client_utdmultigame ,
                client_utdseasonschedule ,
                pcc.client_utdseasontixdue ,
                CASE WHEN pcc.client_utdsgbtetf = '1' THEN 'Yes'
                     WHEN pcc.client_utdsgbtetf = '0' THEN 'No'
                     ELSE ''
                END client_utdsgbtetf ,
                ISNULL(imc.[UTD Test_Behavior], '') [UTD Test_Behavior] ,
                ISNULL(imc.[UTD Test_Rank], '') [UTD Test_Rank] ,
                ISNULL(imc.[UTD Test_Score], '') [UTD Test_Score] ,
                ISNULL(imc.[Mobile User Id], '') [Mobile User Id] ,
                pcc.client_mbsseatingpreferences,
				NULL   PSL_Owner_SSB ,
				NULL [2017_United_STM_Paid] ,
				NULL United_MultiPack_SSB , 
				NULL United_SingleGameBuyer_SSB ,
				NULL [2017_Falcons_STM_Paid] ,
				NULL Falcons_SingleGameBuyer_SSB
        FROM    #FinalData dc
                LEFT JOIN Falcons_Reporting.Prodcopy.Contact pcc ( NOLOCK ) ON dc.SSID = pcc.contactid
                LEFT JOIN ods.IMC_ProductionCopy_MasterDB imc ( NOLOCK ) ON imc.Email = pcc.emailaddress1
                                                              AND imc.[CRM Sync ID] = CONVERT(VARCHAR(255), pcc.contactid)
        WHERE   dc.EmailRank = 1
                AND ( DATEDIFF(DAY, dc.CreatedDate, GETDATE()) <= 10
                      OR DATEDIFF(DAY, dc.UpdatedDate, GETDATE()) <= 10
                    );
--SELECT * FROM #Staged WHERE Email = 'vickieedenny@yahoo.com'

MERGE ods.IMC_SourceData AS myTarget
USING
    ( SELECT    *
      FROM      #Staged
    ) AS mySource
ON ( myTarget.EMAIL = mySource.EMAIL
     AND myTarget.[CRM Sync ID] = mySource.[CRM Sync ID]
   )
WHEN MATCHED THEN
    UPDATE SET myTarget.[21 or older] = mySource.[21 or older] ,
               myTarget.[Academy Team] = mySource.[Academy Team] ,
               myTarget.[Academy Tried Out] = mySource.[Academy Tried Out] ,
               myTarget.[Address1_City] = mySource.[Address1_City] ,
               myTarget.[Address1_Country] = mySource.[Address1_Country] ,
               myTarget.[Address1_County] = mySource.[Address1_County] ,
               myTarget.[Address1_Line1] = mySource.[Address1_Line1] ,
               myTarget.[Address1_Line2] = mySource.[Address1_Line2] ,
               myTarget.[Address1_Line3] = mySource.[Address1_Line3] ,
               myTarget.[Address1_PostalCode] = mySource.[Address1_PostalCode] ,
               myTarget.[Address1_StateOrProvince] = mySource.[Address1_StateOrProvince] ,
               myTarget.[AF Season Schedule] = mySource.[AF Season Schedule] ,
               myTarget.[Agree Official Rules] = mySource.[Agree Official Rules] ,
               myTarget.[AllowSMS] = mySource.[AllowSMS] ,
               myTarget.[Appointment Time] = mySource.[Appointment Time] ,
               myTarget.[AssistantName] = mySource.[AssistantName] ,
               myTarget.[AssistantPhone] = mySource.[AssistantPhone] ,
               myTarget.[AUExclusiveContentNotifications] = mySource.[AUExclusiveContentNotifications] ,
               myTarget.[AUInTheStadiumNotifications] = mySource.[AUInTheStadiumNotifications] ,
               myTarget.[AUMatchStartNotifications] = mySource.[AUMatchStartNotifications] ,
               myTarget.[AUParkingAndTransitNotifications] = mySource.[AUParkingAndTransitNotifications] ,
               myTarget.[AUScoringNotifications] = mySource.[AUScoringNotifications] ,
               myTarget.[AUTeamNewsNotifications] = mySource.[AUTeamNewsNotifications] ,
               myTarget.[BirthDate] = mySource.[BirthDate] ,
               myTarget.[cdi_facebook] = mySource.[cdi_facebook] ,
               myTarget.[cdi_linkedin] = mySource.[cdi_linkedin] ,
               myTarget.[cdi_twitter] = mySource.[cdi_twitter] ,
               myTarget.[client_ambffsuppression] = mySource.[client_ambffsuppression] ,
               myTarget.[client_BWContactId] = mySource.[client_BWContactId] ,
               myTarget.[Company] = mySource.[Company] ,
               myTarget.[Corporate Entertainment] = mySource.[Corporate Entertainment] ,
               myTarget.[CRM_Contact_ID] = mySource.[CRM_Contact_ID] ,
               myTarget.[Current Stadium Employee] = mySource.[Current Stadium Employee] ,
               myTarget.[DoNotBulkEMail] = mySource.[DoNotBulkEMail] ,
               myTarget.[DoNotBulkPostalMail] = mySource.[DoNotBulkPostalMail] ,
               myTarget.[DoNotEMail] = mySource.[DoNotEMail] ,
               myTarget.[DoNotPostalMail] = mySource.[DoNotPostalMail] ,
               myTarget.[Falcons Group] = mySource.[Falcons Group] ,
               myTarget.[Falcons Home Opponents] = mySource.[Falcons Home Opponents] ,
               myTarget.[Falcons Insider] = mySource.[Falcons Insider] ,
               myTarget.[Falcons Season Ticket Holder] = mySource.[Falcons Season Ticket Holder] ,
               myTarget.[Falcons Season Tix Due] = mySource.[Falcons Season Tix Due] ,
               myTarget.[Falcons Seating Preference] = mySource.[Falcons Seating Preference] ,
               myTarget.[Falcons SGB TE TF] = mySource.[Falcons SGB TE TF] ,
               myTarget.[FirstName] = mySource.[FirstName] ,
               myTarget.[Founding Members no seats] = mySource.[Founding Members no seats] ,
               myTarget.[Founding Members with seats] = mySource.[Founding Members with seats] ,
               myTarget.[FullName] = mySource.[FullName] ,
               myTarget.[GA Dome Premium Events] = mySource.[GA Dome Premium Events] ,
               myTarget.[GA Dome Seating Preferences] = mySource.[GA Dome Seating Preferences] ,
               myTarget.[GenderCode] = mySource.[GenderCode] ,
               myTarget.[Group Size] = mySource.[Group Size] ,
               myTarget.[Group Type] = mySource.[Group Type] ,
               myTarget.[HasChildrenCode] = mySource.[HasChildrenCode] ,
               myTarget.[JobTitle] = mySource.[JobTitle] ,
               myTarget.[KIA Account] = mySource.[KIA Account] ,
               myTarget.[kore_accountaliasidName] = mySource.[kore_accountaliasidName] ,
               myTarget.[kore_address1milesfromfacility] = mySource.[kore_address1milesfromfacility] ,
               myTarget.[kore_BWBaseDate] = mySource.[kore_BWBaseDate] ,
               myTarget.[kore_BWCompanyId] = mySource.[kore_BWCompanyId] ,
               myTarget.[kore_BWContactId] = mySource.[kore_BWContactId] ,
               myTarget.[kore_BWSequence] = mySource.[kore_BWSequence] ,
               myTarget.[kore_CheckedOutById] = mySource.[kore_CheckedOutById] ,
               myTarget.[kore_CheckedOutByIdName] = mySource.[kore_CheckedOutByIdName] ,
               myTarget.[kore_InvoiceBalance] = mySource.[kore_InvoiceBalance] ,
               myTarget.[kore_PrimaryAccountNumber] = mySource.[kore_PrimaryAccountNumber] ,
               myTarget.[kore_SinceDate] = mySource.[kore_SinceDate] ,
               myTarget.[KORE_Type] = mySource.[KORE_Type] ,
               myTarget.[Last_Click] = mySource.[Last_Click] ,
               myTarget.[Last_Open] = mySource.[Last_Open] ,
               myTarget.[Last_Sent] = mySource.[Last_Sent] ,
               myTarget.[LastName] = mySource.[LastName] ,
               myTarget.[MBS Hiring Emails] = mySource.[MBS Hiring Emails] ,
               myTarget.[MiddleName] = mySource.[MiddleName] ,
               myTarget.[Mobile User Id] = mySource.[Mobile User Id] ,
               myTarget.[MobilePhone] = mySource.[MobilePhone] ,
               myTarget.[My Finder] = mySource.[My Finder] ,
               myTarget.[new_Address1_MetroArea] = mySource.[new_Address1_MetroArea] ,
               myTarget.[new_AFYFNetwork] = mySource.[new_AFYFNetwork] ,
               myTarget.[new_AMBFFNewsletter] = mySource.[new_AMBFFNewsletter] ,
               myTarget.[new_AMBFFTrustees] = mySource.[new_AMBFFTrustees] ,
               myTarget.[new_AmericanExplorers] = mySource.[new_AmericanExplorers] ,
               myTarget.[new_AtlantaFalconsNationalFootballLeague] = mySource.[new_AtlantaFalconsNationalFootballLeague] ,
               myTarget.[new_AtlantaUnitedFCEventsFanPerksa] = mySource.[new_AtlantaUnitedFCEventsFanPerksa] ,
               myTarget.[new_AtlantaUnitedFCMajorLeagueSoccer] = mySource.[new_AtlantaUnitedFCMajorLeagueSoccer] ,
               myTarget.[new_BrokerFlag] = mySource.[new_BrokerFlag] ,
               myTarget.[new_FalconsNASSurveyLink] = mySource.[new_FalconsNASSurveyLink] ,
               myTarget.[new_FanCouncilURL] = mySource.[new_FanCouncilURL] ,
               myTarget.[new_FoundationSubscription] = mySource.[new_FoundationSubscription] ,
               myTarget.[new_HasKidsunder18] = mySource.[new_HasKidsunder18] ,
               myTarget.[new_MLSFoundersSurveyLink] = mySource.[new_MLSFoundersSurveyLink] ,
               myTarget.[new_MLSLiveCode] = mySource.[new_MLSLiveCode] ,
               myTarget.[new_new_subscription_MLSOfficialGearMail] = mySource.[new_new_subscription_MLSOfficialGearMail] ,
               myTarget.[new_NFLAccount] = mySource.[new_NFLAccount] ,
               myTarget.[new_NFLAccountPassword] = mySource.[new_NFLAccountPassword] ,
               myTarget.[new_NFLMC1] = mySource.[new_NFLMC1] ,
               myTarget.[new_NFLMCCode1] = mySource.[new_NFLMCCode1] ,
               myTarget.[new_NFLMCCode2] = mySource.[new_NFLMCCode2] ,
               myTarget.[new_NFLMCCode3] = mySource.[new_NFLMCCode3] ,
               myTarget.[new_NFLMCCode4] = mySource.[new_NFLMCCode4] ,
               myTarget.[new_NFLMCURL2] = mySource.[new_NFLMCURL2] ,
               myTarget.[new_NSCheckedOutBy] = mySource.[new_NSCheckedOutBy] ,
               myTarget.[new_NSCheckedOutByName] = mySource.[new_NSCheckedOutByName] ,
               myTarget.[new_NSLicenseeName] = mySource.[new_NSLicenseeName] ,
               myTarget.[new_RelocationDateTime] = mySource.[new_RelocationDateTime] ,
               myTarget.[new_SponsorshipCheckedOutBy] = mySource.[new_SponsorshipCheckedOutBy] ,
               myTarget.[new_SponsorshipCheckedOutByName] = mySource.[new_SponsorshipCheckedOutByName] ,
               myTarget.[new_Subscription_MLSSubscription] = mySource.[new_Subscription_MLSSubscription] ,
               myTarget.[new_Subscription_PreferredPartner] = mySource.[new_Subscription_PreferredPartner] ,
               myTarget.[new_Subscription_Ticket_Offers] = mySource.[new_Subscription_Ticket_Offers] ,
               myTarget.[new_subscriptionNewStadiumInformationOffers] = mySource.[new_subscriptionNewStadiumInformationOffers] ,
               myTarget.[new_UnitedCheckedOutBy] = mySource.[new_UnitedCheckedOutBy] ,
               myTarget.[new_UnitedCheckedOutByName] = mySource.[new_UnitedCheckedOutByName] ,
               myTarget.[new_VirtualseatView] = mySource.[new_VirtualseatView] ,
               myTarget.[new_WNPFNetwork] = mySource.[new_WNPFNetwork] ,
               myTarget.[Opt Out of Arthur M Blank Foundation Email Communication] = mySource.[Opt Out of Arthur M Blank Foundation Email Communication] ,
               myTarget.[Opt Out of Atlanta Falcons Email Communication] = mySource.[Opt Out of Atlanta Falcons Email Communication] ,
               myTarget.[Opt Out of Atlanta United Email Communication] = mySource.[Opt Out of Atlanta United Email Communication] ,
               myTarget.[Part Time Positions] = mySource.[Part Time Positions] ,
               myTarget.[Phone Call Opt In] = mySource.[Phone Call Opt In] ,
               myTarget.[Playoff Payment] = mySource.[Playoff Payment] ,
               myTarget.[Preferred Partner] = mySource.[Preferred Partner] ,
               myTarget.[Preferred Ticket Price] = mySource.[Preferred Ticket Price] ,
               myTarget.[PreferredLanguage] = mySource.[PreferredLanguage] ,
               myTarget.[Primary Rep] = mySource.[Primary Rep] ,
               myTarget.[Primary Rep Email] = mySource.[Primary Rep Email] ,
               myTarget.[Primary Rep Name] = mySource.[Primary Rep Name] ,
               myTarget.[Primary Rep Phone] = mySource.[Primary Rep Phone] ,
               myTarget.[PSL Owner] = mySource.[PSL Owner] ,
               myTarget.[Question or Comment] = mySource.[Question or Comment] ,
               myTarget.[Salutation] = mySource.[Salutation] ,
               myTarget.[Seating Level Preference] = mySource.[Seating Level Preference] ,
               myTarget.[Send Hour] = mySource.[Send Hour] ,
               myTarget.[StateCode] = mySource.[StateCode] ,
               myTarget.[Suffix] = mySource.[Suffix] ,
               myTarget.[Team Member Referral] = mySource.[Team Member Referral] ,
               myTarget.[Team Member Requirements] = mySource.[Team Member Requirements] ,
               myTarget.[Telephone1] = mySource.[Telephone1] ,
               myTarget.[Telephone2] = mySource.[Telephone2] ,
               myTarget.[United Season Ticket Holder] = mySource.[United Season Ticket Holder] ,
               myTarget.[United Seating Preference] = mySource.[United Seating Preference] ,
               myTarget.[UnitedStayConnected] = mySource.[UnitedStayConnected] ,
               myTarget.[UTD Acct Number] = mySource.[UTD Acct Number] ,
               myTarget.[UTD Event Sign Up] = mySource.[UTD Event Sign Up] ,
               myTarget.[UTD Group] = mySource.[UTD Group] ,
               myTarget.[UTD Multi Game] = mySource.[UTD Multi Game] ,
               myTarget.[UTD Season Schedule] = mySource.[UTD Season Schedule] ,
               myTarget.[UTD Season Tix Due] = mySource.[UTD Season Tix Due] ,
               myTarget.[UTD SGB TE TF] = mySource.[UTD SGB TE TF] ,
               myTarget.[UTD Test_Behavior] = mySource.[UTD Test_Behavior] ,
               myTarget.[UTD Test_Rank] = mySource.[UTD Test_Rank] ,
               myTarget.[UTD Test_Score] = mySource.[UTD Test_Score] ,
               myTarget.[MOBILE_USER_ID] = mySource.[MOBILE_USER_ID] ,
               myTarget.[MBS Seating Interest] = mySource.[MBS Seating Interest],
			   myTarget.ETL__UpdatedDate=GETDATE()

WHEN NOT MATCHED BY TARGET
	THEN INSERT (
	[Opt In Details] ,
          [Email Type] ,
          [CRM Account ID] ,
          [CRM Enable Sync] ,
          [Opted Out Date] ,
          [CRM Sync ID] ,
          EMAIL ,
          [CRM Lead Source] ,
          [Last Modified Date] ,
          [Opt Out Details] ,
          [CRM Contact Type] ,
          [Opt In Date] ,
          CREATED_FROM ,
          [21 or older] ,
          [Academy Team] ,
          [Academy Tried Out] ,
          Address1_City ,
          Address1_Country ,
          Address1_County ,
          Address1_Line1 ,
          Address1_Line2 ,
          Address1_Line3 ,
          Address1_PostalCode ,
          Address1_StateOrProvince ,
          [AF Season Schedule] ,
          [Agree Official Rules] ,
          AllowSMS ,
          [Appointment Time] ,
          AssistantName ,
          AssistantPhone ,
          AUExclusiveContentNotifications ,
          AUInTheStadiumNotifications ,
          AUMatchStartNotifications ,
          AUParkingAndTransitNotifications ,
          AUScoringNotifications ,
          AUTeamNewsNotifications ,
          BirthDate ,
          cdi_facebook ,
          cdi_linkedin ,
          cdi_twitter ,
          client_ambffsuppression ,
          client_BWContactId ,
          Company ,
          [Corporate Entertainment] ,
          CRM_Contact_ID ,
          [Current Stadium Employee] ,
          DoNotBulkEMail ,
          DoNotBulkPostalMail ,
          DoNotEMail ,
          DoNotPostalMail ,
          [Falcons Group] ,
          [Falcons Home Opponents] ,
          [Falcons Insider] ,
          [Falcons Season Ticket Holder] ,
          [Falcons Season Tix Due] ,
          [Falcons Seating Preference] ,
          [Falcons SGB TE TF] ,
          FirstName ,
          [Founding Members no seats] ,
          [Founding Members with seats] ,
          FullName ,
          [GA Dome Premium Events] ,
          [GA Dome Seating Preferences] ,
          GenderCode ,
          [Group Size] ,
          [Group Type] ,
          HasChildrenCode ,
          JobTitle ,
          [KIA Account] ,
          kore_accountaliasidName ,
          kore_address1milesfromfacility ,
          kore_BWBaseDate ,
          kore_BWCompanyId ,
          kore_BWContactId ,
          kore_BWSequence ,
          kore_CheckedOutById ,
          kore_CheckedOutByIdName ,
          kore_InvoiceBalance ,
          kore_PrimaryAccountNumber ,
          kore_SinceDate ,
          KORE_Type ,
          Last_Click ,
          Last_Open ,
          Last_Sent ,
          LastName ,
          [MBS Hiring Emails] ,
          MiddleName ,
          [Mobile User Id] ,
          MobilePhone ,
          [My Finder] ,
          new_Address1_MetroArea ,
          new_AFYFNetwork ,
          new_AMBFFNewsletter ,
          new_AMBFFTrustees ,
          new_AmericanExplorers ,
          new_AtlantaFalconsNationalFootballLeague ,
          new_AtlantaUnitedFCEventsFanPerksa ,
          new_AtlantaUnitedFCMajorLeagueSoccer ,
          new_BrokerFlag ,
          new_FalconsNASSurveyLink ,
          new_FanCouncilURL ,
          new_FoundationSubscription ,
          new_HasKidsunder18 ,
          new_MLSFoundersSurveyLink ,
          new_MLSLiveCode ,
          new_new_subscription_MLSOfficialGearMail ,
          new_NFLAccount ,
          new_NFLAccountPassword ,
          new_NFLMC1 ,
          new_NFLMCCode1 ,
          new_NFLMCCode2 ,
          new_NFLMCCode3 ,
          new_NFLMCCode4 ,
          new_NFLMCURL2 ,
          new_NSCheckedOutBy ,
          new_NSCheckedOutByName ,
          new_NSLicenseeName ,
          new_RelocationDateTime ,
          new_SponsorshipCheckedOutBy ,
          new_SponsorshipCheckedOutByName ,
          new_Subscription_MLSSubscription ,
          new_Subscription_PreferredPartner ,
          new_Subscription_Ticket_Offers ,
          new_subscriptionNewStadiumInformationOffers ,
          new_UnitedCheckedOutBy ,
          new_UnitedCheckedOutByName ,
          new_VirtualseatView ,
          new_WNPFNetwork ,
          [Opt Out of Arthur M Blank Foundation Email Communication] ,
          [Opt Out of Atlanta Falcons Email Communication] ,
          [Opt Out of Atlanta United Email Communication] ,
          [Part Time Positions] ,
          [Phone Call Opt In] ,
          [Playoff Payment] ,
          [Preferred Partner] ,
          [Preferred Ticket Price] ,
          PreferredLanguage ,
          [Primary Rep] ,
          [Primary Rep Email] ,
          [Primary Rep Name] ,
          [Primary Rep Phone] ,
          [PSL Owner] ,
          [Question or Comment] ,
          Salutation ,
          [Seating Level Preference] ,
          [Send Hour] ,
          StateCode ,
          Suffix ,
          [Team Member Referral] ,
          [Team Member Requirements] ,
          Telephone1 ,
          Telephone2 ,
          [United Season Ticket Holder] ,
          [United Seating Preference] ,
          UnitedStayConnected ,
          [UTD Acct Number] ,
          [UTD Event Sign Up] ,
          [UTD Group] ,
          [UTD Multi Game] ,
          [UTD Season Schedule] ,
          [UTD Season Tix Due] ,
          [UTD SGB TE TF] ,
          [UTD Test_Behavior] ,
          [UTD Test_Rank] ,
          [UTD Test_Score] ,
          MOBILE_USER_ID ,
          [MBS Seating Interest],
		  ETL__CreatedDate,
		  ETL__UpdatedDate)
VALUES (
		  mysource.[Opt In Details] ,
          mysource.[Email Type] ,
          mysource.[CRM Account ID] ,
          mysource.[CRM Enable Sync] ,
          mysource.[Opted Out Date] ,
          mysource.[CRM Sync ID] ,
          mysource.EMAIL ,
          mysource.[CRM Lead Source] ,
          mysource.[Last Modified Date] ,
          mysource.[Opt Out Details] ,
          mysource.[CRM Contact Type] ,
          mysource.[Opt In Date] ,
          mysource.CREATED_FROM ,
          mysource.[21 or older] ,
          mysource.[Academy Team] ,
          mysource.[Academy Tried Out] ,
          mysource.Address1_City ,
          mysource.Address1_Country ,
          mysource.Address1_County ,
          mysource.Address1_Line1 ,
          mysource.Address1_Line2 ,
          mysource.Address1_Line3 ,
          mysource.Address1_PostalCode ,
          mysource.Address1_StateOrProvince ,
          mysource.[AF Season Schedule] ,
          mysource.[Agree Official Rules] ,
          mysource.AllowSMS ,
          mysource.[Appointment Time] ,
          mysource.AssistantName ,
          mysource.AssistantPhone ,
          mysource.AUExclusiveContentNotifications ,
          mysource.AUInTheStadiumNotifications ,
          mysource.AUMatchStartNotifications ,
          mysource.AUParkingAndTransitNotifications ,
          mysource.AUScoringNotifications ,
          mysource.AUTeamNewsNotifications ,
          mysource.BirthDate ,
          mysource.cdi_facebook ,
          mysource.cdi_linkedin ,
          mysource.cdi_twitter ,
          mysource.client_ambffsuppression ,
          mysource.client_BWContactId ,
          mysource.Company ,
          mysource.[Corporate Entertainment] ,
          mysource.CRM_Contact_ID ,
          mysource.[Current Stadium Employee] ,
          mysource.DoNotBulkEMail ,
          mysource.DoNotBulkPostalMail ,
          mysource.DoNotEMail ,
          mysource.DoNotPostalMail ,
          mysource.[Falcons Group] ,
          mysource.[Falcons Home Opponents] ,
          mysource.[Falcons Insider] ,
          mysource.[Falcons Season Ticket Holder] ,
          mysource.[Falcons Season Tix Due] ,
          mysource.[Falcons Seating Preference] ,
          mysource.[Falcons SGB TE TF] ,
          mysource.FirstName ,
          mysource.[Founding Members no seats] ,
          mysource.[Founding Members with seats] ,
          mysource.FullName ,
          mysource.[GA Dome Premium Events] ,
          mysource.[GA Dome Seating Preferences] ,
          mysource.GenderCode ,
          mysource.[Group Size] ,
          mysource.[Group Type] ,
          mysource.HasChildrenCode ,
          mysource.JobTitle ,
          mysource.[KIA Account] ,
          mysource.kore_accountaliasidName ,
          mysource.kore_address1milesfromfacility ,
          mysource.kore_BWBaseDate ,
          mysource.kore_BWCompanyId ,
          mysource.kore_BWContactId ,
          mysource.kore_BWSequence ,
          mysource.kore_CheckedOutById ,
          mysource.kore_CheckedOutByIdName ,
          mysource.kore_InvoiceBalance ,
          mysource.kore_PrimaryAccountNumber ,
          mysource.kore_SinceDate ,
          mysource.KORE_Type ,
          mysource.Last_Click ,
          mysource.Last_Open ,
          mysource.Last_Sent ,
          mysource.LastName ,
          mysource.[MBS Hiring Emails] ,
          mysource.MiddleName ,
          mysource.[Mobile User Id] ,
          mysource.MobilePhone ,
          mysource.[My Finder] ,
          mysource.new_Address1_MetroArea ,
          mysource.new_AFYFNetwork ,
          mysource.new_AMBFFNewsletter ,
          mysource.new_AMBFFTrustees ,
          mysource.new_AmericanExplorers ,
          mysource.new_AtlantaFalconsNationalFootballLeague ,
          mysource.new_AtlantaUnitedFCEventsFanPerksa ,
          mysource.new_AtlantaUnitedFCMajorLeagueSoccer ,
          mysource.new_BrokerFlag ,
          mysource.new_FalconsNASSurveyLink ,
          mysource.new_FanCouncilURL ,
          mysource.new_FoundationSubscription ,
          mysource.new_HasKidsunder18 ,
          mysource.new_MLSFoundersSurveyLink ,
          mysource.new_MLSLiveCode ,
          mysource.new_new_subscription_MLSOfficialGearMail ,
          mysource.new_NFLAccount ,
          mysource.new_NFLAccountPassword ,
          mysource.new_NFLMC1 ,
          mysource.new_NFLMCCode1 ,
          mysource.new_NFLMCCode2 ,
          mysource.new_NFLMCCode3 ,
          mysource.new_NFLMCCode4 ,
          mysource.new_NFLMCURL2 ,
          mysource.new_NSCheckedOutBy ,
          mysource.new_NSCheckedOutByName ,
          mysource.new_NSLicenseeName ,
          mysource.new_RelocationDateTime ,
          mysource.new_SponsorshipCheckedOutBy ,
          mysource.new_SponsorshipCheckedOutByName ,
          mysource.new_Subscription_MLSSubscription ,
          mysource.new_Subscription_PreferredPartner ,
          mysource.new_Subscription_Ticket_Offers ,
          mysource.new_subscriptionNewStadiumInformationOffers ,
          mysource.new_UnitedCheckedOutBy ,
          mysource.new_UnitedCheckedOutByName ,
          mysource.new_VirtualseatView ,
          mysource.new_WNPFNetwork ,
          mysource.[Opt Out of Arthur M Blank Foundation Email Communication] ,
          mysource.[Opt Out of Atlanta Falcons Email Communication] ,
          mysource.[Opt Out of Atlanta United Email Communication] ,
          mysource.[Part Time Positions] ,
          mysource.[Phone Call Opt In] ,
          mysource.[Playoff Payment] ,
          mysource.[Preferred Partner] ,
          mysource.[Preferred Ticket Price] ,
          mysource.PreferredLanguage ,
          mysource.[Primary Rep] ,
          mysource.[Primary Rep Email] ,
          mysource.[Primary Rep Name] ,
          mysource.[Primary Rep Phone] ,
          mysource.[PSL Owner] ,
          mysource.[Question or Comment] ,
          mysource.Salutation ,
          mysource.[Seating Level Preference] ,
          mysource.[Send Hour] ,
          mysource.StateCode ,
          mysource.Suffix ,
          mysource.[Team Member Referral] ,
          mysource.[Team Member Requirements] ,
          mysource.Telephone1 ,
          mysource.Telephone2 ,
          mysource.[United Season Ticket Holder] ,
          mysource.[United Seating Preference] ,
          mysource.UnitedStayConnected ,
          mysource.[UTD Acct Number] ,
          mysource.[UTD Event Sign Up] ,
          mysource.[UTD Group] ,
          mysource.[UTD Multi Game] ,
          mysource.[UTD Season Schedule] ,
          mysource.[UTD Season Tix Due] ,
          mysource.[UTD SGB TE TF] ,
          mysource.[UTD Test_Behavior] ,
          mysource.[UTD Test_Rank] ,
          mysource.[UTD Test_Score] ,
          mysource.MOBILE_USER_ID ,
          mysource.[MBS Seating Interest],
		  GETDATE(),
		  GETDATE());


GO
