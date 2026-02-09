# This is a demo showing how to embed mermaid.js code in md
## InspectionRecords 
inspection_date qty_defects 
## Lot 
lot_id 
## Defect 
defect_code 
## Relationships 
One lot can have many inspection records 

One defect can exist in many inspection records

# ERD Diagram
```mermaid
erDiagram
    LOT ||--o{ INSPECTION_RECORD : has
    INSPECTION_RECORD }o--o{ DEFECT : includes

    LOT {
        lot_id attribute
    }

    INSPECTION_RECORD {
        inspection_date attribute
        qty_defects attribute
    }

    DEFECT {
        defect_code attribute
    }
```
