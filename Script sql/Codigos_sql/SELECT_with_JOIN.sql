USE AdventureWorks2025;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetProductsWithCategory
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ProductID,
        p.Name       AS ProductName,
        p.ProductNumber,
        p.ListPrice,
        ps.Name      AS SubcategoryName,
        pc.Name      AS CategoryName
    FROM Production.Product p
    INNER JOIN Production.ProductSubcategory ps 
        ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    INNER JOIN Production.ProductCategory pc 
        ON ps.ProductCategoryID = pc.ProductCategoryID
    ORDER BY pc.Name, ps.Name, p.Name;
END
GO