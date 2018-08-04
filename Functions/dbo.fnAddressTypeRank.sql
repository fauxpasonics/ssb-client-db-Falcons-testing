SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create  FUNCTION [dbo].[fnAddressTypeRank]()

RETURNS @Result TABLE 
(  
	AddressType	VARCHAR(25),
    PriorityRank INT
) 
AS
BEGIN

	INSERT INTO @Result (AddressType, PriorityRank)
	VALUES ('P', 1)

	INSERT INTO @Result (AddressType, PriorityRank)
	VALUES ('H', 2)

	INSERT INTO @Result (AddressType, PriorityRank)
	VALUES ('B', 3)

	INSERT INTO @Result (AddressType, PriorityRank)
	VALUES ('O', 4)


	RETURN

END



GO
