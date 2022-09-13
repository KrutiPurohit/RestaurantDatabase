CREATE TABLE [Restaurant].[DiningTable] (
    [DiningTableID] INT            IDENTITY (1, 1) NOT NULL,
    [RestaurantID]  INT            NOT NULL,
    [Location]      NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_DiningTable_DiningTableID] PRIMARY KEY CLUSTERED ([DiningTableID] ASC),
    CONSTRAINT [FK_DiningTable_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY ([RestaurantID]) REFERENCES [Restaurant].[Restaurant] ([RestaurantID]),
    CONSTRAINT [UQ_DiningTable_Location] UNIQUE NONCLUSTERED ([Location] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_DiningTable_RestaurantID]
    ON [Restaurant].[DiningTable]([RestaurantID] ASC)
    INCLUDE([Location]);

