/*  
====================================
Quality Checks for the Gold Layer
====================================
Purpose: 
        This script will check quality of the data by checking the uniqueness of the surrogate keys which is used to connect the dimension tables with fact tables.
*/

-- Foreign Key Integrity (Dimensions)
SELECT * 
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON dc.customer_key = fs.customer_key
LEFT JOIN gold.dim_products dp
ON dp.product_key = fs.product_key
WHERE dc.customer_key IS NULL OR dp.product_key IS NULL;

-- Uniqueness: Checking gold.product_key
SELECT 
	product_key, 
	count(*)
FROM gold.dim_products
GROUP BY product_key
HAVING count(*) > 1;

-- Uniqueness: Checking gold.customer_key
SELECT 
	customer_key, 
	count(*)
FROM gold.dim_customers
GROUP BY customer_key
HAVING count(*) > 1;
