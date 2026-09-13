USE AdventureWorks2025;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetProductsByName
    @Name NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ProductID,
        Name,
        ProductNumber,
        ListPrice,
        Color,
        SellStartDate
    FROM Production.Product
    WHERE Name LIKE '%' + @Name + '%'
    ORDER BY Name;
END
GO