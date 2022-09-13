CREATE TABLE [Restaurant].[Customer] (
    [CustomerID]   INT            IDENTITY (1, 1) NOT NULL,
    [RestaurantID] INT            NOT NULL,
    [CustomerName] NVARCHAR (100) NOT NULL,
    [MobileNo]     NVARCHAR (10)  NOT NULL,
    CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID] ASC),
    CONSTRAINT [FK_Customer_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY ([RestaurantID]) REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
);


GO
CREATE NONCLUSTERED INDEX [NC_Customer_RestaurantID]
    ON [Restaurant].[Customer]([RestaurantID] ASC)
    INCLUDE([CustomerName], [MobileNo]);

