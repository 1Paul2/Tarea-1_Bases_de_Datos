USE AdventureWorks2025;
GO

-- =========================================================
-- 5. SELECT con JOIN: departamentos + empleados actuales
-- =========================================================
CREATE OR ALTER PROCEDURE dbo.usp_GetDepartmentsWithEmployees
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.DepartmentID,
        d.Name AS DepartmentName,
        d.GroupName,
        p.BusinessEntityID,
        p.FirstName,
        p.LastName,
        edh.StartDate
    FROM HumanResources.Department d
    INNER JOIN HumanResources.EmployeeDepartmentHistory edh
        ON d.DepartmentID = edh.DepartmentID
    INNER JOIN Person.Person p
        ON edh.BusinessEntityID = p.BusinessEntityID
    WHERE edh.EndDate IS NULL
    ORDER BY d.Name, p.LastName;
END
GO