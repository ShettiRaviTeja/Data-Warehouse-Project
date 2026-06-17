/* 
=================================
CREATE DATABASE AND SCHEMAS
=================================
Purpose of this Script:
This script checks whether the 'DataWarehouse' database already exists. If it does, it terminates all active connections, rolls back uncommitted transactions, drops the existing database, and creates a fresh instance. This prevents errors caused by the database being in use during the recreation process. After that, 3 schemas will be created for 3 layers ('bronze', 'silver', 'gold') one for each.
*/

USE master;
GO

-- Drop and recreate the database
IF DB_ID('DataWarehouse') IS NOT NULL
BEGIN
	ALTER DATABASE DataWarehouse
	SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;

	DROP DATABASE DataWarehouse;
END
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Creating the schemas for differenct layers.
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
