/*
View Name: vw_customer_sales_summary

Purpose:
Provides customer-level sales metrics and KPIs
for customer analytics, segmentation, and reporting.

Grain:
One Row = One Customer

Consumers:
- Business Analysts
- Sales Team
- BI Developers
- Management

Key Metrics:
- Total Sales
- Total Orders
- Total Quantity
- Average Order Value
- First Purchase Date
- Last Purchase Date
- Customer Lifespan
*/
CREATE VIEW vw_customer_sales_summary AS
	SELECT 
		c.customer_id,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		c.country,
		c.marital_status,
		c.gender,
		DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age,
		c.create_date,
		SUM(f.sales_amount) AS total_sales,
		COUNT(DISTINCT f.order_number) AS total_orders,
		SUM(f.quantity) AS total_quantity,
		CAST(SUM(f.sales_amount) * 1.0 / COUNT(DISTINCT f.order_number) AS DECIMAL(18,2)) AS average_order_value,
		MIN(f.order_date) AS first_purchase_date,
		MAX(f.order_date) AS last_purchase_date,
		DATEDIFF(DAY, MIN(f.order_date), MAX(f.order_date)) AS customer_lifespan
	FROM gold.fact_sales AS f
	INNER JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
	GROUP BY 
			c.customer_id,
			CONCAT(c.first_name, ' ', c.last_name),
			c.country,
			c.marital_status,
			c.gender,
			c.birthdate, 
			c.create_date;
