/* 
===================================
QUALITY CHECKS:
===================================
Script Purpose: 
			This script will perform different quality checks for data consistency, standardization and accuracy across the silver schema tables.
What checks it include:
			- NULL values or Duplicates
			- Unwanted spaces 
			- Data Standardization & Normalization
			- Consistency
			- Invalid Date Ranges
			- DataType Casting
*/

-- =======================================================
-- DATA QUALITY ISSUES of 'crm_cust_info':
-- =======================================================
-- 1. Check for NULL or Duplicates in  Primary Key
-- Result: NULLs and Duplicates are there
SELECT cst_id,
COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 2. Check for unwanted spaces
-- Result: Unwanted Spaces present in firstname and lastname
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

--3. Data Standardization & Consistency
-- Result: Readable format issue with marital_status and gndr
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;
-- ------------------
-- Quality Checks:
-- ------------------
-- 1. Check for NULL or Duplicates in  Primary Key
SELECT cst_id,
COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 2. Check for unwanted spaces
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

--3. Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;


-- =======================================================
-- DATA QUALITY ISSUES of 'crm_prd_info':
-- =======================================================
-- 1. Checking for NULL or Duplicates:
-- Result: No issues.
SELECT 
	prd_id,
	COUNT(prd_id)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1 OR prd_id IS NULL;

-- 2. Unwanted Spaces:
-- Result: No issues
SELECT * 
FROM bronze.crm_prd_info 
WHERE prd_nm <> TRIM(prd_nm);

-- 3. Checking NULLs or Negative Numbers:
-- Result: NULLs in the cost
SELECT *
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- 4. Standardization and Normalization:
-- Result: No Proper readable format
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

-- 5. Checking Date Order Issues:
-- Result: Date Orders are invalid
SELECT * 
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt
-- ------------------
-- Quality Checks:
-- ------------------
-- 3. Checking NULLs or Negative Numbers:
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- 4. Standardization and Normalization:
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- 5. Invalid Date Orders:
SELECT * 
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt


-- ================================================
-- Data Quality Issues of 'crm_sales_details'
-- ================================================
-- 1. Checking the values to convert it into DATE.
SELECT 
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) <> 8

-- 2. Check the data consistency among Sales, Quantity, Price
	-- Sales = Price * Quantity 
	-- Sales should not be NULL, ZERO or Negative.
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
OR sls_sales <> sls_quantity * sls_price
ORDER BY sls_sales, sls_quantity, sls_price;
-- --------------------
-- Quality Checks
-- --------------------
-- Data is Normalized
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
OR sls_sales <> sls_quantity * sls_price
ORDER BY sls_sales, sls_quantity, sls_price;


-- ==================================================
-- Data Quality Issues of 'erp_cust_az12'
-- ==================================================
-- Invalid or Out of Range BirthDate
SELECT
bdate
FROM bronze.erp_cust_az12
where bdate > GETDATE() OR bdate < '1925-01-01'

-- Non-Standardized Format
SELECT DISTINCT gen,
LEN(gen)
FROM bronze.erp_cust_az12
group by gen;
-- ---------------
-- Quality Check 
-- ---------------
-- BirthDate Validation
SELECT
bdate
FROM silver.erp_cust_az12
where bdate > GETDATE();

-- Gender Standardization
SELECT DISTINCT gen
FROM silver.erp_cust_az12;


-- =========================================
-- Data Quality Issues of 'erp_loc_a101'
-- =========================================
-- 1. Non-Standardized cid
SELECT *
FROM bronze.erp_loc_a101
WHERE cid NOT LIKE 'AW-%';

-- 2. Non-Standardized cntry
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;
-- -----------------------
-- QUALITY CHECKS
-- -----------------------
-- 1. Standardized cid
SELECT *
FROM silver.erp_loc_a101
WHERE cid LIKE 'AW-%';

-- 2. Standardized cntry
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;


-- ============================================
-- Data Quality Issues of 'erp_px_cat_g1v2'
-- ============================================
-- No Issues in this table.
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat <> TRIM(cat) or subcat <> TRIM(subcat) OR maintenance <> TRIM(maintenance);

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;
