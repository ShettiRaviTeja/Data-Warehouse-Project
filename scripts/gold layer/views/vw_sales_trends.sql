/*
View Name: vw_sales_trends

Purpose:
Provides time-based sales metrics and KPIs
to analyze sales trends, seasonality, and business growth over time.

Grain:
One Row = One Month

Consumers:
- Business Analysts
- BI Developers
- Management
- Finance Team

Key Metrics:
- Total Sales
- Total Orders
- Total Customers
- Total Quantity Sold
- Average Order Value
*/

CREATE VIEW gold.vw_sales_trends AS
  SELECT 
  	YEAR(f.order_date) AS year,
  	MONTH(f.order_date) AS month_number,
  	DATENAME(MONTH, f.order_date) AS month_name,
  	COUNT(DISTINCT order_number) total_orders,
  	SUM(f.sales_amount) AS total_sales,
  	COUNT(DISTINCT c.customer_id) AS total_customers,
  	SUM(f.quantity) AS total_quantity_sold,
  	CAST(SUM(f.sales_amount) * 1.0 / COUNT(DISTINCT f.order_number) AS DECIMAL(18, 2)) AS average_order_value
  FROM gold.fact_sales AS f
  INNER JOIN gold.dim_customers AS c
  ON f.customer_key = c.customer_key
  WHERE f.order_date IS NOT NULL
  GROUP BY 
  		YEAR(f.order_date),
  		MONTH(f.order_date),
  		DATENAME(MONTH, f.order_date);
