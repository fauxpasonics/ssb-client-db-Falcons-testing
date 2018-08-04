CREATE TABLE [bkp].[ods__IMC_Master_20171117]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[RECIPIENT_ID] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_In_Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opted_Out] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_In_Details] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opted_Out_Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_Details] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Sync_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Enable_Sync] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Contact_Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Account_ID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2016_PSL_Payment_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_PSL_Amount_Due] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_PSL_Payment_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_Falcons_STM_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2017_United_STM_Paid] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2018_United_STM_Paid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[21_or_older] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_Season_Schedule] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AF_Ticket_Offers] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFExclusiveContent] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFInDome] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFLocationServices] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFMediaNotifications] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFOffersPromotions] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFParkingTransportation] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFScoreUpdatebyQuarter] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFScoringPlays] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AFTeamNews] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUExclusiveContentNotifications] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUInTheStadiumNotifications] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUMatchStartNotifications] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUOffersPromotions] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUParkingAndTransitNotifications] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUScoringNotifications] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AUTeamNewsNotifications] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Academy_Team] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Academy_Tried_Out] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional_Comments] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_County] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line1] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_PostalCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_StateOrProvince] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Agree_Official_Rules] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowSMS] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Appointment_Time] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssistantPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Associated_Archtics_ID_Suite_Owner_Admin] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AtlantaFalconsProspect] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AtlantaUnitedEnrolledInAutoRenewal] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Sync_ID_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_Contact_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Corporate_Client_or_Employee_Entertainment] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Corporate_Entertainment] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Stadium_Employee] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkEMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotBulkPostalMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotEMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotPostalMail] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duplicate] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Executive_Member] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Group] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Home_Opponents] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Insider] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_SGB_TE_TF] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Ticket_Holder] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Tix_Due] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Seating_Preference] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_SingleGameBuyer_SSB] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Founding_Members_no_seats] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Founding_Members_with_seats] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GA_Dome_Premium_Events] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GA_Dome_Seating_Preferences] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Size] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Group_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasChildrenCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobTitle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KIA_Account] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KORE_Type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Click] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Open] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Sent] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBEventNews] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBExclusiveContent] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBInTheStadium] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBLocationServices] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBOffersPromotions] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBParkingAndTransit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Concert_Garth_Brooks_20170619] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Events] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Events_Stay_Informed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Group_Tour_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Hiring_Emails] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Premium_Entertainment_Groups] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Premium_Interests] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Premium_Seating_Info_OptIn] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Seating_Interest] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBS_Tour_Interest_20170628] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mobile_User_Id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[My_Finder] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Arthur_M_Blank_Foundation_Email_Communication] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Atlanta_Falcons_Email_Communication] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Opt_Out_of_Atlanta_United_Email_Communication] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSL_Owner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PSL_Owner_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part_Time_Positions] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Call_Opt_In] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Playoff_Payment] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preferred_Partner] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Preferred_Ticket_Price] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredLanguage] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Rep_Phone] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_or_Comment] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salutation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seating_Level_Preference] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Send_Hour] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StateCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member_Referral] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team_Member_Requirements] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Behavior] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Rank] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Test_Opens_for_Email_Score] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Acct_Number] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Event_Sign_Up] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group__Type] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Group_Size] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Home_Opponents] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Multi_Game] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_SGB_TE_TF] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Season_Schedule] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Season_Tix_Due] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Seating_Preferences] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Behavior] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Rank] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UTD_Test_Score] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_Season_Ticket_Holder] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_Seating_Preference] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnitedStayConnected] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_MultiPack_SSB] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_SingleGameBuyer_SSB] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unsubscribe_from_CD] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Company] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_First_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Last_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Telephone1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Form_Zip_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_facebook] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_linkedin] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cdi_twitter] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_BWContactId] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[client_ambffsuppression] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWBaseDate] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWCompanyId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWContactId] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_BWSequence] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_CheckedOutById] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_CheckedOutByIdName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_InvoiceBalance] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_PrimaryAccountNumber] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_SinceDate] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_accountaliasidName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kore_address1milesfromfacility] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AFYFNetwork] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AMBFFNewsletter] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AMBFFTrustees] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Address1_MetroArea] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AmericanExplorers] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaFalconsNationalFootballLeague] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaUnitedFCEventsFanPerksa] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_AtlantaUnitedFCMajorLeagueSoccer] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_BrokerFlag] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_ExcludeFromMBSEmails] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FalconsNASSurveyLink] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FanCouncilURL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_FoundationSubscription] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_HasKidsunder18] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MLSFoundersSurveyLink] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MLSLiveCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesLastUpdated] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRedeemedCredits] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRegisteredMember] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesRemainingCredits] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_MemoriesStartingCredits] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLAccount] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLAccountPassword] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMC1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCCode4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NFLMCURL2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSCheckedOutBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSCheckedOutByName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_NSLicenseeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_RelocationDateTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SponsorshipCheckedOutBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SponsorshipCheckedOutByName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_EReport] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_GearMail] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_MLSSubscription] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Postgame_STH] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_PreferredPartner] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Pregame_STH] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_TicketSuiteSales] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_Subscription_Ticket_Offers] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_UnitedCheckedOutBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_UnitedCheckedOutByName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_VirtualseatView] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_WNPFNetwork] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_new_subscription_MLSOfficialGearMail] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_subscriptionNewStadiumInformationOffers] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
