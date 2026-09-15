USE AdventureWorks2025;
GO


-- =========================================================
-- 1. INSERT
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.sp_InsertDepartment
    @Name NVARCHAR(50),
    @GroupName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HumanResources.Department (Name, GroupName, ModifiedDate)
    VALUES (@Name, @GroupName, GETDATE());

END
GO
