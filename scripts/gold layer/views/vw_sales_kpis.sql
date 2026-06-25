/*
View Name: vw_sales_kpis

Purpose:
Provides executive-level business KPIs
for overall business performance monitoring
and executive dashboard reporting.

Grain:
One Row = Entire Business

Consumers:
- Executives
- Management
- Business Analysts
- BI Developers
- Finance Team

Key Metrics:
- Total Sales
- Total Orders
- Total Customers
- Total Products
- Total Quantity Sold
- Average Order Value
*/
CREATE VIEW gold.vw_sales_kpis AS
  SELECT 
  	SUM(f.sales_amount) AS total_sales,
  	COUNT(DISTINCT f.order_number) AS total_orders,
  	SUM(f.quantity) AS total_quantity,
  	CAST(SUM(f.sales_amount) * 1.0 / COUNT(DISTINCT f.order_number) AS DECIMAL(18, 2)) AS average_order_value,
  	COUNT(DISTINCT c.customer_id) AS total_customers,
  	COUNT(DISTINCT p.product_id) AS total_products
  FROM gold.fact_sales AS f
  INNER JOIN gold.dim_customers AS c
  ON c.customer_key = f.customer_key
  INNER JOIN gold.dim_products AS p
  ON f.product_key = p.product_key;
