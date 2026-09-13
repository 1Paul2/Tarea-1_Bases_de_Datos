USE AdventureWorks2025;
GO

CREATE OR ALTER PROCEDURE dbo.usp_DeleteProduct
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Production.ProductProductPhoto     WHERE ProductID = @ProductID;
    DELETE FROM Production.ProductInventory        WHERE ProductID = @ProductID;
    DELETE FROM Production.ProductListPriceHistory WHERE ProductID = @ProductID;

    DELETE FROM Production.Product WHERE ProductID = @ProductID;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO