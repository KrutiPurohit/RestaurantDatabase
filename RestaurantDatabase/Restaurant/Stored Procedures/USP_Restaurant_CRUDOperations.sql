

CREATE PROCEDURE [Restaurant].[USP_Restaurant_CRUDOperations]
(
 @RestaurantID INT,	
 @RestaurantName	NVARCHAR(200),
 @Address	NVARCHAR(500) ,
 @MobileNo	NVARCHAR(10) ,
 @ActionType NVARCHAR(6)
)
AS
BEGIN;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantName = @RestaurantName)
			BEGIN;
				IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND LEN(@Address)>10 AND ISNUMERIC(LEFT(@Address, 1)) = 1)
				BEGIN;
					INSERT INTO Restaurant.Restaurant (RestaurantName,Address,MobileNo)
											VALUES (@RestaurantName,@Address,@MobileNo);
					PRINT 'Record Inserted Successfully';
				END;
				ELSE
				BEGIN;
					RAISERROR ( 'EITHER MOBILE NUMBER OR ADDRESS IS INVALID',1,1); 
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'RESTAURANT NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
			BEGIN;
				IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND LEN(@Address)>10 AND ISNUMERIC(LEFT(@Address, 1)) = 1)
				BEGIN;
					UPDATE Restaurant.Restaurant 
						SET RestaurantName=@RestaurantName,
								  Address=@Address,
								MobileNo=@MobileNo
						WHERE RestaurantID = @RestaurantID;
					PRINT 'Record Updated Successfully';
				END
				ELSE
				BEGIN;
					RAISERROR ( 'EITHER MOBILE NUMBER OR ADDRESS IS INVALID',1,1); 
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Restaurnt Found With This Restaurant ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
				BEGIN
						DELETE FROM Restaurant.Restaurant 
								WHERE RestaurantID = @RestaurantID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Restaurnt Found With This Restaurant ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
				BEGIN;
						SELECT * FROM Restaurant.Restaurant 
								WHERE RestaurantName=@RestaurantName;
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
