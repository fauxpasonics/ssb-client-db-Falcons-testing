SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_IMC_ProductionCopy_MasterDB]
AS
SELECT RECIPIENT_ID,
       Email,
       [Opt In Date] Opt_In_Date,
       [Opted Out] Opted_Out,
       [Opt In Details] Opt_In_Details,
       [Email Type] Email_type,
       [Opted Out Date] Opted_Out_Date,
       [Opt Out Details] Opt_Out_Details,
       [CRM Lead Source] CRM_Lead_Source,
       [CRM Sync ID] CRM_Sync_ID,
       [CRM Enable Sync] CRM_Enable_Sync,
       [CRM Contact Type] CRM_ContactType,
       [CRM Account ID] CRM_Account_ID,
       [Last Modified Date] Last_Modified_Date,
       [2016 PSL Payment Paid] AS PSL_Payment_Paid_2016,
       [2017 PSL Amount Due]  AS PSL_Amount_Due_2017,
       [2017 PSL Payment Paid]  AS PSL_Payment_Paid_2017,
       [21 or older] AS Older_than_21,
       [AF Season Schedule] AF_Season_Schedule,
       [AF Ticket Offers] AF_Ticket_Offers,
       AUExclusiveContentNotifications,
       AUInTheStadiumNotifications,
       AUMatchStartNotifications,
       AUParkingAndTransitNotifications,
       AUScoringNotifications,
       AUTeamNewsNotifications,
       [Academy Team] Academy_Team,
       [Academy Tried Out] Academy_Tried_Out,
       [Additional Comments] Additional_Comments,
       Address1_City,
       Address1_Country,
       Address1_County,
       Address1_Line1,
       Address1_Line2,
       Address1_Line3,
       Address1_PostalCode,
       Address1_StateOrProvince,
       [Agree Official Rules] Agree_Official_Rules,
       AllowSMS,
       [Appointment Time] Appointment_Time,
       AssistantName,
       AssistantPhone,
       [Associated Archtics ID Suite Owner Admin] Associated_Archtics_ID_Suite_Owner_Admin,
       BirthDate,
       [CRM Sync ID 2] CRM_Sync_ID_2,
       CRM_Contact_ID,
       Company,
       [Corporate Client or Employee Entertainment] Corporate_Client_or_Employee_Entertainment,
       [Corporate Entertainment] Corporate_Entertainment,
       [Current Stadium Employee] Current_Stadium_Employee,
       DoNotBulkEMail,
       DoNotBulkPostalMail,
       DoNotEMail,
       DoNotPostalMail,
       Duplicate,
       [Executive Member] Executive_Member,
       [Falcons Group] Falcons_Group,
       [Falcons Home Opponents] Falcons_Home_Opponents,
       [Falcons Insider] Falcons_Insider,
       [Falcons SGB TE TF] Falcons_SGB_TE_TF,
       [Falcons Season Ticket Holder] Falcons_Season_Tix_Holder,
       [Falcons Season Tix Due] Falcons_Season_Tix_Due,
       [Falcons Seating Preference] Falcons_Seating_Preference,
       FirstName,
       [Founding Members no seats] FoundingMembers_NoSeats,
       [Founding Members with seats] FoundingMembers_WithSeats,
       FullName,
       [GA Dome Premium Events] GADome_PremiumEvents,
       [GA Dome Seating Preferences] GADome_SeatingPreferences,
       GenderCode,
       [Group Size] Group_Size,
       [Group Type] Group_Type,
       HasChildrenCode,
       JobTitle,
       [KIA Account] KIA_Account,
       KORE_Type,
       LastName,
       Last_Click,
       Last_Open,
       Last_Sent,
       [MBS Concert Garth Brooks 20170619] MBS_Concert_GarthBrooks_20170619,
       [MBS Events] MBS_Events,
       [MBS Events Stay Informed] MBS_Events_StayInformed,
       [MBS Hiring Emails] MBS_HiringEmails,
       [MBS Seating Interest] MBS_SeatingInterest,
       [MBS Tour Interest 20170628] MBS_TourInterest_20170628,
       MiddleName,
       [Mobile User Id] Mobile_User_Id,
       MobilePhone,
       [My Finder] My_Finder,
       [Opt Out of Arthur M Blank Foundation Email Communication] Opt_Out_Arthur_M_Blank_Foundation_Email,
       [Opt Out of Atlanta Falcons Email Communication] Opt_Out_Atlanta_Falcons_Email,
       [Opt Out of Atlanta United Email Communication] Opt_Out_Atlanta_United_Email,
       [PSL Owner] PSL_Owner,
       [Part Time Positions] PartTime_Positions,
       [Phone Call Opt In] PhoneCall_OptIn,
       [Playoff Payment] Playoff_Payment,
       [Preferred Partner] Preferred_Partner,
       [Preferred Ticket Price] Preferred_Ticket_Price,
       PreferredLanguage,
       [Primary Rep] PrimaryRep,
       [Primary Rep Email] PrimaryRep_Email,
       [Primary Rep Name] PrimaryRep_Name,
       [Primary Rep Phone] PrimaryRep_Phone,
       [Question or Comment] Question_or_Comment,
       Salutation,
       [Seating Level Preference] Seating_Level_Preference,
       [Send Hour] SendHour,
       StateCode,
       Suffix,
       [Team Member Referral] TeamMember_Referral,
       [Team Member Requirements] TeamMember_Requirements,
       Telephone1,
       Telephone2,
       [UTD Acct Number] UTC_Acct_Number,
       [UTD Event Sign Up] UTD_Event_Signup,
       [UTD Group] UTD_Group,
       [UTD Group  Type] UTD_GroupType,
       [UTD Group Size] UTD_GroupSize,
       [UTD Home Opponents] UTD_HomeOpponents,
       [UTD Multi Game] UTD_MultiGame,
       [UTD SGB TE TF] UTD_SGB_TE_TF,
       [UTD Season Schedule] UTD_Season_Schedule,
       [UTD Season Tix Due] UTD_Season_Tix_Due,
       [UTD Seating Preferences] UTD_Seating_Preferences,
       [UTD Test_Behavior] UTD_Test_Behavior,
       [UTD Test_Rank] UTD_Test_Rank,
       [UTD Test_Score] UTD_Test_Score,
       [United Season Ticket Holder] United_Season_Ticket_Holder,
       [United Seating Preference] United_Seating_Preference,
       UnitedStayConnected ,
       [Unsubscribe from CD] Unsubscribe_from_CD,
       [Web Form First Name] WebForm_FirstName,
       [Web Form Last Name] WebForm_LastName,
       [Web Form Telephone1] WebForm_Telephone,
       [Web Form Zip Code] WebForm_ZipCode,
       cdi_facebook,
       cdi_linkedin,
       cdi_twitter,
       client_BWContactId,
       client_ambffsuppression,
       kore_BWBaseDate,
       kore_BWCompanyId,
       kore_BWContactId,
       kore_BWSequence,
       kore_CheckedOutById,
       kore_CheckedOutByIdName,
       kore_InvoiceBalance,
       kore_PrimaryAccountNumber,
       kore_SinceDate,
       kore_accountaliasidName,
       kore_address1milesfromfacility,
       new_AFYFNetwork,
       new_AMBFFNewsletter,
       new_AMBFFTrustees,
       new_Address1_MetroArea,
       new_AmericanExplorers,
       new_AtlantaFalconsNationalFootballLeague,
       new_AtlantaUnitedFCEventsFanPerksa,
       new_AtlantaUnitedFCMajorLeagueSoccer,
       new_BrokerFlag,
       new_ExcludeFromMBSEmails,
       new_FalconsNASSurveyLink,
       new_FanCouncilURL,
       new_FoundationSubscription,
       new_HasKidsunder18,
       new_MLSFoundersSurveyLink,
       new_MLSLiveCode,
       new_MemoriesLastUpdated,
       new_MemoriesRedeemedCredits,
       new_MemoriesRegisteredMember,
       new_MemoriesRemainingCredits,
       new_MemoriesStartingCredits,
       new_NFLAccount,
       new_NFLAccountPassword,
       new_NFLMC1,
       new_NFLMCCode1,
       new_NFLMCCode2,
       new_NFLMCCode3,
       new_NFLMCCode4,
       new_NFLMCURL2,
       new_NSCheckedOutBy,
       new_NSCheckedOutByName,
       new_NSLicenseeName,
       new_RelocationDateTime,
       new_SponsorshipCheckedOutBy,
       new_SponsorshipCheckedOutByName,
       new_Subscription_EReport,
       new_Subscription_GearMail,
       new_Subscription_MLSSubscription,
       new_Subscription_Postgame_STH,
       new_Subscription_PreferredPartner,
       new_Subscription_Pregame_STH,
       new_Subscription_TicketSuiteSales,
       new_Subscription_Ticket_Offers,
       new_UnitedCheckedOutBy,
       new_UnitedCheckedOutByName,
       new_VirtualseatView,
       new_WNPFNetwork,
       new_new_subscription_MLSOfficialGearMail,
       new_subscriptionNewStadiumInformationOffers,
       ETL__ID,
       ETL__CreatedDate,
       ETL__UpdatedDate,
       ETL__silverpop_exportList_id,
       ETL__session_id,
       ETL__insert_datetime,
       ETL__multi_query_value_for_audit,
       Email_alt,
       Full_Name,
       GuestInfo_Email,
       GuestInfo_FirstName,
       GuestInfo_LastName,
       GuestInfo_Title,
       MobileNumber,
       Notes,
       Organization_Address1,
       Organization_Address2,
       Organization_City,
       Organization_Classification,
       Organization_Name,
       Organization_Type,
       Organization_Zip,
       Title,
       AFInDome,
       AFMediaNotifications,
       AFParkingTransportation,
       AFScoreUpdatebyQuarter,
       AFScoringPlays,
       AFTeamNews FROM ods.IMC_ProductionCopy_MasterDB
GO
