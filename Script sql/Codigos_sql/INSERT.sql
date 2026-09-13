USE AdventureWorks2025;
GO

CREATE OR ALTER PROCEDURE dbo.usp_InsertProduct
    @Name          NVARCHAR(50),
    @ProductNumber NVARCHAR(25),
    @ListPrice     MONEY
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Production.Product 
        (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, 
         SafetyStockLevel, ReorderPoint, StandardCost, ListPrice,
         DaysToManufacture, SellStartDate)
    VALUES 
        (@Name, @ProductNumber, 1, 1,
         100, 75, @ListPrice * 0.6, @ListPrice,
         1, GETDATE());

    SELECT SCOPE_IDENTITY() AS NewProductID;
END
GO