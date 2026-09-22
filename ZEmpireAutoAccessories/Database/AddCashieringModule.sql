-- ============================================================
-- Z-Empire Auto Accessories - Cashiering module registration
--
-- The Cashiering screen is gated by [ModuleAuthorize("Cashiering")],
-- which resolves against sec.RolePermission -> sec.Module. That row
-- does not exist yet, so until this script is run nobody can open
-- Cashiering (including Admin) and the menu entry stays hidden.
--
-- Cashiering itself adds no tables: it is a read-only view over
-- sales.Sales and sales.ServiceInvoice.
--
-- Run once against the ZEmpire database. Re-running is safe.
--
-- NOTE: module access is baked into the auth cookie at sign-in
-- (AppUserClaimsPrincipalFactory), so users who are already signed in
-- must sign out and back in before the new module appears.
-- ============================================================

SET NOCOUNT ON;

-- 1. The module itself -------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM sec.Module WHERE ModuleName = N'Cashiering')
BEGIN
    INSERT INTO sec.Module (ModuleName) VALUES (N'Cashiering');
    PRINT 'Added sec.Module row: Cashiering';
END
ELSE
BEGIN
    PRINT 'sec.Module already has Cashiering - skipped.';
END
GO

-- 2. Grant it to Admin -------------------------------------------------
-- Admin is granted here because an admin who cannot open the module
-- cannot grant it to anyone else from the Roles & Permissions screen.
DECLARE @ModuleID INT =
    (SELECT ModuleID FROM sec.Module WHERE ModuleName = N'Cashiering');

INSERT INTO sec.RolePermission (RoleId, ModuleID, CanAccess)
SELECT r.Id, @ModuleID, 1
FROM asp.AspNetRoles r
WHERE r.Name = N'Admin'
  AND NOT EXISTS (
      SELECT 1 FROM sec.RolePermission rp
      WHERE rp.RoleId = r.Id AND rp.ModuleID = @ModuleID
  );

PRINT 'Granted Cashiering to Admin (where not already granted).';
GO

-- 3. Grant it to Staff -------------------------------------------------
-- Staff are the people who actually work the counter. Comment this
-- block out if cashiering should be Admin-only at this shop; access can
-- also be toggled later from Roles & Permissions.
DECLARE @ModuleID INT =
    (SELECT ModuleID FROM sec.Module WHERE ModuleName = N'Cashiering');

INSERT INTO sec.RolePermission (RoleId, ModuleID, CanAccess)
SELECT r.Id, @ModuleID, 1
FROM asp.AspNetRoles r
WHERE r.Name = N'Staff'
  AND NOT EXISTS (
      SELECT 1 FROM sec.RolePermission rp
      WHERE rp.RoleId = r.Id AND rp.ModuleID = @ModuleID
  );

PRINT 'Granted Cashiering to Staff (where not already granted).';
GO

-- 4. Verify ------------------------------------------------------------
SELECT r.Name AS RoleName, m.ModuleName, rp.CanAccess
FROM sec.RolePermission rp
JOIN sec.Module       m ON m.ModuleID = rp.ModuleID
JOIN asp.AspNetRoles  r ON r.Id       = rp.RoleId
WHERE m.ModuleName = N'Cashiering'
ORDER BY r.Name;
GO
