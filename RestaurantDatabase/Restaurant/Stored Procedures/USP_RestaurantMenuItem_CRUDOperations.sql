
CREATE PROCEDURE Restaurant.USP_RestaurantMenuItem_CRUDOperations
(
	@MenuItemID INT,
	@CuisineID INT,
	@ItemName	NVARCHAR(100),
	@ItemPrice  FLOAT,
	@ActionType NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE ItemName = @ItemName)
			BEGIN;
				IF @ItemPrice>0
				BEGIN;
					INSERT INTO Restaurant.RestaurantMenuItem 
													(CuisineID,
													ItemName,
													ItemPrice)
											VALUES (@CuisineID,
													@ItemName,
													@ItemPrice);
					PRINT 'Record Inserted Successfully';
				END;
				ELSE
				BEGIN;
					RAISERROR('ITEM PRICE MUST BE GREATER THAN ZERO',1,1);
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'MENU ITEM NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE MenuItemID = @MenuItemID)
			BEGIN;
				IF @ItemPrice>0
				BEGIN;
					UPDATE Restaurant.RestaurantMenuItem 
							SET CuisineID = @CuisineID,
								ItemName = @ItemName,
								ItemPrice=@ItemPrice
							WHERE MenuItemID = @MenuItemID;
					PRINT 'Record Updated Successfully';
					END;
				ELSE
				BEGIN;
					RAISERROR('ITEM PRICE MUST BE GREATER THAN ZERO',1,1);
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Menu Item Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE MenuItemID = @MenuItemID)
				BEGIN
						DELETE FROM Restaurant.RestaurantMenuItem
								WHERE  MenuItemID = @MenuItemID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Menu Item Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE MenuItemID = @MenuItemID)
				BEGIN;
						SELECT * FROM Restaurant.RestaurantMenuItem
								WHERE MenuItemID = @MenuItemID;
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