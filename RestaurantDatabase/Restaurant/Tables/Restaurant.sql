CREATE TABLE [Restaurant].[Restaurant] (
    [RestaurantID]   INT            IDENTITY (1, 1) NOT NULL,
    [RestaurantName] NVARCHAR (200) NOT NULL,
    [Address]        NVARCHAR (500) NOT NULL,
    [MobileNo]       NVARCHAR (10)  NOT NULL,
    CONSTRAINT [PK_Restaurant_RestaurantID] PRIMARY KEY CLUSTERED ([RestaurantID] ASC),
    CONSTRAINT [UQ_Restaurant_MobileNo] UNIQUE NONCLUSTERED ([MobileNo] ASC),
    CONSTRAINT [UQ_Restaurant_RestaurantName] UNIQUE NONCLUSTERED ([RestaurantName] ASC)
);

