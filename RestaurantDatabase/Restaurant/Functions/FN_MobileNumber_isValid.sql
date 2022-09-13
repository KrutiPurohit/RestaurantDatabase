
CREATE FUNCTION Restaurant.FN_MobileNumber_isValid (@MobileNo NVARCHAR(10))
RETURNS bit
AS
BEGIN
RETURN CASE WHEN @MobileNo LIKE '[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' THEN 1 ELSE 0 END;
END