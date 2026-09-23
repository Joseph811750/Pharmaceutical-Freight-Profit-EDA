/* ============================================================================
   PURPOSE: 
   This script utilises a (CTE) to clean messy date formats and standardise. 
   numerical costs, then applies window functions to calculate KPIs.
============================================================================ */

-- Isolate data type conversions and date formatting in a CTE 
WITH CleanedDates AS (
    SELECT 
        shipment_id,
        location_id,           
        product_id,            
        "Line Item Value" AS revenue,   
        
        -- Handle missing freight costs using CAST and IFNULL. 
        NULLIF(CAST("Freight Cost (USD)" AS REAL), 0) AS freight_cost,
        
        -- Date Formatting: Standardise string dates into ('YYYY-MM-DD') format
        '20' || SUBSTR("Scheduled Delivery Date", -2, 2) || '-' || 
        CASE LOWER(SUBSTR("Scheduled Delivery Date", -6, 3))
            WHEN 'jan' THEN '01' WHEN 'feb' THEN '02' WHEN 'mar' THEN '03'
            WHEN 'apr' THEN '04' WHEN 'may' THEN '05' WHEN 'jun' THEN '06'
            WHEN 'jul' THEN '07' WHEN 'aug' THEN '08' WHEN 'sep' THEN '09'
            WHEN 'oct' THEN '10' WHEN 'nov' THEN '11' WHEN 'dec' THEN '12'
        END || '-' || 
        CASE WHEN LENGTH("Scheduled Delivery Date") = 8 
             THEN '0' || SUBSTR("Scheduled Delivery Date", 1, 1)
             ELSE SUBSTR("Scheduled Delivery Date", 1, 2) 
        END AS clean_scheduled_date,

        '20' || SUBSTR("Delivered to Client Date", -2, 2) || '-' || 
        CASE LOWER(SUBSTR("Delivered to Client Date", -6, 3))
            WHEN 'jan' THEN '01' WHEN 'feb' THEN '02' WHEN 'mar' THEN '03'
            WHEN 'apr' THEN '04' WHEN 'may' THEN '05' WHEN 'jun' THEN '06'
            WHEN 'jul' THEN '07' WHEN 'aug' THEN '08' WHEN 'sep' THEN '09'
            WHEN 'oct' THEN '10' WHEN 'nov' THEN '11' WHEN 'dec' THEN '12'
        END || '-' || 
        CASE WHEN LENGTH("Delivered to Client Date") = 8 
             THEN '0' || SUBSTR("Delivered to Client Date", 1, 1)
             ELSE SUBSTR("Delivered to Client Date", 1, 2) 
        END AS clean_delivered_date

    FROM fact_shipment
)

-- Join dimensions back to the facts to create a flat, dataset
SELECT 
    c.shipment_id,
    l.country,
    l.manufacturing_site,
    p.product_group,
    p.sub_classification,
    c.revenue,
    c.freight_cost,
    
    -- KPI Calculation
    -- Converting profits to null, missing freight cost values to avoid
    -- artificially inflating profit margins.
ROUND(
    CASE 
        WHEN c.freight_cost IS NULL THEN NULL 
        ELSE c.revenue - c.freight_cost 
    END, 2
) AS order_profit,
    
    -- Ranking revenues within their specific product categories
    RANK() OVER(PARTITION BY p.product_group ORDER BY c.revenue DESC) AS category_revenue_rank,
    
    c.clean_scheduled_date,
    c.clean_delivered_date,
    
    -- Calculating the exact number of days a shipment was early/delayed
    julianday(c.clean_delivered_date) - julianday(c.clean_scheduled_date) AS delivery_delay

FROM CleanedDates c
-- Re-attaching geographic and product dimensions using LEFT JOINs to preserve all shipments
LEFT JOIN dim_location l ON c.location_id = l.location_id
LEFT JOIN dim_product p ON c.product_id = p.product_id
WHERE delivery_delay IS NOT NULL
ORDER BY p.product_group, category_revenue_rank;
