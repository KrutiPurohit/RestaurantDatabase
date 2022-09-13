
CREATE PROCEDURE [Restaurant].[USP_Dynamic_GetAllCustomerOrderDetails]
(
 @FilterBy  NVARCHAR(100),
 @OrderBy  NVARCHAR(100)
 )
 AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	DECLARE @SqlQry AS NVARCHAR(MAX);

	

	SET @SqlQry=N'SELECT CS.CustomerName,ODR.OrderDate ''Order Date'', RS.RestaurantName, DT.Location ''Dining Table'',ODR.OrderAmount
				FROM Restaurant.Bills AS BL
				INNER JOIN Restaurant.[Order] AS ODR
				ON BL.OrderID=ODR.OrderID
				INNER JOIN Restaurant.Customer AS CS
				ON BL.CustomerID=CS.CustomerID
				INNER JOIN Restaurant.DiningTable AS DT
				ON ODR.DiningTableID = DT.DiningTableID
				INNER JOIN Restaurant.Restaurant AS RS
				ON BL.RestaurantID=RS.RestaurantID';

	IF LEN(@FilterBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N'  WHERE '+@FilterBy;
	END;
	IF LEN(@OrderBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N'  ORDER BY '+@OrderBy;
	END;

EXEC(@SqlQry);

END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;