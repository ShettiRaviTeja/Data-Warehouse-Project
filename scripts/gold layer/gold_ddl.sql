/*
  ==================================================
  DDL Script to create the tables for gold layer
  ==================================================
*/

-- DDL design for dim_customers table
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL
	DROP TABLE gold.dim_customers;
GO

CREATE TABLE gold.dim_customers
(
	customer_key INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	customer_id INT,							-- Business Key
	customer_number NVARCHAR(50),
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	country NVARCHAR(50),
	marital_status NVARCHAR(50),
	gender NVARCHAR(50),
	birthdate DATE,
	create_date DATE
);
GO

-- DDL design for dim_products table
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL
	DROP TABLE gold.dim_products;
GO

CREATE TABLE gold.dim_products
(
	product_key INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
	product_id INT,							   -- Business Key
	product_number NVARCHAR(50),
	product_name NVARCHAR(50),
	category_id NVARCHAR(50),
	category NVARCHAR(50),
	subcategory NVARCHAR(50),
	maintenance NVARCHAR(50),
	cost INT,
	product_line NVARCHAR(50),
	start_date DATE
);
GO

-- DDL design for fact_sales table
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
	DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales
(
	order_number NVARCHAR(50),
	product_key INT,					-- Foreign Key
	customer_key INT,					-- Foreign Key
	order_date DATE,
	shipping_date DATE,
	due_date DATE,
	sales_amount INT,
	quantity INT,
	price INT
);


-- Creating the indexes for fact_sales table:
CREATE INDEX idx_fact_sales_customer_key ON gold.fact_sales(customer_key);
CREATE INDEX idx_fact_sales_product_key ON gold.fact_sales(product_key);
