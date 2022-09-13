CREATE TABLE [Restaurant].[Bills] (
    [BillsID]      INT        IDENTITY (1, 1) NOT NULL,
    [OrderID]      INT        NOT NULL,
    [RestaurantID] INT        NOT NULL,
    [BillsAmount]  FLOAT (53) NOT NULL,
    [CustomerID]   INT        NOT NULL,
    CONSTRAINT [PK_Bills_BillsID] PRIMARY KEY CLUSTERED ([BillsID] ASC),
    CONSTRAINT [FK_Bills_CustomerID_Customer_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [Restaurant].[Customer] ([CustomerID]),
    CONSTRAINT [FK_Bills_OrderID_Order_OrderID] FOREIGN KEY ([OrderID]) REFERENCES [Restaurant].[Order] ([OrderID]),
    CONSTRAINT [FK_Bills_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY ([RestaurantID]) REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
);


GO
CREATE NONCLUSTERED INDEX [NC_Bills_OrderID]
    ON [Restaurant].[Bills]([OrderID] ASC)
    INCLUDE([BillsAmount]);


GO
CREATE NONCLUSTERED INDEX [NC_Bills_RestaurantID]
    ON [Restaurant].[Bills]([RestaurantID] ASC)
    INCLUDE([BillsAmount]);


GO
CREATE NONCLUSTERED INDEX [NC_Bills_CustomerID]
    ON [Restaurant].[Bills]([CustomerID] ASC)
    INCLUDE([BillsAmount]);

