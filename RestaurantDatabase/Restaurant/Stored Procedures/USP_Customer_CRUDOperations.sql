
CREATE PROCEDURE Restaurant.USP_Customer_CRUDOperations
(
	@CustomerID INT,
	@RestaurantID INT,
	@CustomerName	NVARCHAR(100),
	@MobileNo  NVARCHAR(10),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND @CustomerName NOT LIKE '%[^a-zA-Z ]%' AND LEN(@CustomerName)>=10)
			BEGIN;
				
					INSERT INTO Restaurant.Customer (RestaurantID,
													CustomerName,
													MobileNo)
											VALUES (@RestaurantID,
													@CustomerName,
													@MobileNo);
					PRINT 'Record Inserted Successfully';
			END;
			ELSE
			BEGIN;
				RAISERROR(  'INVALID MOBILE NUMBER OR CUSTOMER NAME',1,1);
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE CustomerID = @CustomerID)
			BEGIN;
				
				IF EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
				BEGIN;
					IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND @CustomerName NOT LIKE '%[^a-zA-Z ]%' AND LEN(@CustomerName)>=10)
					BEGIN;
						UPDATE Restaurant.Customer 
							SET RestaurantID=@RestaurantID,
							CustomerName = @CustomerName	 
						WHERE CustomerID = @CustomerID;
						PRINT 'Record Updated Successfully';
					END;
					ELSE
					BEGIN;
						RAISERROR('INVALID MOBILE NUMBER OR CUSTOMER NAME',1,1);
					END;
				
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Update ,No Customer Found With This ID';
				END;
			END;
			ELSE
			BEGIN;
				RAISERROR(  'CAN NOT UPDATE CUSTOMER ONCE BILL IS GENERATED',1,1);
			END;
		END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE CustomerID = @CustomerID)
				BEGIN;
					
					IF EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					BEGIN
						DELETE FROM Restaurant.Customer 
								WHERE CustomerID = @CustomerID;
						PRINT 'Record Deleted Successfully';
					END;
					ELSE
					BEGIN;
						PRINT  'Can Not Delete,No Customer Found With This ID';
					END;
				END;
				ELSE
				BEGIN;
					RAISERROR(  'CAN NOT DELETE CUSTOMER ONCE BILL IS GENERATED',1,1);
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
				BEGIN;
						SELECT * FROM Restaurant.Customer 
								WHERE CustomerID = @CustomerID;
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