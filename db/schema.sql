-- 1. Defect Table
-- id: Surrogate PK
-- defect_id: Business identifier (formerly defect_code)
CREATE TABLE Defect (
    id BIGSERIAL PRIMARY KEY,
    defect_id VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Lot Table
-- id: Surrogate PK
-- lot_id: Business identifier
CREATE TABLE Lot (
    id BIGSERIAL PRIMARY KEY,
    lot_id VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. InspectionRecords Table
-- lot_id & defect_id: Surrogate FKs pointing to the .id of the parent tables
CREATE TABLE InspectionRecords (
    id BIGSERIAL PRIMARY KEY,
    inspection_id VARCHAR(100) NOT NULL UNIQUE,
    lot_id BIGINT NOT NULL,
    defect_id BIGINT NOT NULL,
    inspection_date DATE NOT NULL,
    qty_defects INTEGER NOT NULL CHECK (qty_defects >= 0),
    
    -- Fields from sample Excel logs
    inspection_time TIME,
    inspector VARCHAR(255),
    production_line VARCHAR(100),
    part_number VARCHAR(100),
    severity VARCHAR(50),
    qty_checked INTEGER,
    disposition VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Key Constraints with ON DELETE CASCADE
    CONSTRAINT fk_lot FOREIGN KEY (lot_id) REFERENCES Lot(id) ON DELETE CASCADE,
    CONSTRAINT fk_defect FOREIGN KEY (defect_id) REFERENCES Defect(id) ON DELETE CASCADE
);

-- 4. Performance Indexes
-- Optimized for AC7 (Drill-down by defect) and AC9 (Sorting/Filtering)
CREATE INDEX idx_inspection_records_defect_date ON InspectionRecords (defect_id, inspection_date);
CREATE INDEX idx_inspection_records_date ON InspectionRecords (inspection_date);
CREATE INDEX idx_inspection_records_lot ON InspectionRecords (lot_id);
CREATE INDEX idx_lot_id_search ON Lot (lot_id);
