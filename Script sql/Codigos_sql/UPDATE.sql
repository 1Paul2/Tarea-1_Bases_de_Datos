USE AdventureWorks2025;
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateProduct
    @ProductID INT,
    @ListPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Production.Product
    SET ListPrice = @ListPrice,
        ModifiedDate = GETDATE()
    WHERE ProductID = @ProductID;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO