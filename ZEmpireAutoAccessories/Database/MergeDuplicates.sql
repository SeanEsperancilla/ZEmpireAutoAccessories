/*
    Merges the duplicate categories and clears out products nothing
    references. Data only - no schema change.

    RUN ReviewDuplicates.sql FIRST and read report 4. This script will not
    delete a product that carries prices, stock or document lines; those are
    listed there for you to decide on, and section 3 below is how to merge
    one once you have decided.

    Idempotent: re-running finds nothing left to do.

    It runs inside a transaction and prints what it changed. Read the output,
    then COMMIT or ROLLBACK at the bottom - nothing is permanent until you do.
*/

SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ============================================================
-- 1. Categories that are the same thing
-- ============================================================
-- Left = the one to keep, right = the one to fold into it. Comment out a
-- row to leave that pair alone.
DECLARE @CategoryMerges TABLE (KeepName NVARCHAR(80), MergeName NVARCHAR(80));
INSERT INTO @CategoryMerges (KeepName, MergeName) VALUES
    (N'Paint Protection Film', N'Paint Protection'),
    (N'Window Tint',           N'Tint');

DECLARE @Keep INT, @Merge INT, @KeepName NVARCHAR(80), @MergeName NVARCHAR(80), @Moved INT;

DECLARE merges CURSOR LOCAL FAST_FORWARD FOR
    SELECT KeepName, MergeName FROM @CategoryMerges;
OPEN merges;
FETCH NEXT FROM merges INTO @KeepName, @MergeName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @Keep  = CategoryID FROM cat.ProductCategory WHERE CategoryName = @KeepName;
    SELECT @Merge = CategoryID FROM cat.ProductCategory WHERE CategoryName = @MergeName;

    IF @Keep IS NOT NULL AND @Merge IS NOT NULL AND @Keep <> @Merge
    BEGIN
        UPDATE cat.Product SET CategoryID = @Keep WHERE CategoryID = @Merge;
        SET @Moved = @@ROWCOUNT;

        DELETE FROM cat.ProductCategory WHERE CategoryID = @Merge;

        PRINT CONCAT('Merged category "', @MergeName, '" into "', @KeepName,
                     '" - moved ', @Moved, ' product(s).');
    END
    ELSE IF @Merge IS NULL
        PRINT CONCAT('Category "', @MergeName, '" is already gone - nothing to do.');
    ELSE
        PRINT CONCAT('Category "', @KeepName, '" not found - skipped.');

    SET @Keep = NULL; SET @Merge = NULL;
    FETCH NEXT FROM merges INTO @KeepName, @MergeName;
END
CLOSE merges;
DEALLOCATE merges;
GO

-- ============================================================
-- 2. Products nothing references, whose name duplicates another
-- ============================================================
-- Only rows where all eight ON DELETE RESTRICT parents are empty, so nothing
-- is destroyed and the database would not have refused the delete anyway.
DECLARE @Removable TABLE (ProductID INT, ProductName NVARCHAR(150));

INSERT INTO @Removable (ProductID, ProductName)
SELECT  p.ProductID, p.ProductName
FROM    cat.Product p
WHERE   EXISTS (SELECT 1 FROM cat.Product q
                WHERE q.ProductID <> p.ProductID
                  AND (q.ProductName LIKE N'%' + p.ProductName + N'%'
                    OR p.ProductName LIKE N'%' + q.ProductName + N'%'))
  AND   NOT EXISTS (SELECT 1 FROM cat.Pricing                x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM cat.TintVariant            x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM sales.QuotationDetail      x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM ops.JobOrderDetail         x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM sales.SalesDetail          x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM sales.ServiceInvoiceDetail x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM inv.InventoryCheckDetail   x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM inv.InventoryTransaction   x WHERE x.ProductID = p.ProductID);

SELECT ProductName AS [Deleting - nothing referenced these] FROM @Removable ORDER BY ProductName;

DELETE FROM cat.Product WHERE ProductID IN (SELECT ProductID FROM @Removable);
PRINT CONCAT('Removed ', @@ROWCOUNT, ' unreferenced duplicate product(s).');
GO

-- ============================================================
-- 3. Merging two products that BOTH carry data
-- ============================================================
-- Not run automatically - which of two real products survives is your call,
-- and it moves stock and history from one onto the other.
--
-- To use: set the two names, uncomment the block, run it.
--
-- DECLARE @KeepProduct NVARCHAR(150)   = N'ProFilm Shield';
-- DECLARE @RemoveProduct NVARCHAR(150) = N'Paint Protection Film';
--
-- DECLARE @KeepID   INT = (SELECT ProductID FROM cat.Product WHERE ProductName = @KeepProduct);
-- DECLARE @RemoveID INT = (SELECT ProductID FROM cat.Product WHERE ProductName = @RemoveProduct);
--
-- IF @KeepID IS NULL OR @RemoveID IS NULL OR @KeepID = @RemoveID
--     PRINT 'One of those products was not found - nothing done.';
-- ELSE
-- BEGIN
--     -- History and documents point at the surviving product.
--     UPDATE inv.InventoryTransaction   SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--     UPDATE inv.InventoryCheckDetail   SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--     UPDATE sales.SalesDetail          SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--     UPDATE sales.ServiceInvoiceDetail SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--     UPDATE sales.QuotationDetail      SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--     UPDATE ops.JobOrderDetail         SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--
--     -- Prices are per product/variant/classification/panel and a unique index
--     -- covers that combination, so only the ones the survivor does not
--     -- already have can move; the rest are dropped as duplicates.
--     DELETE pr
--     FROM   cat.Pricing pr
--     WHERE  pr.ProductID = @RemoveID
--       AND  EXISTS (SELECT 1 FROM cat.Pricing k
--                    WHERE k.ProductID = @KeepID
--                      AND k.VehicleClassificationID = pr.VehicleClassificationID
--                      AND k.PanelID = pr.PanelID
--                      AND ISNULL(k.TintVariantID, -1) = ISNULL(pr.TintVariantID, -1));
--     UPDATE cat.Pricing SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--
--     UPDATE cat.TintVariant SET ProductID = @KeepID WHERE ProductID = @RemoveID;
--
--     DELETE FROM cat.Product WHERE ProductID = @RemoveID;
--     PRINT CONCAT('Merged "', @RemoveProduct, '" into "', @KeepProduct, '".');
-- END
-- GO

-- ============================================================
-- 4. What the catalogue looks like now
-- ============================================================
SELECT  c.CategoryName, COUNT(p.ProductID) AS Products
FROM    cat.ProductCategory c
LEFT JOIN cat.Product p ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY c.CategoryName;

PRINT '';
PRINT 'Nothing is permanent yet. Read the output above, then run COMMIT to keep';
PRINT 'these changes or ROLLBACK to undo them.';

-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;
