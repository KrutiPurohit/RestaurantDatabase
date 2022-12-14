USE [master]
GO
/****** Object:  Database [Restaurant]    Script Date: 13-09-2022 22:32:31 ******/
CREATE DATABASE [Restaurant] ON  PRIMARY 
( NAME = N'Restaurant', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Restaurant.mdf' , SIZE = 2240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Restaurant_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Restaurant_log.LDF' , SIZE = 504KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'Restaurant', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Restaurant].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Restaurant] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Restaurant] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Restaurant] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Restaurant] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Restaurant] SET ARITHABORT OFF 
GO
ALTER DATABASE [Restaurant] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Restaurant] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Restaurant] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Restaurant] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Restaurant] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Restaurant] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Restaurant] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Restaurant] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Restaurant] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Restaurant] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Restaurant] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Restaurant] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Restaurant] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Restaurant] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Restaurant] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Restaurant] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Restaurant] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Restaurant] SET  MULTI_USER 
GO
ALTER DATABASE [Restaurant] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Restaurant] SET DB_CHAINING OFF 
GO
USE [Restaurant]
GO
/****** Object:  Schema [Audit]    Script Date: 13-09-2022 22:32:32 ******/
CREATE SCHEMA [Audit]
GO
/****** Object:  Schema [Restaurant]    Script Date: 13-09-2022 22:32:32 ******/
CREATE SCHEMA [Restaurant]
GO
/****** Object:  UserDefinedFunction [Restaurant].[FN_GetOrderAmount]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Restaurant].[FN_GetOrderAmount] (@MenuItemID INT,@ItemQuantity INT)
RETURNS FLOAT
AS
BEGIN;
RETURN ((SELECT ItemPrice  FROM Restaurant.RestaurantMenuItem WHERE MenuItemID=@MenuItemID)* @ItemQuantity);
END;
GO
/****** Object:  UserDefinedFunction [Restaurant].[FN_MobileNumber_isValid]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Restaurant].[FN_MobileNumber_isValid] (@MobileNo NVARCHAR(10))
RETURNS bit
AS
BEGIN
RETURN CASE WHEN @MobileNo LIKE '[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' THEN 1 ELSE 0 END;
END
GO
/****** Object:  Table [Audit].[AuditLogDB]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Audit].[AuditLogDB](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[EventTime] [datetime] NULL,
	[EventType] [nvarchar](100) NULL,
	[LoginName] [nvarchar](100) NULL,
	[Command] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[Bills]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[Bills](
	[BillsID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[BillsAmount] [float] NOT NULL,
	[CustomerID] [int] NOT NULL,
 CONSTRAINT [PK_Bills_BillsID] PRIMARY KEY CLUSTERED 
(
	[BillsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[Cuisine]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[Cuisine](
	[CuisineID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CuisineName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Cuisine_CuisineID] PRIMARY KEY CLUSTERED 
(
	[CuisineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[Customer]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[MobileNo] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[DiningTable]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[DiningTable](
	[DiningTableID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[Location] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_DiningTable_DiningTableID] PRIMARY KEY CLUSTERED 
(
	[DiningTableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[DiningTableTrack]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[DiningTableTrack](
	[DiningTableTrackID] [int] IDENTITY(1,1) NOT NULL,
	[DiningTableID] [int] NOT NULL,
	[TableStatus] [nvarchar](100) NULL,
 CONSTRAINT [PK_DiningTableTrack_DiningTableTrackID] PRIMARY KEY CLUSTERED 
(
	[DiningTableTrackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[Order]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[MenuItemID] [int] NOT NULL,
	[ItemQuantity] [int] NOT NULL,
	[OrderAmount] [float] NOT NULL,
	[DiningTableID] [int] NOT NULL,
 CONSTRAINT [PK_Order_OrderID] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[Restaurant]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[Restaurant](
	[RestaurantID] [int] IDENTITY(1,1) NOT NULL,
	[RestaurantName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[MobileNo] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Restaurant_RestaurantID] PRIMARY KEY CLUSTERED 
(
	[RestaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Restaurant].[RestaurantMenuItem]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Restaurant].[RestaurantMenuItem](
	[MenuItemID] [int] IDENTITY(1,1) NOT NULL,
	[CuisineID] [int] NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL,
	[ItemPrice] [float] NULL,
 CONSTRAINT [PK_RestaurantMenuItem_MenuItemID] PRIMARY KEY CLUSTERED 
(
	[MenuItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Restaurant].[TVFN_GetOrderDetails]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
  Table-Valued Funciton to get order details
*/
CREATE FUNCTION [Restaurant].[TVFN_GetOrderDetails](@OrderID INT)
RETURNS @OrderDetailTable TABLE 
( 
	OrderID INT,
	RestaurantID INT,
	OrderAmount FLOAT,
	DiningTableID INT
  )
WITH SCHEMABINDING
AS
BEGIN
		INSERT INTO @OrderDetailTable
		SELECT OrderID,RestaurantID,OrderAmount,DiningTableID FROM Restaurant.[Order]
								WHERE OrderID = @OrderID;
	RETURN;
END;
GO
/****** Object:  View [dbo].[VW_CuisineWiseItemDetails]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CuisineWiseItemDetails]
AS
SELECT        TOP (100) PERCENT Restaurant.Cuisine.CuisineName, Restaurant.RestaurantMenuItem.ItemName, Restaurant.RestaurantMenuItem.ItemPrice
FROM            Restaurant.Cuisine INNER JOIN
                         Restaurant.RestaurantMenuItem ON Restaurant.Cuisine.CuisineID = Restaurant.RestaurantMenuItem.CuisineID
ORDER BY Restaurant.Cuisine.CuisineName
GO
SET IDENTITY_INSERT [Audit].[AuditLogDB] ON 

INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (1, CAST(N'2022-08-25T21:26:38.800' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Cuisine_RestaurantID on Restaurant.Cuisine(RestaurantID) INCLUDE (CuisineName)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (2, CAST(N'2022-08-25T21:29:27.343' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_RestaurantMenuItem_CuisineID on Restaurant.RestaurantMenuItem(CuisineID) INCLUDE (ItemName,ItemPrice)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (3, CAST(N'2022-08-25T21:31:55.883' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_DiningTable_RestaurantID on Restaurant.DiningTable(RestaurantID) INCLUDE (Location)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (4, CAST(N'2022-08-25T21:34:07.333' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_DiningTableTrack_DiningTableID on Restaurant.DiningTableTrack(DiningTableID) INCLUDE (TableStatus);
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (5, CAST(N'2022-08-25T21:35:50.913' AS DateTime), N'DROP_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'DROP INDEX NC_DiningTableTrack_DiningTableID  ON Restaurant.DiningTableTrack;   
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (6, CAST(N'2022-08-25T21:35:50.927' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_DiningTableTrack_DiningTableID on Restaurant.DiningTableTrack(DiningTableID) INCLUDE (TableStatus);
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (7, CAST(N'2022-08-25T21:36:09.633' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Order_RestaurantID on Restaurant.[ORDER](RestaurantID) INCLUDE (OrderDate, 
ItemQuantity, OrderAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (8, CAST(N'2022-08-25T21:37:32.457' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Order_MenuItemID on Restaurant.[ORDER](MenuItemID) INCLUDE (OrderDate, 
ItemQuantity, OrderAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (9, CAST(N'2022-08-25T21:38:19.380' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Order_DiningTableID on Restaurant.[ORDER](DiningTableID) INCLUDE (OrderDate, 
ItemQuantity, OrderAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (10, CAST(N'2022-08-25T21:40:24.370' AS DateTime), N'DROP_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'DROP INDEX NC_Order_DiningTableID  ON Restaurant.[Order];   
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (11, CAST(N'2022-08-25T21:40:24.387' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Order_DiningTableID on Restaurant.[ORDER](DiningTableID) INCLUDE (OrderDate, 
ItemQuantity, OrderAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (12, CAST(N'2022-08-25T21:43:16.710' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Bills_OrderID on Restaurant.Bills(OrderID) INCLUDE (BillsAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (13, CAST(N'2022-08-25T21:44:15.030' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Bills_RestaurantID on Restaurant.Bills(RestaurantID) INCLUDE (BillsAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (14, CAST(N'2022-08-25T21:45:07.927' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Bills_CustomerID on Restaurant.Bills(CustomerID) INCLUDE (BillsAmount)
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (15, CAST(N'2022-08-25T21:46:54.073' AS DateTime), N'CREATE_INDEX', N'DESKTOP-T7V5IRE\Infinity', N'CREATE NONCLUSTERED INDEX NC_Customer_RestaurantID on Restaurant.Customer(RestaurantID) INCLUDE (CustomerName,MobileNo);
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (16, CAST(N'2022-08-25T22:52:54.507' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (17, CAST(N'2022-08-25T23:00:19.793' AS DateTime), N'DROP_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'DROP PROCEDURE Restaurant.USP_Dynamic_GetAllCustomerOrderDetails;
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (23, CAST(N'2022-09-09T15:08:06.107' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (24, CAST(N'2022-09-09T15:08:06.503' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (25, CAST(N'2022-09-10T17:00:39.417' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (26, CAST(N'2022-09-10T17:02:33.507' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (31, CAST(N'2022-09-13T22:02:29.913' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (32, CAST(N'2022-09-13T22:02:30.587' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (33, CAST(N'2022-09-13T22:02:31.153' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (34, CAST(N'2022-09-13T22:02:31.173' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (35, CAST(N'2022-09-13T22:02:31.177' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (36, CAST(N'2022-09-13T22:02:31.253' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (37, CAST(N'2022-09-13T22:02:31.257' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (38, CAST(N'2022-09-13T22:02:31.270' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (39, CAST(N'2022-09-13T22:02:31.270' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (40, CAST(N'2022-09-13T22:02:31.273' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (41, CAST(N'2022-09-13T22:02:31.450' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (42, CAST(N'2022-09-13T22:02:32.153' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (43, CAST(N'2022-09-13T22:02:33.663' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (44, CAST(N'2022-09-13T22:02:34.187' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (18, CAST(N'2022-08-25T23:00:45.267' AS DateTime), N'CREATE_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'
CREATE PROCEDURE Restaurant.USP_Dynamic_GetAllCustomerOrderDetails
(
 @FilterBy  NVARCHAR(100),
 @OrderBy  NVARCHAR(100)
 )
 AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	DECLARE @SqlQry AS NVARCHAR(MAX);

	

	SET @SqlQry=N''SELECT CS.CustomerName,CONVERT(varchar(10),ODR.OrderDate,3) ''''Order Date'''', RS.RestaurantName, DT.Location ''''Dining Table'''',ODR.OrderAmount
				FROM Restaurant.Bills AS BL
				INNER JOIN Restaurant.[Order] AS ODR
				ON BL.OrderID=ODR.OrderID
				INNER JOIN Restaurant.Customer AS CS
				ON BL.CustomerID=CS.CustomerID
				INNER JOIN Restaurant.DiningTable AS DT
				ON ODR.DiningTableID = DT.DiningTableID
				INNER JOIN Restaurant.Restaurant AS RS
				ON BL.RestaurantID=RS.RestaurantID'';

	IF LEN(@FilterBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  WHERE ''+@FilterBy;
	END;
	IF LEN(@OrderBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  ORDER BY ''+@OrderBy;
	END;

EXEC(@SqlQry);

END TRY		
BEGIN CATCH;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (19, CAST(N'2022-08-25T23:03:46.610' AS DateTime), N'DROP_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'DROP PROCEDURE Restaurant.USP_Dynamic_GetAllCustomerOrderDetails;
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (20, CAST(N'2022-08-25T23:03:46.610' AS DateTime), N'CREATE_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'
CREATE PROCEDURE Restaurant.USP_Dynamic_GetAllCustomerOrderDetails
(
 @FilterBy  NVARCHAR(100),
 @OrderBy  NVARCHAR(100)
 )
 AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	DECLARE @SqlQry AS NVARCHAR(MAX);

	

	SET @SqlQry=N''SELECT CustomerName,CONVERT(varchar(10),ODR.OrderDate,3) ''''Order Date'''', RS.RestaurantName, DT.Location ''''Dining Table'''',ODR.OrderAmount
				FROM Restaurant.Bills AS BL
				INNER JOIN Restaurant.[Order] AS ODR
				ON BL.OrderID=ODR.OrderID
				INNER JOIN Restaurant.Customer
				ON BL.CustomerID=Customer.CustomerID
				INNER JOIN Restaurant.DiningTable AS DT
				ON ODR.DiningTableID = DT.DiningTableID
				INNER JOIN Restaurant.Restaurant AS RS
				ON BL.RestaurantID=RS.RestaurantID'';

	IF LEN(@FilterBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  WHERE ''+@FilterBy;
	END;
	IF LEN(@OrderBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  ORDER BY ''+@OrderBy;
	END;

EXEC(@SqlQry);

END TRY		
BEGIN CATCH;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (21, CAST(N'2022-08-25T23:04:38.323' AS DateTime), N'DROP_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'DROP PROCEDURE Restaurant.USP_Dynamic_GetAllCustomerOrderDetails;
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (45, CAST(N'2022-09-13T22:02:34.190' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (47, CAST(N'2022-09-13T22:02:34.407' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (48, CAST(N'2022-09-13T22:02:34.407' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (49, CAST(N'2022-09-13T22:02:34.573' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (22, CAST(N'2022-08-25T23:04:38.323' AS DateTime), N'CREATE_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'
CREATE PROCEDURE Restaurant.USP_Dynamic_GetAllCustomerOrderDetails
(
 @FilterBy  NVARCHAR(100),
 @OrderBy  NVARCHAR(100)
 )
 AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	DECLARE @SqlQry AS NVARCHAR(MAX);

	

	SET @SqlQry=N''SELECT CS.CustomerName,CONVERT(varchar(10),ODR.OrderDate,3) ''''Order Date'''', RS.RestaurantName, DT.Location ''''Dining Table'''',ODR.OrderAmount
				FROM Restaurant.Bills AS BL
				INNER JOIN Restaurant.[Order] AS ODR
				ON BL.OrderID=ODR.OrderID
				INNER JOIN Restaurant.Customer AS CS
				ON BL.CustomerID=CS.CustomerID
				INNER JOIN Restaurant.DiningTable AS DT
				ON ODR.DiningTableID = DT.DiningTableID
				INNER JOIN Restaurant.Restaurant AS RS
				ON BL.RestaurantID=RS.RestaurantID'';

	IF LEN(@FilterBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  WHERE ''+@FilterBy;
	END;
	IF LEN(@OrderBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  ORDER BY ''+@OrderBy;
	END;

EXEC(@SqlQry);

END TRY		
BEGIN CATCH;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (29, CAST(N'2022-09-10T21:19:57.497' AS DateTime), N'ALTER_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'
ALTER PROCEDURE [Restaurant].[USP_Cuisine_CRUDOperations]
(
	@CuisineID INT,
	@RestaurantID INT,
	@CuisineName	NVARCHAR(50),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;


BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType=''INSERT''
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineName = @CuisineName)
			BEGIN;
				
					INSERT INTO Restaurant.Cuisine (RestaurantID,
													CuisineName)
											VALUES (@RestaurantID,
													@CuisineName);
					PRINT ''Record Inserted Successfully'';
			END;
			ELSE
			BEGIN;
				PRINT  ''CUISINE NAME IS ALREADY EXISTS'';
			END;
		END;
		ELSE IF @ActionType=''UPDATE''
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
			BEGIN;
					UPDATE Restaurant.Cuisine 
						SET RestaurantID=@RestaurantID,
							CuisineName = @CuisineName	 
						WHERE CuisineID = @CuisineID;
					PRINT ''Record Updated Successfully'';
			END;
			ELSE
			BEGIN;
				PRINT  ''Can Not Update,No Cuisine Found With This ID'';
			END;
		 END;
		ELSE  IF @ActionType=''DELETE''
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
				BEGIN
						DELETE FROM Restaurant.Cuisine 
								WHERE CuisineID = @CuisineID;
						PRINT ''Record Deleted Successfully'';
				END;
				ELSE
				BEGIN;
					PRINT  ''Can Not Delete,No Cuisine Found With This ID'';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType=''SELECT''
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
				BEGIN;
						SELECT * FROM Restaurant.Cuisine 
								WHERE CuisineID = @CuisineID;
				END;
				ELSE
				BEGIN;
					PRINT ''No Record Found'';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;



END;')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (27, CAST(N'2022-09-10T21:17:31.963' AS DateTime), N'ALTER_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'

ALTER PROCEDURE [Restaurant].[USP_Restaurant_CRUDOperations]
(
 @RestaurantID INT,	
 @RestaurantName	NVARCHAR(200),
 @Address	NVARCHAR(500) ,
 @MobileNo	NVARCHAR(10) ,
 @ActionType NVARCHAR(6)
)
AS
BEGIN;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType=''INSERT''
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantName = @RestaurantName)
			BEGIN;
				IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND LEN(@Address)>10 AND ISNUMERIC(LEFT(@Address, 1)) = 1)
				BEGIN;
					INSERT INTO Restaurant.Restaurant (RestaurantName,Address,MobileNo)
											VALUES (@RestaurantName,@Address,@MobileNo);
					PRINT ''Record Inserted Successfully'';
				END;
				ELSE
				BEGIN;
					RAISERROR ( ''EITHER MOBILE NUMBER OR ADDRESS IS INVALID'',1,1); 
				END;
			END;
			ELSE
			BEGIN;
				PRINT  ''RESTAURANT NAME IS ALREADY EXISTS'';
			END;
		END;
		ELSE IF @ActionType=''UPDATE''
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
			BEGIN;
				IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND LEN(@Address)>10 AND ISNUMERIC(LEFT(@Address, 1)) = 1)
				BEGIN;
					UPDATE Restaurant.Restaurant 
						SET RestaurantName=@RestaurantName,
								  Address=@Address,
								MobileNo=@MobileNo
						WHERE RestaurantID = @RestaurantID;
					PRINT ''Record Updated Successfully'';
				END
				ELSE
				BEGIN;
					RAISERROR ( ''EITHER MOBILE NUMBER OR ADDRESS IS INVALID'',1,1); 
				END;
			END;
			ELSE
			BEGIN;
				PRINT  ''Can Not Update,No Restaurnt Found With This Restaurant ID'';
			END;
		 END;
		ELSE  IF @ActionType=''DELETE''
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
				BEGIN
						DELETE FROM Restaurant.Restaurant 
								WHERE RestaurantID = @RestaurantID;
						PRINT ''Record Deleted Successfully'';
				END;
				ELSE
				BEGIN;
					PRINT  ''Can Not Delete,No Restaurnt Found With This Restaurant ID'';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType=''SELECT''
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
				BEGIN;
						SELECT * FROM Restaurant.Restaurant 
								WHERE RestaurantName=@RestaurantName;
				END;
				ELSE
				BEGIN;
					PRINT ''No Record Found'';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;

END;
')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (28, CAST(N'2022-09-10T21:19:39.957' AS DateTime), N'ALTER_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'
ALTER PROCEDURE [Restaurant].[USP_Bills_CRUDOperations]
(
	@BillsID INT,
	@OrderID INT,
	@CustomerID INT,
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;


DECLARE @BillAmount FLOAT;
DECLARE @RestaurantID INT;
DECLARE @DiningTableID INT;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType=''INSERT''
		BEGIN	
					IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID) AND EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					BEGIN;
							SELECT @BillAmount=sum(OrderAmount),@DiningTableID=DiningTableID,@RestaurantID=RestaurantID FROM Restaurant.TVFN_GetOrderDetails(@OrderID) GROUP BY OrderID,DiningTableID,RestaurantID;
				
							INSERT INTO Restaurant.Bills
												   (OrderID,
													RestaurantID,
													BillsAmount,
													CustomerID)
											VALUES (@OrderID,
													@RestaurantID,
													@BillAmount,
													@CustomerID);
							PRINT ''Record Inserted Successfully'';
						UPDATE Restaurant.DiningTableTrack SET  TableStatus=''Vacant'' WHERE DiningTableID = @DiningTableID;
					END;
					ELSE
					BEGIN;
						  RAISERROR(''INVALID ORDER ID or CUSTOMER ID'',1,1);
					END;
		
		END;
		ELSE IF @ActionType=''UPDATE''
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
			BEGIN
					IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID) AND EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					 BEGIN;
							SELECT @BillAmount=sum(OrderAmount),@DiningTableID=DiningTableID FROM Restaurant.TVFN_GetOrderDetails(@OrderID) GROUP BY OrderID,DiningTableID;
				
							UPDATE  Restaurant.Bills
								SET OrderID=@OrderID,
								RestaurantID=@RestaurantID,
								BillsAmount=@BillAmount,
								CustomerID=@CustomerID	
							WHERE BillsID = @BillsID;
							PRINT ''Record Updated Successfully'';
					END;
					ELSE
					BEGIN;
						  RAISERROR(''INVALID ORDER ID or CUSTOMER ID'',1,1);
					END;
			END;
			ELSE
			BEGIN;
					PRINT  ''Can Not Update,No Bill Found With This ID'';
			END;
		
		END;
		ELSE  IF @ActionType=''DELETE''
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
				BEGIN
						DELETE FROM Restaurant.Bills 
								WHERE BillsID = @BillsID;
						PRINT ''Record Deleted Successfully'';
				END;
				ELSE
				BEGIN;
					PRINT  ''Can Not Delete,No Bills Found With This ID'';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType=''SELECT''
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
				BEGIN
						SELECT * FROM Restaurant.Bills 
								WHERE BillsID = @BillsID;
				END;
				ELSE
				BEGIN;
					PRINT ''No Record Found'';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;



END;')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (30, CAST(N'2022-09-12T14:07:25.887' AS DateTime), N'ALTER_PROCEDURE', N'DESKTOP-T7V5IRE\Infinity', N'
ALTER PROCEDURE [Restaurant].[USP_Dynamic_GetAllCustomerOrderDetails]
(
 @FilterBy  NVARCHAR(100),
 @OrderBy  NVARCHAR(100)
 )
 AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	DECLARE @SqlQry AS NVARCHAR(MAX);

	

	SET @SqlQry=N''SELECT CS.CustomerName,ODR.OrderDate ''''Order Date'''', RS.RestaurantName, DT.Location ''''Dining Table'''',ODR.OrderAmount
				FROM Restaurant.Bills AS BL
				INNER JOIN Restaurant.[Order] AS ODR
				ON BL.OrderID=ODR.OrderID
				INNER JOIN Restaurant.Customer AS CS
				ON BL.CustomerID=CS.CustomerID
				INNER JOIN Restaurant.DiningTable AS DT
				ON ODR.DiningTableID = DT.DiningTableID
				INNER JOIN Restaurant.Restaurant AS RS
				ON BL.RestaurantID=RS.RestaurantID'';

	IF LEN(@FilterBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  WHERE ''+@FilterBy;
	END;
	IF LEN(@OrderBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N''  ORDER BY ''+@OrderBy;
	END;

EXEC(@SqlQry);

END TRY		
BEGIN CATCH;
	PRINT ''Error occurred in '' + ERROR_PROCEDURE() + '' '' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;')
INSERT [Audit].[AuditLogDB] ([AuditId], [EventTime], [EventType], [LoginName], [Command]) VALUES (46, CAST(N'2022-09-13T22:02:34.403' AS DateTime), N'CREATE_STATISTICS', N'DESKTOP-T7V5IRE\Infinity', N'--ENCRYPTED--')
SET IDENTITY_INSERT [Audit].[AuditLogDB] OFF
GO
SET IDENTITY_INSERT [Restaurant].[Bills] ON 

INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (3, 2, 4, 240, 2)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (5, 4, 4, 200, 3)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (6, 5, 3, 200, 1)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (7, 6, 3, 420, 7)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (8, 11, 4, 160, 8)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (9, 10, 3, 420, 6)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (19, 12, 3, 70, 1)
INSERT [Restaurant].[Bills] ([BillsID], [OrderID], [RestaurantID], [BillsAmount], [CustomerID]) VALUES (20, 13, 3, 120, 2)
SET IDENTITY_INSERT [Restaurant].[Bills] OFF
GO
SET IDENTITY_INSERT [Restaurant].[Cuisine] ON 

INSERT [Restaurant].[Cuisine] ([CuisineID], [RestaurantID], [CuisineName]) VALUES (4, 3, N'Chinise')
INSERT [Restaurant].[Cuisine] ([CuisineID], [RestaurantID], [CuisineName]) VALUES (1, 4, N'South Indian')
INSERT [Restaurant].[Cuisine] ([CuisineID], [RestaurantID], [CuisineName]) VALUES (2, 4, N'North Indian')
INSERT [Restaurant].[Cuisine] ([CuisineID], [RestaurantID], [CuisineName]) VALUES (3, 4, N'Gujarati')
INSERT [Restaurant].[Cuisine] ([CuisineID], [RestaurantID], [CuisineName]) VALUES (5, 6, N'Italian')
SET IDENTITY_INSERT [Restaurant].[Cuisine] OFF
GO
SET IDENTITY_INSERT [Restaurant].[Customer] ON 

INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (3, 3, N'Manya Patel', N'8238073115')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (8, 3, N'Parthiv Purohit', N'9909059959')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (10, 3, N'Vishva patel', N'8568023149')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (1, 4, N'Kruti Purohit', N'9909188040')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (2, 4, N'Pratik1Patel', N'8238073115')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (6, 4, N'Dixit Purohit', N'9427736647')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (7, 4, N'Dhatri Tewani', N'8980472523')
INSERT [Restaurant].[Customer] ([CustomerID], [RestaurantID], [CustomerName], [MobileNo]) VALUES (9, 4, N'Dhimahi Purohit', N'8238054886')
SET IDENTITY_INSERT [Restaurant].[Customer] OFF
GO
SET IDENTITY_INSERT [Restaurant].[DiningTable] ON 

INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (1, 3, N'Window 1')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (2, 3, N'Window 2')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (3, 3, N'Window 3')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (4, 3, N'Center 1')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (5, 3, N'Center 2')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (6, 4, N'Left 1')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (7, 4, N'Left 2')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (8, 4, N'Right 1')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (9, 4, N'Right 2')
INSERT [Restaurant].[DiningTable] ([DiningTableID], [RestaurantID], [Location]) VALUES (10, 4, N'Middle')
SET IDENTITY_INSERT [Restaurant].[DiningTable] OFF
GO
SET IDENTITY_INSERT [Restaurant].[DiningTableTrack] ON 

INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (1, 1, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (2, 2, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (3, 3, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (4, 4, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (5, 5, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (6, 6, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (7, 7, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (8, 8, N'Vacant')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (9, 9, N'Occupied')
INSERT [Restaurant].[DiningTableTrack] ([DiningTableTrackID], [DiningTableID], [TableStatus]) VALUES (10, 10, N'Occupied')
SET IDENTITY_INSERT [Restaurant].[DiningTableTrack] OFF
GO
SET IDENTITY_INSERT [Restaurant].[Order] ON 

INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (2, CAST(N'2022-08-24T00:00:00.000' AS DateTime), 4, 4, 3, 240, 6)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (4, CAST(N'2022-08-24T00:00:00.000' AS DateTime), 4, 3, 2, 200, 7)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (5, CAST(N'2022-08-25T00:00:00.000' AS DateTime), 3, 16, 2, 200, 3)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (6, CAST(N'2022-08-25T00:00:00.000' AS DateTime), 3, 20, 3, 420, 2)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (10, CAST(N'2022-08-25T00:00:00.000' AS DateTime), 3, 21, 2, 420, 4)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (11, CAST(N'2022-08-24T00:00:00.000' AS DateTime), 4, 10, 2, 160, 6)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (12, CAST(N'2023-06-09T00:00:00.000' AS DateTime), 3, 6, 1, 70, 1)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (13, CAST(N'2022-09-07T00:00:00.000' AS DateTime), 3, 7, 1, 120, 8)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (15, CAST(N'2022-09-09T00:00:00.000' AS DateTime), 4, 1, 2, 420, 10)
INSERT [Restaurant].[Order] ([OrderID], [OrderDate], [RestaurantID], [MenuItemID], [ItemQuantity], [OrderAmount], [DiningTableID]) VALUES (17, CAST(N'2022-09-09T00:00:00.000' AS DateTime), 4, 2, 2, 180, 9)
SET IDENTITY_INSERT [Restaurant].[Order] OFF
GO
SET IDENTITY_INSERT [Restaurant].[Restaurant] ON 

INSERT [Restaurant].[Restaurant] ([RestaurantID], [RestaurantName], [Address], [MobileNo]) VALUES (3, N'Sarvoday', N'1Collage Road, Bharuch', N'8238073018')
INSERT [Restaurant].[Restaurant] ([RestaurantID], [RestaurantName], [Address], [MobileNo]) VALUES (4, N'Greenary', N'2 Bholav, Bharuch', N'9909144525')
INSERT [Restaurant].[Restaurant] ([RestaurantID], [RestaurantName], [Address], [MobileNo]) VALUES (6, N'Steller Kitchen', N'5-Airport Road,Vadodara', N'8890652301')
SET IDENTITY_INSERT [Restaurant].[Restaurant] OFF
GO
SET IDENTITY_INSERT [Restaurant].[RestaurantMenuItem] ON 

INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (6, 1, N'Idali', 70)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (7, 1, N'Masala Dosa', 120)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (8, 1, N'Mendu Vada', 90)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (9, 1, N'Uttapam', 150)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (10, 1, N'Upama', 80)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (11, 2, N'Paneer Butter Masala', 170)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (12, 2, N'Dal Makhani', 150)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (13, 2, N'Rajma Chawal', 190)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (14, 2, N'Tanduri Roti', 30)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (15, 2, N'Chhole Bhature', 110)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (1, 3, N'Gujarati Thali', 210)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (2, 3, N'Dhokla', 90)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (3, 3, N'Handavo', 100)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (4, 3, N'Khaman', 80)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (5, 3, N'Khandavi', 60)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (16, 4, N'Hakka Noodles', 100)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (17, 4, N'Manchurian', 120)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (18, 4, N'Fried Rice', 150)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (19, 4, N'Spring Rolls', 160)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (20, 4, N'American Chopsuey', 140)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (21, 5, N'Pizza', 210)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (22, 5, N'Pasta', 190)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (23, 5, N'Garlic Bread', 180)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (24, 5, N'Lasagne', 220)
INSERT [Restaurant].[RestaurantMenuItem] ([MenuItemID], [CuisineID], [ItemName], [ItemPrice]) VALUES (26, 5, N'Panini', 210)
SET IDENTITY_INSERT [Restaurant].[RestaurantMenuItem] OFF
GO
/****** Object:  Index [NC_Bills_CustomerID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Bills_CustomerID] ON [Restaurant].[Bills]
(
	[CustomerID] ASC
)
INCLUDE([BillsAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Bills_OrderID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Bills_OrderID] ON [Restaurant].[Bills]
(
	[OrderID] ASC
)
INCLUDE([BillsAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Bills_RestaurantID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Bills_RestaurantID] ON [Restaurant].[Bills]
(
	[RestaurantID] ASC
)
INCLUDE([BillsAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Cuisine_CuisineName]    Script Date: 13-09-2022 22:32:32 ******/
ALTER TABLE [Restaurant].[Cuisine] ADD  CONSTRAINT [UQ_Cuisine_CuisineName] UNIQUE NONCLUSTERED 
(
	[CuisineName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Cuisine_RestaurantID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Cuisine_RestaurantID] ON [Restaurant].[Cuisine]
(
	[RestaurantID] ASC
)
INCLUDE([CuisineName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Customer_RestaurantID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Customer_RestaurantID] ON [Restaurant].[Customer]
(
	[RestaurantID] ASC
)
INCLUDE([CustomerName],[MobileNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_DiningTable_Location]    Script Date: 13-09-2022 22:32:32 ******/
ALTER TABLE [Restaurant].[DiningTable] ADD  CONSTRAINT [UQ_DiningTable_Location] UNIQUE NONCLUSTERED 
(
	[Location] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_DiningTable_RestaurantID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_DiningTable_RestaurantID] ON [Restaurant].[DiningTable]
(
	[RestaurantID] ASC
)
INCLUDE([Location]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_DiningTableTrack_DiningTableID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_DiningTableTrack_DiningTableID] ON [Restaurant].[DiningTableTrack]
(
	[DiningTableID] ASC
)
INCLUDE([TableStatus]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_DiningTableID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Order_DiningTableID] ON [Restaurant].[Order]
(
	[DiningTableID] ASC
)
INCLUDE([OrderDate],[ItemQuantity],[OrderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_MenuItemID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Order_MenuItemID] ON [Restaurant].[Order]
(
	[MenuItemID] ASC
)
INCLUDE([OrderDate],[ItemQuantity],[OrderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_Order_RestaurantID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_Order_RestaurantID] ON [Restaurant].[Order]
(
	[RestaurantID] ASC
)
INCLUDE([OrderDate],[ItemQuantity],[OrderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Restaurant_MobileNo]    Script Date: 13-09-2022 22:32:32 ******/
ALTER TABLE [Restaurant].[Restaurant] ADD  CONSTRAINT [UQ_Restaurant_MobileNo] UNIQUE NONCLUSTERED 
(
	[MobileNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Restaurant_RestaurantName]    Script Date: 13-09-2022 22:32:32 ******/
ALTER TABLE [Restaurant].[Restaurant] ADD  CONSTRAINT [UQ_Restaurant_RestaurantName] UNIQUE NONCLUSTERED 
(
	[RestaurantName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_RestaurantMenuItem_ItemName]    Script Date: 13-09-2022 22:32:32 ******/
ALTER TABLE [Restaurant].[RestaurantMenuItem] ADD  CONSTRAINT [UQ_RestaurantMenuItem_ItemName] UNIQUE NONCLUSTERED 
(
	[ItemName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [NC_RestaurantMenuItem_CuisineID]    Script Date: 13-09-2022 22:32:32 ******/
CREATE NONCLUSTERED INDEX [NC_RestaurantMenuItem_CuisineID] ON [Restaurant].[RestaurantMenuItem]
(
	[CuisineID] ASC
)
INCLUDE([ItemName],[ItemPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [Restaurant].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_CustomerID_Customer_CustomerID] FOREIGN KEY([CustomerID])
REFERENCES [Restaurant].[Customer] ([CustomerID])
GO
ALTER TABLE [Restaurant].[Bills] CHECK CONSTRAINT [FK_Bills_CustomerID_Customer_CustomerID]
GO
ALTER TABLE [Restaurant].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_OrderID_Order_OrderID] FOREIGN KEY([OrderID])
REFERENCES [Restaurant].[Order] ([OrderID])
GO
ALTER TABLE [Restaurant].[Bills] CHECK CONSTRAINT [FK_Bills_OrderID_Order_OrderID]
GO
ALTER TABLE [Restaurant].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY([RestaurantID])
REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [Restaurant].[Bills] CHECK CONSTRAINT [FK_Bills_RestaurantID_Restaurant_RestaurantID]
GO
ALTER TABLE [Restaurant].[Cuisine]  WITH CHECK ADD  CONSTRAINT [FK_Cuisine_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY([RestaurantID])
REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [Restaurant].[Cuisine] CHECK CONSTRAINT [FK_Cuisine_RestaurantID_Restaurant_RestaurantID]
GO
ALTER TABLE [Restaurant].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY([RestaurantID])
REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [Restaurant].[Customer] CHECK CONSTRAINT [FK_Customer_RestaurantID_Restaurant_RestaurantID]
GO
ALTER TABLE [Restaurant].[DiningTable]  WITH CHECK ADD  CONSTRAINT [FK_DiningTable_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY([RestaurantID])
REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [Restaurant].[DiningTable] CHECK CONSTRAINT [FK_DiningTable_RestaurantID_Restaurant_RestaurantID]
GO
ALTER TABLE [Restaurant].[DiningTableTrack]  WITH CHECK ADD  CONSTRAINT [FK_DiningTableTrack_DiningTableID_DiningTable_DiningTableID] FOREIGN KEY([DiningTableID])
REFERENCES [Restaurant].[DiningTable] ([DiningTableID])
GO
ALTER TABLE [Restaurant].[DiningTableTrack] CHECK CONSTRAINT [FK_DiningTableTrack_DiningTableID_DiningTable_DiningTableID]
GO
ALTER TABLE [Restaurant].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_DiningTableID_DiningTable_DiningTableID] FOREIGN KEY([DiningTableID])
REFERENCES [Restaurant].[DiningTable] ([DiningTableID])
GO
ALTER TABLE [Restaurant].[Order] CHECK CONSTRAINT [FK_Order_DiningTableID_DiningTable_DiningTableID]
GO
ALTER TABLE [Restaurant].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_MenuItemID_RestaurantMenuItem_MenuItemID] FOREIGN KEY([MenuItemID])
REFERENCES [Restaurant].[RestaurantMenuItem] ([MenuItemID])
GO
ALTER TABLE [Restaurant].[Order] CHECK CONSTRAINT [FK_Order_MenuItemID_RestaurantMenuItem_MenuItemID]
GO
ALTER TABLE [Restaurant].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_RestaurantID_Restaurant_RestaurantID] FOREIGN KEY([RestaurantID])
REFERENCES [Restaurant].[Restaurant] ([RestaurantID])
GO
ALTER TABLE [Restaurant].[Order] CHECK CONSTRAINT [FK_Order_RestaurantID_Restaurant_RestaurantID]
GO
ALTER TABLE [Restaurant].[RestaurantMenuItem]  WITH CHECK ADD  CONSTRAINT [FK_RestaurantMenuItem_CuisineID_Cuisine_CuisineID] FOREIGN KEY([CuisineID])
REFERENCES [Restaurant].[Cuisine] ([CuisineID])
GO
ALTER TABLE [Restaurant].[RestaurantMenuItem] CHECK CONSTRAINT [FK_RestaurantMenuItem_CuisineID_Cuisine_CuisineID]
GO
/****** Object:  StoredProcedure [Restaurant].[USP_Bills_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_Bills_CRUDOperations]
(
	@BillsID INT,
	@OrderID INT,
	@CustomerID INT,
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;


DECLARE @BillAmount FLOAT;
DECLARE @RestaurantID INT;
DECLARE @DiningTableID INT;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
					IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID) AND EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					BEGIN;
							SELECT @BillAmount=sum(OrderAmount),@DiningTableID=DiningTableID,@RestaurantID=RestaurantID FROM Restaurant.TVFN_GetOrderDetails(@OrderID) GROUP BY OrderID,DiningTableID,RestaurantID;
				
							INSERT INTO Restaurant.Bills
												   (OrderID,
													RestaurantID,
													BillsAmount,
													CustomerID)
											VALUES (@OrderID,
													@RestaurantID,
													@BillAmount,
													@CustomerID);
							PRINT 'Record Inserted Successfully';
						UPDATE Restaurant.DiningTableTrack SET  TableStatus='Vacant' WHERE DiningTableID = @DiningTableID;
					END;
					ELSE
					BEGIN;
						  RAISERROR('INVALID ORDER ID or CUSTOMER ID',1,1);
					END;
		
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
			BEGIN
					IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID) AND EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					 BEGIN;
							SELECT @BillAmount=sum(OrderAmount),@DiningTableID=DiningTableID FROM Restaurant.TVFN_GetOrderDetails(@OrderID) GROUP BY OrderID,DiningTableID;
				
							UPDATE  Restaurant.Bills
								SET OrderID=@OrderID,
								RestaurantID=@RestaurantID,
								BillsAmount=@BillAmount,
								CustomerID=@CustomerID	
							WHERE BillsID = @BillsID;
							PRINT 'Record Updated Successfully';
					END;
					ELSE
					BEGIN;
						  RAISERROR('INVALID ORDER ID or CUSTOMER ID',1,1);
					END;
			END;
			ELSE
			BEGIN;
					PRINT  'Can Not Update,No Bill Found With This ID';
			END;
		
		END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
				BEGIN
						DELETE FROM Restaurant.Bills 
								WHERE BillsID = @BillsID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Bills Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Bills WHERE BillsID = @BillsID)
				BEGIN
						SELECT * FROM Restaurant.Bills 
								WHERE BillsID = @BillsID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;



END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_Cuisine_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_Cuisine_CRUDOperations]
(
	@CuisineID INT,
	@RestaurantID INT,
	@CuisineName	NVARCHAR(50),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;


BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineName = @CuisineName)
			BEGIN;
				
					INSERT INTO Restaurant.Cuisine (RestaurantID,
													CuisineName)
											VALUES (@RestaurantID,
													@CuisineName);
					PRINT 'Record Inserted Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'CUISINE NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
			BEGIN;
					UPDATE Restaurant.Cuisine 
						SET RestaurantID=@RestaurantID,
							CuisineName = @CuisineName	 
						WHERE CuisineID = @CuisineID;
					PRINT 'Record Updated Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Cuisine Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
				BEGIN
						DELETE FROM Restaurant.Cuisine 
								WHERE CuisineID = @CuisineID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Cuisine Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Cuisine WHERE CuisineID = @CuisineID)
				BEGIN;
						SELECT * FROM Restaurant.Cuisine 
								WHERE CuisineID = @CuisineID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;



END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_Customer_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_Customer_CRUDOperations]
(
	@CustomerID INT,
	@RestaurantID INT,
	@CustomerName	NVARCHAR(100),
	@MobileNo  NVARCHAR(10),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND @CustomerName NOT LIKE '%[^a-zA-Z ]%' AND LEN(@CustomerName)>=10)
			BEGIN;
				
					INSERT INTO Restaurant.Customer (RestaurantID,
													CustomerName,
													MobileNo)
											VALUES (@RestaurantID,
													@CustomerName,
													@MobileNo);
					PRINT 'Record Inserted Successfully';
			END;
			ELSE
			BEGIN;
				RAISERROR(  'INVALID MOBILE NUMBER OR CUSTOMER NAME',1,1);
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE CustomerID = @CustomerID)
			BEGIN;
				
				IF EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
				BEGIN;
					IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND @CustomerName NOT LIKE '%[^a-zA-Z ]%' AND LEN(@CustomerName)>=10)
					BEGIN;
						UPDATE Restaurant.Customer 
							SET RestaurantID=@RestaurantID,
							CustomerName = @CustomerName	 
						WHERE CustomerID = @CustomerID;
						PRINT 'Record Updated Successfully';
					END;
					ELSE
					BEGIN;
						RAISERROR('INVALID MOBILE NUMBER OR CUSTOMER NAME',1,1);
					END;
				
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Update ,No Customer Found With This ID';
				END;
			END;
			ELSE
			BEGIN;
				RAISERROR(  'CAN NOT UPDATE CUSTOMER ONCE BILL IS GENERATED',1,1);
			END;
		END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE CustomerID = @CustomerID)
				BEGIN;
					
					IF EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
					BEGIN
						DELETE FROM Restaurant.Customer 
								WHERE CustomerID = @CustomerID;
						PRINT 'Record Deleted Successfully';
					END;
					ELSE
					BEGIN;
						PRINT  'Can Not Delete,No Customer Found With This ID';
					END;
				END;
				ELSE
				BEGIN;
					RAISERROR(  'CAN NOT DELETE CUSTOMER ONCE BILL IS GENERATED',1,1);
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Customer WHERE CustomerID = @CustomerID)
				BEGIN;
						SELECT * FROM Restaurant.Customer 
								WHERE CustomerID = @CustomerID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_DiningTable_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_DiningTable_CRUDOperations]
(
	@DiningTableID INT,
	@RestaurantID INT,
	@Location	NVARCHAR(100),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE [Location] = @Location)
			BEGIN;
				
					INSERT INTO Restaurant.DiningTable (RestaurantID,
													Location)
											VALUES (@RestaurantID,
													@Location);
					PRINT 'Record Inserted Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'DINING TABLE NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
			BEGIN;
					UPDATE Restaurant.DiningTable 
						SET RestaurantID=@RestaurantID,
							Location = @Location	 
						WHERE DiningTableID = @DiningTableID;
					PRINT 'Record Updated Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Dining Table Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN
						DELETE FROM Restaurant.DiningTable 
								WHERE DiningTableID = @DiningTableID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Dining Table Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN;
						SELECT * FROM Restaurant.DiningTable 
								WHERE DiningTableID = @DiningTableID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_DiningTableTrack_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_DiningTableTrack_CRUDOperations]
(
	@DiningTableTrackID INT,
	@DiningTableID  INT,
	@TableStatus	NVARCHAR(10),
	@ActionType  NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			
					INSERT INTO Restaurant.DiningTableTrack (DiningTableID,
													TableStatus)
											VALUES (@DiningTableID,
													@TableStatus);
					PRINT 'Record Inserted Successfully';	
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.DiningTableTrack WHERE DiningTableTrackID = @DiningTableTrackID)
			BEGIN;
					UPDATE Restaurant.DiningTableTrack 
						SET DiningTableID=@DiningTableID,
							TableStatus = @TableStatus	 
						WHERE DiningTableTrackID = @DiningTableTrackID;
					PRINT 'Record Updated Successfully';
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Dining Table Track Record Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN
						DELETE FROM Restaurant.DiningTableTrack 
								WHERE DiningTableTrackID = @DiningTableTrackID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Dining Table Track Record Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.DiningTable WHERE DiningTableID = @DiningTableID)
				BEGIN;
						SELECT * FROM Restaurant.DiningTableTrack 
								WHERE DiningTableTrackID = @DiningTableTrackID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_Dynamic_GetAllCustomerOrderDetails]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_Dynamic_GetAllCustomerOrderDetails]
(
 @FilterBy  NVARCHAR(100),
 @OrderBy  NVARCHAR(100)
 )
 AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	DECLARE @SqlQry AS NVARCHAR(MAX);

	

	SET @SqlQry=N'SELECT CS.CustomerName,ODR.OrderDate ''Order Date'', RS.RestaurantName, DT.Location ''Dining Table'',ODR.OrderAmount
				FROM Restaurant.Bills AS BL
				INNER JOIN Restaurant.[Order] AS ODR
				ON BL.OrderID=ODR.OrderID
				INNER JOIN Restaurant.Customer AS CS
				ON BL.CustomerID=CS.CustomerID
				INNER JOIN Restaurant.DiningTable AS DT
				ON ODR.DiningTableID = DT.DiningTableID
				INNER JOIN Restaurant.Restaurant AS RS
				ON BL.RestaurantID=RS.RestaurantID';

	IF LEN(@FilterBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N'  WHERE '+@FilterBy;
	END;
	IF LEN(@OrderBy)>0
	BEGIN;
		SET @SqlQry=@SqlQry+N'  ORDER BY '+@OrderBy;
	END;

EXEC(@SqlQry);

END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_GetVaccantDiningTableDetails]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_GetVaccantDiningTableDetails]
(
	@RestaurantID INT
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
			
			SELECT DT.RestaurantID,RS.RestaurantName, DT.DiningTableID,DT.Location, DTTrack.TableStatus
			FROM Restaurant.DiningTableTrack AS DTTrack 
			INNER JOIN Restaurant.DiningTable AS DT
				ON DTTrack.DiningTableID=DT.DiningTableID
			INNER JOIN Restaurant.Restaurant As RS
				ON DT.RestaurantID=RS.RestaurantID
			WHERE DT.RestaurantID=@RestaurantID AND
				DTTrack.TableStatus='Vacant'
END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_Order_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_Order_CRUDOperations]
(
	@OrderID INT,
	@OrderDate DATETIME,
	@RestaurantID INT,
	@MenuItemID INT,
	@ItemQuantity INT,
	@DiningTableID INT,
	@ActionType NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
		
				IF ( @ItemQuantity>0 AND @OrderDate=Convert(datetime, convert(varchar(10), getdate(),120)))
				BEGIN;
					IF EXISTS(SELECT 1 FROM Restaurant.DiningTableTrack WHERE DiningTableID = @DiningTableID AND TableStatus='Vacant')
					BEGIN;
							INSERT INTO Restaurant.[Order] 
													(OrderDate,
													RestaurantID,
													MenuItemID,
													ItemQuantity,
													OrderAmount,
													DiningTableID)
											VALUES (@OrderDate,
													@RestaurantID,
													@MenuItemID,
													@ItemQuantity,
													Restaurant.FN_GetOrderAmount(@MenuItemID,@ItemQuantity),
													@DiningTableID);

							---------Update dining table status as occupied------------
							UPDATE Restaurant.DiningTableTrack SET  TableStatus='Occupied' WHERE DiningTableID = @DiningTableID;
							
							PRINT 'Record Inserted Successfully';
					END;
					ELSE
					BEGIN;
						PRINT 'Dining Table is Already Occupied, Try Different Dining Table ID';
					END;
				END;
				ELSE
				BEGIN; 
					RAISERROR('INVALID ITEM QTY. OR ORDER DATE',1,1);
				END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID)
			BEGIN;
				IF ( @ItemQuantity>0 AND @OrderDate=Convert(datetime, convert(varchar(10), getdate(),120)))
				BEGIN;
					IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE OrderID = @OrderID)
					BEGIN;
						UPDATE Restaurant.DiningTableTrack SET  TableStatus='Vacant' WHERE DiningTableID = (SELECT DiningTableID FROM Restaurant.[Order] WHERE OrderID = @OrderID);
						IF EXISTS(SELECT 1 FROM Restaurant.DiningTableTrack WHERE DiningTableID = @DiningTableID AND TableStatus='Vacant')
						BEGIN;
							UPDATE Restaurant.[Order] 
								SET 
								OrderDate = @OrderDate,
								RestaurantID=@RestaurantID,
								MenuItemID=@MenuItemID,
								ItemQuantity=@ItemQuantity,
								OrderAmount=Restaurant.FN_GetOrderAmount(@MenuItemID,@ItemQuantity)
								--DiningTableID=@DiningTableID
							WHERE OrderID = @OrderID;
							PRINT 'Record Updated Successfully';

							UPDATE Restaurant.DiningTableTrack SET  TableStatus='Occupied' WHERE DiningTableID = @DiningTableID;
						END;
						ELSE
						BEGIN;
							PRINT 'Dining Table is Already Occupied, Try Different Dining Table ID';
						END;
					END;
					ELSE
					BEGIN;
						PRINT 'Can not Update Order once Bill is Generated';
					END;
				END;
				ELSE
				BEGIN;
					RAISERROR('INVALID ITEM QTY. OR ORDER DATE',1,1);
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Order Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID)
				BEGIN;
					IF NOT EXISTS(SELECT 1 FROM Restaurant.Bills WHERE OrderID = @OrderID)
					BEGIN;
						DELETE FROM Restaurant.[Order]
								WHERE  OrderID = @OrderID;
						PRINT 'Record Deleted Successfully';

						UPDATE Restaurant.DiningTableTrack SET  TableStatus='Vacant' WHERE DiningTableID = @DiningTableID;

					END;
					ELSE
					BEGIN;
						PRINT 'Can not delete Order once Bill is Generated';
					END;
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Order Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.[Order] WHERE OrderID = @OrderID)
				BEGIN;
						SELECT * FROM Restaurant.[Order]
								WHERE OrderID = @OrderID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_ORDER_GetDayAndTableWiseTotalOrderAmount]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_ORDER_GetDayAndTableWiseTotalOrderAmount]
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	SELECT CONVERT(VARCHAR,[Order].OrderDate,5) 'Order Date', [Order].DiningTableID, SUM(OrderAmount) 'Total Order Amount' FROM Restaurant.[Order]
	GROUP BY [Order].OrderDate, [Order].DiningTableID
	ORDER BY [Order].OrderDate ASC

END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_ORDER_GetYearAndRestaurantWiseTotalOrderAmount]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_ORDER_GetYearAndRestaurantWiseTotalOrderAmount]
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;

	SELECT  YEAR(ODR.OrderDate) 'Year', RS.RestaurantName, SUM(ODR.OrderAmount) 'Total Order Amount' FROM Restaurant.[Order] AS ODR
	INNER JOIN Restaurant.Restaurant AS RS
	ON ODR.RestaurantID =RS.RestaurantID
	GROUP BY  YEAR(ODR.OrderDate), ODR.RestaurantID,RS.RestaurantName
	ORDER BY YEAR(ODR.OrderDate) ASC

END TRY		
BEGIN CATCH;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;


GO
/****** Object:  StoredProcedure [Restaurant].[USP_Restaurant_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Restaurant].[USP_Restaurant_CRUDOperations]
(
 @RestaurantID INT,	
 @RestaurantName	NVARCHAR(200),
 @Address	NVARCHAR(500) ,
 @MobileNo	NVARCHAR(10) ,
 @ActionType NVARCHAR(6)
)
AS
BEGIN;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantName = @RestaurantName)
			BEGIN;
				IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND LEN(@Address)>10 AND ISNUMERIC(LEFT(@Address, 1)) = 1)
				BEGIN;
					INSERT INTO Restaurant.Restaurant (RestaurantName,Address,MobileNo)
											VALUES (@RestaurantName,@Address,@MobileNo);
					PRINT 'Record Inserted Successfully';
				END;
				ELSE
				BEGIN;
					RAISERROR ( 'EITHER MOBILE NUMBER OR ADDRESS IS INVALID',1,1); 
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'RESTAURANT NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
			BEGIN;
				IF (Restaurant.FN_MobileNumber_isValid(@MobileNo) = 1 AND LEN(@Address)>10 AND ISNUMERIC(LEFT(@Address, 1)) = 1)
				BEGIN;
					UPDATE Restaurant.Restaurant 
						SET RestaurantName=@RestaurantName,
								  Address=@Address,
								MobileNo=@MobileNo
						WHERE RestaurantID = @RestaurantID;
					PRINT 'Record Updated Successfully';
				END
				ELSE
				BEGIN;
					RAISERROR ( 'EITHER MOBILE NUMBER OR ADDRESS IS INVALID',1,1); 
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Restaurnt Found With This Restaurant ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
				BEGIN
						DELETE FROM Restaurant.Restaurant 
								WHERE RestaurantID = @RestaurantID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Restaurnt Found With This Restaurant ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.Restaurant WHERE RestaurantID = @RestaurantID)
				BEGIN;
						SELECT * FROM Restaurant.Restaurant 
								WHERE RestaurantName=@RestaurantName;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

END;
GO
/****** Object:  StoredProcedure [Restaurant].[USP_RestaurantMenuItem_CRUDOperations]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Restaurant].[USP_RestaurantMenuItem_CRUDOperations]
(
	@MenuItemID INT,
	@CuisineID INT,
	@ItemName	NVARCHAR(100),
	@ItemPrice  FLOAT,
	@ActionType NVARCHAR(6)
)
AS
BEGIN;
SET NOCOUNT ON;

BEGIN TRY;
	
		
	BEGIN TRANSACTION;
		IF @ActionType='INSERT'
		BEGIN	
			IF NOT EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE ItemName = @ItemName)
			BEGIN;
				IF @ItemPrice>0
				BEGIN;
					INSERT INTO Restaurant.RestaurantMenuItem 
													(CuisineID,
													ItemName,
													ItemPrice)
											VALUES (@CuisineID,
													@ItemName,
													@ItemPrice);
					PRINT 'Record Inserted Successfully';
				END;
				ELSE
				BEGIN;
					RAISERROR('ITEM PRICE MUST BE GREATER THAN ZERO',1,1);
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'MENU ITEM NAME IS ALREADY EXISTS';
			END;
		END;
		ELSE IF @ActionType='UPDATE'
		BEGIN
			IF EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE MenuItemID = @MenuItemID)
			BEGIN;
				IF @ItemPrice>0
				BEGIN;
					UPDATE Restaurant.RestaurantMenuItem 
							SET CuisineID = @CuisineID,
								ItemName = @ItemName,
								ItemPrice=@ItemPrice
							WHERE MenuItemID = @MenuItemID;
					PRINT 'Record Updated Successfully';
					END;
				ELSE
				BEGIN;
					RAISERROR('ITEM PRICE MUST BE GREATER THAN ZERO',1,1);
				END;
			END;
			ELSE
			BEGIN;
				PRINT  'Can Not Update,No Menu Item Found With This ID';
			END;
		 END;
		ELSE  IF @ActionType='DELETE'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE MenuItemID = @MenuItemID)
				BEGIN
						DELETE FROM Restaurant.RestaurantMenuItem
								WHERE  MenuItemID = @MenuItemID;
						PRINT 'Record Deleted Successfully';
				END;
				ELSE
				BEGIN;
					PRINT  'Can Not Delete,No Menu Item Found With This ID';
				END;
		END;

	   COMMIT TRANSACTION;

		IF @ActionType='SELECT'
		BEGIN
				IF EXISTS(SELECT 1 FROM Restaurant.RestaurantMenuItem WHERE MenuItemID = @MenuItemID)
				BEGIN;
						SELECT * FROM Restaurant.RestaurantMenuItem
								WHERE MenuItemID = @MenuItemID;
				END;
				ELSE
				BEGIN;
					PRINT 'No Record Found';
				END;
		END;
		
END TRY		
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	BEGIN;
		ROLLBACK TRANSACTION;
	END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();

END CATCH;

SET NOCOUNT OFF;

END;
GO
/****** Object:  DdlTrigger [TR_AuditLogDatabaseEvents]    Script Date: 13-09-2022 22:32:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [TR_AuditLogDatabaseEvents]
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
GO
ENABLE TRIGGER [TR_AuditLogDatabaseEvents] ON DATABASE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Cuisine (Restaurant)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "RestaurantMenuItem (Restaurant)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 141
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CuisineWiseItemDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_CuisineWiseItemDetails'
GO
USE [master]
GO
ALTER DATABASE [Restaurant] SET  READ_WRITE 
GO
