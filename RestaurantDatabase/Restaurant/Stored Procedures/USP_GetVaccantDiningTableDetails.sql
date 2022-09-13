
CREATE PROCEDURE Restaurant.USP_GetVaccantDiningTableDetails
(
	@RestaurantID INT
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
			
			SELECT DT.RestaurantID,RS.RestaurantName, DT.DiningTableID,DT.Location, DTTrack.TableStatus
			FROM Restaurant.DiningTableTrack AS DTTrack 
			INNER JOIN Restaurant.DiningTable AS DT
				ON DTTrack.DiningTableID=DT.DiningTableID
			INNER JOIN Restaurant.Restaurant As RS
				ON DT.RestaurantID=RS.RestaurantID
			WHERE DT.RestaurantID=@RestaurantID AND
				DTTrack.TableStatus='Vacant'
END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;