/*
Stored Procedure to load the data from silver layer to gold layer.
	Silver Layer -----> Gold Layer

Purpose: 
		This script contains stored procedure which is used to load the data from 'silver' to 'gold' layer.
		What it will do:
			- It will truncate the gold layer tables before loading data.
			- Cleaned data will get inserted into the tables from silver layer.
Command to Execute this script:
		EXEC gold.load_gold;
*/

CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @gold_start_time DATETIME, @gold_end_time DATETIME
	BEGIN TRY
		SET @gold_start_time = GETDATE();
		PRINT '========================================'
		PRINT 'Loading the Gold Layer'
		PRINT '========================================'

		PRINT '-----------------------------------'
		PRINT 'Loading Dimension Tables'
		PRINT '-----------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: gold.dim_customers'
		TRUNCATE TABLE gold.dim_customers;
		PRINT '>> Inserting data into: gold.dim_customers'
		INSERT INTO gold.dim_customers 
		(
			customer_id,
			customer_number,
			first_name,
			last_name,
			country,
			marital_status,
			gender,
			birthdate,
			create_date
		)
		SELECT 
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds';
		PRINT '---------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: gold.dim_products'
		TRUNCATE TABLE gold.dim_products;
		PRINT '>> Inserting into table: gold.dim_products'
		INSERT INTO gold.dim_products
		(
			product_id,
			product_number,
			product_name,
			category_id,
			category,
			subcategory,
			maintenance,
			cost,
			product_line,
			start_date
		)
		SELECT 
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds'
		PRINT '---------------------------'

		PRINT '-----------------------------'
		PRINT 'Loading fact Table'
		PRINT '-----------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: gold.fact_sales'
		TRUNCATE TABLE gold.fact_sales;
		PRINT '>> Inserting into table: gold.fact_sales'
		INSERT INTO gold.fact_sales
		(
			order_number,
			product_key,
			customer_key,
			order_date,
			shipping_date,
			due_date,
			sales_amount,
			quantity,
			price
		)
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
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds'
		PRINT '---------------------------'

		SET @gold_end_time = GETDATE();
		PRINT '==================================='
		PRINT 'Gold Layer Loaded Successfully' 
		PRINT '>>> Total Load Duration: ' + CAST(DATEDIFF(SECOND, @gold_start_time, @gold_end_time) AS VARCHAR) + ' Seconds'
		PRINT '==================================='
	END TRY 

	BEGIN CATCH
		PRINT '>> ERROR OCCURED WHILE LOADING THE SILVER LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Number: ' + ERROR_NUMBER()
		PRINT 'Error State: ' + ERROR_STATE() 
	END CATCH 
END
GO
