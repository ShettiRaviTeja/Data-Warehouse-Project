# Data Catalog for Gold Layer
## Overview
The Gold Layer contains business-ready data modeled using **Fact tables** and **Dimension tables**. It is optimized for reporting, analytics, and dashboarding, providing a single source of truth for business users and BI tools.

### 1. gold.dim_customers
- Purpose: Stores enriched descriptive information about the customers.
- Columns:

|Column Name|Data Type|Description
|-----------|---------|-----------|
|customer_key|INT|Surrogate Key used to identify each customer record in the dimension table.
|customer_id|INT| Unique numerical identifier assigned to each customer.
|customer_number|NVARCHAR(50)|Alphanumeric identifier assigned to customers for tracking.
|first_name|NVARCHAR(50)|Firstname of the customer as per the source system.
|last_name|NVARCHAR(50)|Lastname or family name of the customer.
|country|NVARCHAR(50)|Customer's country (e.g: Germany)
|marital_status|NVARCHAR(50)|Marital Status of customer (e.g: Married, Single)
|gender|NVARCHAR(50)|Customer's gender (e.g: Male, Female, Unknown)
|birthdate|DATE|Customer's date of birth in the following format (YYYY-MM-DD)
|create_date|DATE|Create date of the customer in the system

### 2. gold.dim_products
- Purpose: Stores information & provide the detailed description about the products.
- Columns:

|Column Name|Data Type|Description
|-----------|---------|-----------|
|product_key|INT|Surrogate Key used to identify the each product record in the dimension table.
|product_id|INT|Numerical identifier assigned to the product for the tracking.
|product_number|NVARCHAR(50)|A structured alphanumeric identifier for the different categories.
|product_name|NVARCHAR(50)|Name of the product along with the size, color.
|category_id|NVARCHAR(50)|ID that represents the product category used for the classification.
|category|NVARCHAR(50)|Classification of the products like Bikes, Clothing, Components, etc.
|subcategory|NVARCHAR(50)|Second level of classification under the category like Lights, Shorts, Road Bikes, etc.
|maintenance|NVARCHAR(50)|Tells whether the product required maintenance or not. (Yes, No)
|cost|INT|Cost or base price of the product
product_line|NVARCHAR(50)|Specific product line or series to which the product belongs. (e.g: Mountains, Road, etc.)
|start_date|DATE|Date when the product became available or came into use.

### 3. gold.fact_sales
- Purpose: Stores transactional sales data for the analytics or business reports purpose.
- Columns:

|Column Name|Data Type|Description
|-----------|---------|-----------|
|order_number|NVARCHAR(50)|Unique alphanumeric identifier assigned to each order.
|product_key|INT|Surrogate Key of the products dimension table used to join with the fact table easily.
|customer_key|INT|Surrogate Key of the customers dimension table used to join with the fact table easily.
|order_date|DATE|The date of the order received from the customer.
|shipping_date|DATE|The date of the order that shipped to the customer.
|due_date|DATE|The date when the order payment was due.
|sales_amount|INT|The total sales of the product.
|quantity|INT|The number of units ordered by the customer.
|price|INT|The price of the each product.
