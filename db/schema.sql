-- Drop tables if they exist (for clean re-execution)
DROP TABLE IF EXISTS "InspectionRecords" CASCADE;
DROP TABLE IF EXISTS "Defect" CASCADE;
DROP TABLE IF EXISTS "Lot" CASCADE;

-- 1. Defect Table
-- Logical entity: Defect
-- Requirement: Rename defect_code to defect_id, add surrogate PK 'id', add UNIQUE to defect_id.
CREATE TABLE "Defect" (
    "id" BIGSERIAL PRIMARY KEY,
    "defect_id" VARCHAR(100) NOT NULL UNIQUE,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Lot Table
-- Logical entity: Lot
-- Requirement: Add surrogate PK 'id', add UNIQUE to lot_id.
CREATE TABLE "Lot" (
    "id" BIGSERIAL PRIMARY KEY,
    "lot_id" VARCHAR(100) NOT NULL UNIQUE,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. InspectionRecords Table
-- Logical entity: InspectionRecords
-- Requirement: Add surrogate PK 'id', add UNIQUE to inspection_id.
-- Requirement: FKs with ON DELETE CASCADE to delete records in this table if parents are deleted.
CREATE TABLE "InspectionRecords" (
    "id" BIGSERIAL PRIMARY KEY,
    "inspection_id" VARCHAR(100) NOT NULL UNIQUE,
    "lot_fk" BIGINT NOT NULL,
    "defect_fk" BIGINT NOT NULL,
    "inspection_date" DATE NOT NULL,
    "qty_defects" INTEGER NOT NULL CHECK ("qty_defects" >= 0),
    
    -- Additional fields to accommodate sample Excel data
    "inspection_time" TIME,
    "inspector" VARCHAR(255),
    "production_line" VARCHAR(100),
    "part_number" VARCHAR(100),
    "severity" VARCHAR(50),
    "qty_checked" INTEGER CHECK ("qty_checked" >= 0),
    "disposition" VARCHAR(100),
    "notes" TEXT,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints with ON DELETE CASCADE
    CONSTRAINT "fk_lot" FOREIGN KEY ("lot_fk") REFERENCES "Lot"("id") ON DELETE CASCADE,
    CONSTRAINT "fk_defect" FOREIGN KEY ("defect_fk") REFERENCES "Defect"("id") ON DELETE CASCADE
);
-- AC9: General sorting and filtering performance.
CREATE INDEX "idx_inspection_records_date" ON "InspectionRecords" ("inspection_date");
CREATE INDEX "idx_inspection_records_lot" ON "InspectionRecords" ("lot_fk");
CREATE INDEX "idx_lot_id_search" ON "Lot" ("lot_id");
CREATE INDEX "idx_defect_id_search" ON "Defect" ("defect_id");

-- Verification: Show created tables
SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('Defect', 'Lot', 'InspectionRecords');
