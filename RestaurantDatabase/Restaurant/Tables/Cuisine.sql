CREATE TABLE [Restaurant].[Cuisine] (
    [CuisineID]    INT           IDENTITY (1, 1) NOT NULL,
    [RestaurantID] INT           NOT NULL,
    [CuisineName]  NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Cuisine_CuisineID] PRIMARY KEY CLUSTERED ([CuisineID] ASC),
    CONSTRAINT [FK_Cuisine_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY ([RestaurantID]) REFERENCES [Restaurant].[Restaurant] ([RestaurantID]),
    CONSTRAINT [UQ_Cuisine_CuisineName] UNIQUE NONCLUSTERED ([CuisineName] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NC_Cuisine_RestaurantID]
    ON [Restaurant].[Cuisine]([RestaurantID] ASC)
    INCLUDE([CuisineName]);

