
CREATE PROCEDURE [Restaurant].[USP_Bills_CRUDOperations]
(
	@BillsID INT,
	@OrderID INT,
	@CustomerID INT,
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;


DECLARE @BillAmount FLOAT;
DECLARE @RestaurantID INT;
DECLARE @DiningTableID INT;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
					IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID) AND EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					BEGIN;
							SELECT @BillAmount=sum(OrderAmount),@DiningTableID=DiningTableID,@RestaurantID=RestaurantID FROM Restaurant.TVFN_GetOrderDetails(@OrderID) GROUP BY OrderID,DiningTableID,RestaurantID;
				
							INSERT INTO Restaurant.Bills
												   (OrderID,
													RestaurantID,
													BillsAmount,
													CustomerID)
											VALUES (@OrderID,
													@RestaurantID,
													@BillAmount,
													@CustomerID);
							PRINT 'Record Inserted Successfully';
						UPDATE Restaurant.DiningTableTrack SET  TableStatus='Vacant' WHERE DiningTableID = @DiningTableID;
					END;
					ELSE
					BEGIN;
						  RAISERROR('INVALID ORDER ID or CUSTOMER ID',1,1);
					END;
		
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
			BEGIN
					IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID) AND EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					 BEGIN;
							SELECT @BillAmount=sum(OrderAmount),@DiningTableID=DiningTableID FROM Restaurant.TVFN_GetOrderDetails(@OrderID) GROUP BY OrderID,DiningTableID;
				
							UPDATE  Restaurant.Bills
								SET OrderID=@OrderID,
								RestaurantID=@RestaurantID,
								BillsAmount=@BillAmount,
								CustomerID=@CustomerID	
							WHERE BillsID = @BillsID;
							PRINT 'Record Updated Successfully';
					END;
					ELSE
					BEGIN;
						  RAISERROR('INVALID ORDER ID or CUSTOMER ID',1,1);
					END;
			END;
			ELSE
			BEGIN;
					PRINT  'Can Not Update,No Bill Found With This ID';
			END;
		
		END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
				BEGIN
						DELETE FROM Restaurant.Bills 
								WHERE BillsID = @BillsID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Bills Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
				BEGIN
						SELECT * FROM Restaurant.Bills 
								WHERE BillsID = @BillsID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;



END;