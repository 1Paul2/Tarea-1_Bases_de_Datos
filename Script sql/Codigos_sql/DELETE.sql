USE AdventureWorks2025;
GO

-- =========================================================
-- 3. DELETE (con transacción)
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.usp_DeleteDepartment
    @DepartmentID SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    DELETE FROM HumanResources.EmployeeDepartmentHistory WHERE DepartmentID = @DepartmentID;
    DELETE FROM HumanResources.Department WHERE DepartmentID = @DepartmentID;

    COMMIT TRANSACTION;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO