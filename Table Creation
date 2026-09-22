/* ============================================================================
   This script engineers a Star Schema from the raw dataset. 
   It separates dimension tables (Location and Product) from the fact table 
   (Shipments) to optimise query speed and prepare a master dataset for 
   Tableau visualisations.
============================================================================ */

-- Cleaning up old tables
-- Ensures this script can be re-run without errors.
DROP TABLE IF EXISTS dim_location;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS fact_shipment;

-- Creating the Location Dimension Table
CREATE TABLE dim_location (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    country TEXT,
    manufacturing_site TEXT
);

INSERT INTO dim_location (country, manufacturing_site)
SELECT DISTINCT 
    "Country", 
    "Manufacturing Site" 
FROM "SCMS_Delivery_History_Dataset"
WHERE "Country" IS NOT NULL;

-- Creating the Product Dimension Table 
CREATE TABLE dim_product (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_group TEXT,
    sub_classification TEXT,
    molecule_test_type TEXT,
    brand TEXT,
    dosage TEXT,
    dosage_form TEXT,
    item_description TEXT
);

INSERT INTO dim_product (product_group, sub_classification, molecule_test_type, brand, dosage, dosage_form, item_description)
SELECT DISTINCT 
    "Product Group", 
    "Sub Classification", 
    "Molecule/Test Type",
    "Brand",
    "Dosage",
    "Dosage Form",
    "Item Description"
FROM "SCMS_Delivery_History_Dataset"
WHERE "Item Description" IS NOT NULL;

-- Creating the Shipment Fact Table 
-- Using LEFT JOINs to connect the dimension IDs back to the
-- shipment records, ensuring no shipment data is lost, even
-- if location or product details are missing.
CREATE TABLE fact_shipment AS
SELECT 
    r."ID" AS shipment_id,
    r."Project Code",
    l.location_id,
    p.product_id,
    r."Vendor",
    r."Shipment Mode",
    r."Scheduled Delivery Date",
    r."Delivered to Client Date",
    r."Line Item Quantity",
    r."Line Item Value",
    r."Unit Price",
    r."Weight (Kilograms)",
    r."Freight Cost (USD)",
    r."Line Item Insurance (USD)"
FROM "SCMS_Delivery_History_Dataset" r
-- Connect location data using compound keys (Country + Site)
LEFT JOIN dim_location l 
    ON r."Country" = l.country 
    AND r."Manufacturing Site" = l.manufacturing_site
-- Connect product data 
LEFT JOIN dim_product p 
    ON r."Item Description" = p.item_description;
