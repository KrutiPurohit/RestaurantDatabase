
CREATE FUNCTION [Restaurant].[FN_GetOrderAmount] (@MenuItemID INT,@ItemQuantity INT)
RETURNS FLOAT
AS
BEGIN;
RETURN ((SELECT ItemPrice  FROM Restaurant.RestaurantMenuItem WHERE MenuItemID=@MenuItemID)* @ItemQuantity);
END;