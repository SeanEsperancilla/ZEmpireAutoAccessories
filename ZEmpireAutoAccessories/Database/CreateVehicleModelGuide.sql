-- ============================================================
-- Z-Empire Auto Accessories - VehicleModelGuide table
--
-- Reference table only: which classification a given car brand/model
-- normally falls under (e.g. "Toyota Corolla Cross" -> "Subcompact/
-- Crossover"). Meant to help staff pick the right classification when
-- registering a vehicle. Not linked to any specific Vehicle record.
--
-- This does NOT seed any brand/model rows yet - see the note in chat
-- about why the brand/model chart wasn't auto-transcribed. Run this
-- to create the table, then either seed it from a cleaner source (a
-- spreadsheet export is much safer than re-typing from a photo) or
-- ask for the best-effort transcription and review it before use.
-- ============================================================

IF NOT EXISTS (
    SELECT 1 FROM sys.tables t
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE s.name = 'crm' AND t.name = 'VehicleModelGuide'
)
BEGIN
    CREATE TABLE crm.VehicleModelGuide (
        VehicleModelGuideID     INT IDENTITY(1,1) PRIMARY KEY,
        Brand                   NVARCHAR(60) NOT NULL,
        ModelName               NVARCHAR(80) NOT NULL,
        VehicleClassificationID INT NOT NULL
            REFERENCES crm.VehicleClassification (VehicleClassificationID),
        CONSTRAINT UQ_VehicleModelGuide_Brand_Model UNIQUE (Brand, ModelName)
    );
END
GO
