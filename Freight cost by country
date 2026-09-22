/* ============================================================================
       To identify which specific countries and shipping methods are costing the 
       most. By ranking the average cost per shipment, we can pinpoint 
       inefficient shipping routes and recommend cost-saving alternatives.
       Utilises CAST to handle missing freight text, ensuring the aggregation 
       remains accurate.
    ============================================================================ */
    
SELECT 
        l.country, 
        f."Shipment Mode",
        ROUND(SUM(CAST(f."Freight Cost (USD)" AS REAL)), 2) AS total_freight_cost,
        ROUND(AVG(CAST(f."Freight Cost (USD)" AS REAL)), 2) AS avg_cost_per_shipment,
        COUNT(f.shipment_id) AS total_shipments_made

    FROM dim_location l
    INNER JOIN fact_shipment f ON l.location_id = f.location_id
WHERE f."Shipment Mode" IS NOT NULL 
      AND f."Shipment Mode" != ''
      AND f."Shipment Mode" != 'N/A'
      AND CAST(f."Freight Cost (USD)" AS REAL) > 0

    GROUP BY 
        l.country,
        f."Shipment Mode"
        
    ORDER BY 
        avg_cost_per_shipment DESC;
