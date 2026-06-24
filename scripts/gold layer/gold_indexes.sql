/*
For dim_customers and dim_products, we already have a clustered index. Because when we create a primary key for a table, automatically a clustered index will be created. 
    >> dim_products --> product_key(pk)
    >> dim_customers --> customer_key(pk)
So automatically clustered indexes are created for those tables.
*/

-- Creating the indexes for fact_sales table: (Non Clustered Indexes)
CREATE NONCLUSTERED INDEX idx_fact_sales_customer_key ON gold.fact_sales(customer_key);
CREATE NONCLUSTERED INDEX idx_fact_sales_product_key ON gold.fact_sales(product_key); 
