USE AdventureWorks2025;
GO

-- =========================================================
-- 4. SELECT simple (una sola tabla)
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.usp_GetDepartmentsByName
    @Name NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DepartmentID, Name, GroupName, ModifiedDate
    FROM HumanResources.Department
    WHERE Name LIKE '%' + @Name + '%'
    ORDER BY Name;
END
GO