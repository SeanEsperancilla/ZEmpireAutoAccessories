-- ============================================================
-- Z-Empire Auto Accessories - Profilm Nano Ceramic Tint & PPF seed
-- Generated from the Profilm per-panel pricelist, the Profilm
-- Pro/Lite full-wrap sheet, and the Print Protection Film sheet.
-- Idempotent: safe to re-run. Reuses the Panel and
-- VehicleClassification rows already seeded by
-- SeedCoatingAndTintPricing.sql -- run that script first.
--
-- Assumptions made while mapping onto the shared
-- VehicleClassification list -- please review:
--   * Profilm's combined "MPV / Mid SUV" tier is applied to
--     BOTH the MPV and SUV classes; "Full Size SUV" -> Big SUV.
--   * PPF's combined "Full SUV/MPV" tier is applied to BOTH
--     the MPV and Big SUV classes (the two classes its other
--     rows don't already cover).
--   * Profilm's panel names (FWS/1st Row/2nd Row/Qtr Window/RWS)
--     are mapped onto the SAME Panel rows already used by the
--     BF Film Clear/Black Series pricing (Front WS/2FWS/2RWS/
--     Qtr Window/Rear WS), so both brands share one panel list.
-- ============================================================

-- ---- Product Category: Paint Protection Film ----
IF NOT EXISTS (SELECT 1 FROM cat.ProductCategory WHERE CategoryName = N'Paint Protection Film')
    INSERT INTO cat.ProductCategory (CategoryName) VALUES (N'Paint Protection Film');
GO

-- ---- Products ----
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Window Tint'), N'Profilm Nano Ceramic Tint', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'ProFilm Ultra')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Paint Protection Film'), N'ProFilm Ultra', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'ProFilm Shield')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Paint Protection Film'), N'ProFilm Shield', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'ProFilm Supreme')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Paint Protection Film'), N'ProFilm Supreme', 1);
GO

-- ---- Tint Variants (Profilm Pro / Lite) ----
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'), N'Pro (99%)');
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'), N'Lite (97%)');
GO

-- ---- Profilm Pricing (per panel, Pro variant) ----
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        9500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        10500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        10500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        11500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Pro (99%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Pro (99%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        12500
    );
GO

-- ---- Profilm Pricing (per panel, Lite variant) ----
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Front WS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2FWS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'2RWS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Qtr Window'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Rear WS'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Small' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Sedan' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Pickup' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        7000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'MPV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Big SUV' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND pn.PanelName = N'Full Wrap'
      AND vc.ClassificationName = N'Van' AND tv.VariantName = N'Lite (97%)'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Profilm Nano Ceramic Tint'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Profilm Nano Ceramic Tint' AND tv.VariantName = N'Lite (97%)'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        9000
    );
GO

-- ---- Print Protection Film Pricing (per whole vehicle) ----
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Small' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        45000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Sedan' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        50000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        55000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Pickup' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        60000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        65000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'MPV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        70000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Big SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        70000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Ultra' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Van' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Ultra'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        80000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Small' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        60000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Sedan' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        65000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        70000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Pickup' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        75000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        85000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'MPV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        95000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Big SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        95000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Shield' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Van' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Shield'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        105000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Small' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        95000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Sedan' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        100000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Subcompact/Crossover' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        105000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Pickup' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        110000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        125000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'MPV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        130000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Big SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        130000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'ProFilm Supreme' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Van' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'ProFilm Supreme'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        140000
    );
GO

-- Total pricing rows: 114
