
CREATE PROCEDURE Restaurant.USP_DiningTable_CRUDOperations
(
	@DiningTableID INT,
	@RestaurantID INT,
	@Location	NVARCHAR(100),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE [Location] = @Location)
			BEGIN;
				
					INSERT INTO Restaurant.DiningTable (RestaurantID,
													Location)
											VALUES (@RestaurantID,
													@Location);
					PRINT 'Record Inserted Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'DINING TABLE NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
			BEGIN;
					UPDATE Restaurant.DiningTable 
						SET RestaurantID=@RestaurantID,
							Location = @Location	 
						WHERE DiningTableID = @DiningTableID;
					PRINT 'Record Updated Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Dining Table Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN
						DELETE FROM Restaurant.DiningTable 
								WHERE DiningTableID = @DiningTableID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Dining Table Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN;
						SELECT * FROM Restaurant.DiningTable 
								WHERE DiningTableID = @DiningTableID;
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