CREATE TABLE [Restaurant].[DiningTableTrack] (
    [DiningTableTrackID] INT            IDENTITY (1, 1) NOT NULL,
    [DiningTableID]      INT            NOT NULL,
    [TableStatus]        NVARCHAR (100) NULL,
    CONSTRAINT [PK_DiningTableTrack_DiningTableTrackID] PRIMARY KEY CLUSTERED ([DiningTableTrackID] ASC),
    CONSTRAINT [FK_DiningTableTrack_DiningTableID_DiningTable_DiningTableID] FOREIGN KEY ([DiningTableID]) REFERENCES [Restaurant].[DiningTable] ([DiningTableID])
);


GO
CREATE NONCLUSTERED INDEX [NC_DiningTableTrack_DiningTableID]
    ON [Restaurant].[DiningTableTrack]([DiningTableID] ASC)
    INCLUDE([TableStatus]);

