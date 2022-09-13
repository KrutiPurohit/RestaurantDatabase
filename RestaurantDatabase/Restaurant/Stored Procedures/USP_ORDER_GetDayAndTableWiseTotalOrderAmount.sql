
CREATE PROCEDURE Restaurant.USP_ORDER_GetDayAndTableWiseTotalOrderAmount
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	SELECT CONVERT(VARCHAR,[Order].OrderDate,5) 'Order Date', [Order].DiningTableID, SUM(OrderAmount) 'Total Order Amount' FROM Restaurant.[Order]
	GROUP BY [Order].OrderDate, [Order].DiningTableID
	ORDER BY [Order].OrderDate ASC

END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;