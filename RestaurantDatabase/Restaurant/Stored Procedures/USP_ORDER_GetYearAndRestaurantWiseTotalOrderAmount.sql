
CREATE PROCEDURE Restaurant.USP_ORDER_GetYearAndRestaurantWiseTotalOrderAmount
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	SELECT  YEAR(ODR.OrderDate) 'Year', RS.RestaurantName, SUM(ODR.OrderAmount) 'Total Order Amount' FROM Restaurant.[Order] AS ODR
	INNER JOIN Restaurant.Restaurant AS RS
	ON ODR.RestaurantID =RS.RestaurantID
	GROUP BY  YEAR(ODR.OrderDate), ODR.RestaurantID,RS.RestaurantName
	ORDER BY YEAR(ODR.OrderDate) ASC

END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;

