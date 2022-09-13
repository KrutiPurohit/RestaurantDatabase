
CREATE PROCEDURE [Restaurant].[USP_Cuisine_CRUDOperations]
(
	@CuisineID INT,
	@RestaurantID INT,
	@CuisineName	NVARCHAR(50),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;


BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineName = @CuisineName)
			BEGIN;
				
					INSERT INTO Restaurant.Cuisine (RestaurantID,
													CuisineName)
											VALUES (@RestaurantID,
													@CuisineName);
					PRINT 'Record Inserted Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'CUISINE NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
			BEGIN;
					UPDATE Restaurant.Cuisine 
						SET RestaurantID=@RestaurantID,
							CuisineName = @CuisineName	 
						WHERE CuisineID = @CuisineID;
					PRINT 'Record Updated Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Cuisine Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
				BEGIN
						DELETE FROM Restaurant.Cuisine 
								WHERE CuisineID = @CuisineID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Cuisine Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
				BEGIN;
						SELECT * FROM Restaurant.Cuisine 
								WHERE CuisineID = @CuisineID;
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