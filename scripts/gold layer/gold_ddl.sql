/*
===========================================
DDL Script to create Gold Layer Views
===========================================
Purpose: 
        By running this script, the views will be created for the gold layer. Gold Layer contains dimension and fact tables. These views can be directly used for the analytics and reports. 
*/

-- View for the Customers dimension table.
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
  DROP VIEW gold.dim_customers;
GO
  
CREATE OR ALTER VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE 
		WHEN ci.cst_gndr <> 'Unknown' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'Unknown')
	END AS gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.cid;
GO

-- View for the Products dimension table.
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
  DROP VIEW gold.dim_products;
GO
  
CREATE VIEW gold.dim_products AS 
SELECT 
	ROW_NUMBER() OVER(ORDER BY prd_start_dt, pri.prd_id) product_key,
	pri.prd_id AS product_id,
	pri.prd_key AS product_number,
	pri.prd_nm AS product_name,
	pri.cat_id AS category_id,
	prc.cat AS category,
	prc.subcat AS subcategory,
	prc.maintenance,
	pri.prd_cost AS cost,
	pri.prd_line AS product_line,
	pri.prd_start_dt AS start_date
FROM silver.crm_prd_info pri
LEFT JOIN silver.erp_px_cat_g1v2 prc
ON pri.cat_id = prc.id
WHERE prd_end_dt IS NULL; -- Removing all historical data.
GO

-- View for the sales fact table.
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
  DROP VIEW gold.fact_sales;
GO
  
CREATE VIEW gold.fact_sales AS
SELECT 
	sls_ord_num AS order_number,
	dp.product_key,
	dc.customer_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS quantity,
	sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products dp
ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.customer_id;
GO
