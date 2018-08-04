CREATE TABLE [stg].[IMC_ProductionCopy_MasterDB]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[RECIPIENT_ID] [nvarchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (245) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_In_Date] [nvarchar] (95) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opted_Out] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_In_Details] [nvarchar] (360) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opted_Out_Date] [nvarchar] (95) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_Details] [nvarchar] (210) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Sync_ID] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Enable_Sync] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Contact_Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Account_ID] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_PSL_Payment_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_PSL_Amount_Due] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_PSL_Payment_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_Falcons_STM_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_United_STM_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2018_United_STM_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[21_or_older] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_Season_Schedule] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_Ticket_Offers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFExclusiveContent] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFInDome] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFLocationServices] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFMediaNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFOffersPromotions] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFParkingTransportation] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFScoreUpdatebyQuarter] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFScoringPlays] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFTeamNews] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUExclusiveContentNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUInTheStadiumNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUMatchStartNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUOffersPromotions] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUParkingAndTransitNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUScoringNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUTeamNewsNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Academy_Team] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Academy_Tried_Out] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Comments] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_City] [nvarchar] (135) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Country] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_County] [nvarchar] (105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line1] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line2] [nvarchar] (195) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line3] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_PostalCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_StateOrProvince] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agree_Official_Rules] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowSMS] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appointment_Time] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantPhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Associated_Archtics_ID_Suite_Owner_Admin] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AtlantaFalconsProspect] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AtlantaUnitedEnrolledInAutoRenewal] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Sync_ID_2] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Contact_ID] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (195) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Corporate_Client_or_Employee_Entertainment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Corporate_Entertainment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Stadium_Employee] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkEMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkPostalMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotEMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotPostalMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duplicate] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executive_Member] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Group] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Home_Opponents] [nvarchar] (1525) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Insider] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_SGB_TE_TF] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Ticket_Holder] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Tix_Due] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Seating_Preference] [nvarchar] (650) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_SingleGameBuyer_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Founding_Members_no_seats] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Founding_Members_with_seats] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GA_Dome_Premium_Events] [nvarchar] (435) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GA_Dome_Seating_Preferences] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderCode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Size] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Type] [nvarchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasChildrenCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle] [nvarchar] (215) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KIA_Account] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KORE_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (350) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Click] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Open] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Sent] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Concert_Garth_Brooks_20170619] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Events] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Events_Stay_Informed] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Group_Tour_Type] [nvarchar] (115) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Hiring_Emails] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Seating_Interest] [nvarchar] (455) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Tour_Interest_20170628] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mobile_User_Id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[My_Finder] [nvarchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Arthur_M_Blank_Foundation_Email_Communication] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Atlanta_Falcons_Email_Communication] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Atlanta_United_Email_Communication] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSL_Owner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSL_Owner_SSB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part_Time_Positions] [nvarchar] (1110) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Call_Opt_In] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Playoff_Payment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preferred_Partner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preferred_Ticket_Price] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredLanguage] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Email] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Name] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_or_Comment] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salutation] [nvarchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seating_Level_Preference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Send_Hour] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member_Referral] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member_Requirements] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone2] [nvarchar] (105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Behavior] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Rank] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Score] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Acct_Number] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Event_Sign_Up] [nvarchar] (130) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group__Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group_Size] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Home_Opponents] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Multi_Game] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_SGB_TE_TF] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Season_Schedule] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Season_Tix_Due] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Seating_Preferences] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Behavior] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Rank] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Score] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_Season_Ticket_Holder] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_Seating_Preference] [nvarchar] (675) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitedStayConnected] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_MultiPack_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_SingleGameBuyer_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unsubscribe_from_CD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_First_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Last_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Telephone1] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Zip_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_facebook] [nvarchar] (315) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_linkedin] [nvarchar] (270) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_twitter] [nvarchar] (175) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_BWContactId] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_ambffsuppression] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWBaseDate] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWCompanyId] [nvarchar] (195) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWContactId] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWSequence] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_CheckedOutById] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_CheckedOutByIdName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_InvoiceBalance] [nvarchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_PrimaryAccountNumber] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_SinceDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_accountaliasidName] [nvarchar] (280) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_address1milesfromfacility] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AFYFNetwork] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AMBFFNewsletter] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AMBFFTrustees] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Address1_MetroArea] [nvarchar] (105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AmericanExplorers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaFalconsNationalFootballLeague] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaUnitedFCEventsFanPerksa] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaUnitedFCMajorLeagueSoccer] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_BrokerFlag] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_ExcludeFromMBSEmails] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FalconsNASSurveyLink] [nvarchar] (540) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FanCouncilURL] [nvarchar] (505) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FoundationSubscription] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_HasKidsunder18] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MLSFoundersSurveyLink] [nvarchar] (540) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MLSLiveCode] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesLastUpdated] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRedeemedCredits] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRegisteredMember] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRemainingCredits] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesStartingCredits] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLAccount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLAccountPassword] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMC1] [nvarchar] (465) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode1] [nvarchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode2] [nvarchar] (95) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode3] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode4] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCURL2] [nvarchar] (485) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSCheckedOutBy] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSCheckedOutByName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSLicenseeName] [nvarchar] (160) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_RelocationDateTime] [nvarchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SponsorshipCheckedOutBy] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SponsorshipCheckedOutByName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_EReport] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_GearMail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_MLSSubscription] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Postgame_STH] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_PreferredPartner] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Pregame_STH] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_TicketSuiteSales] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Ticket_Offers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_UnitedCheckedOutBy] [nvarchar] (180) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_UnitedCheckedOutByName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_VirtualseatView] [nvarchar] (370) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_WNPFNetwork] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_new_subscription_MLSOfficialGearMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_subscriptionNewStadiumInformationOffers] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[IMC_ProductionCopy_MasterDB] ADD CONSTRAINT [PK_IMC_ProductionCopy_MasterDB] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
