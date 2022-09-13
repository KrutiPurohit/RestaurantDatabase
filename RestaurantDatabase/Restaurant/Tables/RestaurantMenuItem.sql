CREATE TABLE [Restaurant].[RestaurantMenuItem] (
    [MenuItemID] INT            IDENTITY (1, 1) NOT NULL,
    [CuisineID]  INT            NOT NULL,
    [ItemName]   NVARCHAR (100) NOT NULL,
    [ItemPrice]  FLOAT (53)     NULL,
    CONSTRAINT [PK_RestaurantMenuItem_MenuItemID] PRIMARY KEY CLUSTERED ([MenuItemID] ASC),
    CONSTRAINT [FK_RestaurantMenuItem_CuisineID_Cuisine_CuisineID] FOREIGN KEY ([CuisineID]) REFERENCES [Restaurant].[Cuisine] ([CuisineID]),
    CONSTRAINT [UQ_RestaurantMenuItem_ItemName] UNIQUE NONCLUSTERED ([ItemName] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_RestaurantMenuItem_CuisineID]
    ON [Restaurant].[RestaurantMenuItem]([CuisineID] ASC)
    INCLUDE([ItemName], [ItemPrice]);

