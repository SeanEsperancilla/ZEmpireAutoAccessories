/*
    READ-ONLY. Changes nothing. Run this first to see what the cleanup in
    MergeDuplicates.sql would touch, and to spot overlaps it cannot decide
    on its own.

    Five reports:
      1  Categories that mean the same thing
      2  Products whose names overlap
      3  Products that are safe to delete (nothing references them)
      4  Products that look redundant but carry data
      5  Categories left with no products
*/

PRINT '=== 1. Categories that look like the same thing ===';
SELECT  a.CategoryID AS KeepID,   a.CategoryName AS Keep,
        b.CategoryID AS MergeID,  b.CategoryName AS Merge,
        (SELECT COUNT(*) FROM cat.Product p WHERE p.CategoryID = a.CategoryID) AS KeepProducts,
        (SELECT COUNT(*) FROM cat.Product p WHERE p.CategoryID = b.CategoryID) AS MergeProducts
FROM    cat.ProductCategory a
JOIN    cat.ProductCategory b
        ON  b.CategoryID <> a.CategoryID
        -- one name contained in the other: "Paint Protection" inside
        -- "Paint Protection Film", "Tint" inside "Window Tint"
        AND (a.CategoryName LIKE N'%' + b.CategoryName + N'%')
        -- keep the longer, more specific name
        AND LEN(a.CategoryName) > LEN(b.CategoryName)
ORDER BY a.CategoryName;

PRINT '=== 2. Products whose names overlap ===';
SELECT  p1.ProductID, p1.ProductName, c1.CategoryName,
        p2.ProductID AS OtherID, p2.ProductName AS OtherName, c2.CategoryName AS OtherCategory
FROM    cat.Product p1
JOIN    cat.ProductCategory c1 ON c1.CategoryID = p1.CategoryID
JOIN    cat.Product p2 ON p2.ProductID > p1.ProductID
JOIN    cat.ProductCategory c2 ON c2.CategoryID = p2.CategoryID
WHERE   p2.ProductName LIKE N'%' + p1.ProductName + N'%'
   OR   p1.ProductName LIKE N'%' + p2.ProductName + N'%'
ORDER BY p1.ProductName;

/*
    A product is only safe to delete outright when all eight of the
    ON DELETE RESTRICT parents are empty for it. Anything else would either
    be refused by the database or would destroy history.
*/
PRINT '=== 3. Products nothing references - safe to delete ===';
SELECT  p.ProductID, p.ProductName, c.CategoryName, p.IsActive
FROM    cat.Product p
JOIN    cat.ProductCategory c ON c.CategoryID = p.CategoryID
WHERE   NOT EXISTS (SELECT 1 FROM cat.Pricing               x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM cat.TintVariant           x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM sales.QuotationDetail     x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM ops.JobOrderDetail        x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM sales.SalesDetail         x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM sales.ServiceInvoiceDetail x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM inv.InventoryCheckDetail  x WHERE x.ProductID = p.ProductID)
  AND   NOT EXISTS (SELECT 1 FROM inv.InventoryTransaction  x WHERE x.ProductID = p.ProductID)
ORDER BY c.CategoryName, p.ProductName;

PRINT '=== 4. Products that carry data - decide these by hand ===';
SELECT  p.ProductID, p.ProductName, c.CategoryName,
        (SELECT COUNT(*) FROM cat.Pricing               x WHERE x.ProductID = p.ProductID) AS Prices,
        (SELECT COUNT(*) FROM cat.TintVariant           x WHERE x.ProductID = p.ProductID) AS Variants,
        (SELECT COUNT(*) FROM inv.InventoryTransaction  x WHERE x.ProductID = p.ProductID) AS StockMoves,
        (SELECT ISNULL(SUM(CASE WHEN x.TransactionType = N'IN' THEN x.Quantity ELSE -x.Quantity END), 0)
           FROM inv.InventoryTransaction x WHERE x.ProductID = p.ProductID)                AS StockOnHand,
        (SELECT COUNT(*) FROM sales.SalesDetail         x WHERE x.ProductID = p.ProductID) AS SaleLines,
        (SELECT COUNT(*) FROM ops.JobOrderDetail        x WHERE x.ProductID = p.ProductID) AS JobLines,
        (SELECT COUNT(*) FROM sales.QuotationDetail     x WHERE x.ProductID = p.ProductID) AS QuoteLines,
        (SELECT COUNT(*) FROM sales.ServiceInvoiceDetail x WHERE x.ProductID = p.ProductID) AS InvoiceLines
FROM    cat.Product p
JOIN    cat.ProductCategory c ON c.CategoryID = p.CategoryID
WHERE   EXISTS (SELECT 1 FROM cat.Product q
                WHERE q.ProductID <> p.ProductID
                  AND (q.ProductName LIKE N'%' + p.ProductName + N'%'
                    OR p.ProductName LIKE N'%' + q.ProductName + N'%'))
ORDER BY c.CategoryName, p.ProductName;

PRINT '=== 5. Categories with no products left ===';
SELECT  c.CategoryID, c.CategoryName
FROM    cat.ProductCategory c
WHERE   NOT EXISTS (SELECT 1 FROM cat.Product p WHERE p.CategoryID = c.CategoryID)
ORDER BY c.CategoryName;
GO
