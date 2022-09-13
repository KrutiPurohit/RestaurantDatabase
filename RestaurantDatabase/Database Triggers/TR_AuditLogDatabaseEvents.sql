CREATE TRIGGER TR_AuditLogDatabaseEvents
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @EventData XML ;
 SET @EventData= EVENTDATA();
 INSERT INTO [Audit].AuditLogDB(EventTime,EventType,LoginName,Command) 
 SELECT @EventData.value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME'),
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(100)'),
	    @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(100)'),
		@EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
END