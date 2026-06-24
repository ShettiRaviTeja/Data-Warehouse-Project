/*
View Name: vw_product_sales_summary

Purpose:
Provides product-level sales metrics and KPIs
for product performance analysis, inventory planning,
and sales reporting.

Grain:
One Row = One Product

Consumers:
- Business Analysts
- Sales Team
- Product Managers
- BI Developers
- Management

Key Metrics:
- Total Sales
- Total Orders
- Total Quantity Sold
- Average Order Value
- First Sale Date
- Last Sale Date
- Product Lifespan
*/
CREATE VIEW gold.vw_product_sales_summary AS
  SELECT
  	p.product_id,
  	p.product_name,
  	p.category,
  	p.subcategory,
  	p.cost,
  	p.product_line,
  	COUNT(DISTINCT f.order_number) AS total_orders,
  	SUM(f.sales_amount) AS total_sales,
  	SUM(f.quantity) AS total_quantity_sold,
  	CAST((SUM(f.sales_amount) * 1.0) / COUNT(DISTINCT f.order_number) AS DECIMAL(12, 2)) AS average_order_value,
  	MIN(f.order_date) AS first_sale_date,
  	MAX(f.order_date) AS last_sale_date,
  	DATEDIFF(DAY, MIN(f.order_date), MAX(f.order_date)) AS product_lifespan
  FROM gold.fact_sales AS f
  INNER JOIN gold.dim_products AS p
  ON f.product_key = p.product_key
  GROUP BY 
  		p.product_id,
  		p.product_name,
  		p.category,
  		p.subcategory,
  		p.cost,
  		p.product_line;
