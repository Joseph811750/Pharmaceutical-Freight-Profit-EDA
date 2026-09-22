# Pharmaceutical Freight & Profit Analytics (EDA)

### Project Overview
The objective of this project was to utilise SQL and Tableau to process and analyse real-world global pharmaceutical supply chain data. By engineering a relational database and visualising the cleaned metrics, my goal was to investigate underlying logistics trends, isolate severe budget leaks, and provide data-driven strategic recommendations to improve profit margins.

---

### Dataset & Technical Stack
**Data Source:** `SCMS_Delivery_History_Dataset.csv` (Global pharmaceutical delivery history, geographic routing, item values, and shipping timestamps).

**Technical Stack:**
* **SQL (SQLite):** Data modelling (Star Schema), Common Table Expressions (CTEs), Window Functions (`PARTITION BY`, `RANK`), date manipulation, and data quality guardrails (`IFNULL`, `CAST`).
* **Tableau:** KPIs, Geographic mapping, Top performing products and countries, Shipping delay vs profit margin.

---

### Workflow
1. **Data Modelling:** Imported the flat CSV into a SQL database and engineered a Star Schema, separating Location and Product dimensions from the central Shipment fact table.
2. **Data Cleaning:** Used a CTE to fix text anomalies and parsed non-standard date formats into ISO formatting.
3. **Metric Engineering:** Calculated true delivery delays in days and order profit.
4. **Aggregation & Trend Analysis:** Filtered and aggregated freight expenses by country and shipping mode to identify costs and shipment volumes.

---

### Insights

**1. The "Delay vs. Profit Margin" Hypothesis:**
Initially, I hypothesised that extended delivery delays were the cause of reduced profit margins. However, mapping Average Delivery Delay against Profit Margin in Tableau revealed an R-squared value of 0.007 (P-value: 0.60). This indicates that delivery times are not impacting profit margin, allowing the business to redirect its focus toward raw shipping expenses.

**2. Route Optimisation and Profitability:**
Analysis revealed that profit margins were typically higher on shipping routes with high shipment volume. This suggests established routes were optimised, whereas low-volume routes remain highly inefficient and costly.

**3. Nigeria Profit and Logistics:**
Nigeria is the company's most critical geographic market, generating the highest overall shipment volume and driving over $350 million in total revenue. However, this massive revenue stream masks a severe logistics leak: Nigeria also has the highest total freight costs (over $14.2M) and the second-highest average cost per shipment. This high unit cost could be driven by multiple factors, such as heavy volumetric weight, infrastructure bottlenecks, or localised fuel surcharges. 

**4. Budget Leaks in Low-Volume Routes:**
SQL analysis isolated specific high freight costs in low-volume regions:
* **Cameroon (Air Freight):** Costing nearly $1.44 million across just 61 shipments.
* **Rwanda (Ocean Freight):** Averaging $31,984 per single shipment for ocean transport.

---

### Strategic Recommendations

Based on the EDA findings, I recommend the following business actions:

* **Initiate a Vendor Audit in Nigeria:** To address Nigeria's exceptionally high average freight cost, we must audit local vendor contracts to ensure fair pricing. If the high costs are driven by physical cargo constraints or route complexity, we should negotiate bulk shipping discounts.
* **Investigate Rwanda & Cameroon Inefficiencies:** The $31,984/shipment ocean freight in Rwanda and the $1.44M air freight in Cameroon suggest severe operational inefficiencies. Renegotiating these specific contracts or rerouting these deliveries will immediately recover lost margin.
* **Pivot Focus from Speed to Cost:** Because the regression analysis (R²=0.007) proved that late deliveries do not significantly impact order profitability, the company should immediately stop paying premium rates for expedited shipping and transition non-emergency volume to cheaper transit modes.

---

### Project Files & Live Dashboard
* **Interactive Dashboard:** [View Freight & Profit Dashboard Here](https://public.tableau.com/app/profile/joseph.robertson1338/viz/dashboard_17900241268670/FREIGHTPROFITANALYTICS)
* **SQL Architecture:** Review the `table_creation.sql`, `data_cleaning.sql`, and `Freight_Cost_Analysis.sql` scripts for the Star Schema setup, data standardisation, and analytical aggregations.

--- 

### Author: 

Joseph Robertson  
* http://linkedin.com/in/joseph-r-786b79429
