
CREATE PROCEDURE Restaurant.USP_DiningTableTrack_CRUDOperations
(
	@DiningTableTrackID INT,
	@DiningTableID  INT,
	@TableStatus	NVARCHAR(10),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			
					INSERT INTO Restaurant.DiningTableTrack (DiningTableID,
													TableStatus)
											VALUES (@DiningTableID,
													@TableStatus);
					PRINT 'Record Inserted Successfully';	
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.DiningTableTrack WHERE DiningTableTrackID = @DiningTableTrackID)
			BEGIN;
					UPDATE Restaurant.DiningTableTrack 
						SET DiningTableID=@DiningTableID,
							TableStatus = @TableStatus	 
						WHERE DiningTableTrackID = @DiningTableTrackID;
					PRINT 'Record Updated Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Dining Table Track Record Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN
						DELETE FROM Restaurant.DiningTableTrack 
								WHERE DiningTableTrackID = @DiningTableTrackID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Dining Table Track Record Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN;
						SELECT * FROM Restaurant.DiningTableTrack 
								WHERE DiningTableTrackID = @DiningTableTrackID;
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