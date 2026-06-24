/*
View Name: vw_sales_details

Purpose:
Combines sales, customer, and product information
for detailed sales reporting and analysis.

Grain:
One Row = One Sales Transaction
*/

SELECT 
	f.order_number,
	f.order_date,
	f.shipping_date,
	f.due_date,
	f.price,
	f.quantity,
	f.sales_amount,
	c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	c.country,
	c.marital_status,
	c.gender,
	c.birthdate,
	p.product_id,
	p.product_number,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	p.product_line
FROM gold.fact_sales AS f
INNER JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
INNER JOIN gold.dim_products AS p
ON f.product_key = p.product_key;
