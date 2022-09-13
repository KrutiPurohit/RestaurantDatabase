CREATE TABLE [Restaurant].[Order] (
    [OrderID]       INT        IDENTITY (1, 1) NOT NULL,
    [OrderDate]     DATETIME   NOT NULL,
    [RestaurantID]  INT        NOT NULL,
    [MenuItemID]    INT        NOT NULL,
    [ItemQuantity]  INT        NOT NULL,
    [OrderAmount]   FLOAT (53) NOT NULL,
    [DiningTableID] INT        NOT NULL,
    CONSTRAINT [PK_Order_OrderID] PRIMARY KEY CLUSTERED ([OrderID] ASC),
    CONSTRAINT [FK_Order_DiningTableID_DiningTable_DiningTableID] FOREIGN KEY ([DiningTableID]) REFERENCES [Restaurant].[DiningTable] ([DiningTableID]),
    CONSTRAINT [FK_Order_MenuItemID_RestaurantMenuItem_MenuItemID] FOREIGN KEY ([MenuItemID]) REFERENCES [Restaurant].[RestaurantMenuItem] ([MenuItemID]),
    CONSTRAINT [FK_Order_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY ([RestaurantID]) REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
);


GO
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID]
    ON [Restaurant].[Order]([RestaurantID] ASC)
    INCLUDE([OrderDate], [ItemQuantity], [OrderAmount]);


GO
CREATE NONCLUSTERED INDEX [NC_Order_MenuItemID]
    ON [Restaurant].[Order]([MenuItemID] ASC)
    INCLUDE([OrderDate], [ItemQuantity], [OrderAmount]);


GO
CREATE NONCLUSTERED INDEX [NC_Order_DiningTableID]
    ON [Restaurant].[Order]([DiningTableID] ASC)
    INCLUDE([OrderDate], [ItemQuantity], [OrderAmount]);

