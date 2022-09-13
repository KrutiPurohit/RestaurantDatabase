/*
  Table-Valued Funciton to get order details
*/
CREATE FUNCTION Restaurant.TVFN_GetOrderDetails(@OrderID INT)
RETURNS @OrderDetailTable TABLE 
( 
	OrderID INT,
	RestaurantID INT,
	OrderAmount FLOAT,
	DiningTableID INT
  )
WITH SCHEMABINDING
AS
BEGIN
		INSERT INTO @OrderDetailTable
		SELECT OrderID,RestaurantID,OrderAmount,DiningTableID FROM Restaurant.[Order]
								WHERE OrderID = @OrderID;
	RETURN;
END;
