USE AdventureWorks2025;
GO

-- =========================================================
-- 2. UPDATE (parcial, con COALESCE)
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.usp_UpdateDepartment
    @DepartmentID SMALLINT,
    @Name NVARCHAR(50) = NULL,
    @GroupName NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE HumanResources.Department
    SET Name = COALESCE(@Name, Name),
        GroupName = COALESCE(@GroupName, GroupName),
        ModifiedDate = GETDATE()
    WHERE DepartmentID = @DepartmentID;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO