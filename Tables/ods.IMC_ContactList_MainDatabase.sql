CREATE TABLE [ods].[IMC_ContactList_MainDatabase]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[RECIPIENT_ID] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_In_Date] [datetime] NULL,
[Opted_Out] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_In_Details] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Type] [int] NULL,
[Opted_Out_Date] [datetime] NULL,
[Opt_Out_Details] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Sync_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Enable_Sync] [int] NULL,
[CRM_Contact_Type] [int] NULL,
[CRM_Account_ID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_PSL_Payment_Paid] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_PSL_Amount_Due] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_PSL_Payment_Paid] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_Falcons_STM_Paid] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_United_STM_Paid] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2018_Falcons_Home_Opponents] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2018_United_STM_Paid] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[21_or_older] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_Season_Schedule] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_Ticket_Offers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFExclusiveContent] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFInDome] [int] NULL,
[AFLocationServices] [int] NULL,
[AFMediaNotifications] [int] NULL,
[AFOffersPromotions] [int] NULL,
[AFParkingTransportation] [int] NULL,
[AFScoreUpdatebyQuarter] [int] NULL,
[AFScoringPlays] [int] NULL,
[AFTeamNews] [int] NULL,
[AUExclusiveContentNotifications] [int] NULL,
[AUInTheStadiumNotifications] [int] NULL,
[AUMatchStartNotifications] [int] NULL,
[AUOffersPromotions] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUParkingAndTransitNotifications] [int] NULL,
[AUScoringNotifications] [int] NULL,
[AUTeamNewsNotifications] [int] NULL,
[Academy_Team] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Academy_Tried_Out] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Comments] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_City] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Country] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_County] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line1] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line3] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_PostalCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_StateOrProvince] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agree_Official_Rules] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowSMS] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appointment_Time] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Associated_Archtics_ID_Suite_Owner_Admin] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AtlantaFalconsProspect] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AtlantaUnitedEnrolledInAutoRenewal] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [datetime] NULL,
[CRM_Sync_ID_2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Contact_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Corporate_Client_or_Employee_Entertainment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Corporate_Entertainment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Stadium_Employee] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkEMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkPostalMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotEMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotPostalMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duplicate] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executive_Member] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Group] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Home_Opponents] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Insider] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_SGB_TE_TF] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Ticket_Holder] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Tix_Due] [int] NULL,
[Falcons_Seating_Preference] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_SingleGameBuyer_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Founding_Members_no_seats] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Founding_Members_with_seats] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GA_Dome_Premium_Events] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GA_Dome_Seating_Preferences] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Size] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Type] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HF_MBS_Group_Tours_Time] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HF_MBS_Group_Tours_UTM] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasChildrenCode] [int] NULL,
[JobTitle] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KIA_Account] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KORE_Type] [datetime] NULL,
[LastName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Click] [datetime] NULL,
[Last_Open] [datetime] NULL,
[Last_Sent] [datetime] NULL,
[MBEventNews] [int] NULL,
[MBExclusiveContent] [int] NULL,
[MBInTheStadium] [int] NULL,
[MBLocationServices] [int] NULL,
[MBOffersPromotions] [int] NULL,
[MBParkingAndTransit] [int] NULL,
[MBS_Concert_Garth_Brooks_20170619] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Events] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Events_Stay_Informed] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Group_Tour_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Hiring_Emails] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Premium_Entertainment_Groups] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Premium_Interests] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Premium_Seating_Info_OptIn] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Seating_Interest] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Tour_Interest_20170628] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mobile_User_Id] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[My_Finder] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Arthur_M_Blank_Foundation_Email_Communication] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Atlanta_Falcons_Email_Communication] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Atlanta_United_Email_Communication] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSL_Owner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSL_Owner_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part_Time_Positions] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Call_Opt_In] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Playoff_Payment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preferred_Partner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preferred_Ticket_Price] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredLanguage] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Previous_Rep_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_or_Comment] [nvarchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salutation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seating_Level_Preference] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Send_Hour] [int] NULL,
[StateCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member_Referral] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member_Requirements] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Behavior] [int] NULL,
[Test_Opens_for_Email_Rank] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Score] [int] NULL,
[USL_Seating_Interest] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Acct_Number] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Event_Sign_Up] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group__Type] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group_Size] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Home_Opponents] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Multi_Game] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_SGB_TE_TF] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Season_Schedule] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Season_Tix_Due] [int] NULL,
[UTD_Seating_Preferences] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Behavior] [int] NULL,
[UTD_Test_Rank] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Score] [int] NULL,
[United_Season_Ticket_Holder] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_Seating_Preference] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitedStayConnected] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_MultiPack_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_SingleGameBuyer_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unsubscribe_from_CD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Company] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_First_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Last_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Telephone1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Zip_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_facebook] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_linkedin] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_twitter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_BWContactId] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_USLOptin] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_ambffsuppression] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWBaseDate] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWCompanyId] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWContactId] [int] NULL,
[kore_BWSequence] [int] NULL,
[kore_CheckedOutById] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_CheckedOutByIdName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_InvoiceBalance] [int] NULL,
[kore_PrimaryAccountNumber] [int] NULL,
[kore_SinceDate] [datetime] NULL,
[kore_accountaliasidName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_address1milesfromfacility] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AFYFNetwork] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AMBFFNewsletter] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AMBFFTrustees] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Address1_MetroArea] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AmericanExplorers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaFalconsNationalFootballLeague] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaUnitedFCEventsFanPerksa] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaUnitedFCMajorLeagueSoccer] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_BrokerFlag] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_ExcludeFromMBSEmails] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FalconsNASSurveyLink] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FanCouncilURL] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FoundationSubscription] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_HasKidsunder18] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MLSFoundersSurveyLink] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MLSLiveCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesLastUpdated] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRedeemedCredits] [int] NULL,
[new_MemoriesRegisteredMember] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRemainingCredits] [int] NULL,
[new_MemoriesStartingCredits] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLAccount] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLAccountPassword] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMC1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode1] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode2] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode3] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode4] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCURL2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSCheckedOutBy] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSCheckedOutByName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSLicenseeName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_RelocationDateTime] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SponsorshipCheckedOutBy] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SponsorshipCheckedOutByName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_EReport] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_GearMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_MLSSubscription] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Postgame_STH] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_PreferredPartner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Pregame_STH] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_TicketSuiteSales] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Ticket_Offers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_UnitedCheckedOutBy] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_UnitedCheckedOutByName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_VirtualseatView] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_WNPFNetwork] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_new_subscription_MLSOfficialGearMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_subscriptionNewStadiumInformationOffers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[IMC_ContactList_MainDatabase] ADD CONSTRAINT [PK_ods__IMC_ContactList_MainDatabase] PRIMARY KEY NONCLUSTERED  ([ETL__ID])
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__IMC_ContactList_MainDatabase] ON [ods].[IMC_ContactList_MainDatabase]
GO
CREATE NONCLUSTERED INDEX [IX_ETL__UpdatedDate] ON [ods].[IMC_ContactList_MainDatabase] ([ETL__UpdatedDate] DESC)
GO
