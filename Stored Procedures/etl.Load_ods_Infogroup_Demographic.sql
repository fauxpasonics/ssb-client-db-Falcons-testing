SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[Load_ods_Infogroup_Demographic]
(
	@BatchId NVARCHAR(50) = null,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     12/19/2016
Comments: Initial creation
*************************************************************************************/

SET @BatchId = ISNULL(@BatchId, CONVERT(NVARCHAR(50), NEWID()))

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Infogroup_Demographic),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
	, ETL_CreatedDate, ETL_FileName, customerid, email, sumtm_acct_id, tkt_acct_id, CE_ATV_Model, CE_Active_Bank_Card_Flag, CE_Adventure_Seekers_Model, CE_Allergies_Flag, CE_Alternative_Medicine_Model, CE_Alzheimers_Flag, CE_Angina_Heart_Flag, CE_Annuities_Model, CE_Apparel_Interest_Flag, CE_Arrival_Date_Formatted, CE_Arthritis_Flag, CE_Asthma_Flag, CE_Auto_Club_Model, CE_Auto_Loan_Model, CE_Avid_Cell_Phone_User_Model, CE_Avid_Gamers_Model, CE_Avid_Smart_Phone_Users_Model, CE_Avid_Theme_Park_Visitor_Model, CE_Baby_Product_Model, CE_Bank_Card_Holder_Flag, CE_Blog_Writing_Model, CE_Boat_Owner_Flag, CE_Boat_Propulsion_Code, CE_Books_Music_Interest_Flag, CE_Business_Banking_Model, CE_Buyer_Behavior_Cluster_Code, CE_Camping_Flag, CE_Camping_Model, CE_Car_Buff_Flag, CE_Carrier_Route, CE_Carrier_Route_Type, CE_Cat_Owner_Flag, CE_Cat_Product_Model, CE_Cell_Phone_Only_Model, CE_Children_By_Age_By_Gender, CE_Children_By_Age_By_Month, CE_Children_Present_Flag, CE_Childrens_Products_Interest_F, CE_Collectibles_Interest_Flag, CE_College_Basketball_Model, CE_College_Football_Model, CE_Comprehensive_Auto_Ins_Model, CE_Computer_Owner_Flag, CE_Conservative_Model, CE_Construction_Type_Code, CE_Cook_For_Fun_Model, CE_Cook_From_Scratch_Model, CE_Cooking_Flag, CE_Corrective_Lenses_Present_Fla, CE_Country_Club_Member_Model, CE_County_Nielsen_Rank_Code, CE_County_Nielsen_Region_Code, CE_Credit_Card_Rewards_Model, CE_Cruise_Model, CE_DIY_Auto_Maintenance_Model, CE_Delivery_Point, CE_Delivery_Unit_Size, CE_Diabetes_Flag, CE_Diet_Product_Model, CE_Dieting_Weightloss_Flag, CE_Discretionary_Income_Score, CE_Dog_Product_Model, CE_Donor_Ever_Contributor_Flag, CE_Donors_PBS_NPR_Model, CE_E_Reader_Model, CE_Early_Internet_Adopter_Model, CE_Education_Loan_Model, CE_Electronics_Interest_Flag, CE_Emphysema_Flag, CE_Environment_Contributor_Flag, CE_Expendable_Income_Rank_Code, CE_Family_Income_Detector, CE_Family_Income_Detector_Code, CE_Family_Income_Detector_Ranges, CE_Fantasy_Sports_Model, CE_Fast_Food_Model, CE_Female_Occupation_Code, CE_Financial_Planner_Model, CE_Financing_Type, CE_Fireplaces, CE_Fishing_Flag, CE_Foreign_Travel_Flag, CE_Foreign_Travel_Vacation_Model, CE_Frequent_Business_Traveler_Mo, CE_Frequent_Flyer_Model, CE_Frequent_Headaches_Flag, CE_Fresh_Water_Fishing_Model, CE_Frozen_Dinner_Model, CE_Gambling_Flag, CE_Garage_Pool_Presence, CE_Garage_Type_Code, CE_Garden_Maintenance_Model, CE_Gardening_Horticulture_Intere, CE_Gift_Buyers_Model, CE_Golf_Model, CE_Golfer_Flag, CE_Gourmet_Food_Wine_Interest_Fl, CE_Grandparent_Present_Flag, CE_Green_Model, CE_Handcrafts_Sewing_Interest_Fl, CE_Health_Contributor_Flag, CE_Health_Fitness_Interest_Flag, CE_Health_Insurance_Model, CE_Hearing_Difficulty_Flag, CE_Heating_Type_Code, CE_Heavy_Book_Buyer_Model, CE_Heavy_Catalog_Buyer_Model, CE_Heavy_Coupon_User_Model, CE_Heavy_Domestic_Traveler_Model, CE_Heavy_Family_Restaurant_Visit, CE_Heavy_Internet_User_Model, CE_Heavy_Investment_Trader_Model, CE_Heavy_Online_Buyer_Model, CE_Heavy_Payperview_Movie_Model, CE_Heavy_Payperview_Sports_Model, CE_Heavy_Snack_Eaters_Model, CE_Heavy_Vitamin_Model, CE_High_Blood_Pressure_Flag, CE_High_Cholesterol_Flag, CE_High_End_Apparel_Model, CE_High_End_Electronic_Model, CE_High_End_Sporting_Equipment_M, CE_High_Risk_Investor_Model, CE_High_Tech_Flag, CE_High_Ticket_Mail_Order_Flag, CE_High_Value_Security_Investor, CE_High_Value_Stock_Investor_Mod, CE_Higher_Education_Model, CE_Hockey_Buyer_Model, CE_Home_Age, CE_Home_Age_Source, CE_Home_Decorating_Interest_Flag, CE_Home_Equity_Estimate_Code, CE_Home_Improvement_Model, CE_Home_Loan_Interest_Rate, CE_Home_Office_Model, CE_Home_Owner_Flag, CE_Home_Sale_Date, CE_Home_Sale_Date_Source, CE_Home_Sale_Price, CE_Home_Sale_Price_Source, CE_Home_Size, CE_Home_Value_Code, CE_Home_Value_Source_Code, CE_Home_Workshop_Interest_Flag, CE_Homeowner_Source_Code, CE_House_Fraction, CE_House_Number, CE_Household_Active_Trade_Lines, CE_Household_Dropped_Flag, CE_Household_Head_Age_Code, CE_Household_Head_Age_Code_Sourc, CE_Household_Head_Has_Travel_Ent, CE_Household_ID, CE_Household_Status_Code, CE_Hunting_Flag, CE_Hunting_Model, CE_Hybrid_Cars_Model, CE_Impulse_Buyer_Model, CE_Income_Producing_Assets, CE_Income_Producing_Assets_Desc, CE_Incontenance_Flag, CE_Individual2_Age, CE_Individual2_Gender, CE_Individual2_Given_Name, CE_Individual2_Has_Finance_Card, CE_Individual2_Has_Misc_Credit_C, CE_Individual2_Has_Oil_Company_C, CE_Individual2_Has_Premium_Bank, CE_Individual2_Has_Retail_Store, CE_Individual2_Has_Specialty_Sto, CE_Individual2_Has_Upscale_Retai, CE_Individual2_Head_of_Household, CE_Individual2_Individual_ID, CE_Individual2_Marital_Stat_Code, CE_Individual2_Marriage_Date, CE_Individual2_Middle_Initial, CE_Individual2_Parent_Flag, CE_Individual2_Political_Affilia, CE_Individual2_Spouse_Flag, CE_Individual2_Surname, CE_Individual2_Surname_Suffix, CE_Individual2_Title_Code, CE_Individual2_Vendor_Country_Or, CE_Individual2_Vendor_Ethnic_Gro, CE_Individual2_Vendor_Ethnicity, CE_Individual2_Vendor_Religion_C, CE_Individual2_Vendor_Spoken_Lan, CE_Individual2_Work_At_Home_Flag, CE_Individual2_YYYYMMDD_Of_Birth, CE_Individual3_Age, CE_Individual3_Gender, CE_Individual3_Given_Name, CE_Individual3_Has_Finance_Card, CE_Individual3_Has_Misc_Credit_C, CE_Individual3_Has_Oil_Company_C, CE_Individual3_Has_Premium_Bank, CE_Individual3_Has_Retail_Store, CE_Individual3_Has_Specialty_Sto, CE_Individual3_Has_Upscale_Retai, CE_Individual3_Head_of_Household, CE_Individual3_Individual_ID, CE_Individual3_Marital_Stat_Code, CE_Individual3_Marriage_Date, CE_Individual3_Middle_Initial, CE_Individual3_Parent_Flag, CE_Individual3_Political_Affilia, CE_Individual3_Spouse_Flag, CE_Individual3_Surname, CE_Individual3_Surname_Suffix, CE_Individual3_Title_Code, CE_Individual3_Vendor_Country_Or, CE_Individual3_Vendor_Ethnic_Gro, CE_Individual3_Vendor_Ethnicity, CE_Individual3_Vendor_Religion_C, CE_Individual3_Vendor_Spoken_Lan, CE_Individual3_Work_At_Home_Flag, CE_Individual3_YYYYMMDD_Of_Birth, CE_Individual_HoH_Age, CE_Individual_HoH_Gender, CE_Individual_HoH_Given_Name, CE_Individual_HoH_Has_Finance_Ca, CE_Individual_HoH_Has_Misc_Credi, CE_Individual_HoH_Has_Oil_Compan, CE_Individual_HoH_Has_Premium_Ba, CE_Individual_HoH_Has_Retail_Sto, CE_Individual_HoH_Has_Specialty, CE_Individual_HoH_Has_Upscale_Re, CE_Individual_HoH_Head_of_Househ, CE_Individual_HoH_Individual_ID, CE_Individual_HoH_Marital_Status, CE_Individual_HoH_Marriage_Date, CE_Individual_HoH_Middle_Initial, CE_Individual_HoH_Mobile_Age_Fla, CE_Individual_HoH_Mortgage_Link, CE_Individual_HoH_Parent_Flag, CE_Individual_HoH_Political_Affi, CE_Individual_HoH_Spouse_Flag, CE_Individual_HoH_Surname, CE_Individual_HoH_Surname_Suffix, CE_Individual_HoH_Title_Code, CE_Individual_HoH_Vendor_Country, CE_Individual_HoH_Vendor_Ethnic, CE_Individual_HoH_Vendor_Ethnici, CE_Individual_HoH_Vendor_Religio, CE_Individual_HoH_Vendor_Spoken, CE_Individual_HoH_Work_At_Home_F, CE_Individual_HoH_YYYYMMDD_Of_Bi, CE_InfoPersona_Cluster, CE_InfoPersona_SuperCluster, CE_Interest_Rate_Source, CE_Intl_Long_Distance_Model, CE_Invest_Not_Stocks_Bonds_Flag, CE_LHI_Household_Apparel_Accesso, CE_LHI_Household_Apparel_General, CE_LHI_Household_Apparel_Kids, CE_LHI_Household_Apparel_Mens, CE_LHI_Household_Apparel_Mens_Fa, CE_LHI_Household_Apparel_Wo_0001, CE_LHI_Household_Apparel_Womens, CE_LHI_Household_Auto_Racing, CE_LHI_Household_Auto_Trucks, CE_LHI_Household_Automotive, CE_LHI_Household_Aviation, CE_LHI_Household_Bargain_Seekers, CE_LHI_Household_Beauty_Cosmetic, CE_LHI_Household_Bible, CE_LHI_Household_Birds, CE_LHI_Household_Business_Home_O, CE_LHI_Household_Business_Items, CE_LHI_Household_Catalogs, CE_LHI_Household_Charitable_Dono, CE_LHI_Household_Collectibles, CE_LHI_Household_Collectibles_St, CE_LHI_Household_College, CE_LHI_Household_Computers, CE_LHI_Household_Cooking, CE_LHI_Household_Cooking_Gourmet, CE_LHI_Household_Crafts_Crocheti, CE_LHI_Household_Crafts_General, CE_LHI_Household_Crafts_Knitting, CE_LHI_Household_Crafts_Needlepo, CE_LHI_Household_Crafts_Quilting, CE_LHI_Household_Crafts_Sewing, CE_LHI_Household_Culture_Arts, CE_LHI_Household_Current_Events, CE_LHI_Household_Do_It_Yourselfe, CE_LHI_Household_Ego_Personalize, CE_LHI_Household_Electronics, CE_LHI_Household_Equestrian, CE_LHI_Household_Ethnic_Pro_0001, CE_LHI_Household_Ethnic_Pro_0002, CE_LHI_Household_Ethnic_Product, CE_LHI_Household_Family, CE_LHI_Household_Finance_Credit, CE_LHI_Household_Finance_Money_M, CE_LHI_Household_Finance_Persona, CE_LHI_Household_Finance_Stocks, CE_LHI_Household_Gambling, CE_LHI_Household_Games, CE_LHI_Household_Gardening, CE_LHI_Household_Gift_Giver, CE_LHI_Household_Health_Dieting, CE_LHI_Household_Health_Fitness, CE_LHI_Household_Health_General, CE_LHI_Household_High_Ticket, CE_LHI_Household_Hightech, CE_LHI_Household_History, CE_LHI_Household_History_America, CE_LHI_Household_Hobbies, CE_LHI_Household_Home_Decorating, CE_LHI_Household_Humor, CE_LHI_Household_Inspirational, CE_LHI_Household_Internet, CE_LHI_Household_Internet_Access, CE_LHI_Household_Internet_Buying, CE_LHI_Household_Motorcycles, CE_LHI_Household_Music, CE_LHI_Household_Ocean, CE_LHI_Household_Outdoors, CE_LHI_Household_Outdoors_Boatin, CE_LHI_Household_Outdoors_Campin, CE_LHI_Household_Outdoors_Fishin, CE_LHI_Household_Outdoors_H_0001, CE_LHI_Household_Outdoors_Huntin, CE_LHI_Household_Pets, CE_LHI_Household_Pets_Cats, CE_LHI_Household_Pets_Dogs, CE_LHI_Household_Photo_Photograp, CE_LHI_Household_Photo_Photoproc, CE_LHI_Household_Politically_Con, CE_LHI_Household_Politically_Lib, CE_LHI_Household_Publish_Books, CE_LHI_Household_Publish_Fiction, CE_LHI_Household_Publish_Magazin, CE_LHI_Household_Publish_Nonfict, CE_LHI_Household_Publish_Publica, CE_LHI_Household_Publish_Science, CE_LHI_Household_Rural_Farming, CE_LHI_Household_Science, CE_LHI_Household_Seniors, CE_LHI_Household_Sports_Baseball, CE_LHI_Household_Sports_Basketba, CE_LHI_Household_Sports_Football, CE_LHI_Household_Sports_General, CE_LHI_Household_Sports_Golf, CE_LHI_Household_Sports_Hockey, CE_LHI_Household_Sports_Skiing, CE_LHI_Household_Sports_Soccer, CE_LHI_Household_Sports_Tennis, CE_LHI_Household_Stationery, CE_LHI_Household_Sweepstakes, CE_LHI_Household_TV_Movies, CE_LHI_Household_Technology_VCR, CE_LHI_Household_Tobacco, CE_LHI_Household_Travel_Cruises, CE_LHI_Household_Travel_Foreign, CE_LHI_Household_Travel_General, CE_LHI_Household_Travel_RV, CE_LHI_Household_Travel_US, CE_LHI_Household_Wildlife, CE_LHI_Individual_HoH_Apparel_Ge, CE_Leaning_Conservative_Model, CE_Leaning_Liberal_Model, CE_Length_of_Residence_Years, CE_Liberal_Model, CE_Life_Insurance_Model, CE_Live_Theater_Model, CE_Loan_Amount, CE_Loan_Amount_Source, CE_Loan_Type, CE_Loan_to_Value_Ratio_Range_Cod, CE_Location_ID, CE_Location_Type, CE_Lot_Size, CE_Low_End_Sporting_Equip_Model, CE_Low_Risk_Investor_Model, CE_Luxury_Car_Buyer_Model, CE_Luxury_Hotel_Model, CE_Magazine_Subscriber_Flag, CE_Mail_Order_Buyer_Current_Flag, CE_Mail_Order_Buyer_Ever_Flag, CE_Mail_Order_Software_Purchase, CE_Mail_Responsive_Current_Flag, CE_Mail_Responsive_Ever_Flag, CE_Mail_Responsive_Previous_Flag, CE_Major_Home_Remodeling_Model, CE_Male_Occupation_Code, CE_Marketing_HH_1_To_2_People, CE_Marketing_HH_3_Plus_People, CE_Marketing_Target_Age_0_To_11, CE_Marketing_Target_Age_0_To_17, CE_Marketing_Target_Age_0_To_5, CE_Marketing_Target_Age_12_To_17, CE_Marketing_Target_Age_6_To_11, CE_Marketing_Target_Age_Over_50, CE_Marketing_Target_Age_Over_65, CE_Marketing_Target_Females_0001, CE_Marketing_Target_Females_0002, CE_Marketing_Target_Females_0003, CE_Marketing_Target_Females_0004, CE_Marketing_Target_Females_0005, CE_Marketing_Target_Females_0006, CE_Marketing_Target_Females_0007, CE_Marketing_Target_Females_0008, CE_Marketing_Target_Females_Age, CE_Marketing_Target_Males_A_0001, CE_Marketing_Target_Males_A_0002, CE_Marketing_Target_Males_Age_12, CE_Marketing_Target_Males_Age_18, CE_Marketing_Target_Males_Age_25, CE_Marketing_Target_Males_Age_35, CE_Marketing_Target_Males_Age_45, CE_Marketing_Target_Males_Age_55, CE_Member_Count, CE_Migraines_Flag, CE_Minivan_Buyer_Model, CE_Mobile_Internet_Access_Model, CE_Moderate_Economy_Hotel_Model, CE_Mortgage_Amount_Source_Code, CE_Mortgage_Type_Source_Code, CE_Move_Out_Flag, CE_Multi_Unit_Flag, CE_Music_Concert_Classical_Model, CE_Music_Concert_Country_Model, CE_Music_Concert_Rock_Model, CE_Nascar_Model, CE_New_Vehicle_Buyer_Model, CE_Non_Religious_Donor_Model, CE_Number_Adult_Females, CE_Number_Adult_Males, CE_Number_Adults, CE_Number_Bathrooms, CE_Number_Bedrooms, CE_Number_Children, CE_Occupancy_Count, CE_Online_Bill_Payment_Model, CE_Online_Gaming_Model, CE_Online_Invest_Trading_Model, CE_Online_Music_Download_Model, CE_Online_Purchase_Bus_Model, CE_Online_Purchase_Personl_Model, CE_Online_TV_Download_Model, CE_Online_Travel_Plan_Model, CE_Opinion_Leader_Model, CE_Opportunist_Flag, CE_Organic_Food_Model, CE_Osteoporosis_Flag, CE_Outdoor_Activities_Model, CE_Outdoor_Enthusiast_Flag, CE_Own_Rent_Likelihood_Code, CE_Pensioner_Present_Flag, CE_Pet_Owner_Flag, CE_Photography_Enthusiast_Flag, CE_Physical_Fitness_Club_Model, CE_Physical_Handicap_Flag, CE_Pilates_Yoga_Model, CE_Political_Contributor_Flag, CE_Postal_County_Code, CE_Postal_State_Code, CE_Potential_Investor_Consumer_S, CE_Power_Boating_Model, CE_Presence_Age_0_To_3_Flag, CE_Presence_Age_13_To_17_Flag, CE_Presence_Age_4_To_7_Flag, CE_Presence_Age_8_To_12_Flag, CE_Primary_Family_Flag, CE_Pro_Tax_Preparation_Model, CE_Professional_Baseball_Model, CE_Professional_Basketball_Model, CE_Professional_Football_Model, CE_Professional_Wrestling_Model, CE_Property_Type, CE_Purchasing_Power_Income_Code, CE_Purchasing_Power_Income_Detec, CE_Real_Estate_Investment_Model, CE_Recency_Date_Formatted, CE_Reference_Qualified_Indicator, CE_Religious_Contributor_Flag, CE_Religious_Donor_Model, CE_Rental_Car_Model, CE_Revolver_Minimum_Payment_Mode, CE_Rooms, CE_SUV_Buyer_Model, CE_Safety_Security_Conscious_Mod, CE_Salt_Water_Fishing_Model, CE_Satellite_TV_Model, CE_Second_Property_Indicator_Fla, CE_Selected_Age, CE_Selected_Gender, CE_Selected_Given_Name, CE_Selected_Ind_YYYYMMDD_Birth, CE_Selected_Individual_Active_Ba, CE_Selected_Individual_Bank_Card, CE_Selected_Individual_Formatted, CE_Selected_Individual_Grandpare, CE_Selected_Individual_Has_Finan, CE_Selected_Individual_Has_Misc, CE_Selected_Individual_Has_Oil_C, CE_Selected_Individual_Has_Premi, CE_Selected_Individual_Has_Retai, CE_Selected_Individual_Has_Speci, CE_Selected_Individual_Has_Upsca, CE_Selected_Individual_Head_of_H, CE_Selected_Individual_Marital_S, CE_Selected_Individual_Parent_Fl, CE_Selected_Individual_Political, CE_Selected_Individual_Spouse_Fl, CE_Selected_Individual_Vend_0001, CE_Selected_Individual_Vendor_Co, CE_Selected_Individual_Vendor_Et, CE_Selected_Individual_Vendor_Re, CE_Selected_Individual_Vendor_Sp, CE_Selected_Individual_Work_At_H, CE_Selected_Middle_Initial, CE_Selected_Surname, CE_Selected_Surname_Suffix, CE_Shopaholics_Model, CE_Small_Business_Insur_Model, CE_Soccer_Model, CE_Social_Media_Network_Model, CE_Speclty_Org_Food_Store_Model, CE_Sports_Fanatics_Model, CE_Stamps_Coins_Collector_Flag, CE_Stocks_Bonds_Investments_Flag, CE_Surnames_In_Household, CE_Tennis_Model, CE_Timeshare_Owner_Model, CE_VCR_Ownership_Flag, CE_Veteran_Present_Flag, CE_Voice_Over_Internet_Model, CE_Wealthfinder_Code, CE_Wholesale_Club_Model, CE_Wifi_In_Home_Model, CE_Wifi_Outside_Of_Home_Model, CE_Wine_Lover_Model, CE_Work_Health_Insurance_Model, CE_Year_Home_Built, ER_ABI_NUMBER, ER_BUS_ADDRESS, ER_BUS_CITY, ER_BUS_COUNTY_CODE, ER_BUS_STATE, ER_BUS_TELEPHONE, ER_BUS_ZIP_CODE, ER_BUS_ZIP_FOUR, ER_COMPANY_NAME, ER_EMPLOYEE_CODE, ER_INDIVIDUAL_NAME, ER_SALES_VOLUME, ER_SIC, ER_SIC_DESCRIPTION, ER_TITLE_CODE, ER_TITLE_DESCRIPTION, EE_Email_Address, Email_Verify_Flag
INTO #SrcData
FROM (
	SELECT ETL_CreatedDate, ETL_FileName, customerid, email, sumtm_acct_id, tkt_acct_id, CE_ATV_Model, CE_Active_Bank_Card_Flag, CE_Adventure_Seekers_Model, CE_Allergies_Flag, CE_Alternative_Medicine_Model, CE_Alzheimers_Flag, CE_Angina_Heart_Flag, CE_Annuities_Model, CE_Apparel_Interest_Flag, CE_Arrival_Date_Formatted, CE_Arthritis_Flag, CE_Asthma_Flag, CE_Auto_Club_Model, CE_Auto_Loan_Model, CE_Avid_Cell_Phone_User_Model, CE_Avid_Gamers_Model, CE_Avid_Smart_Phone_Users_Model, CE_Avid_Theme_Park_Visitor_Model, CE_Baby_Product_Model, CE_Bank_Card_Holder_Flag, CE_Blog_Writing_Model, CE_Boat_Owner_Flag, CE_Boat_Propulsion_Code, CE_Books_Music_Interest_Flag, CE_Business_Banking_Model, CE_Buyer_Behavior_Cluster_Code, CE_Camping_Flag, CE_Camping_Model, CE_Car_Buff_Flag, CE_Carrier_Route, CE_Carrier_Route_Type, CE_Cat_Owner_Flag, CE_Cat_Product_Model, CE_Cell_Phone_Only_Model, CE_Children_By_Age_By_Gender, CE_Children_By_Age_By_Month, CE_Children_Present_Flag, CE_Childrens_Products_Interest_F, CE_Collectibles_Interest_Flag, CE_College_Basketball_Model, CE_College_Football_Model, CE_Comprehensive_Auto_Ins_Model, CE_Computer_Owner_Flag, CE_Conservative_Model, CE_Construction_Type_Code, CE_Cook_For_Fun_Model, CE_Cook_From_Scratch_Model, CE_Cooking_Flag, CE_Corrective_Lenses_Present_Fla, CE_Country_Club_Member_Model, CE_County_Nielsen_Rank_Code, CE_County_Nielsen_Region_Code, CE_Credit_Card_Rewards_Model, CE_Cruise_Model, CE_DIY_Auto_Maintenance_Model, CE_Delivery_Point, CE_Delivery_Unit_Size, CE_Diabetes_Flag, CE_Diet_Product_Model, CE_Dieting_Weightloss_Flag, CE_Discretionary_Income_Score, CE_Dog_Product_Model, CE_Donor_Ever_Contributor_Flag, CE_Donors_PBS_NPR_Model, CE_E_Reader_Model, CE_Early_Internet_Adopter_Model, CE_Education_Loan_Model, CE_Electronics_Interest_Flag, CE_Emphysema_Flag, CE_Environment_Contributor_Flag, CE_Expendable_Income_Rank_Code, CE_Family_Income_Detector, CE_Family_Income_Detector_Code, CE_Family_Income_Detector_Ranges, CE_Fantasy_Sports_Model, CE_Fast_Food_Model, CE_Female_Occupation_Code, CE_Financial_Planner_Model, CE_Financing_Type, CE_Fireplaces, CE_Fishing_Flag, CE_Foreign_Travel_Flag, CE_Foreign_Travel_Vacation_Model, CE_Frequent_Business_Traveler_Mo, CE_Frequent_Flyer_Model, CE_Frequent_Headaches_Flag, CE_Fresh_Water_Fishing_Model, CE_Frozen_Dinner_Model, CE_Gambling_Flag, CE_Garage_Pool_Presence, CE_Garage_Type_Code, CE_Garden_Maintenance_Model, CE_Gardening_Horticulture_Intere, CE_Gift_Buyers_Model, CE_Golf_Model, CE_Golfer_Flag, CE_Gourmet_Food_Wine_Interest_Fl, CE_Grandparent_Present_Flag, CE_Green_Model, CE_Handcrafts_Sewing_Interest_Fl, CE_Health_Contributor_Flag, CE_Health_Fitness_Interest_Flag, CE_Health_Insurance_Model, CE_Hearing_Difficulty_Flag, CE_Heating_Type_Code, CE_Heavy_Book_Buyer_Model, CE_Heavy_Catalog_Buyer_Model, CE_Heavy_Coupon_User_Model, CE_Heavy_Domestic_Traveler_Model, CE_Heavy_Family_Restaurant_Visit, CE_Heavy_Internet_User_Model, CE_Heavy_Investment_Trader_Model, CE_Heavy_Online_Buyer_Model, CE_Heavy_Payperview_Movie_Model, CE_Heavy_Payperview_Sports_Model, CE_Heavy_Snack_Eaters_Model, CE_Heavy_Vitamin_Model, CE_High_Blood_Pressure_Flag, CE_High_Cholesterol_Flag, CE_High_End_Apparel_Model, CE_High_End_Electronic_Model, CE_High_End_Sporting_Equipment_M, CE_High_Risk_Investor_Model, CE_High_Tech_Flag, CE_High_Ticket_Mail_Order_Flag, CE_High_Value_Security_Investor, CE_High_Value_Stock_Investor_Mod, CE_Higher_Education_Model, CE_Hockey_Buyer_Model, CE_Home_Age, CE_Home_Age_Source, CE_Home_Decorating_Interest_Flag, CE_Home_Equity_Estimate_Code, CE_Home_Improvement_Model, CE_Home_Loan_Interest_Rate, CE_Home_Office_Model, CE_Home_Owner_Flag, CE_Home_Sale_Date, CE_Home_Sale_Date_Source, CE_Home_Sale_Price, CE_Home_Sale_Price_Source, CE_Home_Size, CE_Home_Value_Code, CE_Home_Value_Source_Code, CE_Home_Workshop_Interest_Flag, CE_Homeowner_Source_Code, CE_House_Fraction, CE_House_Number, CE_Household_Active_Trade_Lines, CE_Household_Dropped_Flag, CE_Household_Head_Age_Code, CE_Household_Head_Age_Code_Sourc, CE_Household_Head_Has_Travel_Ent, CE_Household_ID, CE_Household_Status_Code, CE_Hunting_Flag, CE_Hunting_Model, CE_Hybrid_Cars_Model, CE_Impulse_Buyer_Model, CE_Income_Producing_Assets, CE_Income_Producing_Assets_Desc, CE_Incontenance_Flag, CE_Individual2_Age, CE_Individual2_Gender, CE_Individual2_Given_Name, CE_Individual2_Has_Finance_Card, CE_Individual2_Has_Misc_Credit_C, CE_Individual2_Has_Oil_Company_C, CE_Individual2_Has_Premium_Bank, CE_Individual2_Has_Retail_Store, CE_Individual2_Has_Specialty_Sto, CE_Individual2_Has_Upscale_Retai, CE_Individual2_Head_of_Household, CE_Individual2_Individual_ID, CE_Individual2_Marital_Stat_Code, CE_Individual2_Marriage_Date, CE_Individual2_Middle_Initial, CE_Individual2_Parent_Flag, CE_Individual2_Political_Affilia, CE_Individual2_Spouse_Flag, CE_Individual2_Surname, CE_Individual2_Surname_Suffix, CE_Individual2_Title_Code, CE_Individual2_Vendor_Country_Or, CE_Individual2_Vendor_Ethnic_Gro, CE_Individual2_Vendor_Ethnicity, CE_Individual2_Vendor_Religion_C, CE_Individual2_Vendor_Spoken_Lan, CE_Individual2_Work_At_Home_Flag, CE_Individual2_YYYYMMDD_Of_Birth, CE_Individual3_Age, CE_Individual3_Gender, CE_Individual3_Given_Name, CE_Individual3_Has_Finance_Card, CE_Individual3_Has_Misc_Credit_C, CE_Individual3_Has_Oil_Company_C, CE_Individual3_Has_Premium_Bank, CE_Individual3_Has_Retail_Store, CE_Individual3_Has_Specialty_Sto, CE_Individual3_Has_Upscale_Retai, CE_Individual3_Head_of_Household, CE_Individual3_Individual_ID, CE_Individual3_Marital_Stat_Code, CE_Individual3_Marriage_Date, CE_Individual3_Middle_Initial, CE_Individual3_Parent_Flag, CE_Individual3_Political_Affilia, CE_Individual3_Spouse_Flag, CE_Individual3_Surname, CE_Individual3_Surname_Suffix, CE_Individual3_Title_Code, CE_Individual3_Vendor_Country_Or, CE_Individual3_Vendor_Ethnic_Gro, CE_Individual3_Vendor_Ethnicity, CE_Individual3_Vendor_Religion_C, CE_Individual3_Vendor_Spoken_Lan, CE_Individual3_Work_At_Home_Flag, CE_Individual3_YYYYMMDD_Of_Birth, CE_Individual_HoH_Age, CE_Individual_HoH_Gender, CE_Individual_HoH_Given_Name, CE_Individual_HoH_Has_Finance_Ca, CE_Individual_HoH_Has_Misc_Credi, CE_Individual_HoH_Has_Oil_Compan, CE_Individual_HoH_Has_Premium_Ba, CE_Individual_HoH_Has_Retail_Sto, CE_Individual_HoH_Has_Specialty, CE_Individual_HoH_Has_Upscale_Re, CE_Individual_HoH_Head_of_Househ, CE_Individual_HoH_Individual_ID, CE_Individual_HoH_Marital_Status, CE_Individual_HoH_Marriage_Date, CE_Individual_HoH_Middle_Initial, CE_Individual_HoH_Mobile_Age_Fla, CE_Individual_HoH_Mortgage_Link, CE_Individual_HoH_Parent_Flag, CE_Individual_HoH_Political_Affi, CE_Individual_HoH_Spouse_Flag, CE_Individual_HoH_Surname, CE_Individual_HoH_Surname_Suffix, CE_Individual_HoH_Title_Code, CE_Individual_HoH_Vendor_Country, CE_Individual_HoH_Vendor_Ethnic, CE_Individual_HoH_Vendor_Ethnici, CE_Individual_HoH_Vendor_Religio, CE_Individual_HoH_Vendor_Spoken, CE_Individual_HoH_Work_At_Home_F, CE_Individual_HoH_YYYYMMDD_Of_Bi, CE_InfoPersona_Cluster, CE_InfoPersona_SuperCluster, CE_Interest_Rate_Source, CE_Intl_Long_Distance_Model, CE_Invest_Not_Stocks_Bonds_Flag, CE_LHI_Household_Apparel_Accesso, CE_LHI_Household_Apparel_General, CE_LHI_Household_Apparel_Kids, CE_LHI_Household_Apparel_Mens, CE_LHI_Household_Apparel_Mens_Fa, CE_LHI_Household_Apparel_Wo_0001, CE_LHI_Household_Apparel_Womens, CE_LHI_Household_Auto_Racing, CE_LHI_Household_Auto_Trucks, CE_LHI_Household_Automotive, CE_LHI_Household_Aviation, CE_LHI_Household_Bargain_Seekers, CE_LHI_Household_Beauty_Cosmetic, CE_LHI_Household_Bible, CE_LHI_Household_Birds, CE_LHI_Household_Business_Home_O, CE_LHI_Household_Business_Items, CE_LHI_Household_Catalogs, CE_LHI_Household_Charitable_Dono, CE_LHI_Household_Collectibles, CE_LHI_Household_Collectibles_St, CE_LHI_Household_College, CE_LHI_Household_Computers, CE_LHI_Household_Cooking, CE_LHI_Household_Cooking_Gourmet, CE_LHI_Household_Crafts_Crocheti, CE_LHI_Household_Crafts_General, CE_LHI_Household_Crafts_Knitting, CE_LHI_Household_Crafts_Needlepo, CE_LHI_Household_Crafts_Quilting, CE_LHI_Household_Crafts_Sewing, CE_LHI_Household_Culture_Arts, CE_LHI_Household_Current_Events, CE_LHI_Household_Do_It_Yourselfe, CE_LHI_Household_Ego_Personalize, CE_LHI_Household_Electronics, CE_LHI_Household_Equestrian, CE_LHI_Household_Ethnic_Pro_0001, CE_LHI_Household_Ethnic_Pro_0002, CE_LHI_Household_Ethnic_Product, CE_LHI_Household_Family, CE_LHI_Household_Finance_Credit, CE_LHI_Household_Finance_Money_M, CE_LHI_Household_Finance_Persona, CE_LHI_Household_Finance_Stocks, CE_LHI_Household_Gambling, CE_LHI_Household_Games, CE_LHI_Household_Gardening, CE_LHI_Household_Gift_Giver, CE_LHI_Household_Health_Dieting, CE_LHI_Household_Health_Fitness, CE_LHI_Household_Health_General, CE_LHI_Household_High_Ticket, CE_LHI_Household_Hightech, CE_LHI_Household_History, CE_LHI_Household_History_America, CE_LHI_Household_Hobbies, CE_LHI_Household_Home_Decorating, CE_LHI_Household_Humor, CE_LHI_Household_Inspirational, CE_LHI_Household_Internet, CE_LHI_Household_Internet_Access, CE_LHI_Household_Internet_Buying, CE_LHI_Household_Motorcycles, CE_LHI_Household_Music, CE_LHI_Household_Ocean, CE_LHI_Household_Outdoors, CE_LHI_Household_Outdoors_Boatin, CE_LHI_Household_Outdoors_Campin, CE_LHI_Household_Outdoors_Fishin, CE_LHI_Household_Outdoors_H_0001, CE_LHI_Household_Outdoors_Huntin, CE_LHI_Household_Pets, CE_LHI_Household_Pets_Cats, CE_LHI_Household_Pets_Dogs, CE_LHI_Household_Photo_Photograp, CE_LHI_Household_Photo_Photoproc, CE_LHI_Household_Politically_Con, CE_LHI_Household_Politically_Lib, CE_LHI_Household_Publish_Books, CE_LHI_Household_Publish_Fiction, CE_LHI_Household_Publish_Magazin, CE_LHI_Household_Publish_Nonfict, CE_LHI_Household_Publish_Publica, CE_LHI_Household_Publish_Science, CE_LHI_Household_Rural_Farming, CE_LHI_Household_Science, CE_LHI_Household_Seniors, CE_LHI_Household_Sports_Baseball, CE_LHI_Household_Sports_Basketba, CE_LHI_Household_Sports_Football, CE_LHI_Household_Sports_General, CE_LHI_Household_Sports_Golf, CE_LHI_Household_Sports_Hockey, CE_LHI_Household_Sports_Skiing, CE_LHI_Household_Sports_Soccer, CE_LHI_Household_Sports_Tennis, CE_LHI_Household_Stationery, CE_LHI_Household_Sweepstakes, CE_LHI_Household_TV_Movies, CE_LHI_Household_Technology_VCR, CE_LHI_Household_Tobacco, CE_LHI_Household_Travel_Cruises, CE_LHI_Household_Travel_Foreign, CE_LHI_Household_Travel_General, CE_LHI_Household_Travel_RV, CE_LHI_Household_Travel_US, CE_LHI_Household_Wildlife, CE_LHI_Individual_HoH_Apparel_Ge, CE_Leaning_Conservative_Model, CE_Leaning_Liberal_Model, CE_Length_of_Residence_Years, CE_Liberal_Model, CE_Life_Insurance_Model, CE_Live_Theater_Model, CE_Loan_Amount, CE_Loan_Amount_Source, CE_Loan_Type, CE_Loan_to_Value_Ratio_Range_Cod, CE_Location_ID, CE_Location_Type, CE_Lot_Size, CE_Low_End_Sporting_Equip_Model, CE_Low_Risk_Investor_Model, CE_Luxury_Car_Buyer_Model, CE_Luxury_Hotel_Model, CE_Magazine_Subscriber_Flag, CE_Mail_Order_Buyer_Current_Flag, CE_Mail_Order_Buyer_Ever_Flag, CE_Mail_Order_Software_Purchase, CE_Mail_Responsive_Current_Flag, CE_Mail_Responsive_Ever_Flag, CE_Mail_Responsive_Previous_Flag, CE_Major_Home_Remodeling_Model, CE_Male_Occupation_Code, CE_Marketing_HH_1_To_2_People, CE_Marketing_HH_3_Plus_People, CE_Marketing_Target_Age_0_To_11, CE_Marketing_Target_Age_0_To_17, CE_Marketing_Target_Age_0_To_5, CE_Marketing_Target_Age_12_To_17, CE_Marketing_Target_Age_6_To_11, CE_Marketing_Target_Age_Over_50, CE_Marketing_Target_Age_Over_65, CE_Marketing_Target_Females_0001, CE_Marketing_Target_Females_0002, CE_Marketing_Target_Females_0003, CE_Marketing_Target_Females_0004, CE_Marketing_Target_Females_0005, CE_Marketing_Target_Females_0006, CE_Marketing_Target_Females_0007, CE_Marketing_Target_Females_0008, CE_Marketing_Target_Females_Age, CE_Marketing_Target_Males_A_0001, CE_Marketing_Target_Males_A_0002, CE_Marketing_Target_Males_Age_12, CE_Marketing_Target_Males_Age_18, CE_Marketing_Target_Males_Age_25, CE_Marketing_Target_Males_Age_35, CE_Marketing_Target_Males_Age_45, CE_Marketing_Target_Males_Age_55, CE_Member_Count, CE_Migraines_Flag, CE_Minivan_Buyer_Model, CE_Mobile_Internet_Access_Model, CE_Moderate_Economy_Hotel_Model, CE_Mortgage_Amount_Source_Code, CE_Mortgage_Type_Source_Code, CE_Move_Out_Flag, CE_Multi_Unit_Flag, CE_Music_Concert_Classical_Model, CE_Music_Concert_Country_Model, CE_Music_Concert_Rock_Model, CE_Nascar_Model, CE_New_Vehicle_Buyer_Model, CE_Non_Religious_Donor_Model, CE_Number_Adult_Females, CE_Number_Adult_Males, CE_Number_Adults, CE_Number_Bathrooms, CE_Number_Bedrooms, CE_Number_Children, CE_Occupancy_Count, CE_Online_Bill_Payment_Model, CE_Online_Gaming_Model, CE_Online_Invest_Trading_Model, CE_Online_Music_Download_Model, CE_Online_Purchase_Bus_Model, CE_Online_Purchase_Personl_Model, CE_Online_TV_Download_Model, CE_Online_Travel_Plan_Model, CE_Opinion_Leader_Model, CE_Opportunist_Flag, CE_Organic_Food_Model, CE_Osteoporosis_Flag, CE_Outdoor_Activities_Model, CE_Outdoor_Enthusiast_Flag, CE_Own_Rent_Likelihood_Code, CE_Pensioner_Present_Flag, CE_Pet_Owner_Flag, CE_Photography_Enthusiast_Flag, CE_Physical_Fitness_Club_Model, CE_Physical_Handicap_Flag, CE_Pilates_Yoga_Model, CE_Political_Contributor_Flag, CE_Postal_County_Code, CE_Postal_State_Code, CE_Potential_Investor_Consumer_S, CE_Power_Boating_Model, CE_Presence_Age_0_To_3_Flag, CE_Presence_Age_13_To_17_Flag, CE_Presence_Age_4_To_7_Flag, CE_Presence_Age_8_To_12_Flag, CE_Primary_Family_Flag, CE_Pro_Tax_Preparation_Model, CE_Professional_Baseball_Model, CE_Professional_Basketball_Model, CE_Professional_Football_Model, CE_Professional_Wrestling_Model, CE_Property_Type, CE_Purchasing_Power_Income_Code, CE_Purchasing_Power_Income_Detec, CE_Real_Estate_Investment_Model, CE_Recency_Date_Formatted, CE_Reference_Qualified_Indicator, CE_Religious_Contributor_Flag, CE_Religious_Donor_Model, CE_Rental_Car_Model, CE_Revolver_Minimum_Payment_Mode, CE_Rooms, CE_SUV_Buyer_Model, CE_Safety_Security_Conscious_Mod, CE_Salt_Water_Fishing_Model, CE_Satellite_TV_Model, CE_Second_Property_Indicator_Fla, CE_Selected_Age, CE_Selected_Gender, CE_Selected_Given_Name, CE_Selected_Ind_YYYYMMDD_Birth, CE_Selected_Individual_Active_Ba, CE_Selected_Individual_Bank_Card, CE_Selected_Individual_Formatted, CE_Selected_Individual_Grandpare, CE_Selected_Individual_Has_Finan, CE_Selected_Individual_Has_Misc, CE_Selected_Individual_Has_Oil_C, CE_Selected_Individual_Has_Premi, CE_Selected_Individual_Has_Retai, CE_Selected_Individual_Has_Speci, CE_Selected_Individual_Has_Upsca, CE_Selected_Individual_Head_of_H, CE_Selected_Individual_Marital_S, CE_Selected_Individual_Parent_Fl, CE_Selected_Individual_Political, CE_Selected_Individual_Spouse_Fl, CE_Selected_Individual_Vend_0001, CE_Selected_Individual_Vendor_Co, CE_Selected_Individual_Vendor_Et, CE_Selected_Individual_Vendor_Re, CE_Selected_Individual_Vendor_Sp, CE_Selected_Individual_Work_At_H, CE_Selected_Middle_Initial, CE_Selected_Surname, CE_Selected_Surname_Suffix, CE_Shopaholics_Model, CE_Small_Business_Insur_Model, CE_Soccer_Model, CE_Social_Media_Network_Model, CE_Speclty_Org_Food_Store_Model, CE_Sports_Fanatics_Model, CE_Stamps_Coins_Collector_Flag, CE_Stocks_Bonds_Investments_Flag, CE_Surnames_In_Household, CE_Tennis_Model, CE_Timeshare_Owner_Model, CE_VCR_Ownership_Flag, CE_Veteran_Present_Flag, CE_Voice_Over_Internet_Model, CE_Wealthfinder_Code, CE_Wholesale_Club_Model, CE_Wifi_In_Home_Model, CE_Wifi_Outside_Of_Home_Model, CE_Wine_Lover_Model, CE_Work_Health_Insurance_Model, CE_Year_Home_Built, ER_ABI_NUMBER, ER_BUS_ADDRESS, ER_BUS_CITY, ER_BUS_COUNTY_CODE, ER_BUS_STATE, ER_BUS_TELEPHONE, ER_BUS_ZIP_CODE, ER_BUS_ZIP_FOUR, ER_COMPANY_NAME, ER_EMPLOYEE_CODE, ER_INDIVIDUAL_NAME, ER_SALES_VOLUME, ER_SIC, ER_SIC_DESCRIPTION, ER_TITLE_CODE, ER_TITLE_DESCRIPTION, EE_Email_Address, Email_Verify_Flag
	, ROW_NUMBER() OVER(PARTITION BY email, sumtm_acct_id ORDER BY ETL_ID) RowRank
	FROM stg.Infogroup_Demographic
) a
WHERE RowRank = 1


UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM([CE_Active_Bank_Card_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Adventure_Seekers_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Allergies_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Alternative_Medicine_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Alzheimers_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Angina_Heart_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Annuities_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Apparel_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Arrival_Date_Formatted]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Arthritis_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Asthma_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_ATV_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Auto_Club_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Auto_Loan_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Avid_Cell_Phone_User_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Avid_Gamers_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Avid_Smart_Phone_Users_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Avid_Theme_Park_Visitor_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Baby_Product_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Bank_Card_Holder_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Blog_Writing_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Boat_Owner_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Boat_Propulsion_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Books_Music_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Business_Banking_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Buyer_Behavior_Cluster_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Camping_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Camping_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Car_Buff_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Carrier_Route]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Carrier_Route_Type]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cat_Owner_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cat_Product_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cell_Phone_Only_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Children_By_Age_By_Gender]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Children_By_Age_By_Month]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Children_Present_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Childrens_Products_Interest_F]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Collectibles_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_College_Basketball_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_College_Football_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Comprehensive_Auto_Ins_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Computer_Owner_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Conservative_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Construction_Type_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cook_For_Fun_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cook_From_Scratch_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cooking_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Corrective_Lenses_Present_Fla]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Country_Club_Member_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_County_Nielsen_Rank_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_County_Nielsen_Region_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Credit_Card_Rewards_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Cruise_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Delivery_Point]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Delivery_Unit_Size]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Diabetes_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Diet_Product_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Dieting_Weightloss_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Discretionary_Income_Score]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_DIY_Auto_Maintenance_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Dog_Product_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Donor_Ever_Contributor_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Donors_PBS_NPR_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_E_Reader_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Early_Internet_Adopter_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Education_Loan_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Electronics_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Emphysema_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Environment_Contributor_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Expendable_Income_Rank_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Family_Income_Detector]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Family_Income_Detector_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Family_Income_Detector_Ranges]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Fantasy_Sports_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Fast_Food_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Female_Occupation_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Financial_Planner_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Financing_Type]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Fireplaces]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Fishing_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Foreign_Travel_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Foreign_Travel_Vacation_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Frequent_Business_Traveler_Mo]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Frequent_Flyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Frequent_Headaches_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Fresh_Water_Fishing_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Frozen_Dinner_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Gambling_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Garage_Pool_Presence]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Garage_Type_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Garden_Maintenance_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Gardening_Horticulture_Intere]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Gift_Buyers_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Golf_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Golfer_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Gourmet_Food_Wine_Interest_Fl]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Grandparent_Present_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Green_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Handcrafts_Sewing_Interest_Fl]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Health_Contributor_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Health_Fitness_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Health_Insurance_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Hearing_Difficulty_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heating_Type_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Book_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Catalog_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Coupon_User_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Domestic_Traveler_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Family_Restaurant_Visit]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Internet_User_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Investment_Trader_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Online_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Payperview_Movie_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Payperview_Sports_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Snack_Eaters_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Heavy_Vitamin_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Blood_Pressure_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Cholesterol_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_End_Apparel_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_End_Electronic_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_End_Sporting_Equipment_M]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Risk_Investor_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Tech_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Ticket_Mail_Order_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Value_Security_Investor]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_High_Value_Stock_Investor_Mod]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Higher_Education_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Hockey_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Age]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Age_Source]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Decorating_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Equity_Estimate_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Improvement_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Loan_Interest_Rate]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Office_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Owner_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Sale_Date]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Sale_Date_Source]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Sale_Price]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Sale_Price_Source]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Size]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Value_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Value_Source_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Home_Workshop_Interest_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Homeowner_Source_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_House_Fraction]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_House_Number]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_Active_Trade_Lines]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_Dropped_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_Head_Age_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_Head_Age_Code_Sourc]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_Head_Has_Travel_Ent]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_ID]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Household_Status_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Hunting_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Hunting_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Hybrid_Cars_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Impulse_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Income_Producing_Assets]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Income_Producing_Assets_Desc]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Incontenance_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Age]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Gender]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Given_Name]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Finance_Ca]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Misc_Credi]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Oil_Compan]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Premium_Ba]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Retail_Sto]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Specialty]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Has_Upscale_Re]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Head_of_Househ]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Individual_ID]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Marital_Status]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Marriage_Date]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Middle_Initial]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Mobile_Age_Fla]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Mortgage_Link]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Parent_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Political_Affi]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Spouse_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Surname]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Surname_Suffix]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Title_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Vendor_Country]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Vendor_Ethnic]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Vendor_Ethnici]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Vendor_Religio]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Vendor_Spoken]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_Work_At_Home_F]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual_HoH_YYYYMMDD_Of_Bi]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Age]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Gender]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Given_Name]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Finance_Card]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Misc_Credit_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Oil_Company_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Premium_Bank]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Retail_Store]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Specialty_Sto]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Has_Upscale_Retai]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Head_of_Household]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Individual_ID]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Marital_Stat_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Marriage_Date]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Middle_Initial]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Parent_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Political_Affilia]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Spouse_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Surname]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Surname_Suffix]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Title_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Vendor_Country_Or]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Vendor_Ethnic_Gro]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Vendor_Ethnicity]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Vendor_Religion_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Vendor_Spoken_Lan]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_Work_At_Home_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual2_YYYYMMDD_Of_Birth]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Age]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Gender]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Given_Name]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Finance_Card]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Misc_Credit_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Oil_Company_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Premium_Bank]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Retail_Store]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Specialty_Sto]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Has_Upscale_Retai]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Head_of_Household]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Individual_ID]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Marital_Stat_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Marriage_Date]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Middle_Initial]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Parent_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Political_Affilia]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Spouse_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Surname]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Surname_Suffix]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Title_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Vendor_Country_Or]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Vendor_Ethnic_Gro]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Vendor_Ethnicity]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Vendor_Religion_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Vendor_Spoken_Lan]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_Work_At_Home_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Individual3_YYYYMMDD_Of_Birth]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_InfoPersona_Cluster]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_InfoPersona_SuperCluster]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Interest_Rate_Source]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Intl_Long_Distance_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Invest_Not_Stocks_Bonds_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Leaning_Conservative_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Leaning_Liberal_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Length_of_Residence_Years]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_Accesso]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_General]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_Kids]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_Mens]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_Mens_Fa]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_Wo_0001]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Apparel_Womens]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Auto_Racing]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Auto_Trucks]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Automotive]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Aviation]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Bargain_Seekers]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Beauty_Cosmetic]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Bible]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Birds]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Business_Home_O]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Business_Items]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Catalogs]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Charitable_Dono]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Collectibles]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Collectibles_St]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_College]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Computers]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Cooking]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Cooking_Gourmet]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Crafts_Crocheti]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Crafts_General]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Crafts_Knitting]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Crafts_Needlepo]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Crafts_Quilting]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Crafts_Sewing]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Culture_Arts]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Current_Events]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Do_It_Yourselfe]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Ego_Personalize]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Electronics]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Equestrian]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Ethnic_Pro_0001]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Ethnic_Pro_0002]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Ethnic_Product]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Family]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Finance_Credit]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Finance_Money_M]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Finance_Persona]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Finance_Stocks]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Gambling]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Games]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Gardening]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Gift_Giver]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Health_Dieting]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Health_Fitness]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Health_General]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_High_Ticket]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Hightech]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_History]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_History_America]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Hobbies]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Home_Decorating]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Humor]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Inspirational]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Internet]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Internet_Access]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Internet_Buying]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Motorcycles]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Music]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Ocean]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Outdoors]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Outdoors_Boatin]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Outdoors_Campin]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Outdoors_Fishin]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Outdoors_H_0001]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Outdoors_Huntin]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Pets]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Pets_Cats]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Pets_Dogs]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Photo_Photograp]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Photo_Photoproc]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Politically_Con]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Politically_Lib]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Publish_Books]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Publish_Fiction]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Publish_Magazin]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Publish_Nonfict]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Publish_Publica]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Publish_Science]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Rural_Farming]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Science]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Seniors]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Baseball]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Basketba]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Football]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_General]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Golf]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Hockey]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Skiing]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Soccer]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sports_Tennis]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Stationery]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Sweepstakes]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Technology_VCR]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Tobacco]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Travel_Cruises]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Travel_Foreign]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Travel_General]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Travel_RV]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Travel_US]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_TV_Movies]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Household_Wildlife]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_LHI_Individual_HoH_Apparel_Ge]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Liberal_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Life_Insurance_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Live_Theater_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Loan_Amount]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Loan_Amount_Source]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Loan_to_Value_Ratio_Range_Cod]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Loan_Type]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Location_ID]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Location_Type]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Lot_Size]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Low_End_Sporting_Equip_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Low_Risk_Investor_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Luxury_Car_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Luxury_Hotel_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Magazine_Subscriber_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mail_Order_Buyer_Current_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mail_Order_Buyer_Ever_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mail_Order_Software_Purchase]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mail_Responsive_Current_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mail_Responsive_Ever_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mail_Responsive_Previous_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Major_Home_Remodeling_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Male_Occupation_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_HH_1_To_2_People]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_HH_3_Plus_People]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_0_To_11]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_0_To_17]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_0_To_5]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_12_To_17]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_6_To_11]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_Over_50]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Age_Over_65]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0001]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0002]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0003]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0004]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0005]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0006]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0007]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_0008]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Females_Age]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_A_0001]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_A_0002]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_Age_12]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_Age_18]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_Age_25]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_Age_35]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_Age_45]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Marketing_Target_Males_Age_55]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Member_Count]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Migraines_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Minivan_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mobile_Internet_Access_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Moderate_Economy_Hotel_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mortgage_Amount_Source_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Mortgage_Type_Source_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Move_Out_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Multi_Unit_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Music_Concert_Classical_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Music_Concert_Country_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Music_Concert_Rock_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Nascar_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_New_Vehicle_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Non_Religious_Donor_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Number_Adult_Females]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Number_Adult_Males]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Number_Adults]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Number_Bathrooms]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Number_Bedrooms]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Number_Children]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Occupancy_Count]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Bill_Payment_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Gaming_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Invest_Trading_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Music_Download_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Purchase_Bus_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Purchase_Personl_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_Travel_Plan_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Online_TV_Download_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Opinion_Leader_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Opportunist_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Organic_Food_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Osteoporosis_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Outdoor_Activities_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Outdoor_Enthusiast_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Own_Rent_Likelihood_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Pensioner_Present_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Pet_Owner_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Photography_Enthusiast_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Physical_Fitness_Club_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Physical_Handicap_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Pilates_Yoga_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Political_Contributor_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Postal_County_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Postal_State_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Potential_Investor_Consumer_S]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Power_Boating_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Presence_Age_0_To_3_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Presence_Age_13_To_17_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Presence_Age_4_To_7_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Presence_Age_8_To_12_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Primary_Family_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Pro_Tax_Preparation_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Professional_Baseball_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Professional_Basketball_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Professional_Football_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Professional_Wrestling_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Property_Type]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Purchasing_Power_Income_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Purchasing_Power_Income_Detec]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Real_Estate_Investment_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Recency_Date_Formatted]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Reference_Qualified_Indicator]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Religious_Contributor_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Religious_Donor_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Rental_Car_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Revolver_Minimum_Payment_Mode]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Rooms]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Safety_Security_Conscious_Mod]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Salt_Water_Fishing_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Satellite_TV_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Second_Property_Indicator_Fla]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Age]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Gender]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Given_Name]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Ind_YYYYMMDD_Birth]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Active_Ba]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Bank_Card]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Formatted]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Grandpare]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Finan]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Misc]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Oil_C]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Premi]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Retai]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Speci]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Has_Upsca]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Head_of_H]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Marital_S]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Parent_Fl]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Political]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Spouse_Fl]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Vend_0001]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Vendor_Co]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Vendor_Et]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Vendor_Re]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Vendor_Sp]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Individual_Work_At_H]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Middle_Initial]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Surname]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Selected_Surname_Suffix]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Shopaholics_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Small_Business_Insur_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Soccer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Social_Media_Network_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Speclty_Org_Food_Store_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Sports_Fanatics_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Stamps_Coins_Collector_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Stocks_Bonds_Investments_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Surnames_In_Household]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_SUV_Buyer_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Tennis_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Timeshare_Owner_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_VCR_Ownership_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Veteran_Present_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Voice_Over_Internet_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Wealthfinder_Code]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Wholesale_Club_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Wifi_In_Home_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Wifi_Outside_Of_Home_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Wine_Lover_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Work_Health_Insurance_Model]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([CE_Year_Home_Built]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([customerid]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([EE_Email_Address]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([email]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([Email_Verify_Flag]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_ABI_NUMBER]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_ADDRESS]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_CITY]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_COUNTY_CODE]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_STATE]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_TELEPHONE]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_ZIP_CODE]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_BUS_ZIP_FOUR]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_COMPANY_NAME]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_EMPLOYEE_CODE]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_INDIVIDUAL_NAME]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_SALES_VOLUME]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_SIC]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_SIC_DESCRIPTION]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_TITLE_CODE]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([ER_TITLE_DESCRIPTION]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([sumtm_acct_id]),'DBNULL_TEXT') 
											+ ISNULL(RTRIM([tkt_acct_id]),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (email, sumtm_acct_id)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)


MERGE ods.Infogroup_Demographic AS myTarget
USING #SrcData AS mySource
ON myTarget.email = mySource.email and myTarget.sumtm_acct_id = mySource.sumtm_acct_id

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
)

THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
	 ,myTarget.[ETL_IsDeleted] = 0
	 ,myTarget.[ETL_DeletedDate] = NULL
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ETL_FileName] = mySource.[ETL_FileName]
	, myTarget.[customerid] = mySource.[customerid]
	, myTarget.[email] = mySource.[email]
	, myTarget.[sumtm_acct_id] = mySource.[sumtm_acct_id]
	, myTarget.[tkt_acct_id] = mySource.[tkt_acct_id]
	, myTarget.[CE_ATV_Model] = mySource.[CE_ATV_Model]
	, myTarget.[CE_Active_Bank_Card_Flag] = mySource.[CE_Active_Bank_Card_Flag]
	, myTarget.[CE_Adventure_Seekers_Model] = mySource.[CE_Adventure_Seekers_Model]
	, myTarget.[CE_Allergies_Flag] = mySource.[CE_Allergies_Flag]
	, myTarget.[CE_Alternative_Medicine_Model] = mySource.[CE_Alternative_Medicine_Model]
	, myTarget.[CE_Alzheimers_Flag] = mySource.[CE_Alzheimers_Flag]
	, myTarget.[CE_Angina_Heart_Flag] = mySource.[CE_Angina_Heart_Flag]
	, myTarget.[CE_Annuities_Model] = mySource.[CE_Annuities_Model]
	, myTarget.[CE_Apparel_Interest_Flag] = mySource.[CE_Apparel_Interest_Flag]
	, myTarget.[CE_Arrival_Date_Formatted] = mySource.[CE_Arrival_Date_Formatted]
	, myTarget.[CE_Arthritis_Flag] = mySource.[CE_Arthritis_Flag]
	, myTarget.[CE_Asthma_Flag] = mySource.[CE_Asthma_Flag]
	, myTarget.[CE_Auto_Club_Model] = mySource.[CE_Auto_Club_Model]
	, myTarget.[CE_Auto_Loan_Model] = mySource.[CE_Auto_Loan_Model]
	, myTarget.[CE_Avid_Cell_Phone_User_Model] = mySource.[CE_Avid_Cell_Phone_User_Model]
	, myTarget.[CE_Avid_Gamers_Model] = mySource.[CE_Avid_Gamers_Model]
	, myTarget.[CE_Avid_Smart_Phone_Users_Model] = mySource.[CE_Avid_Smart_Phone_Users_Model]
	, myTarget.[CE_Avid_Theme_Park_Visitor_Model] = mySource.[CE_Avid_Theme_Park_Visitor_Model]
	, myTarget.[CE_Baby_Product_Model] = mySource.[CE_Baby_Product_Model]
	, myTarget.[CE_Bank_Card_Holder_Flag] = mySource.[CE_Bank_Card_Holder_Flag]
	, myTarget.[CE_Blog_Writing_Model] = mySource.[CE_Blog_Writing_Model]
	, myTarget.[CE_Boat_Owner_Flag] = mySource.[CE_Boat_Owner_Flag]
	, myTarget.[CE_Boat_Propulsion_Code] = mySource.[CE_Boat_Propulsion_Code]
	, myTarget.[CE_Books_Music_Interest_Flag] = mySource.[CE_Books_Music_Interest_Flag]
	, myTarget.[CE_Business_Banking_Model] = mySource.[CE_Business_Banking_Model]
	, myTarget.[CE_Buyer_Behavior_Cluster_Code] = mySource.[CE_Buyer_Behavior_Cluster_Code]
	, myTarget.[CE_Camping_Flag] = mySource.[CE_Camping_Flag]
	, myTarget.[CE_Camping_Model] = mySource.[CE_Camping_Model]
	, myTarget.[CE_Car_Buff_Flag] = mySource.[CE_Car_Buff_Flag]
	, myTarget.[CE_Carrier_Route] = mySource.[CE_Carrier_Route]
	, myTarget.[CE_Carrier_Route_Type] = mySource.[CE_Carrier_Route_Type]
	, myTarget.[CE_Cat_Owner_Flag] = mySource.[CE_Cat_Owner_Flag]
	, myTarget.[CE_Cat_Product_Model] = mySource.[CE_Cat_Product_Model]
	, myTarget.[CE_Cell_Phone_Only_Model] = mySource.[CE_Cell_Phone_Only_Model]
	, myTarget.[CE_Children_By_Age_By_Gender] = mySource.[CE_Children_By_Age_By_Gender]
	, myTarget.[CE_Children_By_Age_By_Month] = mySource.[CE_Children_By_Age_By_Month]
	, myTarget.[CE_Children_Present_Flag] = mySource.[CE_Children_Present_Flag]
	, myTarget.[CE_Childrens_Products_Interest_F] = mySource.[CE_Childrens_Products_Interest_F]
	, myTarget.[CE_Collectibles_Interest_Flag] = mySource.[CE_Collectibles_Interest_Flag]
	, myTarget.[CE_College_Basketball_Model] = mySource.[CE_College_Basketball_Model]
	, myTarget.[CE_College_Football_Model] = mySource.[CE_College_Football_Model]
	, myTarget.[CE_Comprehensive_Auto_Ins_Model] = mySource.[CE_Comprehensive_Auto_Ins_Model]
	, myTarget.[CE_Computer_Owner_Flag] = mySource.[CE_Computer_Owner_Flag]
	, myTarget.[CE_Conservative_Model] = mySource.[CE_Conservative_Model]
	, myTarget.[CE_Construction_Type_Code] = mySource.[CE_Construction_Type_Code]
	, myTarget.[CE_Cook_For_Fun_Model] = mySource.[CE_Cook_For_Fun_Model]
	, myTarget.[CE_Cook_From_Scratch_Model] = mySource.[CE_Cook_From_Scratch_Model]
	, myTarget.[CE_Cooking_Flag] = mySource.[CE_Cooking_Flag]
	, myTarget.[CE_Corrective_Lenses_Present_Fla] = mySource.[CE_Corrective_Lenses_Present_Fla]
	, myTarget.[CE_Country_Club_Member_Model] = mySource.[CE_Country_Club_Member_Model]
	, myTarget.[CE_County_Nielsen_Rank_Code] = mySource.[CE_County_Nielsen_Rank_Code]
	, myTarget.[CE_County_Nielsen_Region_Code] = mySource.[CE_County_Nielsen_Region_Code]
	, myTarget.[CE_Credit_Card_Rewards_Model] = mySource.[CE_Credit_Card_Rewards_Model]
	, myTarget.[CE_Cruise_Model] = mySource.[CE_Cruise_Model]
	, myTarget.[CE_DIY_Auto_Maintenance_Model] = mySource.[CE_DIY_Auto_Maintenance_Model]
	, myTarget.[CE_Delivery_Point] = mySource.[CE_Delivery_Point]
	, myTarget.[CE_Delivery_Unit_Size] = mySource.[CE_Delivery_Unit_Size]
	, myTarget.[CE_Diabetes_Flag] = mySource.[CE_Diabetes_Flag]
	, myTarget.[CE_Diet_Product_Model] = mySource.[CE_Diet_Product_Model]
	, myTarget.[CE_Dieting_Weightloss_Flag] = mySource.[CE_Dieting_Weightloss_Flag]
	, myTarget.[CE_Discretionary_Income_Score] = mySource.[CE_Discretionary_Income_Score]
	, myTarget.[CE_Dog_Product_Model] = mySource.[CE_Dog_Product_Model]
	, myTarget.[CE_Donor_Ever_Contributor_Flag] = mySource.[CE_Donor_Ever_Contributor_Flag]
	, myTarget.[CE_Donors_PBS_NPR_Model] = mySource.[CE_Donors_PBS_NPR_Model]
	, myTarget.[CE_E_Reader_Model] = mySource.[CE_E_Reader_Model]
	, myTarget.[CE_Early_Internet_Adopter_Model] = mySource.[CE_Early_Internet_Adopter_Model]
	, myTarget.[CE_Education_Loan_Model] = mySource.[CE_Education_Loan_Model]
	, myTarget.[CE_Electronics_Interest_Flag] = mySource.[CE_Electronics_Interest_Flag]
	, myTarget.[CE_Emphysema_Flag] = mySource.[CE_Emphysema_Flag]
	, myTarget.[CE_Environment_Contributor_Flag] = mySource.[CE_Environment_Contributor_Flag]
	, myTarget.[CE_Expendable_Income_Rank_Code] = mySource.[CE_Expendable_Income_Rank_Code]
	, myTarget.[CE_Family_Income_Detector] = mySource.[CE_Family_Income_Detector]
	, myTarget.[CE_Family_Income_Detector_Code] = mySource.[CE_Family_Income_Detector_Code]
	, myTarget.[CE_Family_Income_Detector_Ranges] = mySource.[CE_Family_Income_Detector_Ranges]
	, myTarget.[CE_Fantasy_Sports_Model] = mySource.[CE_Fantasy_Sports_Model]
	, myTarget.[CE_Fast_Food_Model] = mySource.[CE_Fast_Food_Model]
	, myTarget.[CE_Female_Occupation_Code] = mySource.[CE_Female_Occupation_Code]
	, myTarget.[CE_Financial_Planner_Model] = mySource.[CE_Financial_Planner_Model]
	, myTarget.[CE_Financing_Type] = mySource.[CE_Financing_Type]
	, myTarget.[CE_Fireplaces] = mySource.[CE_Fireplaces]
	, myTarget.[CE_Fishing_Flag] = mySource.[CE_Fishing_Flag]
	, myTarget.[CE_Foreign_Travel_Flag] = mySource.[CE_Foreign_Travel_Flag]
	, myTarget.[CE_Foreign_Travel_Vacation_Model] = mySource.[CE_Foreign_Travel_Vacation_Model]
	, myTarget.[CE_Frequent_Business_Traveler_Mo] = mySource.[CE_Frequent_Business_Traveler_Mo]
	, myTarget.[CE_Frequent_Flyer_Model] = mySource.[CE_Frequent_Flyer_Model]
	, myTarget.[CE_Frequent_Headaches_Flag] = mySource.[CE_Frequent_Headaches_Flag]
	, myTarget.[CE_Fresh_Water_Fishing_Model] = mySource.[CE_Fresh_Water_Fishing_Model]
	, myTarget.[CE_Frozen_Dinner_Model] = mySource.[CE_Frozen_Dinner_Model]
	, myTarget.[CE_Gambling_Flag] = mySource.[CE_Gambling_Flag]
	, myTarget.[CE_Garage_Pool_Presence] = mySource.[CE_Garage_Pool_Presence]
	, myTarget.[CE_Garage_Type_Code] = mySource.[CE_Garage_Type_Code]
	, myTarget.[CE_Garden_Maintenance_Model] = mySource.[CE_Garden_Maintenance_Model]
	, myTarget.[CE_Gardening_Horticulture_Intere] = mySource.[CE_Gardening_Horticulture_Intere]
	, myTarget.[CE_Gift_Buyers_Model] = mySource.[CE_Gift_Buyers_Model]
	, myTarget.[CE_Golf_Model] = mySource.[CE_Golf_Model]
	, myTarget.[CE_Golfer_Flag] = mySource.[CE_Golfer_Flag]
	, myTarget.[CE_Gourmet_Food_Wine_Interest_Fl] = mySource.[CE_Gourmet_Food_Wine_Interest_Fl]
	, myTarget.[CE_Grandparent_Present_Flag] = mySource.[CE_Grandparent_Present_Flag]
	, myTarget.[CE_Green_Model] = mySource.[CE_Green_Model]
	, myTarget.[CE_Handcrafts_Sewing_Interest_Fl] = mySource.[CE_Handcrafts_Sewing_Interest_Fl]
	, myTarget.[CE_Health_Contributor_Flag] = mySource.[CE_Health_Contributor_Flag]
	, myTarget.[CE_Health_Fitness_Interest_Flag] = mySource.[CE_Health_Fitness_Interest_Flag]
	, myTarget.[CE_Health_Insurance_Model] = mySource.[CE_Health_Insurance_Model]
	, myTarget.[CE_Hearing_Difficulty_Flag] = mySource.[CE_Hearing_Difficulty_Flag]
	, myTarget.[CE_Heating_Type_Code] = mySource.[CE_Heating_Type_Code]
	, myTarget.[CE_Heavy_Book_Buyer_Model] = mySource.[CE_Heavy_Book_Buyer_Model]
	, myTarget.[CE_Heavy_Catalog_Buyer_Model] = mySource.[CE_Heavy_Catalog_Buyer_Model]
	, myTarget.[CE_Heavy_Coupon_User_Model] = mySource.[CE_Heavy_Coupon_User_Model]
	, myTarget.[CE_Heavy_Domestic_Traveler_Model] = mySource.[CE_Heavy_Domestic_Traveler_Model]
	, myTarget.[CE_Heavy_Family_Restaurant_Visit] = mySource.[CE_Heavy_Family_Restaurant_Visit]
	, myTarget.[CE_Heavy_Internet_User_Model] = mySource.[CE_Heavy_Internet_User_Model]
	, myTarget.[CE_Heavy_Investment_Trader_Model] = mySource.[CE_Heavy_Investment_Trader_Model]
	, myTarget.[CE_Heavy_Online_Buyer_Model] = mySource.[CE_Heavy_Online_Buyer_Model]
	, myTarget.[CE_Heavy_Payperview_Movie_Model] = mySource.[CE_Heavy_Payperview_Movie_Model]
	, myTarget.[CE_Heavy_Payperview_Sports_Model] = mySource.[CE_Heavy_Payperview_Sports_Model]
	, myTarget.[CE_Heavy_Snack_Eaters_Model] = mySource.[CE_Heavy_Snack_Eaters_Model]
	, myTarget.[CE_Heavy_Vitamin_Model] = mySource.[CE_Heavy_Vitamin_Model]
	, myTarget.[CE_High_Blood_Pressure_Flag] = mySource.[CE_High_Blood_Pressure_Flag]
	, myTarget.[CE_High_Cholesterol_Flag] = mySource.[CE_High_Cholesterol_Flag]
	, myTarget.[CE_High_End_Apparel_Model] = mySource.[CE_High_End_Apparel_Model]
	, myTarget.[CE_High_End_Electronic_Model] = mySource.[CE_High_End_Electronic_Model]
	, myTarget.[CE_High_End_Sporting_Equipment_M] = mySource.[CE_High_End_Sporting_Equipment_M]
	, myTarget.[CE_High_Risk_Investor_Model] = mySource.[CE_High_Risk_Investor_Model]
	, myTarget.[CE_High_Tech_Flag] = mySource.[CE_High_Tech_Flag]
	, myTarget.[CE_High_Ticket_Mail_Order_Flag] = mySource.[CE_High_Ticket_Mail_Order_Flag]
	, myTarget.[CE_High_Value_Security_Investor] = mySource.[CE_High_Value_Security_Investor]
	, myTarget.[CE_High_Value_Stock_Investor_Mod] = mySource.[CE_High_Value_Stock_Investor_Mod]
	, myTarget.[CE_Higher_Education_Model] = mySource.[CE_Higher_Education_Model]
	, myTarget.[CE_Hockey_Buyer_Model] = mySource.[CE_Hockey_Buyer_Model]
	, myTarget.[CE_Home_Age] = mySource.[CE_Home_Age]
	, myTarget.[CE_Home_Age_Source] = mySource.[CE_Home_Age_Source]
	, myTarget.[CE_Home_Decorating_Interest_Flag] = mySource.[CE_Home_Decorating_Interest_Flag]
	, myTarget.[CE_Home_Equity_Estimate_Code] = mySource.[CE_Home_Equity_Estimate_Code]
	, myTarget.[CE_Home_Improvement_Model] = mySource.[CE_Home_Improvement_Model]
	, myTarget.[CE_Home_Loan_Interest_Rate] = mySource.[CE_Home_Loan_Interest_Rate]
	, myTarget.[CE_Home_Office_Model] = mySource.[CE_Home_Office_Model]
	, myTarget.[CE_Home_Owner_Flag] = mySource.[CE_Home_Owner_Flag]
	, myTarget.[CE_Home_Sale_Date] = mySource.[CE_Home_Sale_Date]
	, myTarget.[CE_Home_Sale_Date_Source] = mySource.[CE_Home_Sale_Date_Source]
	, myTarget.[CE_Home_Sale_Price] = mySource.[CE_Home_Sale_Price]
	, myTarget.[CE_Home_Sale_Price_Source] = mySource.[CE_Home_Sale_Price_Source]
	, myTarget.[CE_Home_Size] = mySource.[CE_Home_Size]
	, myTarget.[CE_Home_Value_Code] = mySource.[CE_Home_Value_Code]
	, myTarget.[CE_Home_Value_Source_Code] = mySource.[CE_Home_Value_Source_Code]
	, myTarget.[CE_Home_Workshop_Interest_Flag] = mySource.[CE_Home_Workshop_Interest_Flag]
	, myTarget.[CE_Homeowner_Source_Code] = mySource.[CE_Homeowner_Source_Code]
	, myTarget.[CE_House_Fraction] = mySource.[CE_House_Fraction]
	, myTarget.[CE_House_Number] = mySource.[CE_House_Number]
	, myTarget.[CE_Household_Active_Trade_Lines] = mySource.[CE_Household_Active_Trade_Lines]
	, myTarget.[CE_Household_Dropped_Flag] = mySource.[CE_Household_Dropped_Flag]
	, myTarget.[CE_Household_Head_Age_Code] = mySource.[CE_Household_Head_Age_Code]
	, myTarget.[CE_Household_Head_Age_Code_Sourc] = mySource.[CE_Household_Head_Age_Code_Sourc]
	, myTarget.[CE_Household_Head_Has_Travel_Ent] = mySource.[CE_Household_Head_Has_Travel_Ent]
	, myTarget.[CE_Household_ID] = mySource.[CE_Household_ID]
	, myTarget.[CE_Household_Status_Code] = mySource.[CE_Household_Status_Code]
	, myTarget.[CE_Hunting_Flag] = mySource.[CE_Hunting_Flag]
	, myTarget.[CE_Hunting_Model] = mySource.[CE_Hunting_Model]
	, myTarget.[CE_Hybrid_Cars_Model] = mySource.[CE_Hybrid_Cars_Model]
	, myTarget.[CE_Impulse_Buyer_Model] = mySource.[CE_Impulse_Buyer_Model]
	, myTarget.[CE_Income_Producing_Assets] = mySource.[CE_Income_Producing_Assets]
	, myTarget.[CE_Income_Producing_Assets_Desc] = mySource.[CE_Income_Producing_Assets_Desc]
	, myTarget.[CE_Incontenance_Flag] = mySource.[CE_Incontenance_Flag]
	, myTarget.[CE_Individual2_Age] = mySource.[CE_Individual2_Age]
	, myTarget.[CE_Individual2_Gender] = mySource.[CE_Individual2_Gender]
	, myTarget.[CE_Individual2_Given_Name] = mySource.[CE_Individual2_Given_Name]
	, myTarget.[CE_Individual2_Has_Finance_Card] = mySource.[CE_Individual2_Has_Finance_Card]
	, myTarget.[CE_Individual2_Has_Misc_Credit_C] = mySource.[CE_Individual2_Has_Misc_Credit_C]
	, myTarget.[CE_Individual2_Has_Oil_Company_C] = mySource.[CE_Individual2_Has_Oil_Company_C]
	, myTarget.[CE_Individual2_Has_Premium_Bank] = mySource.[CE_Individual2_Has_Premium_Bank]
	, myTarget.[CE_Individual2_Has_Retail_Store] = mySource.[CE_Individual2_Has_Retail_Store]
	, myTarget.[CE_Individual2_Has_Specialty_Sto] = mySource.[CE_Individual2_Has_Specialty_Sto]
	, myTarget.[CE_Individual2_Has_Upscale_Retai] = mySource.[CE_Individual2_Has_Upscale_Retai]
	, myTarget.[CE_Individual2_Head_of_Household] = mySource.[CE_Individual2_Head_of_Household]
	, myTarget.[CE_Individual2_Individual_ID] = mySource.[CE_Individual2_Individual_ID]
	, myTarget.[CE_Individual2_Marital_Stat_Code] = mySource.[CE_Individual2_Marital_Stat_Code]
	, myTarget.[CE_Individual2_Marriage_Date] = mySource.[CE_Individual2_Marriage_Date]
	, myTarget.[CE_Individual2_Middle_Initial] = mySource.[CE_Individual2_Middle_Initial]
	, myTarget.[CE_Individual2_Parent_Flag] = mySource.[CE_Individual2_Parent_Flag]
	, myTarget.[CE_Individual2_Political_Affilia] = mySource.[CE_Individual2_Political_Affilia]
	, myTarget.[CE_Individual2_Spouse_Flag] = mySource.[CE_Individual2_Spouse_Flag]
	, myTarget.[CE_Individual2_Surname] = mySource.[CE_Individual2_Surname]
	, myTarget.[CE_Individual2_Surname_Suffix] = mySource.[CE_Individual2_Surname_Suffix]
	, myTarget.[CE_Individual2_Title_Code] = mySource.[CE_Individual2_Title_Code]
	, myTarget.[CE_Individual2_Vendor_Country_Or] = mySource.[CE_Individual2_Vendor_Country_Or]
	, myTarget.[CE_Individual2_Vendor_Ethnic_Gro] = mySource.[CE_Individual2_Vendor_Ethnic_Gro]
	, myTarget.[CE_Individual2_Vendor_Ethnicity] = mySource.[CE_Individual2_Vendor_Ethnicity]
	, myTarget.[CE_Individual2_Vendor_Religion_C] = mySource.[CE_Individual2_Vendor_Religion_C]
	, myTarget.[CE_Individual2_Vendor_Spoken_Lan] = mySource.[CE_Individual2_Vendor_Spoken_Lan]
	, myTarget.[CE_Individual2_Work_At_Home_Flag] = mySource.[CE_Individual2_Work_At_Home_Flag]
	, myTarget.[CE_Individual2_YYYYMMDD_Of_Birth] = mySource.[CE_Individual2_YYYYMMDD_Of_Birth]
	, myTarget.[CE_Individual3_Age] = mySource.[CE_Individual3_Age]
	, myTarget.[CE_Individual3_Gender] = mySource.[CE_Individual3_Gender]
	, myTarget.[CE_Individual3_Given_Name] = mySource.[CE_Individual3_Given_Name]
	, myTarget.[CE_Individual3_Has_Finance_Card] = mySource.[CE_Individual3_Has_Finance_Card]
	, myTarget.[CE_Individual3_Has_Misc_Credit_C] = mySource.[CE_Individual3_Has_Misc_Credit_C]
	, myTarget.[CE_Individual3_Has_Oil_Company_C] = mySource.[CE_Individual3_Has_Oil_Company_C]
	, myTarget.[CE_Individual3_Has_Premium_Bank] = mySource.[CE_Individual3_Has_Premium_Bank]
	, myTarget.[CE_Individual3_Has_Retail_Store] = mySource.[CE_Individual3_Has_Retail_Store]
	, myTarget.[CE_Individual3_Has_Specialty_Sto] = mySource.[CE_Individual3_Has_Specialty_Sto]
	, myTarget.[CE_Individual3_Has_Upscale_Retai] = mySource.[CE_Individual3_Has_Upscale_Retai]
	, myTarget.[CE_Individual3_Head_of_Household] = mySource.[CE_Individual3_Head_of_Household]
	, myTarget.[CE_Individual3_Individual_ID] = mySource.[CE_Individual3_Individual_ID]
	, myTarget.[CE_Individual3_Marital_Stat_Code] = mySource.[CE_Individual3_Marital_Stat_Code]
	, myTarget.[CE_Individual3_Marriage_Date] = mySource.[CE_Individual3_Marriage_Date]
	, myTarget.[CE_Individual3_Middle_Initial] = mySource.[CE_Individual3_Middle_Initial]
	, myTarget.[CE_Individual3_Parent_Flag] = mySource.[CE_Individual3_Parent_Flag]
	, myTarget.[CE_Individual3_Political_Affilia] = mySource.[CE_Individual3_Political_Affilia]
	, myTarget.[CE_Individual3_Spouse_Flag] = mySource.[CE_Individual3_Spouse_Flag]
	, myTarget.[CE_Individual3_Surname] = mySource.[CE_Individual3_Surname]
	, myTarget.[CE_Individual3_Surname_Suffix] = mySource.[CE_Individual3_Surname_Suffix]
	, myTarget.[CE_Individual3_Title_Code] = mySource.[CE_Individual3_Title_Code]
	, myTarget.[CE_Individual3_Vendor_Country_Or] = mySource.[CE_Individual3_Vendor_Country_Or]
	, myTarget.[CE_Individual3_Vendor_Ethnic_Gro] = mySource.[CE_Individual3_Vendor_Ethnic_Gro]
	, myTarget.[CE_Individual3_Vendor_Ethnicity] = mySource.[CE_Individual3_Vendor_Ethnicity]
	, myTarget.[CE_Individual3_Vendor_Religion_C] = mySource.[CE_Individual3_Vendor_Religion_C]
	, myTarget.[CE_Individual3_Vendor_Spoken_Lan] = mySource.[CE_Individual3_Vendor_Spoken_Lan]
	, myTarget.[CE_Individual3_Work_At_Home_Flag] = mySource.[CE_Individual3_Work_At_Home_Flag]
	, myTarget.[CE_Individual3_YYYYMMDD_Of_Birth] = mySource.[CE_Individual3_YYYYMMDD_Of_Birth]
	, myTarget.[CE_Individual_HoH_Age] = mySource.[CE_Individual_HoH_Age]
	, myTarget.[CE_Individual_HoH_Gender] = mySource.[CE_Individual_HoH_Gender]
	, myTarget.[CE_Individual_HoH_Given_Name] = mySource.[CE_Individual_HoH_Given_Name]
	, myTarget.[CE_Individual_HoH_Has_Finance_Ca] = mySource.[CE_Individual_HoH_Has_Finance_Ca]
	, myTarget.[CE_Individual_HoH_Has_Misc_Credi] = mySource.[CE_Individual_HoH_Has_Misc_Credi]
	, myTarget.[CE_Individual_HoH_Has_Oil_Compan] = mySource.[CE_Individual_HoH_Has_Oil_Compan]
	, myTarget.[CE_Individual_HoH_Has_Premium_Ba] = mySource.[CE_Individual_HoH_Has_Premium_Ba]
	, myTarget.[CE_Individual_HoH_Has_Retail_Sto] = mySource.[CE_Individual_HoH_Has_Retail_Sto]
	, myTarget.[CE_Individual_HoH_Has_Specialty] = mySource.[CE_Individual_HoH_Has_Specialty]
	, myTarget.[CE_Individual_HoH_Has_Upscale_Re] = mySource.[CE_Individual_HoH_Has_Upscale_Re]
	, myTarget.[CE_Individual_HoH_Head_of_Househ] = mySource.[CE_Individual_HoH_Head_of_Househ]
	, myTarget.[CE_Individual_HoH_Individual_ID] = mySource.[CE_Individual_HoH_Individual_ID]
	, myTarget.[CE_Individual_HoH_Marital_Status] = mySource.[CE_Individual_HoH_Marital_Status]
	, myTarget.[CE_Individual_HoH_Marriage_Date] = mySource.[CE_Individual_HoH_Marriage_Date]
	, myTarget.[CE_Individual_HoH_Middle_Initial] = mySource.[CE_Individual_HoH_Middle_Initial]
	, myTarget.[CE_Individual_HoH_Mobile_Age_Fla] = mySource.[CE_Individual_HoH_Mobile_Age_Fla]
	, myTarget.[CE_Individual_HoH_Mortgage_Link] = mySource.[CE_Individual_HoH_Mortgage_Link]
	, myTarget.[CE_Individual_HoH_Parent_Flag] = mySource.[CE_Individual_HoH_Parent_Flag]
	, myTarget.[CE_Individual_HoH_Political_Affi] = mySource.[CE_Individual_HoH_Political_Affi]
	, myTarget.[CE_Individual_HoH_Spouse_Flag] = mySource.[CE_Individual_HoH_Spouse_Flag]
	, myTarget.[CE_Individual_HoH_Surname] = mySource.[CE_Individual_HoH_Surname]
	, myTarget.[CE_Individual_HoH_Surname_Suffix] = mySource.[CE_Individual_HoH_Surname_Suffix]
	, myTarget.[CE_Individual_HoH_Title_Code] = mySource.[CE_Individual_HoH_Title_Code]
	, myTarget.[CE_Individual_HoH_Vendor_Country] = mySource.[CE_Individual_HoH_Vendor_Country]
	, myTarget.[CE_Individual_HoH_Vendor_Ethnic] = mySource.[CE_Individual_HoH_Vendor_Ethnic]
	, myTarget.[CE_Individual_HoH_Vendor_Ethnici] = mySource.[CE_Individual_HoH_Vendor_Ethnici]
	, myTarget.[CE_Individual_HoH_Vendor_Religio] = mySource.[CE_Individual_HoH_Vendor_Religio]
	, myTarget.[CE_Individual_HoH_Vendor_Spoken] = mySource.[CE_Individual_HoH_Vendor_Spoken]
	, myTarget.[CE_Individual_HoH_Work_At_Home_F] = mySource.[CE_Individual_HoH_Work_At_Home_F]
	, myTarget.[CE_Individual_HoH_YYYYMMDD_Of_Bi] = mySource.[CE_Individual_HoH_YYYYMMDD_Of_Bi]
	, myTarget.[CE_InfoPersona_Cluster] = mySource.[CE_InfoPersona_Cluster]
	, myTarget.[CE_InfoPersona_SuperCluster] = mySource.[CE_InfoPersona_SuperCluster]
	, myTarget.[CE_Interest_Rate_Source] = mySource.[CE_Interest_Rate_Source]
	, myTarget.[CE_Intl_Long_Distance_Model] = mySource.[CE_Intl_Long_Distance_Model]
	, myTarget.[CE_Invest_Not_Stocks_Bonds_Flag] = mySource.[CE_Invest_Not_Stocks_Bonds_Flag]
	, myTarget.[CE_LHI_Household_Apparel_Accesso] = mySource.[CE_LHI_Household_Apparel_Accesso]
	, myTarget.[CE_LHI_Household_Apparel_General] = mySource.[CE_LHI_Household_Apparel_General]
	, myTarget.[CE_LHI_Household_Apparel_Kids] = mySource.[CE_LHI_Household_Apparel_Kids]
	, myTarget.[CE_LHI_Household_Apparel_Mens] = mySource.[CE_LHI_Household_Apparel_Mens]
	, myTarget.[CE_LHI_Household_Apparel_Mens_Fa] = mySource.[CE_LHI_Household_Apparel_Mens_Fa]
	, myTarget.[CE_LHI_Household_Apparel_Wo_0001] = mySource.[CE_LHI_Household_Apparel_Wo_0001]
	, myTarget.[CE_LHI_Household_Apparel_Womens] = mySource.[CE_LHI_Household_Apparel_Womens]
	, myTarget.[CE_LHI_Household_Auto_Racing] = mySource.[CE_LHI_Household_Auto_Racing]
	, myTarget.[CE_LHI_Household_Auto_Trucks] = mySource.[CE_LHI_Household_Auto_Trucks]
	, myTarget.[CE_LHI_Household_Automotive] = mySource.[CE_LHI_Household_Automotive]
	, myTarget.[CE_LHI_Household_Aviation] = mySource.[CE_LHI_Household_Aviation]
	, myTarget.[CE_LHI_Household_Bargain_Seekers] = mySource.[CE_LHI_Household_Bargain_Seekers]
	, myTarget.[CE_LHI_Household_Beauty_Cosmetic] = mySource.[CE_LHI_Household_Beauty_Cosmetic]
	, myTarget.[CE_LHI_Household_Bible] = mySource.[CE_LHI_Household_Bible]
	, myTarget.[CE_LHI_Household_Birds] = mySource.[CE_LHI_Household_Birds]
	, myTarget.[CE_LHI_Household_Business_Home_O] = mySource.[CE_LHI_Household_Business_Home_O]
	, myTarget.[CE_LHI_Household_Business_Items] = mySource.[CE_LHI_Household_Business_Items]
	, myTarget.[CE_LHI_Household_Catalogs] = mySource.[CE_LHI_Household_Catalogs]
	, myTarget.[CE_LHI_Household_Charitable_Dono] = mySource.[CE_LHI_Household_Charitable_Dono]
	, myTarget.[CE_LHI_Household_Collectibles] = mySource.[CE_LHI_Household_Collectibles]
	, myTarget.[CE_LHI_Household_Collectibles_St] = mySource.[CE_LHI_Household_Collectibles_St]
	, myTarget.[CE_LHI_Household_College] = mySource.[CE_LHI_Household_College]
	, myTarget.[CE_LHI_Household_Computers] = mySource.[CE_LHI_Household_Computers]
	, myTarget.[CE_LHI_Household_Cooking] = mySource.[CE_LHI_Household_Cooking]
	, myTarget.[CE_LHI_Household_Cooking_Gourmet] = mySource.[CE_LHI_Household_Cooking_Gourmet]
	, myTarget.[CE_LHI_Household_Crafts_Crocheti] = mySource.[CE_LHI_Household_Crafts_Crocheti]
	, myTarget.[CE_LHI_Household_Crafts_General] = mySource.[CE_LHI_Household_Crafts_General]
	, myTarget.[CE_LHI_Household_Crafts_Knitting] = mySource.[CE_LHI_Household_Crafts_Knitting]
	, myTarget.[CE_LHI_Household_Crafts_Needlepo] = mySource.[CE_LHI_Household_Crafts_Needlepo]
	, myTarget.[CE_LHI_Household_Crafts_Quilting] = mySource.[CE_LHI_Household_Crafts_Quilting]
	, myTarget.[CE_LHI_Household_Crafts_Sewing] = mySource.[CE_LHI_Household_Crafts_Sewing]
	, myTarget.[CE_LHI_Household_Culture_Arts] = mySource.[CE_LHI_Household_Culture_Arts]
	, myTarget.[CE_LHI_Household_Current_Events] = mySource.[CE_LHI_Household_Current_Events]
	, myTarget.[CE_LHI_Household_Do_It_Yourselfe] = mySource.[CE_LHI_Household_Do_It_Yourselfe]
	, myTarget.[CE_LHI_Household_Ego_Personalize] = mySource.[CE_LHI_Household_Ego_Personalize]
	, myTarget.[CE_LHI_Household_Electronics] = mySource.[CE_LHI_Household_Electronics]
	, myTarget.[CE_LHI_Household_Equestrian] = mySource.[CE_LHI_Household_Equestrian]
	, myTarget.[CE_LHI_Household_Ethnic_Pro_0001] = mySource.[CE_LHI_Household_Ethnic_Pro_0001]
	, myTarget.[CE_LHI_Household_Ethnic_Pro_0002] = mySource.[CE_LHI_Household_Ethnic_Pro_0002]
	, myTarget.[CE_LHI_Household_Ethnic_Product] = mySource.[CE_LHI_Household_Ethnic_Product]
	, myTarget.[CE_LHI_Household_Family] = mySource.[CE_LHI_Household_Family]
	, myTarget.[CE_LHI_Household_Finance_Credit] = mySource.[CE_LHI_Household_Finance_Credit]
	, myTarget.[CE_LHI_Household_Finance_Money_M] = mySource.[CE_LHI_Household_Finance_Money_M]
	, myTarget.[CE_LHI_Household_Finance_Persona] = mySource.[CE_LHI_Household_Finance_Persona]
	, myTarget.[CE_LHI_Household_Finance_Stocks] = mySource.[CE_LHI_Household_Finance_Stocks]
	, myTarget.[CE_LHI_Household_Gambling] = mySource.[CE_LHI_Household_Gambling]
	, myTarget.[CE_LHI_Household_Games] = mySource.[CE_LHI_Household_Games]
	, myTarget.[CE_LHI_Household_Gardening] = mySource.[CE_LHI_Household_Gardening]
	, myTarget.[CE_LHI_Household_Gift_Giver] = mySource.[CE_LHI_Household_Gift_Giver]
	, myTarget.[CE_LHI_Household_Health_Dieting] = mySource.[CE_LHI_Household_Health_Dieting]
	, myTarget.[CE_LHI_Household_Health_Fitness] = mySource.[CE_LHI_Household_Health_Fitness]
	, myTarget.[CE_LHI_Household_Health_General] = mySource.[CE_LHI_Household_Health_General]
	, myTarget.[CE_LHI_Household_High_Ticket] = mySource.[CE_LHI_Household_High_Ticket]
	, myTarget.[CE_LHI_Household_Hightech] = mySource.[CE_LHI_Household_Hightech]
	, myTarget.[CE_LHI_Household_History] = mySource.[CE_LHI_Household_History]
	, myTarget.[CE_LHI_Household_History_America] = mySource.[CE_LHI_Household_History_America]
	, myTarget.[CE_LHI_Household_Hobbies] = mySource.[CE_LHI_Household_Hobbies]
	, myTarget.[CE_LHI_Household_Home_Decorating] = mySource.[CE_LHI_Household_Home_Decorating]
	, myTarget.[CE_LHI_Household_Humor] = mySource.[CE_LHI_Household_Humor]
	, myTarget.[CE_LHI_Household_Inspirational] = mySource.[CE_LHI_Household_Inspirational]
	, myTarget.[CE_LHI_Household_Internet] = mySource.[CE_LHI_Household_Internet]
	, myTarget.[CE_LHI_Household_Internet_Access] = mySource.[CE_LHI_Household_Internet_Access]
	, myTarget.[CE_LHI_Household_Internet_Buying] = mySource.[CE_LHI_Household_Internet_Buying]
	, myTarget.[CE_LHI_Household_Motorcycles] = mySource.[CE_LHI_Household_Motorcycles]
	, myTarget.[CE_LHI_Household_Music] = mySource.[CE_LHI_Household_Music]
	, myTarget.[CE_LHI_Household_Ocean] = mySource.[CE_LHI_Household_Ocean]
	, myTarget.[CE_LHI_Household_Outdoors] = mySource.[CE_LHI_Household_Outdoors]
	, myTarget.[CE_LHI_Household_Outdoors_Boatin] = mySource.[CE_LHI_Household_Outdoors_Boatin]
	, myTarget.[CE_LHI_Household_Outdoors_Campin] = mySource.[CE_LHI_Household_Outdoors_Campin]
	, myTarget.[CE_LHI_Household_Outdoors_Fishin] = mySource.[CE_LHI_Household_Outdoors_Fishin]
	, myTarget.[CE_LHI_Household_Outdoors_H_0001] = mySource.[CE_LHI_Household_Outdoors_H_0001]
	, myTarget.[CE_LHI_Household_Outdoors_Huntin] = mySource.[CE_LHI_Household_Outdoors_Huntin]
	, myTarget.[CE_LHI_Household_Pets] = mySource.[CE_LHI_Household_Pets]
	, myTarget.[CE_LHI_Household_Pets_Cats] = mySource.[CE_LHI_Household_Pets_Cats]
	, myTarget.[CE_LHI_Household_Pets_Dogs] = mySource.[CE_LHI_Household_Pets_Dogs]
	, myTarget.[CE_LHI_Household_Photo_Photograp] = mySource.[CE_LHI_Household_Photo_Photograp]
	, myTarget.[CE_LHI_Household_Photo_Photoproc] = mySource.[CE_LHI_Household_Photo_Photoproc]
	, myTarget.[CE_LHI_Household_Politically_Con] = mySource.[CE_LHI_Household_Politically_Con]
	, myTarget.[CE_LHI_Household_Politically_Lib] = mySource.[CE_LHI_Household_Politically_Lib]
	, myTarget.[CE_LHI_Household_Publish_Books] = mySource.[CE_LHI_Household_Publish_Books]
	, myTarget.[CE_LHI_Household_Publish_Fiction] = mySource.[CE_LHI_Household_Publish_Fiction]
	, myTarget.[CE_LHI_Household_Publish_Magazin] = mySource.[CE_LHI_Household_Publish_Magazin]
	, myTarget.[CE_LHI_Household_Publish_Nonfict] = mySource.[CE_LHI_Household_Publish_Nonfict]
	, myTarget.[CE_LHI_Household_Publish_Publica] = mySource.[CE_LHI_Household_Publish_Publica]
	, myTarget.[CE_LHI_Household_Publish_Science] = mySource.[CE_LHI_Household_Publish_Science]
	, myTarget.[CE_LHI_Household_Rural_Farming] = mySource.[CE_LHI_Household_Rural_Farming]
	, myTarget.[CE_LHI_Household_Science] = mySource.[CE_LHI_Household_Science]
	, myTarget.[CE_LHI_Household_Seniors] = mySource.[CE_LHI_Household_Seniors]
	, myTarget.[CE_LHI_Household_Sports_Baseball] = mySource.[CE_LHI_Household_Sports_Baseball]
	, myTarget.[CE_LHI_Household_Sports_Basketba] = mySource.[CE_LHI_Household_Sports_Basketba]
	, myTarget.[CE_LHI_Household_Sports_Football] = mySource.[CE_LHI_Household_Sports_Football]
	, myTarget.[CE_LHI_Household_Sports_General] = mySource.[CE_LHI_Household_Sports_General]
	, myTarget.[CE_LHI_Household_Sports_Golf] = mySource.[CE_LHI_Household_Sports_Golf]
	, myTarget.[CE_LHI_Household_Sports_Hockey] = mySource.[CE_LHI_Household_Sports_Hockey]
	, myTarget.[CE_LHI_Household_Sports_Skiing] = mySource.[CE_LHI_Household_Sports_Skiing]
	, myTarget.[CE_LHI_Household_Sports_Soccer] = mySource.[CE_LHI_Household_Sports_Soccer]
	, myTarget.[CE_LHI_Household_Sports_Tennis] = mySource.[CE_LHI_Household_Sports_Tennis]
	, myTarget.[CE_LHI_Household_Stationery] = mySource.[CE_LHI_Household_Stationery]
	, myTarget.[CE_LHI_Household_Sweepstakes] = mySource.[CE_LHI_Household_Sweepstakes]
	, myTarget.[CE_LHI_Household_TV_Movies] = mySource.[CE_LHI_Household_TV_Movies]
	, myTarget.[CE_LHI_Household_Technology_VCR] = mySource.[CE_LHI_Household_Technology_VCR]
	, myTarget.[CE_LHI_Household_Tobacco] = mySource.[CE_LHI_Household_Tobacco]
	, myTarget.[CE_LHI_Household_Travel_Cruises] = mySource.[CE_LHI_Household_Travel_Cruises]
	, myTarget.[CE_LHI_Household_Travel_Foreign] = mySource.[CE_LHI_Household_Travel_Foreign]
	, myTarget.[CE_LHI_Household_Travel_General] = mySource.[CE_LHI_Household_Travel_General]
	, myTarget.[CE_LHI_Household_Travel_RV] = mySource.[CE_LHI_Household_Travel_RV]
	, myTarget.[CE_LHI_Household_Travel_US] = mySource.[CE_LHI_Household_Travel_US]
	, myTarget.[CE_LHI_Household_Wildlife] = mySource.[CE_LHI_Household_Wildlife]
	, myTarget.[CE_LHI_Individual_HoH_Apparel_Ge] = mySource.[CE_LHI_Individual_HoH_Apparel_Ge]
	, myTarget.[CE_Leaning_Conservative_Model] = mySource.[CE_Leaning_Conservative_Model]
	, myTarget.[CE_Leaning_Liberal_Model] = mySource.[CE_Leaning_Liberal_Model]
	, myTarget.[CE_Length_of_Residence_Years] = mySource.[CE_Length_of_Residence_Years]
	, myTarget.[CE_Liberal_Model] = mySource.[CE_Liberal_Model]
	, myTarget.[CE_Life_Insurance_Model] = mySource.[CE_Life_Insurance_Model]
	, myTarget.[CE_Live_Theater_Model] = mySource.[CE_Live_Theater_Model]
	, myTarget.[CE_Loan_Amount] = mySource.[CE_Loan_Amount]
	, myTarget.[CE_Loan_Amount_Source] = mySource.[CE_Loan_Amount_Source]
	, myTarget.[CE_Loan_Type] = mySource.[CE_Loan_Type]
	, myTarget.[CE_Loan_to_Value_Ratio_Range_Cod] = mySource.[CE_Loan_to_Value_Ratio_Range_Cod]
	, myTarget.[CE_Location_ID] = mySource.[CE_Location_ID]
	, myTarget.[CE_Location_Type] = mySource.[CE_Location_Type]
	, myTarget.[CE_Lot_Size] = mySource.[CE_Lot_Size]
	, myTarget.[CE_Low_End_Sporting_Equip_Model] = mySource.[CE_Low_End_Sporting_Equip_Model]
	, myTarget.[CE_Low_Risk_Investor_Model] = mySource.[CE_Low_Risk_Investor_Model]
	, myTarget.[CE_Luxury_Car_Buyer_Model] = mySource.[CE_Luxury_Car_Buyer_Model]
	, myTarget.[CE_Luxury_Hotel_Model] = mySource.[CE_Luxury_Hotel_Model]
	, myTarget.[CE_Magazine_Subscriber_Flag] = mySource.[CE_Magazine_Subscriber_Flag]
	, myTarget.[CE_Mail_Order_Buyer_Current_Flag] = mySource.[CE_Mail_Order_Buyer_Current_Flag]
	, myTarget.[CE_Mail_Order_Buyer_Ever_Flag] = mySource.[CE_Mail_Order_Buyer_Ever_Flag]
	, myTarget.[CE_Mail_Order_Software_Purchase] = mySource.[CE_Mail_Order_Software_Purchase]
	, myTarget.[CE_Mail_Responsive_Current_Flag] = mySource.[CE_Mail_Responsive_Current_Flag]
	, myTarget.[CE_Mail_Responsive_Ever_Flag] = mySource.[CE_Mail_Responsive_Ever_Flag]
	, myTarget.[CE_Mail_Responsive_Previous_Flag] = mySource.[CE_Mail_Responsive_Previous_Flag]
	, myTarget.[CE_Major_Home_Remodeling_Model] = mySource.[CE_Major_Home_Remodeling_Model]
	, myTarget.[CE_Male_Occupation_Code] = mySource.[CE_Male_Occupation_Code]
	, myTarget.[CE_Marketing_HH_1_To_2_People] = mySource.[CE_Marketing_HH_1_To_2_People]
	, myTarget.[CE_Marketing_HH_3_Plus_People] = mySource.[CE_Marketing_HH_3_Plus_People]
	, myTarget.[CE_Marketing_Target_Age_0_To_11] = mySource.[CE_Marketing_Target_Age_0_To_11]
	, myTarget.[CE_Marketing_Target_Age_0_To_17] = mySource.[CE_Marketing_Target_Age_0_To_17]
	, myTarget.[CE_Marketing_Target_Age_0_To_5] = mySource.[CE_Marketing_Target_Age_0_To_5]
	, myTarget.[CE_Marketing_Target_Age_12_To_17] = mySource.[CE_Marketing_Target_Age_12_To_17]
	, myTarget.[CE_Marketing_Target_Age_6_To_11] = mySource.[CE_Marketing_Target_Age_6_To_11]
	, myTarget.[CE_Marketing_Target_Age_Over_50] = mySource.[CE_Marketing_Target_Age_Over_50]
	, myTarget.[CE_Marketing_Target_Age_Over_65] = mySource.[CE_Marketing_Target_Age_Over_65]
	, myTarget.[CE_Marketing_Target_Females_0001] = mySource.[CE_Marketing_Target_Females_0001]
	, myTarget.[CE_Marketing_Target_Females_0002] = mySource.[CE_Marketing_Target_Females_0002]
	, myTarget.[CE_Marketing_Target_Females_0003] = mySource.[CE_Marketing_Target_Females_0003]
	, myTarget.[CE_Marketing_Target_Females_0004] = mySource.[CE_Marketing_Target_Females_0004]
	, myTarget.[CE_Marketing_Target_Females_0005] = mySource.[CE_Marketing_Target_Females_0005]
	, myTarget.[CE_Marketing_Target_Females_0006] = mySource.[CE_Marketing_Target_Females_0006]
	, myTarget.[CE_Marketing_Target_Females_0007] = mySource.[CE_Marketing_Target_Females_0007]
	, myTarget.[CE_Marketing_Target_Females_0008] = mySource.[CE_Marketing_Target_Females_0008]
	, myTarget.[CE_Marketing_Target_Females_Age] = mySource.[CE_Marketing_Target_Females_Age]
	, myTarget.[CE_Marketing_Target_Males_A_0001] = mySource.[CE_Marketing_Target_Males_A_0001]
	, myTarget.[CE_Marketing_Target_Males_A_0002] = mySource.[CE_Marketing_Target_Males_A_0002]
	, myTarget.[CE_Marketing_Target_Males_Age_12] = mySource.[CE_Marketing_Target_Males_Age_12]
	, myTarget.[CE_Marketing_Target_Males_Age_18] = mySource.[CE_Marketing_Target_Males_Age_18]
	, myTarget.[CE_Marketing_Target_Males_Age_25] = mySource.[CE_Marketing_Target_Males_Age_25]
	, myTarget.[CE_Marketing_Target_Males_Age_35] = mySource.[CE_Marketing_Target_Males_Age_35]
	, myTarget.[CE_Marketing_Target_Males_Age_45] = mySource.[CE_Marketing_Target_Males_Age_45]
	, myTarget.[CE_Marketing_Target_Males_Age_55] = mySource.[CE_Marketing_Target_Males_Age_55]
	, myTarget.[CE_Member_Count] = mySource.[CE_Member_Count]
	, myTarget.[CE_Migraines_Flag] = mySource.[CE_Migraines_Flag]
	, myTarget.[CE_Minivan_Buyer_Model] = mySource.[CE_Minivan_Buyer_Model]
	, myTarget.[CE_Mobile_Internet_Access_Model] = mySource.[CE_Mobile_Internet_Access_Model]
	, myTarget.[CE_Moderate_Economy_Hotel_Model] = mySource.[CE_Moderate_Economy_Hotel_Model]
	, myTarget.[CE_Mortgage_Amount_Source_Code] = mySource.[CE_Mortgage_Amount_Source_Code]
	, myTarget.[CE_Mortgage_Type_Source_Code] = mySource.[CE_Mortgage_Type_Source_Code]
	, myTarget.[CE_Move_Out_Flag] = mySource.[CE_Move_Out_Flag]
	, myTarget.[CE_Multi_Unit_Flag] = mySource.[CE_Multi_Unit_Flag]
	, myTarget.[CE_Music_Concert_Classical_Model] = mySource.[CE_Music_Concert_Classical_Model]
	, myTarget.[CE_Music_Concert_Country_Model] = mySource.[CE_Music_Concert_Country_Model]
	, myTarget.[CE_Music_Concert_Rock_Model] = mySource.[CE_Music_Concert_Rock_Model]
	, myTarget.[CE_Nascar_Model] = mySource.[CE_Nascar_Model]
	, myTarget.[CE_New_Vehicle_Buyer_Model] = mySource.[CE_New_Vehicle_Buyer_Model]
	, myTarget.[CE_Non_Religious_Donor_Model] = mySource.[CE_Non_Religious_Donor_Model]
	, myTarget.[CE_Number_Adult_Females] = mySource.[CE_Number_Adult_Females]
	, myTarget.[CE_Number_Adult_Males] = mySource.[CE_Number_Adult_Males]
	, myTarget.[CE_Number_Adults] = mySource.[CE_Number_Adults]
	, myTarget.[CE_Number_Bathrooms] = mySource.[CE_Number_Bathrooms]
	, myTarget.[CE_Number_Bedrooms] = mySource.[CE_Number_Bedrooms]
	, myTarget.[CE_Number_Children] = mySource.[CE_Number_Children]
	, myTarget.[CE_Occupancy_Count] = mySource.[CE_Occupancy_Count]
	, myTarget.[CE_Online_Bill_Payment_Model] = mySource.[CE_Online_Bill_Payment_Model]
	, myTarget.[CE_Online_Gaming_Model] = mySource.[CE_Online_Gaming_Model]
	, myTarget.[CE_Online_Invest_Trading_Model] = mySource.[CE_Online_Invest_Trading_Model]
	, myTarget.[CE_Online_Music_Download_Model] = mySource.[CE_Online_Music_Download_Model]
	, myTarget.[CE_Online_Purchase_Bus_Model] = mySource.[CE_Online_Purchase_Bus_Model]
	, myTarget.[CE_Online_Purchase_Personl_Model] = mySource.[CE_Online_Purchase_Personl_Model]
	, myTarget.[CE_Online_TV_Download_Model] = mySource.[CE_Online_TV_Download_Model]
	, myTarget.[CE_Online_Travel_Plan_Model] = mySource.[CE_Online_Travel_Plan_Model]
	, myTarget.[CE_Opinion_Leader_Model] = mySource.[CE_Opinion_Leader_Model]
	, myTarget.[CE_Opportunist_Flag] = mySource.[CE_Opportunist_Flag]
	, myTarget.[CE_Organic_Food_Model] = mySource.[CE_Organic_Food_Model]
	, myTarget.[CE_Osteoporosis_Flag] = mySource.[CE_Osteoporosis_Flag]
	, myTarget.[CE_Outdoor_Activities_Model] = mySource.[CE_Outdoor_Activities_Model]
	, myTarget.[CE_Outdoor_Enthusiast_Flag] = mySource.[CE_Outdoor_Enthusiast_Flag]
	, myTarget.[CE_Own_Rent_Likelihood_Code] = mySource.[CE_Own_Rent_Likelihood_Code]
	, myTarget.[CE_Pensioner_Present_Flag] = mySource.[CE_Pensioner_Present_Flag]
	, myTarget.[CE_Pet_Owner_Flag] = mySource.[CE_Pet_Owner_Flag]
	, myTarget.[CE_Photography_Enthusiast_Flag] = mySource.[CE_Photography_Enthusiast_Flag]
	, myTarget.[CE_Physical_Fitness_Club_Model] = mySource.[CE_Physical_Fitness_Club_Model]
	, myTarget.[CE_Physical_Handicap_Flag] = mySource.[CE_Physical_Handicap_Flag]
	, myTarget.[CE_Pilates_Yoga_Model] = mySource.[CE_Pilates_Yoga_Model]
	, myTarget.[CE_Political_Contributor_Flag] = mySource.[CE_Political_Contributor_Flag]
	, myTarget.[CE_Postal_County_Code] = mySource.[CE_Postal_County_Code]
	, myTarget.[CE_Postal_State_Code] = mySource.[CE_Postal_State_Code]
	, myTarget.[CE_Potential_Investor_Consumer_S] = mySource.[CE_Potential_Investor_Consumer_S]
	, myTarget.[CE_Power_Boating_Model] = mySource.[CE_Power_Boating_Model]
	, myTarget.[CE_Presence_Age_0_To_3_Flag] = mySource.[CE_Presence_Age_0_To_3_Flag]
	, myTarget.[CE_Presence_Age_13_To_17_Flag] = mySource.[CE_Presence_Age_13_To_17_Flag]
	, myTarget.[CE_Presence_Age_4_To_7_Flag] = mySource.[CE_Presence_Age_4_To_7_Flag]
	, myTarget.[CE_Presence_Age_8_To_12_Flag] = mySource.[CE_Presence_Age_8_To_12_Flag]
	, myTarget.[CE_Primary_Family_Flag] = mySource.[CE_Primary_Family_Flag]
	, myTarget.[CE_Pro_Tax_Preparation_Model] = mySource.[CE_Pro_Tax_Preparation_Model]
	, myTarget.[CE_Professional_Baseball_Model] = mySource.[CE_Professional_Baseball_Model]
	, myTarget.[CE_Professional_Basketball_Model] = mySource.[CE_Professional_Basketball_Model]
	, myTarget.[CE_Professional_Football_Model] = mySource.[CE_Professional_Football_Model]
	, myTarget.[CE_Professional_Wrestling_Model] = mySource.[CE_Professional_Wrestling_Model]
	, myTarget.[CE_Property_Type] = mySource.[CE_Property_Type]
	, myTarget.[CE_Purchasing_Power_Income_Code] = mySource.[CE_Purchasing_Power_Income_Code]
	, myTarget.[CE_Purchasing_Power_Income_Detec] = mySource.[CE_Purchasing_Power_Income_Detec]
	, myTarget.[CE_Real_Estate_Investment_Model] = mySource.[CE_Real_Estate_Investment_Model]
	, myTarget.[CE_Recency_Date_Formatted] = mySource.[CE_Recency_Date_Formatted]
	, myTarget.[CE_Reference_Qualified_Indicator] = mySource.[CE_Reference_Qualified_Indicator]
	, myTarget.[CE_Religious_Contributor_Flag] = mySource.[CE_Religious_Contributor_Flag]
	, myTarget.[CE_Religious_Donor_Model] = mySource.[CE_Religious_Donor_Model]
	, myTarget.[CE_Rental_Car_Model] = mySource.[CE_Rental_Car_Model]
	, myTarget.[CE_Revolver_Minimum_Payment_Mode] = mySource.[CE_Revolver_Minimum_Payment_Mode]
	, myTarget.[CE_Rooms] = mySource.[CE_Rooms]
	, myTarget.[CE_SUV_Buyer_Model] = mySource.[CE_SUV_Buyer_Model]
	, myTarget.[CE_Safety_Security_Conscious_Mod] = mySource.[CE_Safety_Security_Conscious_Mod]
	, myTarget.[CE_Salt_Water_Fishing_Model] = mySource.[CE_Salt_Water_Fishing_Model]
	, myTarget.[CE_Satellite_TV_Model] = mySource.[CE_Satellite_TV_Model]
	, myTarget.[CE_Second_Property_Indicator_Fla] = mySource.[CE_Second_Property_Indicator_Fla]
	, myTarget.[CE_Selected_Age] = mySource.[CE_Selected_Age]
	, myTarget.[CE_Selected_Gender] = mySource.[CE_Selected_Gender]
	, myTarget.[CE_Selected_Given_Name] = mySource.[CE_Selected_Given_Name]
	, myTarget.[CE_Selected_Ind_YYYYMMDD_Birth] = mySource.[CE_Selected_Ind_YYYYMMDD_Birth]
	, myTarget.[CE_Selected_Individual_Active_Ba] = mySource.[CE_Selected_Individual_Active_Ba]
	, myTarget.[CE_Selected_Individual_Bank_Card] = mySource.[CE_Selected_Individual_Bank_Card]
	, myTarget.[CE_Selected_Individual_Formatted] = mySource.[CE_Selected_Individual_Formatted]
	, myTarget.[CE_Selected_Individual_Grandpare] = mySource.[CE_Selected_Individual_Grandpare]
	, myTarget.[CE_Selected_Individual_Has_Finan] = mySource.[CE_Selected_Individual_Has_Finan]
	, myTarget.[CE_Selected_Individual_Has_Misc] = mySource.[CE_Selected_Individual_Has_Misc]
	, myTarget.[CE_Selected_Individual_Has_Oil_C] = mySource.[CE_Selected_Individual_Has_Oil_C]
	, myTarget.[CE_Selected_Individual_Has_Premi] = mySource.[CE_Selected_Individual_Has_Premi]
	, myTarget.[CE_Selected_Individual_Has_Retai] = mySource.[CE_Selected_Individual_Has_Retai]
	, myTarget.[CE_Selected_Individual_Has_Speci] = mySource.[CE_Selected_Individual_Has_Speci]
	, myTarget.[CE_Selected_Individual_Has_Upsca] = mySource.[CE_Selected_Individual_Has_Upsca]
	, myTarget.[CE_Selected_Individual_Head_of_H] = mySource.[CE_Selected_Individual_Head_of_H]
	, myTarget.[CE_Selected_Individual_Marital_S] = mySource.[CE_Selected_Individual_Marital_S]
	, myTarget.[CE_Selected_Individual_Parent_Fl] = mySource.[CE_Selected_Individual_Parent_Fl]
	, myTarget.[CE_Selected_Individual_Political] = mySource.[CE_Selected_Individual_Political]
	, myTarget.[CE_Selected_Individual_Spouse_Fl] = mySource.[CE_Selected_Individual_Spouse_Fl]
	, myTarget.[CE_Selected_Individual_Vend_0001] = mySource.[CE_Selected_Individual_Vend_0001]
	, myTarget.[CE_Selected_Individual_Vendor_Co] = mySource.[CE_Selected_Individual_Vendor_Co]
	, myTarget.[CE_Selected_Individual_Vendor_Et] = mySource.[CE_Selected_Individual_Vendor_Et]
	, myTarget.[CE_Selected_Individual_Vendor_Re] = mySource.[CE_Selected_Individual_Vendor_Re]
	, myTarget.[CE_Selected_Individual_Vendor_Sp] = mySource.[CE_Selected_Individual_Vendor_Sp]
	, myTarget.[CE_Selected_Individual_Work_At_H] = mySource.[CE_Selected_Individual_Work_At_H]
	, myTarget.[CE_Selected_Middle_Initial] = mySource.[CE_Selected_Middle_Initial]
	, myTarget.[CE_Selected_Surname] = mySource.[CE_Selected_Surname]
	, myTarget.[CE_Selected_Surname_Suffix] = mySource.[CE_Selected_Surname_Suffix]
	, myTarget.[CE_Shopaholics_Model] = mySource.[CE_Shopaholics_Model]
	, myTarget.[CE_Small_Business_Insur_Model] = mySource.[CE_Small_Business_Insur_Model]
	, myTarget.[CE_Soccer_Model] = mySource.[CE_Soccer_Model]
	, myTarget.[CE_Social_Media_Network_Model] = mySource.[CE_Social_Media_Network_Model]
	, myTarget.[CE_Speclty_Org_Food_Store_Model] = mySource.[CE_Speclty_Org_Food_Store_Model]
	, myTarget.[CE_Sports_Fanatics_Model] = mySource.[CE_Sports_Fanatics_Model]
	, myTarget.[CE_Stamps_Coins_Collector_Flag] = mySource.[CE_Stamps_Coins_Collector_Flag]
	, myTarget.[CE_Stocks_Bonds_Investments_Flag] = mySource.[CE_Stocks_Bonds_Investments_Flag]
	, myTarget.[CE_Surnames_In_Household] = mySource.[CE_Surnames_In_Household]
	, myTarget.[CE_Tennis_Model] = mySource.[CE_Tennis_Model]
	, myTarget.[CE_Timeshare_Owner_Model] = mySource.[CE_Timeshare_Owner_Model]
	, myTarget.[CE_VCR_Ownership_Flag] = mySource.[CE_VCR_Ownership_Flag]
	, myTarget.[CE_Veteran_Present_Flag] = mySource.[CE_Veteran_Present_Flag]
	, myTarget.[CE_Voice_Over_Internet_Model] = mySource.[CE_Voice_Over_Internet_Model]
	, myTarget.[CE_Wealthfinder_Code] = mySource.[CE_Wealthfinder_Code]
	, myTarget.[CE_Wholesale_Club_Model] = mySource.[CE_Wholesale_Club_Model]
	, myTarget.[CE_Wifi_In_Home_Model] = mySource.[CE_Wifi_In_Home_Model]
	, myTarget.[CE_Wifi_Outside_Of_Home_Model] = mySource.[CE_Wifi_Outside_Of_Home_Model]
	, myTarget.[CE_Wine_Lover_Model] = mySource.[CE_Wine_Lover_Model]
	, myTarget.[CE_Work_Health_Insurance_Model] = mySource.[CE_Work_Health_Insurance_Model]
	, myTarget.[CE_Year_Home_Built] = mySource.[CE_Year_Home_Built]
	, myTarget.[ER_ABI_NUMBER] = mySource.[ER_ABI_NUMBER]
	, myTarget.[ER_BUS_ADDRESS] = mySource.[ER_BUS_ADDRESS]
	, myTarget.[ER_BUS_CITY] = mySource.[ER_BUS_CITY]
	, myTarget.[ER_BUS_COUNTY_CODE] = mySource.[ER_BUS_COUNTY_CODE]
	, myTarget.[ER_BUS_STATE] = mySource.[ER_BUS_STATE]
	, myTarget.[ER_BUS_TELEPHONE] = mySource.[ER_BUS_TELEPHONE]
	, myTarget.[ER_BUS_ZIP_CODE] = mySource.[ER_BUS_ZIP_CODE]
	, myTarget.[ER_BUS_ZIP_FOUR] = mySource.[ER_BUS_ZIP_FOUR]
	, myTarget.[ER_COMPANY_NAME] = mySource.[ER_COMPANY_NAME]
	, myTarget.[ER_EMPLOYEE_CODE] = mySource.[ER_EMPLOYEE_CODE]
	, myTarget.[ER_INDIVIDUAL_NAME] = mySource.[ER_INDIVIDUAL_NAME]
	, myTarget.[ER_SALES_VOLUME] = mySource.[ER_SALES_VOLUME]
	, myTarget.[ER_SIC] = mySource.[ER_SIC]
	, myTarget.[ER_SIC_DESCRIPTION] = mySource.[ER_SIC_DESCRIPTION]
	, myTarget.[ER_TITLE_CODE] = mySource.[ER_TITLE_CODE]
	, myTarget.[ER_TITLE_DESCRIPTION] = mySource.[ER_TITLE_DESCRIPTION]
	, myTarget.[EE_Email_Address] = mySource.[EE_Email_Address]
	, myTarget.[Email_Verify_Flag] = mySource.[Email_Verify_Flag]




     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
	 ,[ETL_IsDeleted]
	 ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_FileName]
	, [customerid]
	, [email]
	, [sumtm_acct_id]
	, [tkt_acct_id]
	, [CE_ATV_Model]
	, [CE_Active_Bank_Card_Flag]
	, [CE_Adventure_Seekers_Model]
	, [CE_Allergies_Flag]
	, [CE_Alternative_Medicine_Model]
	, [CE_Alzheimers_Flag]
	, [CE_Angina_Heart_Flag]
	, [CE_Annuities_Model]
	, [CE_Apparel_Interest_Flag]
	, [CE_Arrival_Date_Formatted]
	, [CE_Arthritis_Flag]
	, [CE_Asthma_Flag]
	, [CE_Auto_Club_Model]
	, [CE_Auto_Loan_Model]
	, [CE_Avid_Cell_Phone_User_Model]
	, [CE_Avid_Gamers_Model]
	, [CE_Avid_Smart_Phone_Users_Model]
	, [CE_Avid_Theme_Park_Visitor_Model]
	, [CE_Baby_Product_Model]
	, [CE_Bank_Card_Holder_Flag]
	, [CE_Blog_Writing_Model]
	, [CE_Boat_Owner_Flag]
	, [CE_Boat_Propulsion_Code]
	, [CE_Books_Music_Interest_Flag]
	, [CE_Business_Banking_Model]
	, [CE_Buyer_Behavior_Cluster_Code]
	, [CE_Camping_Flag]
	, [CE_Camping_Model]
	, [CE_Car_Buff_Flag]
	, [CE_Carrier_Route]
	, [CE_Carrier_Route_Type]
	, [CE_Cat_Owner_Flag]
	, [CE_Cat_Product_Model]
	, [CE_Cell_Phone_Only_Model]
	, [CE_Children_By_Age_By_Gender]
	, [CE_Children_By_Age_By_Month]
	, [CE_Children_Present_Flag]
	, [CE_Childrens_Products_Interest_F]
	, [CE_Collectibles_Interest_Flag]
	, [CE_College_Basketball_Model]
	, [CE_College_Football_Model]
	, [CE_Comprehensive_Auto_Ins_Model]
	, [CE_Computer_Owner_Flag]
	, [CE_Conservative_Model]
	, [CE_Construction_Type_Code]
	, [CE_Cook_For_Fun_Model]
	, [CE_Cook_From_Scratch_Model]
	, [CE_Cooking_Flag]
	, [CE_Corrective_Lenses_Present_Fla]
	, [CE_Country_Club_Member_Model]
	, [CE_County_Nielsen_Rank_Code]
	, [CE_County_Nielsen_Region_Code]
	, [CE_Credit_Card_Rewards_Model]
	, [CE_Cruise_Model]
	, [CE_DIY_Auto_Maintenance_Model]
	, [CE_Delivery_Point]
	, [CE_Delivery_Unit_Size]
	, [CE_Diabetes_Flag]
	, [CE_Diet_Product_Model]
	, [CE_Dieting_Weightloss_Flag]
	, [CE_Discretionary_Income_Score]
	, [CE_Dog_Product_Model]
	, [CE_Donor_Ever_Contributor_Flag]
	, [CE_Donors_PBS_NPR_Model]
	, [CE_E_Reader_Model]
	, [CE_Early_Internet_Adopter_Model]
	, [CE_Education_Loan_Model]
	, [CE_Electronics_Interest_Flag]
	, [CE_Emphysema_Flag]
	, [CE_Environment_Contributor_Flag]
	, [CE_Expendable_Income_Rank_Code]
	, [CE_Family_Income_Detector]
	, [CE_Family_Income_Detector_Code]
	, [CE_Family_Income_Detector_Ranges]
	, [CE_Fantasy_Sports_Model]
	, [CE_Fast_Food_Model]
	, [CE_Female_Occupation_Code]
	, [CE_Financial_Planner_Model]
	, [CE_Financing_Type]
	, [CE_Fireplaces]
	, [CE_Fishing_Flag]
	, [CE_Foreign_Travel_Flag]
	, [CE_Foreign_Travel_Vacation_Model]
	, [CE_Frequent_Business_Traveler_Mo]
	, [CE_Frequent_Flyer_Model]
	, [CE_Frequent_Headaches_Flag]
	, [CE_Fresh_Water_Fishing_Model]
	, [CE_Frozen_Dinner_Model]
	, [CE_Gambling_Flag]
	, [CE_Garage_Pool_Presence]
	, [CE_Garage_Type_Code]
	, [CE_Garden_Maintenance_Model]
	, [CE_Gardening_Horticulture_Intere]
	, [CE_Gift_Buyers_Model]
	, [CE_Golf_Model]
	, [CE_Golfer_Flag]
	, [CE_Gourmet_Food_Wine_Interest_Fl]
	, [CE_Grandparent_Present_Flag]
	, [CE_Green_Model]
	, [CE_Handcrafts_Sewing_Interest_Fl]
	, [CE_Health_Contributor_Flag]
	, [CE_Health_Fitness_Interest_Flag]
	, [CE_Health_Insurance_Model]
	, [CE_Hearing_Difficulty_Flag]
	, [CE_Heating_Type_Code]
	, [CE_Heavy_Book_Buyer_Model]
	, [CE_Heavy_Catalog_Buyer_Model]
	, [CE_Heavy_Coupon_User_Model]
	, [CE_Heavy_Domestic_Traveler_Model]
	, [CE_Heavy_Family_Restaurant_Visit]
	, [CE_Heavy_Internet_User_Model]
	, [CE_Heavy_Investment_Trader_Model]
	, [CE_Heavy_Online_Buyer_Model]
	, [CE_Heavy_Payperview_Movie_Model]
	, [CE_Heavy_Payperview_Sports_Model]
	, [CE_Heavy_Snack_Eaters_Model]
	, [CE_Heavy_Vitamin_Model]
	, [CE_High_Blood_Pressure_Flag]
	, [CE_High_Cholesterol_Flag]
	, [CE_High_End_Apparel_Model]
	, [CE_High_End_Electronic_Model]
	, [CE_High_End_Sporting_Equipment_M]
	, [CE_High_Risk_Investor_Model]
	, [CE_High_Tech_Flag]
	, [CE_High_Ticket_Mail_Order_Flag]
	, [CE_High_Value_Security_Investor]
	, [CE_High_Value_Stock_Investor_Mod]
	, [CE_Higher_Education_Model]
	, [CE_Hockey_Buyer_Model]
	, [CE_Home_Age]
	, [CE_Home_Age_Source]
	, [CE_Home_Decorating_Interest_Flag]
	, [CE_Home_Equity_Estimate_Code]
	, [CE_Home_Improvement_Model]
	, [CE_Home_Loan_Interest_Rate]
	, [CE_Home_Office_Model]
	, [CE_Home_Owner_Flag]
	, [CE_Home_Sale_Date]
	, [CE_Home_Sale_Date_Source]
	, [CE_Home_Sale_Price]
	, [CE_Home_Sale_Price_Source]
	, [CE_Home_Size]
	, [CE_Home_Value_Code]
	, [CE_Home_Value_Source_Code]
	, [CE_Home_Workshop_Interest_Flag]
	, [CE_Homeowner_Source_Code]
	, [CE_House_Fraction]
	, [CE_House_Number]
	, [CE_Household_Active_Trade_Lines]
	, [CE_Household_Dropped_Flag]
	, [CE_Household_Head_Age_Code]
	, [CE_Household_Head_Age_Code_Sourc]
	, [CE_Household_Head_Has_Travel_Ent]
	, [CE_Household_ID]
	, [CE_Household_Status_Code]
	, [CE_Hunting_Flag]
	, [CE_Hunting_Model]
	, [CE_Hybrid_Cars_Model]
	, [CE_Impulse_Buyer_Model]
	, [CE_Income_Producing_Assets]
	, [CE_Income_Producing_Assets_Desc]
	, [CE_Incontenance_Flag]
	, [CE_Individual2_Age]
	, [CE_Individual2_Gender]
	, [CE_Individual2_Given_Name]
	, [CE_Individual2_Has_Finance_Card]
	, [CE_Individual2_Has_Misc_Credit_C]
	, [CE_Individual2_Has_Oil_Company_C]
	, [CE_Individual2_Has_Premium_Bank]
	, [CE_Individual2_Has_Retail_Store]
	, [CE_Individual2_Has_Specialty_Sto]
	, [CE_Individual2_Has_Upscale_Retai]
	, [CE_Individual2_Head_of_Household]
	, [CE_Individual2_Individual_ID]
	, [CE_Individual2_Marital_Stat_Code]
	, [CE_Individual2_Marriage_Date]
	, [CE_Individual2_Middle_Initial]
	, [CE_Individual2_Parent_Flag]
	, [CE_Individual2_Political_Affilia]
	, [CE_Individual2_Spouse_Flag]
	, [CE_Individual2_Surname]
	, [CE_Individual2_Surname_Suffix]
	, [CE_Individual2_Title_Code]
	, [CE_Individual2_Vendor_Country_Or]
	, [CE_Individual2_Vendor_Ethnic_Gro]
	, [CE_Individual2_Vendor_Ethnicity]
	, [CE_Individual2_Vendor_Religion_C]
	, [CE_Individual2_Vendor_Spoken_Lan]
	, [CE_Individual2_Work_At_Home_Flag]
	, [CE_Individual2_YYYYMMDD_Of_Birth]
	, [CE_Individual3_Age]
	, [CE_Individual3_Gender]
	, [CE_Individual3_Given_Name]
	, [CE_Individual3_Has_Finance_Card]
	, [CE_Individual3_Has_Misc_Credit_C]
	, [CE_Individual3_Has_Oil_Company_C]
	, [CE_Individual3_Has_Premium_Bank]
	, [CE_Individual3_Has_Retail_Store]
	, [CE_Individual3_Has_Specialty_Sto]
	, [CE_Individual3_Has_Upscale_Retai]
	, [CE_Individual3_Head_of_Household]
	, [CE_Individual3_Individual_ID]
	, [CE_Individual3_Marital_Stat_Code]
	, [CE_Individual3_Marriage_Date]
	, [CE_Individual3_Middle_Initial]
	, [CE_Individual3_Parent_Flag]
	, [CE_Individual3_Political_Affilia]
	, [CE_Individual3_Spouse_Flag]
	, [CE_Individual3_Surname]
	, [CE_Individual3_Surname_Suffix]
	, [CE_Individual3_Title_Code]
	, [CE_Individual3_Vendor_Country_Or]
	, [CE_Individual3_Vendor_Ethnic_Gro]
	, [CE_Individual3_Vendor_Ethnicity]
	, [CE_Individual3_Vendor_Religion_C]
	, [CE_Individual3_Vendor_Spoken_Lan]
	, [CE_Individual3_Work_At_Home_Flag]
	, [CE_Individual3_YYYYMMDD_Of_Birth]
	, [CE_Individual_HoH_Age]
	, [CE_Individual_HoH_Gender]
	, [CE_Individual_HoH_Given_Name]
	, [CE_Individual_HoH_Has_Finance_Ca]
	, [CE_Individual_HoH_Has_Misc_Credi]
	, [CE_Individual_HoH_Has_Oil_Compan]
	, [CE_Individual_HoH_Has_Premium_Ba]
	, [CE_Individual_HoH_Has_Retail_Sto]
	, [CE_Individual_HoH_Has_Specialty]
	, [CE_Individual_HoH_Has_Upscale_Re]
	, [CE_Individual_HoH_Head_of_Househ]
	, [CE_Individual_HoH_Individual_ID]
	, [CE_Individual_HoH_Marital_Status]
	, [CE_Individual_HoH_Marriage_Date]
	, [CE_Individual_HoH_Middle_Initial]
	, [CE_Individual_HoH_Mobile_Age_Fla]
	, [CE_Individual_HoH_Mortgage_Link]
	, [CE_Individual_HoH_Parent_Flag]
	, [CE_Individual_HoH_Political_Affi]
	, [CE_Individual_HoH_Spouse_Flag]
	, [CE_Individual_HoH_Surname]
	, [CE_Individual_HoH_Surname_Suffix]
	, [CE_Individual_HoH_Title_Code]
	, [CE_Individual_HoH_Vendor_Country]
	, [CE_Individual_HoH_Vendor_Ethnic]
	, [CE_Individual_HoH_Vendor_Ethnici]
	, [CE_Individual_HoH_Vendor_Religio]
	, [CE_Individual_HoH_Vendor_Spoken]
	, [CE_Individual_HoH_Work_At_Home_F]
	, [CE_Individual_HoH_YYYYMMDD_Of_Bi]
	, [CE_InfoPersona_Cluster]
	, [CE_InfoPersona_SuperCluster]
	, [CE_Interest_Rate_Source]
	, [CE_Intl_Long_Distance_Model]
	, [CE_Invest_Not_Stocks_Bonds_Flag]
	, [CE_LHI_Household_Apparel_Accesso]
	, [CE_LHI_Household_Apparel_General]
	, [CE_LHI_Household_Apparel_Kids]
	, [CE_LHI_Household_Apparel_Mens]
	, [CE_LHI_Household_Apparel_Mens_Fa]
	, [CE_LHI_Household_Apparel_Wo_0001]
	, [CE_LHI_Household_Apparel_Womens]
	, [CE_LHI_Household_Auto_Racing]
	, [CE_LHI_Household_Auto_Trucks]
	, [CE_LHI_Household_Automotive]
	, [CE_LHI_Household_Aviation]
	, [CE_LHI_Household_Bargain_Seekers]
	, [CE_LHI_Household_Beauty_Cosmetic]
	, [CE_LHI_Household_Bible]
	, [CE_LHI_Household_Birds]
	, [CE_LHI_Household_Business_Home_O]
	, [CE_LHI_Household_Business_Items]
	, [CE_LHI_Household_Catalogs]
	, [CE_LHI_Household_Charitable_Dono]
	, [CE_LHI_Household_Collectibles]
	, [CE_LHI_Household_Collectibles_St]
	, [CE_LHI_Household_College]
	, [CE_LHI_Household_Computers]
	, [CE_LHI_Household_Cooking]
	, [CE_LHI_Household_Cooking_Gourmet]
	, [CE_LHI_Household_Crafts_Crocheti]
	, [CE_LHI_Household_Crafts_General]
	, [CE_LHI_Household_Crafts_Knitting]
	, [CE_LHI_Household_Crafts_Needlepo]
	, [CE_LHI_Household_Crafts_Quilting]
	, [CE_LHI_Household_Crafts_Sewing]
	, [CE_LHI_Household_Culture_Arts]
	, [CE_LHI_Household_Current_Events]
	, [CE_LHI_Household_Do_It_Yourselfe]
	, [CE_LHI_Household_Ego_Personalize]
	, [CE_LHI_Household_Electronics]
	, [CE_LHI_Household_Equestrian]
	, [CE_LHI_Household_Ethnic_Pro_0001]
	, [CE_LHI_Household_Ethnic_Pro_0002]
	, [CE_LHI_Household_Ethnic_Product]
	, [CE_LHI_Household_Family]
	, [CE_LHI_Household_Finance_Credit]
	, [CE_LHI_Household_Finance_Money_M]
	, [CE_LHI_Household_Finance_Persona]
	, [CE_LHI_Household_Finance_Stocks]
	, [CE_LHI_Household_Gambling]
	, [CE_LHI_Household_Games]
	, [CE_LHI_Household_Gardening]
	, [CE_LHI_Household_Gift_Giver]
	, [CE_LHI_Household_Health_Dieting]
	, [CE_LHI_Household_Health_Fitness]
	, [CE_LHI_Household_Health_General]
	, [CE_LHI_Household_High_Ticket]
	, [CE_LHI_Household_Hightech]
	, [CE_LHI_Household_History]
	, [CE_LHI_Household_History_America]
	, [CE_LHI_Household_Hobbies]
	, [CE_LHI_Household_Home_Decorating]
	, [CE_LHI_Household_Humor]
	, [CE_LHI_Household_Inspirational]
	, [CE_LHI_Household_Internet]
	, [CE_LHI_Household_Internet_Access]
	, [CE_LHI_Household_Internet_Buying]
	, [CE_LHI_Household_Motorcycles]
	, [CE_LHI_Household_Music]
	, [CE_LHI_Household_Ocean]
	, [CE_LHI_Household_Outdoors]
	, [CE_LHI_Household_Outdoors_Boatin]
	, [CE_LHI_Household_Outdoors_Campin]
	, [CE_LHI_Household_Outdoors_Fishin]
	, [CE_LHI_Household_Outdoors_H_0001]
	, [CE_LHI_Household_Outdoors_Huntin]
	, [CE_LHI_Household_Pets]
	, [CE_LHI_Household_Pets_Cats]
	, [CE_LHI_Household_Pets_Dogs]
	, [CE_LHI_Household_Photo_Photograp]
	, [CE_LHI_Household_Photo_Photoproc]
	, [CE_LHI_Household_Politically_Con]
	, [CE_LHI_Household_Politically_Lib]
	, [CE_LHI_Household_Publish_Books]
	, [CE_LHI_Household_Publish_Fiction]
	, [CE_LHI_Household_Publish_Magazin]
	, [CE_LHI_Household_Publish_Nonfict]
	, [CE_LHI_Household_Publish_Publica]
	, [CE_LHI_Household_Publish_Science]
	, [CE_LHI_Household_Rural_Farming]
	, [CE_LHI_Household_Science]
	, [CE_LHI_Household_Seniors]
	, [CE_LHI_Household_Sports_Baseball]
	, [CE_LHI_Household_Sports_Basketba]
	, [CE_LHI_Household_Sports_Football]
	, [CE_LHI_Household_Sports_General]
	, [CE_LHI_Household_Sports_Golf]
	, [CE_LHI_Household_Sports_Hockey]
	, [CE_LHI_Household_Sports_Skiing]
	, [CE_LHI_Household_Sports_Soccer]
	, [CE_LHI_Household_Sports_Tennis]
	, [CE_LHI_Household_Stationery]
	, [CE_LHI_Household_Sweepstakes]
	, [CE_LHI_Household_TV_Movies]
	, [CE_LHI_Household_Technology_VCR]
	, [CE_LHI_Household_Tobacco]
	, [CE_LHI_Household_Travel_Cruises]
	, [CE_LHI_Household_Travel_Foreign]
	, [CE_LHI_Household_Travel_General]
	, [CE_LHI_Household_Travel_RV]
	, [CE_LHI_Household_Travel_US]
	, [CE_LHI_Household_Wildlife]
	, [CE_LHI_Individual_HoH_Apparel_Ge]
	, [CE_Leaning_Conservative_Model]
	, [CE_Leaning_Liberal_Model]
	, [CE_Length_of_Residence_Years]
	, [CE_Liberal_Model]
	, [CE_Life_Insurance_Model]
	, [CE_Live_Theater_Model]
	, [CE_Loan_Amount]
	, [CE_Loan_Amount_Source]
	, [CE_Loan_Type]
	, [CE_Loan_to_Value_Ratio_Range_Cod]
	, [CE_Location_ID]
	, [CE_Location_Type]
	, [CE_Lot_Size]
	, [CE_Low_End_Sporting_Equip_Model]
	, [CE_Low_Risk_Investor_Model]
	, [CE_Luxury_Car_Buyer_Model]
	, [CE_Luxury_Hotel_Model]
	, [CE_Magazine_Subscriber_Flag]
	, [CE_Mail_Order_Buyer_Current_Flag]
	, [CE_Mail_Order_Buyer_Ever_Flag]
	, [CE_Mail_Order_Software_Purchase]
	, [CE_Mail_Responsive_Current_Flag]
	, [CE_Mail_Responsive_Ever_Flag]
	, [CE_Mail_Responsive_Previous_Flag]
	, [CE_Major_Home_Remodeling_Model]
	, [CE_Male_Occupation_Code]
	, [CE_Marketing_HH_1_To_2_People]
	, [CE_Marketing_HH_3_Plus_People]
	, [CE_Marketing_Target_Age_0_To_11]
	, [CE_Marketing_Target_Age_0_To_17]
	, [CE_Marketing_Target_Age_0_To_5]
	, [CE_Marketing_Target_Age_12_To_17]
	, [CE_Marketing_Target_Age_6_To_11]
	, [CE_Marketing_Target_Age_Over_50]
	, [CE_Marketing_Target_Age_Over_65]
	, [CE_Marketing_Target_Females_0001]
	, [CE_Marketing_Target_Females_0002]
	, [CE_Marketing_Target_Females_0003]
	, [CE_Marketing_Target_Females_0004]
	, [CE_Marketing_Target_Females_0005]
	, [CE_Marketing_Target_Females_0006]
	, [CE_Marketing_Target_Females_0007]
	, [CE_Marketing_Target_Females_0008]
	, [CE_Marketing_Target_Females_Age]
	, [CE_Marketing_Target_Males_A_0001]
	, [CE_Marketing_Target_Males_A_0002]
	, [CE_Marketing_Target_Males_Age_12]
	, [CE_Marketing_Target_Males_Age_18]
	, [CE_Marketing_Target_Males_Age_25]
	, [CE_Marketing_Target_Males_Age_35]
	, [CE_Marketing_Target_Males_Age_45]
	, [CE_Marketing_Target_Males_Age_55]
	, [CE_Member_Count]
	, [CE_Migraines_Flag]
	, [CE_Minivan_Buyer_Model]
	, [CE_Mobile_Internet_Access_Model]
	, [CE_Moderate_Economy_Hotel_Model]
	, [CE_Mortgage_Amount_Source_Code]
	, [CE_Mortgage_Type_Source_Code]
	, [CE_Move_Out_Flag]
	, [CE_Multi_Unit_Flag]
	, [CE_Music_Concert_Classical_Model]
	, [CE_Music_Concert_Country_Model]
	, [CE_Music_Concert_Rock_Model]
	, [CE_Nascar_Model]
	, [CE_New_Vehicle_Buyer_Model]
	, [CE_Non_Religious_Donor_Model]
	, [CE_Number_Adult_Females]
	, [CE_Number_Adult_Males]
	, [CE_Number_Adults]
	, [CE_Number_Bathrooms]
	, [CE_Number_Bedrooms]
	, [CE_Number_Children]
	, [CE_Occupancy_Count]
	, [CE_Online_Bill_Payment_Model]
	, [CE_Online_Gaming_Model]
	, [CE_Online_Invest_Trading_Model]
	, [CE_Online_Music_Download_Model]
	, [CE_Online_Purchase_Bus_Model]
	, [CE_Online_Purchase_Personl_Model]
	, [CE_Online_TV_Download_Model]
	, [CE_Online_Travel_Plan_Model]
	, [CE_Opinion_Leader_Model]
	, [CE_Opportunist_Flag]
	, [CE_Organic_Food_Model]
	, [CE_Osteoporosis_Flag]
	, [CE_Outdoor_Activities_Model]
	, [CE_Outdoor_Enthusiast_Flag]
	, [CE_Own_Rent_Likelihood_Code]
	, [CE_Pensioner_Present_Flag]
	, [CE_Pet_Owner_Flag]
	, [CE_Photography_Enthusiast_Flag]
	, [CE_Physical_Fitness_Club_Model]
	, [CE_Physical_Handicap_Flag]
	, [CE_Pilates_Yoga_Model]
	, [CE_Political_Contributor_Flag]
	, [CE_Postal_County_Code]
	, [CE_Postal_State_Code]
	, [CE_Potential_Investor_Consumer_S]
	, [CE_Power_Boating_Model]
	, [CE_Presence_Age_0_To_3_Flag]
	, [CE_Presence_Age_13_To_17_Flag]
	, [CE_Presence_Age_4_To_7_Flag]
	, [CE_Presence_Age_8_To_12_Flag]
	, [CE_Primary_Family_Flag]
	, [CE_Pro_Tax_Preparation_Model]
	, [CE_Professional_Baseball_Model]
	, [CE_Professional_Basketball_Model]
	, [CE_Professional_Football_Model]
	, [CE_Professional_Wrestling_Model]
	, [CE_Property_Type]
	, [CE_Purchasing_Power_Income_Code]
	, [CE_Purchasing_Power_Income_Detec]
	, [CE_Real_Estate_Investment_Model]
	, [CE_Recency_Date_Formatted]
	, [CE_Reference_Qualified_Indicator]
	, [CE_Religious_Contributor_Flag]
	, [CE_Religious_Donor_Model]
	, [CE_Rental_Car_Model]
	, [CE_Revolver_Minimum_Payment_Mode]
	, [CE_Rooms]
	, [CE_SUV_Buyer_Model]
	, [CE_Safety_Security_Conscious_Mod]
	, [CE_Salt_Water_Fishing_Model]
	, [CE_Satellite_TV_Model]
	, [CE_Second_Property_Indicator_Fla]
	, [CE_Selected_Age]
	, [CE_Selected_Gender]
	, [CE_Selected_Given_Name]
	, [CE_Selected_Ind_YYYYMMDD_Birth]
	, [CE_Selected_Individual_Active_Ba]
	, [CE_Selected_Individual_Bank_Card]
	, [CE_Selected_Individual_Formatted]
	, [CE_Selected_Individual_Grandpare]
	, [CE_Selected_Individual_Has_Finan]
	, [CE_Selected_Individual_Has_Misc]
	, [CE_Selected_Individual_Has_Oil_C]
	, [CE_Selected_Individual_Has_Premi]
	, [CE_Selected_Individual_Has_Retai]
	, [CE_Selected_Individual_Has_Speci]
	, [CE_Selected_Individual_Has_Upsca]
	, [CE_Selected_Individual_Head_of_H]
	, [CE_Selected_Individual_Marital_S]
	, [CE_Selected_Individual_Parent_Fl]
	, [CE_Selected_Individual_Political]
	, [CE_Selected_Individual_Spouse_Fl]
	, [CE_Selected_Individual_Vend_0001]
	, [CE_Selected_Individual_Vendor_Co]
	, [CE_Selected_Individual_Vendor_Et]
	, [CE_Selected_Individual_Vendor_Re]
	, [CE_Selected_Individual_Vendor_Sp]
	, [CE_Selected_Individual_Work_At_H]
	, [CE_Selected_Middle_Initial]
	, [CE_Selected_Surname]
	, [CE_Selected_Surname_Suffix]
	, [CE_Shopaholics_Model]
	, [CE_Small_Business_Insur_Model]
	, [CE_Soccer_Model]
	, [CE_Social_Media_Network_Model]
	, [CE_Speclty_Org_Food_Store_Model]
	, [CE_Sports_Fanatics_Model]
	, [CE_Stamps_Coins_Collector_Flag]
	, [CE_Stocks_Bonds_Investments_Flag]
	, [CE_Surnames_In_Household]
	, [CE_Tennis_Model]
	, [CE_Timeshare_Owner_Model]
	, [CE_VCR_Ownership_Flag]
	, [CE_Veteran_Present_Flag]
	, [CE_Voice_Over_Internet_Model]
	, [CE_Wealthfinder_Code]
	, [CE_Wholesale_Club_Model]
	, [CE_Wifi_In_Home_Model]
	, [CE_Wifi_Outside_Of_Home_Model]
	, [CE_Wine_Lover_Model]
	, [CE_Work_Health_Insurance_Model]
	, [CE_Year_Home_Built]
	, [ER_ABI_NUMBER]
	, [ER_BUS_ADDRESS]
	, [ER_BUS_CITY]
	, [ER_BUS_COUNTY_CODE]
	, [ER_BUS_STATE]
	, [ER_BUS_TELEPHONE]
	, [ER_BUS_ZIP_CODE]
	, [ER_BUS_ZIP_FOUR]
	, [ER_COMPANY_NAME]
	, [ER_EMPLOYEE_CODE]
	, [ER_INDIVIDUAL_NAME]
	, [ER_SALES_VOLUME]
	, [ER_SIC]
	, [ER_SIC_DESCRIPTION]
	, [ER_TITLE_CODE]
	, [ER_TITLE_DESCRIPTION]
	, [EE_Email_Address]
	, [Email_Verify_Flag]
     )

VALUES
     (@RunTime	--	ETL_CreatedDate
     ,@RunTime	--	ETL_UpdatedDate
	 ,0			--	ETL_IsDeleted
	 ,NULL		--	ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ETL_FileName]
 	 , mySource.[customerid]
	, mySource.[email]
	, mySource.[sumtm_acct_id]
	, mySource.[tkt_acct_id]
	, mySource.[CE_ATV_Model]
	, mySource.[CE_Active_Bank_Card_Flag]
	, mySource.[CE_Adventure_Seekers_Model]
	, mySource.[CE_Allergies_Flag]
	, mySource.[CE_Alternative_Medicine_Model]
	, mySource.[CE_Alzheimers_Flag]
	, mySource.[CE_Angina_Heart_Flag]
	, mySource.[CE_Annuities_Model]
	, mySource.[CE_Apparel_Interest_Flag]
	, mySource.[CE_Arrival_Date_Formatted]
	, mySource.[CE_Arthritis_Flag]
	, mySource.[CE_Asthma_Flag]
	, mySource.[CE_Auto_Club_Model]
	, mySource.[CE_Auto_Loan_Model]
	, mySource.[CE_Avid_Cell_Phone_User_Model]
	, mySource.[CE_Avid_Gamers_Model]
	, mySource.[CE_Avid_Smart_Phone_Users_Model]
	, mySource.[CE_Avid_Theme_Park_Visitor_Model]
	, mySource.[CE_Baby_Product_Model]
	, mySource.[CE_Bank_Card_Holder_Flag]
	, mySource.[CE_Blog_Writing_Model]
	, mySource.[CE_Boat_Owner_Flag]
	, mySource.[CE_Boat_Propulsion_Code]
	, mySource.[CE_Books_Music_Interest_Flag]
	, mySource.[CE_Business_Banking_Model]
	, mySource.[CE_Buyer_Behavior_Cluster_Code]
	, mySource.[CE_Camping_Flag]
	, mySource.[CE_Camping_Model]
	, mySource.[CE_Car_Buff_Flag]
	, mySource.[CE_Carrier_Route]
	, mySource.[CE_Carrier_Route_Type]
	, mySource.[CE_Cat_Owner_Flag]
	, mySource.[CE_Cat_Product_Model]
	, mySource.[CE_Cell_Phone_Only_Model]
	, mySource.[CE_Children_By_Age_By_Gender]
	, mySource.[CE_Children_By_Age_By_Month]
	, mySource.[CE_Children_Present_Flag]
	, mySource.[CE_Childrens_Products_Interest_F]
	, mySource.[CE_Collectibles_Interest_Flag]
	, mySource.[CE_College_Basketball_Model]
	, mySource.[CE_College_Football_Model]
	, mySource.[CE_Comprehensive_Auto_Ins_Model]
	, mySource.[CE_Computer_Owner_Flag]
	, mySource.[CE_Conservative_Model]
	, mySource.[CE_Construction_Type_Code]
	, mySource.[CE_Cook_For_Fun_Model]
	, mySource.[CE_Cook_From_Scratch_Model]
	, mySource.[CE_Cooking_Flag]
	, mySource.[CE_Corrective_Lenses_Present_Fla]
	, mySource.[CE_Country_Club_Member_Model]
	, mySource.[CE_County_Nielsen_Rank_Code]
	, mySource.[CE_County_Nielsen_Region_Code]
	, mySource.[CE_Credit_Card_Rewards_Model]
	, mySource.[CE_Cruise_Model]
	, mySource.[CE_DIY_Auto_Maintenance_Model]
	, mySource.[CE_Delivery_Point]
	, mySource.[CE_Delivery_Unit_Size]
	, mySource.[CE_Diabetes_Flag]
	, mySource.[CE_Diet_Product_Model]
	, mySource.[CE_Dieting_Weightloss_Flag]
	, mySource.[CE_Discretionary_Income_Score]
	, mySource.[CE_Dog_Product_Model]
	, mySource.[CE_Donor_Ever_Contributor_Flag]
	, mySource.[CE_Donors_PBS_NPR_Model]
	, mySource.[CE_E_Reader_Model]
	, mySource.[CE_Early_Internet_Adopter_Model]
	, mySource.[CE_Education_Loan_Model]
	, mySource.[CE_Electronics_Interest_Flag]
	, mySource.[CE_Emphysema_Flag]
	, mySource.[CE_Environment_Contributor_Flag]
	, mySource.[CE_Expendable_Income_Rank_Code]
	, mySource.[CE_Family_Income_Detector]
	, mySource.[CE_Family_Income_Detector_Code]
	, mySource.[CE_Family_Income_Detector_Ranges]
	, mySource.[CE_Fantasy_Sports_Model]
	, mySource.[CE_Fast_Food_Model]
	, mySource.[CE_Female_Occupation_Code]
	, mySource.[CE_Financial_Planner_Model]
	, mySource.[CE_Financing_Type]
	, mySource.[CE_Fireplaces]
	, mySource.[CE_Fishing_Flag]
	, mySource.[CE_Foreign_Travel_Flag]
	, mySource.[CE_Foreign_Travel_Vacation_Model]
	, mySource.[CE_Frequent_Business_Traveler_Mo]
	, mySource.[CE_Frequent_Flyer_Model]
	, mySource.[CE_Frequent_Headaches_Flag]
	, mySource.[CE_Fresh_Water_Fishing_Model]
	, mySource.[CE_Frozen_Dinner_Model]
	, mySource.[CE_Gambling_Flag]
	, mySource.[CE_Garage_Pool_Presence]
	, mySource.[CE_Garage_Type_Code]
	, mySource.[CE_Garden_Maintenance_Model]
	, mySource.[CE_Gardening_Horticulture_Intere]
	, mySource.[CE_Gift_Buyers_Model]
	, mySource.[CE_Golf_Model]
	, mySource.[CE_Golfer_Flag]
	, mySource.[CE_Gourmet_Food_Wine_Interest_Fl]
	, mySource.[CE_Grandparent_Present_Flag]
	, mySource.[CE_Green_Model]
	, mySource.[CE_Handcrafts_Sewing_Interest_Fl]
	, mySource.[CE_Health_Contributor_Flag]
	, mySource.[CE_Health_Fitness_Interest_Flag]
	, mySource.[CE_Health_Insurance_Model]
	, mySource.[CE_Hearing_Difficulty_Flag]
	, mySource.[CE_Heating_Type_Code]
	, mySource.[CE_Heavy_Book_Buyer_Model]
	, mySource.[CE_Heavy_Catalog_Buyer_Model]
	, mySource.[CE_Heavy_Coupon_User_Model]
	, mySource.[CE_Heavy_Domestic_Traveler_Model]
	, mySource.[CE_Heavy_Family_Restaurant_Visit]
	, mySource.[CE_Heavy_Internet_User_Model]
	, mySource.[CE_Heavy_Investment_Trader_Model]
	, mySource.[CE_Heavy_Online_Buyer_Model]
	, mySource.[CE_Heavy_Payperview_Movie_Model]
	, mySource.[CE_Heavy_Payperview_Sports_Model]
	, mySource.[CE_Heavy_Snack_Eaters_Model]
	, mySource.[CE_Heavy_Vitamin_Model]
	, mySource.[CE_High_Blood_Pressure_Flag]
	, mySource.[CE_High_Cholesterol_Flag]
	, mySource.[CE_High_End_Apparel_Model]
	, mySource.[CE_High_End_Electronic_Model]
	, mySource.[CE_High_End_Sporting_Equipment_M]
	, mySource.[CE_High_Risk_Investor_Model]
	, mySource.[CE_High_Tech_Flag]
	, mySource.[CE_High_Ticket_Mail_Order_Flag]
	, mySource.[CE_High_Value_Security_Investor]
	, mySource.[CE_High_Value_Stock_Investor_Mod]
	, mySource.[CE_Higher_Education_Model]
	, mySource.[CE_Hockey_Buyer_Model]
	, mySource.[CE_Home_Age]
	, mySource.[CE_Home_Age_Source]
	, mySource.[CE_Home_Decorating_Interest_Flag]
	, mySource.[CE_Home_Equity_Estimate_Code]
	, mySource.[CE_Home_Improvement_Model]
	, mySource.[CE_Home_Loan_Interest_Rate]
	, mySource.[CE_Home_Office_Model]
	, mySource.[CE_Home_Owner_Flag]
	, mySource.[CE_Home_Sale_Date]
	, mySource.[CE_Home_Sale_Date_Source]
	, mySource.[CE_Home_Sale_Price]
	, mySource.[CE_Home_Sale_Price_Source]
	, mySource.[CE_Home_Size]
	, mySource.[CE_Home_Value_Code]
	, mySource.[CE_Home_Value_Source_Code]
	, mySource.[CE_Home_Workshop_Interest_Flag]
	, mySource.[CE_Homeowner_Source_Code]
	, mySource.[CE_House_Fraction]
	, mySource.[CE_House_Number]
	, mySource.[CE_Household_Active_Trade_Lines]
	, mySource.[CE_Household_Dropped_Flag]
	, mySource.[CE_Household_Head_Age_Code]
	, mySource.[CE_Household_Head_Age_Code_Sourc]
	, mySource.[CE_Household_Head_Has_Travel_Ent]
	, mySource.[CE_Household_ID]
	, mySource.[CE_Household_Status_Code]
	, mySource.[CE_Hunting_Flag]
	, mySource.[CE_Hunting_Model]
	, mySource.[CE_Hybrid_Cars_Model]
	, mySource.[CE_Impulse_Buyer_Model]
	, mySource.[CE_Income_Producing_Assets]
	, mySource.[CE_Income_Producing_Assets_Desc]
	, mySource.[CE_Incontenance_Flag]
	, mySource.[CE_Individual2_Age]
	, mySource.[CE_Individual2_Gender]
	, mySource.[CE_Individual2_Given_Name]
	, mySource.[CE_Individual2_Has_Finance_Card]
	, mySource.[CE_Individual2_Has_Misc_Credit_C]
	, mySource.[CE_Individual2_Has_Oil_Company_C]
	, mySource.[CE_Individual2_Has_Premium_Bank]
	, mySource.[CE_Individual2_Has_Retail_Store]
	, mySource.[CE_Individual2_Has_Specialty_Sto]
	, mySource.[CE_Individual2_Has_Upscale_Retai]
	, mySource.[CE_Individual2_Head_of_Household]
	, mySource.[CE_Individual2_Individual_ID]
	, mySource.[CE_Individual2_Marital_Stat_Code]
	, mySource.[CE_Individual2_Marriage_Date]
	, mySource.[CE_Individual2_Middle_Initial]
	, mySource.[CE_Individual2_Parent_Flag]
	, mySource.[CE_Individual2_Political_Affilia]
	, mySource.[CE_Individual2_Spouse_Flag]
	, mySource.[CE_Individual2_Surname]
	, mySource.[CE_Individual2_Surname_Suffix]
	, mySource.[CE_Individual2_Title_Code]
	, mySource.[CE_Individual2_Vendor_Country_Or]
	, mySource.[CE_Individual2_Vendor_Ethnic_Gro]
	, mySource.[CE_Individual2_Vendor_Ethnicity]
	, mySource.[CE_Individual2_Vendor_Religion_C]
	, mySource.[CE_Individual2_Vendor_Spoken_Lan]
	, mySource.[CE_Individual2_Work_At_Home_Flag]
	, mySource.[CE_Individual2_YYYYMMDD_Of_Birth]
	, mySource.[CE_Individual3_Age]
	, mySource.[CE_Individual3_Gender]
	, mySource.[CE_Individual3_Given_Name]
	, mySource.[CE_Individual3_Has_Finance_Card]
	, mySource.[CE_Individual3_Has_Misc_Credit_C]
	, mySource.[CE_Individual3_Has_Oil_Company_C]
	, mySource.[CE_Individual3_Has_Premium_Bank]
	, mySource.[CE_Individual3_Has_Retail_Store]
	, mySource.[CE_Individual3_Has_Specialty_Sto]
	, mySource.[CE_Individual3_Has_Upscale_Retai]
	, mySource.[CE_Individual3_Head_of_Household]
	, mySource.[CE_Individual3_Individual_ID]
	, mySource.[CE_Individual3_Marital_Stat_Code]
	, mySource.[CE_Individual3_Marriage_Date]
	, mySource.[CE_Individual3_Middle_Initial]
	, mySource.[CE_Individual3_Parent_Flag]
	, mySource.[CE_Individual3_Political_Affilia]
	, mySource.[CE_Individual3_Spouse_Flag]
	, mySource.[CE_Individual3_Surname]
	, mySource.[CE_Individual3_Surname_Suffix]
	, mySource.[CE_Individual3_Title_Code]
	, mySource.[CE_Individual3_Vendor_Country_Or]
	, mySource.[CE_Individual3_Vendor_Ethnic_Gro]
	, mySource.[CE_Individual3_Vendor_Ethnicity]
	, mySource.[CE_Individual3_Vendor_Religion_C]
	, mySource.[CE_Individual3_Vendor_Spoken_Lan]
	, mySource.[CE_Individual3_Work_At_Home_Flag]
	, mySource.[CE_Individual3_YYYYMMDD_Of_Birth]
	, mySource.[CE_Individual_HoH_Age]
	, mySource.[CE_Individual_HoH_Gender]
	, mySource.[CE_Individual_HoH_Given_Name]
	, mySource.[CE_Individual_HoH_Has_Finance_Ca]
	, mySource.[CE_Individual_HoH_Has_Misc_Credi]
	, mySource.[CE_Individual_HoH_Has_Oil_Compan]
	, mySource.[CE_Individual_HoH_Has_Premium_Ba]
	, mySource.[CE_Individual_HoH_Has_Retail_Sto]
	, mySource.[CE_Individual_HoH_Has_Specialty]
	, mySource.[CE_Individual_HoH_Has_Upscale_Re]
	, mySource.[CE_Individual_HoH_Head_of_Househ]
	, mySource.[CE_Individual_HoH_Individual_ID]
	, mySource.[CE_Individual_HoH_Marital_Status]
	, mySource.[CE_Individual_HoH_Marriage_Date]
	, mySource.[CE_Individual_HoH_Middle_Initial]
	, mySource.[CE_Individual_HoH_Mobile_Age_Fla]
	, mySource.[CE_Individual_HoH_Mortgage_Link]
	, mySource.[CE_Individual_HoH_Parent_Flag]
	, mySource.[CE_Individual_HoH_Political_Affi]
	, mySource.[CE_Individual_HoH_Spouse_Flag]
	, mySource.[CE_Individual_HoH_Surname]
	, mySource.[CE_Individual_HoH_Surname_Suffix]
	, mySource.[CE_Individual_HoH_Title_Code]
	, mySource.[CE_Individual_HoH_Vendor_Country]
	, mySource.[CE_Individual_HoH_Vendor_Ethnic]
	, mySource.[CE_Individual_HoH_Vendor_Ethnici]
	, mySource.[CE_Individual_HoH_Vendor_Religio]
	, mySource.[CE_Individual_HoH_Vendor_Spoken]
	, mySource.[CE_Individual_HoH_Work_At_Home_F]
	, mySource.[CE_Individual_HoH_YYYYMMDD_Of_Bi]
	, mySource.[CE_InfoPersona_Cluster]
	, mySource.[CE_InfoPersona_SuperCluster]
	, mySource.[CE_Interest_Rate_Source]
	, mySource.[CE_Intl_Long_Distance_Model]
	, mySource.[CE_Invest_Not_Stocks_Bonds_Flag]
	, mySource.[CE_LHI_Household_Apparel_Accesso]
	, mySource.[CE_LHI_Household_Apparel_General]
	, mySource.[CE_LHI_Household_Apparel_Kids]
	, mySource.[CE_LHI_Household_Apparel_Mens]
	, mySource.[CE_LHI_Household_Apparel_Mens_Fa]
	, mySource.[CE_LHI_Household_Apparel_Wo_0001]
	, mySource.[CE_LHI_Household_Apparel_Womens]
	, mySource.[CE_LHI_Household_Auto_Racing]
	, mySource.[CE_LHI_Household_Auto_Trucks]
	, mySource.[CE_LHI_Household_Automotive]
	, mySource.[CE_LHI_Household_Aviation]
	, mySource.[CE_LHI_Household_Bargain_Seekers]
	, mySource.[CE_LHI_Household_Beauty_Cosmetic]
	, mySource.[CE_LHI_Household_Bible]
	, mySource.[CE_LHI_Household_Birds]
	, mySource.[CE_LHI_Household_Business_Home_O]
	, mySource.[CE_LHI_Household_Business_Items]
	, mySource.[CE_LHI_Household_Catalogs]
	, mySource.[CE_LHI_Household_Charitable_Dono]
	, mySource.[CE_LHI_Household_Collectibles]
	, mySource.[CE_LHI_Household_Collectibles_St]
	, mySource.[CE_LHI_Household_College]
	, mySource.[CE_LHI_Household_Computers]
	, mySource.[CE_LHI_Household_Cooking]
	, mySource.[CE_LHI_Household_Cooking_Gourmet]
	, mySource.[CE_LHI_Household_Crafts_Crocheti]
	, mySource.[CE_LHI_Household_Crafts_General]
	, mySource.[CE_LHI_Household_Crafts_Knitting]
	, mySource.[CE_LHI_Household_Crafts_Needlepo]
	, mySource.[CE_LHI_Household_Crafts_Quilting]
	, mySource.[CE_LHI_Household_Crafts_Sewing]
	, mySource.[CE_LHI_Household_Culture_Arts]
	, mySource.[CE_LHI_Household_Current_Events]
	, mySource.[CE_LHI_Household_Do_It_Yourselfe]
	, mySource.[CE_LHI_Household_Ego_Personalize]
	, mySource.[CE_LHI_Household_Electronics]
	, mySource.[CE_LHI_Household_Equestrian]
	, mySource.[CE_LHI_Household_Ethnic_Pro_0001]
	, mySource.[CE_LHI_Household_Ethnic_Pro_0002]
	, mySource.[CE_LHI_Household_Ethnic_Product]
	, mySource.[CE_LHI_Household_Family]
	, mySource.[CE_LHI_Household_Finance_Credit]
	, mySource.[CE_LHI_Household_Finance_Money_M]
	, mySource.[CE_LHI_Household_Finance_Persona]
	, mySource.[CE_LHI_Household_Finance_Stocks]
	, mySource.[CE_LHI_Household_Gambling]
	, mySource.[CE_LHI_Household_Games]
	, mySource.[CE_LHI_Household_Gardening]
	, mySource.[CE_LHI_Household_Gift_Giver]
	, mySource.[CE_LHI_Household_Health_Dieting]
	, mySource.[CE_LHI_Household_Health_Fitness]
	, mySource.[CE_LHI_Household_Health_General]
	, mySource.[CE_LHI_Household_High_Ticket]
	, mySource.[CE_LHI_Household_Hightech]
	, mySource.[CE_LHI_Household_History]
	, mySource.[CE_LHI_Household_History_America]
	, mySource.[CE_LHI_Household_Hobbies]
	, mySource.[CE_LHI_Household_Home_Decorating]
	, mySource.[CE_LHI_Household_Humor]
	, mySource.[CE_LHI_Household_Inspirational]
	, mySource.[CE_LHI_Household_Internet]
	, mySource.[CE_LHI_Household_Internet_Access]
	, mySource.[CE_LHI_Household_Internet_Buying]
	, mySource.[CE_LHI_Household_Motorcycles]
	, mySource.[CE_LHI_Household_Music]
	, mySource.[CE_LHI_Household_Ocean]
	, mySource.[CE_LHI_Household_Outdoors]
	, mySource.[CE_LHI_Household_Outdoors_Boatin]
	, mySource.[CE_LHI_Household_Outdoors_Campin]
	, mySource.[CE_LHI_Household_Outdoors_Fishin]
	, mySource.[CE_LHI_Household_Outdoors_H_0001]
	, mySource.[CE_LHI_Household_Outdoors_Huntin]
	, mySource.[CE_LHI_Household_Pets]
	, mySource.[CE_LHI_Household_Pets_Cats]
	, mySource.[CE_LHI_Household_Pets_Dogs]
	, mySource.[CE_LHI_Household_Photo_Photograp]
	, mySource.[CE_LHI_Household_Photo_Photoproc]
	, mySource.[CE_LHI_Household_Politically_Con]
	, mySource.[CE_LHI_Household_Politically_Lib]
	, mySource.[CE_LHI_Household_Publish_Books]
	, mySource.[CE_LHI_Household_Publish_Fiction]
	, mySource.[CE_LHI_Household_Publish_Magazin]
	, mySource.[CE_LHI_Household_Publish_Nonfict]
	, mySource.[CE_LHI_Household_Publish_Publica]
	, mySource.[CE_LHI_Household_Publish_Science]
	, mySource.[CE_LHI_Household_Rural_Farming]
	, mySource.[CE_LHI_Household_Science]
	, mySource.[CE_LHI_Household_Seniors]
	, mySource.[CE_LHI_Household_Sports_Baseball]
	, mySource.[CE_LHI_Household_Sports_Basketba]
	, mySource.[CE_LHI_Household_Sports_Football]
	, mySource.[CE_LHI_Household_Sports_General]
	, mySource.[CE_LHI_Household_Sports_Golf]
	, mySource.[CE_LHI_Household_Sports_Hockey]
	, mySource.[CE_LHI_Household_Sports_Skiing]
	, mySource.[CE_LHI_Household_Sports_Soccer]
	, mySource.[CE_LHI_Household_Sports_Tennis]
	, mySource.[CE_LHI_Household_Stationery]
	, mySource.[CE_LHI_Household_Sweepstakes]
	, mySource.[CE_LHI_Household_TV_Movies]
	, mySource.[CE_LHI_Household_Technology_VCR]
	, mySource.[CE_LHI_Household_Tobacco]
	, mySource.[CE_LHI_Household_Travel_Cruises]
	, mySource.[CE_LHI_Household_Travel_Foreign]
	, mySource.[CE_LHI_Household_Travel_General]
	, mySource.[CE_LHI_Household_Travel_RV]
	, mySource.[CE_LHI_Household_Travel_US]
	, mySource.[CE_LHI_Household_Wildlife]
	, mySource.[CE_LHI_Individual_HoH_Apparel_Ge]
	, mySource.[CE_Leaning_Conservative_Model]
	, mySource.[CE_Leaning_Liberal_Model]
	, mySource.[CE_Length_of_Residence_Years]
	, mySource.[CE_Liberal_Model]
	, mySource.[CE_Life_Insurance_Model]
	, mySource.[CE_Live_Theater_Model]
	, mySource.[CE_Loan_Amount]
	, mySource.[CE_Loan_Amount_Source]
	, mySource.[CE_Loan_Type]
	, mySource.[CE_Loan_to_Value_Ratio_Range_Cod]
	, mySource.[CE_Location_ID]
	, mySource.[CE_Location_Type]
	, mySource.[CE_Lot_Size]
	, mySource.[CE_Low_End_Sporting_Equip_Model]
	, mySource.[CE_Low_Risk_Investor_Model]
	, mySource.[CE_Luxury_Car_Buyer_Model]
	, mySource.[CE_Luxury_Hotel_Model]
	, mySource.[CE_Magazine_Subscriber_Flag]
	, mySource.[CE_Mail_Order_Buyer_Current_Flag]
	, mySource.[CE_Mail_Order_Buyer_Ever_Flag]
	, mySource.[CE_Mail_Order_Software_Purchase]
	, mySource.[CE_Mail_Responsive_Current_Flag]
	, mySource.[CE_Mail_Responsive_Ever_Flag]
	, mySource.[CE_Mail_Responsive_Previous_Flag]
	, mySource.[CE_Major_Home_Remodeling_Model]
	, mySource.[CE_Male_Occupation_Code]
	, mySource.[CE_Marketing_HH_1_To_2_People]
	, mySource.[CE_Marketing_HH_3_Plus_People]
	, mySource.[CE_Marketing_Target_Age_0_To_11]
	, mySource.[CE_Marketing_Target_Age_0_To_17]
	, mySource.[CE_Marketing_Target_Age_0_To_5]
	, mySource.[CE_Marketing_Target_Age_12_To_17]
	, mySource.[CE_Marketing_Target_Age_6_To_11]
	, mySource.[CE_Marketing_Target_Age_Over_50]
	, mySource.[CE_Marketing_Target_Age_Over_65]
	, mySource.[CE_Marketing_Target_Females_0001]
	, mySource.[CE_Marketing_Target_Females_0002]
	, mySource.[CE_Marketing_Target_Females_0003]
	, mySource.[CE_Marketing_Target_Females_0004]
	, mySource.[CE_Marketing_Target_Females_0005]
	, mySource.[CE_Marketing_Target_Females_0006]
	, mySource.[CE_Marketing_Target_Females_0007]
	, mySource.[CE_Marketing_Target_Females_0008]
	, mySource.[CE_Marketing_Target_Females_Age]
	, mySource.[CE_Marketing_Target_Males_A_0001]
	, mySource.[CE_Marketing_Target_Males_A_0002]
	, mySource.[CE_Marketing_Target_Males_Age_12]
	, mySource.[CE_Marketing_Target_Males_Age_18]
	, mySource.[CE_Marketing_Target_Males_Age_25]
	, mySource.[CE_Marketing_Target_Males_Age_35]
	, mySource.[CE_Marketing_Target_Males_Age_45]
	, mySource.[CE_Marketing_Target_Males_Age_55]
	, mySource.[CE_Member_Count]
	, mySource.[CE_Migraines_Flag]
	, mySource.[CE_Minivan_Buyer_Model]
	, mySource.[CE_Mobile_Internet_Access_Model]
	, mySource.[CE_Moderate_Economy_Hotel_Model]
	, mySource.[CE_Mortgage_Amount_Source_Code]
	, mySource.[CE_Mortgage_Type_Source_Code]
	, mySource.[CE_Move_Out_Flag]
	, mySource.[CE_Multi_Unit_Flag]
	, mySource.[CE_Music_Concert_Classical_Model]
	, mySource.[CE_Music_Concert_Country_Model]
	, mySource.[CE_Music_Concert_Rock_Model]
	, mySource.[CE_Nascar_Model]
	, mySource.[CE_New_Vehicle_Buyer_Model]
	, mySource.[CE_Non_Religious_Donor_Model]
	, mySource.[CE_Number_Adult_Females]
	, mySource.[CE_Number_Adult_Males]
	, mySource.[CE_Number_Adults]
	, mySource.[CE_Number_Bathrooms]
	, mySource.[CE_Number_Bedrooms]
	, mySource.[CE_Number_Children]
	, mySource.[CE_Occupancy_Count]
	, mySource.[CE_Online_Bill_Payment_Model]
	, mySource.[CE_Online_Gaming_Model]
	, mySource.[CE_Online_Invest_Trading_Model]
	, mySource.[CE_Online_Music_Download_Model]
	, mySource.[CE_Online_Purchase_Bus_Model]
	, mySource.[CE_Online_Purchase_Personl_Model]
	, mySource.[CE_Online_TV_Download_Model]
	, mySource.[CE_Online_Travel_Plan_Model]
	, mySource.[CE_Opinion_Leader_Model]
	, mySource.[CE_Opportunist_Flag]
	, mySource.[CE_Organic_Food_Model]
	, mySource.[CE_Osteoporosis_Flag]
	, mySource.[CE_Outdoor_Activities_Model]
	, mySource.[CE_Outdoor_Enthusiast_Flag]
	, mySource.[CE_Own_Rent_Likelihood_Code]
	, mySource.[CE_Pensioner_Present_Flag]
	, mySource.[CE_Pet_Owner_Flag]
	, mySource.[CE_Photography_Enthusiast_Flag]
	, mySource.[CE_Physical_Fitness_Club_Model]
	, mySource.[CE_Physical_Handicap_Flag]
	, mySource.[CE_Pilates_Yoga_Model]
	, mySource.[CE_Political_Contributor_Flag]
	, mySource.[CE_Postal_County_Code]
	, mySource.[CE_Postal_State_Code]
	, mySource.[CE_Potential_Investor_Consumer_S]
	, mySource.[CE_Power_Boating_Model]
	, mySource.[CE_Presence_Age_0_To_3_Flag]
	, mySource.[CE_Presence_Age_13_To_17_Flag]
	, mySource.[CE_Presence_Age_4_To_7_Flag]
	, mySource.[CE_Presence_Age_8_To_12_Flag]
	, mySource.[CE_Primary_Family_Flag]
	, mySource.[CE_Pro_Tax_Preparation_Model]
	, mySource.[CE_Professional_Baseball_Model]
	, mySource.[CE_Professional_Basketball_Model]
	, mySource.[CE_Professional_Football_Model]
	, mySource.[CE_Professional_Wrestling_Model]
	, mySource.[CE_Property_Type]
	, mySource.[CE_Purchasing_Power_Income_Code]
	, mySource.[CE_Purchasing_Power_Income_Detec]
	, mySource.[CE_Real_Estate_Investment_Model]
	, mySource.[CE_Recency_Date_Formatted]
	, mySource.[CE_Reference_Qualified_Indicator]
	, mySource.[CE_Religious_Contributor_Flag]
	, mySource.[CE_Religious_Donor_Model]
	, mySource.[CE_Rental_Car_Model]
	, mySource.[CE_Revolver_Minimum_Payment_Mode]
	, mySource.[CE_Rooms]
	, mySource.[CE_SUV_Buyer_Model]
	, mySource.[CE_Safety_Security_Conscious_Mod]
	, mySource.[CE_Salt_Water_Fishing_Model]
	, mySource.[CE_Satellite_TV_Model]
	, mySource.[CE_Second_Property_Indicator_Fla]
	, mySource.[CE_Selected_Age]
	, mySource.[CE_Selected_Gender]
	, mySource.[CE_Selected_Given_Name]
	, mySource.[CE_Selected_Ind_YYYYMMDD_Birth]
	, mySource.[CE_Selected_Individual_Active_Ba]
	, mySource.[CE_Selected_Individual_Bank_Card]
	, mySource.[CE_Selected_Individual_Formatted]
	, mySource.[CE_Selected_Individual_Grandpare]
	, mySource.[CE_Selected_Individual_Has_Finan]
	, mySource.[CE_Selected_Individual_Has_Misc]
	, mySource.[CE_Selected_Individual_Has_Oil_C]
	, mySource.[CE_Selected_Individual_Has_Premi]
	, mySource.[CE_Selected_Individual_Has_Retai]
	, mySource.[CE_Selected_Individual_Has_Speci]
	, mySource.[CE_Selected_Individual_Has_Upsca]
	, mySource.[CE_Selected_Individual_Head_of_H]
	, mySource.[CE_Selected_Individual_Marital_S]
	, mySource.[CE_Selected_Individual_Parent_Fl]
	, mySource.[CE_Selected_Individual_Political]
	, mySource.[CE_Selected_Individual_Spouse_Fl]
	, mySource.[CE_Selected_Individual_Vend_0001]
	, mySource.[CE_Selected_Individual_Vendor_Co]
	, mySource.[CE_Selected_Individual_Vendor_Et]
	, mySource.[CE_Selected_Individual_Vendor_Re]
	, mySource.[CE_Selected_Individual_Vendor_Sp]
	, mySource.[CE_Selected_Individual_Work_At_H]
	, mySource.[CE_Selected_Middle_Initial]
	, mySource.[CE_Selected_Surname]
	, mySource.[CE_Selected_Surname_Suffix]
	, mySource.[CE_Shopaholics_Model]
	, mySource.[CE_Small_Business_Insur_Model]
	, mySource.[CE_Soccer_Model]
	, mySource.[CE_Social_Media_Network_Model]
	, mySource.[CE_Speclty_Org_Food_Store_Model]
	, mySource.[CE_Sports_Fanatics_Model]
	, mySource.[CE_Stamps_Coins_Collector_Flag]
	, mySource.[CE_Stocks_Bonds_Investments_Flag]
	, mySource.[CE_Surnames_In_Household]
	, mySource.[CE_Tennis_Model]
	, mySource.[CE_Timeshare_Owner_Model]
	, mySource.[CE_VCR_Ownership_Flag]
	, mySource.[CE_Veteran_Present_Flag]
	, mySource.[CE_Voice_Over_Internet_Model]
	, mySource.[CE_Wealthfinder_Code]
	, mySource.[CE_Wholesale_Club_Model]
	, mySource.[CE_Wifi_In_Home_Model]
	, mySource.[CE_Wifi_Outside_Of_Home_Model]
	, mySource.[CE_Wine_Lover_Model]
	, mySource.[CE_Work_Health_Insurance_Model]
	, mySource.[CE_Year_Home_Built]
	, mySource.[ER_ABI_NUMBER]
	, mySource.[ER_BUS_ADDRESS]
	, mySource.[ER_BUS_CITY]
	, mySource.[ER_BUS_COUNTY_CODE]
	, mySource.[ER_BUS_STATE]
	, mySource.[ER_BUS_TELEPHONE]
	, mySource.[ER_BUS_ZIP_CODE]
	, mySource.[ER_BUS_ZIP_FOUR]
	, mySource.[ER_COMPANY_NAME]
	, mySource.[ER_EMPLOYEE_CODE]
	, mySource.[ER_INDIVIDUAL_NAME]
	, mySource.[ER_SALES_VOLUME]
	, mySource.[ER_SIC]
	, mySource.[ER_SIC_DESCRIPTION]
	, mySource.[ER_TITLE_CODE]
	, mySource.[ER_TITLE_DESCRIPTION]
	, mySource.[EE_Email_Address]
	, mySource.[Email_Verify_Flag]
	)
;
	

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END







GO
