CREATE TABLE [Audit].[AuditLogDB] (
    [AuditId]   INT            IDENTITY (1, 1) NOT NULL,
    [EventTime] DATETIME       NULL,
    [EventType] NVARCHAR (100) NULL,
    [LoginName] NVARCHAR (100) NULL,
    [Command]   NVARCHAR (MAX) NULL
);

