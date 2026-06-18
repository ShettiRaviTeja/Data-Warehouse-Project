/*
Stored Procedure to load the data from csv files to bronze layer.
	CSV -----> Bronze Layer

Purpose: 
		This script contains stored procedure which is used to load the data from external csv files to 'bronze' layer.
		What it will do:
			- It will truncate the bronze table before loading data.
			- It uses 'BULK INSERT' command to load the data at a time from external files.
Command to Execute this script:
		EXEC bronze.load_bronze;
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @Start_Time DATETIME, @End_Time DATETIME, @Bronze_Start_Time DATETIME, @Bronze_End_Time DATETIME
	BEGIN TRY
		SET @Bronze_Start_Time = GETDATE();
		PRINT '============================================'
		PRINT 'Loading the Bronze Layer'
		PRINT '============================================'

		PRINT '-------------------'
		PRINT 'Loading CRM Tables'
		PRINT '-------------------'

		SET @Start_Time = GETDATE();
		PRINT '>> Truncating the table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\shett\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @Start_Time, @End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '>> -------------------'

		SET @Start_Time = GETDATE();
		PRINT '>> Truncating the table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting data into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\shett\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @Start_Time, @End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '>> -------------------'

		SET @Start_Time = GETDATE();
		PRINT '>> Truncating the table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting data into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\shett\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @Start_Time, @End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '>> -------------------'

		PRINT '-------------------'
		PRINT 'Loading ERP tables'
		PRINT '-------------------'
		SET @Start_Time = GETDATE();
		PRINT '>> Truncating the table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting data into: bronze.erp_cust_az12;'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\shett\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @Start_Time, @End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '>> -------------------'

		SET @Start_Time = GETDATE();
		PRINT '>> Truncating the table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting data into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\shett\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @Start_Time, @End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '>> -------------------'

		SET @Start_Time = GETDATE();
		PRINT '>> Truncating the table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting data into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\shett\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @Start_Time, @End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '>> -------------------'

		SET @Bronze_End_Time = GETDATE()
		PRINT '==================================================='
		PRINT 'Bronze Layer is Loaded Successfully'
		PRINT '>>> TOTAL LOAD DURATION: ' + CAST(DATEDIFF(Second, @Bronze_Start_Time, @Bronze_End_Time) AS NVARCHAR) + ' Seconds'
		PRINT '==================================================='
	END TRY
	BEGIN CATCH
		PRINT '>>> ERROR OCCURED WHILE LOADING THE BRONZE LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR)
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR)
	END CATCH
END
