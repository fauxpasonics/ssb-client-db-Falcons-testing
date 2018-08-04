SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [rpt].[vw_FactInventory_Resold] AS


(select 

fta.SoldDimCustomerId,

dmss.seasonname,

de.eventname,

dms.sectionname, dms.rowname, dms.seat, 1 as Total_Seats,

fta.TotalRevenue as Orig_TotalRevenue ,fta.TicketRevenue as Orig_TicketRevenue,
fta.PcTicketValue as Orig_PcTicketValue, fta.FullPrice as Orig_FullPrice,
fta.EventDateTime,

fta.PostedSeatValue,

fta.IsAttended,fta.ScanDateTime,fta.ScanGate,

fta.ResoldDimCustomerId,fta.ResoldPurchasePrice,fta.ResoldFees,
fta.ResoldTotalAmount,

dmc.AccountId as Buyer_AccountId,

dmc.CustomerStatus as Buyer_CustomerStatus,
dmc.FirstName as Buyer_FirstName,dmc.MiddleName as Buyer_Middlename,dmc.LastName as Buyer_Lastname,

dmc.AddressPrimaryStreet as Buyer_Address,
dmc.AddressPrimaryCity as Buyer_City,dmc.AddressPrimaryState as Buyer_State,dmc.AddressPrimaryZip as Buyer_Zip,
dmc.PhonePrimary as Buyer_PrimaryPhone, dmc.PhoneHome as Buyer_HomePhone,
dmc.PhoneCell as Buyer_Cell,dmc.EmailPrimary as Buyer_Email,

dmcs.AccountId as Seller_AccountId,

dmcs.CustomerStatus as Seller_CustomerStatus,
dmcs.FirstName as Seller_FirstName,dmcs.MiddleName as Seller_Middlename,dmcs.LastName as Seller_Lastname,

dmcs.AddressPrimaryStreet as Seller_Address,
dmcs.AddressPrimaryCity as Seller_City,dmcs.AddressPrimaryState as Seller_State,dmcs.AddressPrimaryZip as Seller_Zip,
dmcs.PhonePrimary as Seller_PrimaryPhone, dmcs.PhoneHome as Seller_HomePhone,
dmcs.PhoneCell as Seller_Cell,dmcs.EmailPrimary as Seller_Email

from rpt.vw_FactInventory_All fta
inner join rpt.vw_dimcustomer dmc on dmc.dimcustomerid = fta.resoldDimcustomerid
inner join rpt.vw_dimseat dms on dms.dimseatid = fta.dimseatid
inner join rpt.vw_dimseason dmss on dmss.dimseasonid = fta.dimseasonid
inner join rpt.vw_dimevent de on de.dimeventid = fta.dimeventid
INNER JOIN rpt.vw_DimCustomer dmcs ON fta.SoldDimCustomerId = dmcs.DimCustomerId

) 








GO
