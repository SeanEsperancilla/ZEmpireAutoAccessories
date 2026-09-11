-- ============================================================
-- Z-Empire Auto Accessories - Coating & Window Tint pricelist seed
-- Generated from the Coating packages sheet and the
-- "UPDATED PER PANEL PRICELIST 12.21.22" window tint sheet.
-- Idempotent: safe to re-run, will not create duplicate rows.
--
-- Assumptions made while mapping the source sheets onto the
-- shared VehicleClassification list -- please review:
--   * Coating's "Small Sedan" tier is mapped to the "Small" class.
--   * Coating's combined "MPV/SUV" tier is applied to BOTH the
--     MPV and SUV classes, except for Shield Coating, which lists
--     MPV/SUV and a separate SUV price -- there MPV/SUV -> MPV only,
--     and the explicit SUV price is used as given.
--   * Shield Coating has no "Big SUV" tier in the source sheet.
-- ============================================================

-- ---- Vehicle Classifications ----
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'Small')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'Small');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'Sedan');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'Subcompact/Crossover');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'SUV')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'SUV');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'MPV')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'MPV');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'Pickup');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'Big SUV');
IF NOT EXISTS (SELECT 1 FROM crm.VehicleClassification WHERE ClassificationName = N'Van')
    INSERT INTO crm.VehicleClassification (ClassificationName) VALUES (N'Van');
GO

-- ---- Panels ----
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'Front WS')
    INSERT INTO cat.Panel (PanelName) VALUES (N'Front WS');
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'2FWS')
    INSERT INTO cat.Panel (PanelName) VALUES (N'2FWS');
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'2RWS')
    INSERT INTO cat.Panel (PanelName) VALUES (N'2RWS');
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'Qtr Window')
    INSERT INTO cat.Panel (PanelName) VALUES (N'Qtr Window');
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'Rear WS')
    INSERT INTO cat.Panel (PanelName) VALUES (N'Rear WS');
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'Full Wrap')
    INSERT INTO cat.Panel (PanelName) VALUES (N'Full Wrap');
IF NOT EXISTS (SELECT 1 FROM cat.Panel WHERE PanelName = N'Whole Vehicle')
    INSERT INTO cat.Panel (PanelName) VALUES (N'Whole Vehicle');
GO

-- ---- Product Categories ----
IF NOT EXISTS (SELECT 1 FROM cat.ProductCategory WHERE CategoryName = N'Coating')
    INSERT INTO cat.ProductCategory (CategoryName) VALUES (N'Coating');
IF NOT EXISTS (SELECT 1 FROM cat.ProductCategory WHERE CategoryName = N'Window Tint')
    INSERT INTO cat.ProductCategory (CategoryName) VALUES (N'Window Tint');
GO

-- ---- Products ----
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'Diamond Coating')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Coating'), N'Diamond Coating', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Coating'), N'Ultra Gloss Coating', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'Shield Coating')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Coating'), N'Shield Coating', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'Clear Series')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Window Tint'), N'Clear Series', 1);
IF NOT EXISTS (SELECT 1 FROM cat.Product WHERE ProductName = N'Black Series')
    INSERT INTO cat.Product (CategoryID, ProductName, IsActive)
    VALUES ((SELECT CategoryID FROM cat.ProductCategory WHERE CategoryName = N'Window Tint'), N'Black Series', 1);
GO

-- ---- Tint Variants ----
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'), N'Play');
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'), N'Freeze');
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'), N'Max');
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'), N'Stone');
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'), N'Ceramic Pro');
IF NOT EXISTS (SELECT 1 FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme')
    INSERT INTO cat.TintVariant (ProductID, VariantName)
    VALUES ((SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'), N'Ceramic Supreme');
GO

-- ---- Coating Pricing (per whole vehicle) ----
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Small' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        20000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Sedan' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        22000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'MPV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        29000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        29000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Pickup' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        24000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Big SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        31000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Diamond Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Van' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Diamond Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        35000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Small' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        13000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Sedan' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        15000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'MPV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        22000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        22000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Pickup' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        17000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Big SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        24000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Ultra Gloss Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Van' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Ultra Gloss Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        27000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Shield Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Small' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Shield Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        14000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Shield Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Sedan' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Shield Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        16000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Shield Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'MPV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Shield Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        23000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Shield Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'SUV' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Shield Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        25000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Shield Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Pickup' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Shield Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        18000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Shield Coating' AND pn.PanelName = N'Whole Vehicle'
      AND vc.ClassificationName = N'Van' AND pr.TintVariantID IS NULL
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Shield Coating'),
        NULL,
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Whole Vehicle'),
        28000
    );
GO

-- ---- Window Tint Pricing (per panel) ----
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        2750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        2750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
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
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        9000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Play'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        10000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        3250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2750
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        3250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        13500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        15500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        14500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        17000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        20000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        21000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        22500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Freeze'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        23500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        9000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        10000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        11000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        11500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        21500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        23500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        22500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        25000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        29000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        31000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        33500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Clear Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Clear Series' AND tv.VariantName = N'Max'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        36500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        1500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        1000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        2000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        7000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        9000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
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
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        11000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        13000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        14500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        16000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Stone'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        19500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        7000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        9000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        9500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        4250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        4250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        3500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        3000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        4000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        16000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        18500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        17500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        20000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        23000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        24500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        26500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Pro'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        30500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        7500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        8500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        9000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        10000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        11000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Front WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Front WS'),
        11500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2FWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2FWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'2RWS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'2RWS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        2500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        4500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Qtr Window' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Qtr Window'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5250
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        5500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        6500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        7000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Rear WS' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Rear WS'),
        8000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Small'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Small'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        21500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Sedan'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Sedan'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        23500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Pickup'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Pickup'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        22500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Subcompact/Crossover'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Subcompact/Crossover'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        25000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        29000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'MPV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'MPV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        31000
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Big SUV'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Big SUV'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        33500
    );
IF NOT EXISTS (
    SELECT 1 FROM cat.Pricing pr
    JOIN cat.Product p ON pr.ProductID = p.ProductID
    JOIN cat.TintVariant tv ON pr.TintVariantID = tv.TintVariantID
    JOIN cat.Panel pn ON pr.PanelID = pn.PanelID
    JOIN crm.VehicleClassification vc ON pr.VehicleClassificationID = vc.VehicleClassificationID
    WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'
      AND pn.PanelName = N'Full Wrap' AND vc.ClassificationName = N'Van'
)
    INSERT INTO cat.Pricing (ProductID, TintVariantID, VehicleClassificationID, PanelID, Price)
    VALUES (
        (SELECT ProductID FROM cat.Product WHERE ProductName = N'Black Series'),
        (SELECT TintVariantID FROM cat.TintVariant tv JOIN cat.Product p ON tv.ProductID = p.ProductID WHERE p.ProductName = N'Black Series' AND tv.VariantName = N'Ceramic Supreme'),
        (SELECT VehicleClassificationID FROM crm.VehicleClassification WHERE ClassificationName = N'Van'),
        (SELECT PanelID FROM cat.Panel WHERE PanelName = N'Full Wrap'),
        36500
    );
GO

-- Total tint pricing rows: 269
