
CREATE PROCEDURE [Restaurant].[USP_Order_CRUDOperations]
(
	@OrderID INT,
	@OrderDate DATETIME,
	@RestaurantID INT,
	@MenuItemID INT,
	@ItemQuantity INT,
	@DiningTableID INT,
	@ActionType NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
		
				IF ( @ItemQuantity>0 AND @OrderDate=Convert(datetime, convert(varchar(10), getdate(),120)))
				BEGIN;
					IF EXISTS(SELECT 1 FROM Restaurant.DiningTableTrack WHERE DiningTableID = @DiningTableID AND TableStatus='Vacant')
					BEGIN;
							INSERT INTO Restaurant.[Order] 
													(OrderDate,
													RestaurantID,
													MenuItemID,
													ItemQuantity,
													OrderAmount,
													DiningTableID)
											VALUES (@OrderDate,
													@RestaurantID,
													@MenuItemID,
													@ItemQuantity,
													Restaurant.FN_GetOrderAmount(@MenuItemID,@ItemQuantity),
													@DiningTableID);

							---------Update dining table status as occupied------------
							UPDATE Restaurant.DiningTableTrack SET  TableStatus='Occupied' WHERE DiningTableID = @DiningTableID;
							
							PRINT 'Record Inserted Successfully';
					END;
					ELSE
					BEGIN;
						PRINT 'Dining Table is Already Occupied, Try Different Dining Table ID';
					END;
				END;
				ELSE
				BEGIN; 
					RAISERROR('INVALID ITEM QTY. OR ORDER DATE',1,1);
				END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID)
			BEGIN;
				IF ( @ItemQuantity>0 AND @OrderDate=Convert(datetime, convert(varchar(10), getdate(),120)))
				BEGIN;
					IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE OrderID = @OrderID)
					BEGIN;
						UPDATE Restaurant.DiningTableTrack SET  TableStatus='Vacant' WHERE DiningTableID = (SELECT DiningTableID FROM Restaurant.[Order] WHERE OrderID = @OrderID);
						IF EXISTS(SELECT 1 FROM Restaurant.DiningTableTrack WHERE DiningTableID = @DiningTableID AND TableStatus='Vacant')
						BEGIN;
							UPDATE Restaurant.[Order] 
								SET 
								OrderDate = @OrderDate,
								RestaurantID=@RestaurantID,
								MenuItemID=@MenuItemID,
								ItemQuantity=@ItemQuantity,
								OrderAmount=Restaurant.FN_GetOrderAmount(@MenuItemID,@ItemQuantity)
								--DiningTableID=@DiningTableID
							WHERE OrderID = @OrderID;
							PRINT 'Record Updated Successfully';

							UPDATE Restaurant.DiningTableTrack SET  TableStatus='Occupied' WHERE DiningTableID = @DiningTableID;
						END;
						ELSE
						BEGIN;
							PRINT 'Dining Table is Already Occupied, Try Different Dining Table ID';
						END;
					END;
					ELSE
					BEGIN;
						PRINT 'Can not Update Order once Bill is Generated';
					END;
				END;
				ELSE
				BEGIN;
					RAISERROR('INVALID ITEM QTY. OR ORDER DATE',1,1);
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Order Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID)
				BEGIN;
					IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE OrderID = @OrderID)
					BEGIN;
						DELETE FROM Restaurant.[Order]
								WHERE  OrderID = @OrderID;
						PRINT 'Record Deleted Successfully';

						UPDATE Restaurant.DiningTableTrack SET  TableStatus='Vacant' WHERE DiningTableID = @DiningTableID;

					END;
					ELSE
					BEGIN;
						PRINT 'Can not delete Order once Bill is Generated';
					END;
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Order Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID)
				BEGIN;
						SELECT * FROM Restaurant.[Order]
								WHERE OrderID = @OrderID;
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

SET NOCOUNT OFF;

END;