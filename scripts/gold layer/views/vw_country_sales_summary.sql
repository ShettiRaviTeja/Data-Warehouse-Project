/*
View Name: vw_country_sales_summary

Purpose:
Provides country-level sales metrics and KPIs
for geographical sales analysis and regional performance reporting.

Grain:
One Row = One Country

Consumers:
- Business Analysts
- Regional Sales Managers
- BI Developers
- Management

Key Metrics:
- Total Sales
- Total Customers
- Total Orders
- Total Quantity Sold
- Average Order Value
*/
CREATE VIEW gold.vw_country_sales_summary AS
  SELECT 
  	c.country,
  	SUM(f.sales_amount) AS total_sales,
  	COUNT(DISTINCT c.customer_id) AS total_customers,
  	COUNT(DISTINCT f.order_number) AS total_orders,
  	SUM(f.quantity) AS total_quantity,
  	CAST(SUM(f.sales_amount) * 1.0 / COUNT(DISTINCT f.order_number) AS DECIMAL(18, 2)) AS average_order_value
  FROM gold.dim_customers AS c
  INNER JOIN gold.fact_sales AS f
  ON c.customer_key = f.customer_key
  GROUP BY c.country;
