/*
Stored Procedure to load the data from bronze to silver layer.
	Bronze Layer -----> Silver Layer

Purpose: 
		This script contains stored procedure which is used to load the data from 'bronze' to 'silver' layer.
		What it will do:
			- It will truncate the silver layer tables before loading data.
			- Cleaned data will get inserted into the tables from bronze layer.
Command to Execute this script:
		EXEC silver.load_silver;
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @silver_start_time DATETIME, @silver_end_time DATETIME
	BEGIN TRY
		SET @silver_start_time = GETDATE();
		PRINT '========================================'
		PRINT 'Loading the Silver Layer'
		PRINT '========================================'

		PRINT '-----------------------------------'
		PRINT 'Loading CRM Tables'
		PRINT '-----------------------------------'
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting data into: silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info
		(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status, 
			cst_gndr, 
			cst_create_date
		)

		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) cst_firstname, -- Removing unwanted leading and trailing spaces from firstname and lastname
			TRIM(cst_lastname) cst_lastname,
			CASE 
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				ELSE 'Unknown'
			END cst_marital_status, -- Standardize the marital status values to reabable format
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				ELSE 'Unknown'
			END cst_gndr, -- Standardize the gender values to readable format
			cst_create_date
		FROM
		(
			SELECT *,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) LatestCreationRank
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t
		WHERE LatestCreationRank = 1; -- Selecting the latest record of customer;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds';
		PRINT '---------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting into table: silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info 
		(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') cat_id, -- Extract Category ID
			SUBSTRING(prd_key, 7, LEN(prd_key)) prd_key, -- Extract Product Key
			prd_nm,
			COALESCE(prd_cost, 0) prd_cost, -- NULLs replaced with 0
			CASE UPPER(TRIM(prd_line))
				WHEN 'R' THEN 'Road'
				WHEN 'M' THEN 'Mountains'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'Unknown'
			END prd_line, -- Standardize to readable format
			CAST(prd_start_dt AS DATE) prd_start_dt, -- Casting to DATE
			CAST(
				DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS DATE
				) prd_end_date -- Calculating end date as one day before the next start date
		FROM bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds'
		PRINT '---------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting into table: silver.crm_sales_details';
		WITH crm_sales AS
		(
		SELECT 
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					TRY_CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) sls_order_dt, -- Casting the INT into DATE
					TRY_CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) sls_ship_dt,
					TRY_CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) sls_due_dt,
					CASE 
						WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales <> sls_quantity * ABS(sls_price)
							THEN sls_quantity * ABS(sls_price)
						ELSE sls_sales
					END sls_sales, -- Handling the NULLs, Zeroes and Wrong Calculations in Sales
					sls_quantity,
					CASE 
						WHEN sls_price IS NULL OR sls_price <= 0 
							THEN sls_sales / NULLIF(sls_quantity, 0) 
						ELSE sls_price
					END sls_price -- Handling the NULLs, Zeroes, negative values in Price
				FROM bronze.crm_sales_details
		)
		INSERT INTO silver.crm_sales_details
				(
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					sls_order_dt,
					sls_ship_dt,
					sls_due_dt,
					sls_sales,
					sls_quantity,
					sls_price
				)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
					THEN NULL
				ELSE sls_order_dt
			END sls_order_dt, -- Handling invalid dates
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		FROM crm_sales;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds'
		PRINT '---------------------------'

		PRINT '----------------------------------'
		PRINT 'Loading ERP Tables'
		PRINT '----------------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting into table: silver.erp_cust_az12'
		INSERT INTO silver.erp_cust_az12
		(
			cid,
			bdate,
			gen
		)
		SELECT
			CASE 
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
				ELSE cid
			END cid,
			CASE 
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END bdate,
			CASE 
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				ELSE 'Unknown'
			END gen
		FROM bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds'
		PRINT '---------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting into table: silver.erp_loc_a101'
		INSERT INTO silver.erp_loc_a101 
		(
			cid,
			cntry
		)
		SELECT 
			REPLACE(cid, '-', '') cid,
			CASE
				WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
				WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
				WHEN UPPER(TRIM(cntry)) = '' OR cntry IS NULL THEN 'Unknown'
				ELSE TRIM(cntry)
			END cntry
		FROM bronze.erp_loc_a101;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds'
		PRINT '---------------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating the table: silver.erp_px_cat_g1v2 '
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting the table: silver.erp_px_cat_g1v2 '
		INSERT INTO silver.erp_px_cat_g1v2 
		(
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' Seconds';
		PRINT '---------------------------'

		SET @silver_end_time = GETDATE();
		PRINT '==================================='
		PRINT 'Silver Layer Loaded Successfully' 
		PRINT '>>> Total Load Duration: ' + CAST(DATEDIFF(SECOND, @silver_start_time, @silver_end_time) AS VARCHAR) + ' Seconds'
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
