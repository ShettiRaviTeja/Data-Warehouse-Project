# SQL Data Warehouse Project

## 📖 About the Project

This project demonstrates the design and implementation of a modern **SQL Server Data Warehouse** following the **Medallion Architecture (Bronze, Silver, Gold)**. Data from multiple CRM and ERP source systems is extracted, cleansed, standardized, integrated, and transformed into a business-ready dimensional model for reporting and analytics.

The project covers the complete Data Warehouse development lifecycle, including data ingestion, ETL processing, dimensional modeling, and reporting layer creation using SQL Server.

---

# 🏛️ Data Architecture

<p align="center">
  <img src="docs/Data Architecture.png" width="900">
</p>

### Architecture Flow

```text
Source Systems
      ↓
Bronze Layer
      ↓
Silver Layer
      ↓
Gold Layer
      ↓
Business Users / BI Tools
```

---

# 📂 Source Systems

The warehouse integrates data from two operational systems.

## 🧑‍💼 CRM System

* Customer Information
* Product Information
* Sales Details

## 🏢 ERP System

* Customer Demographics
* Customer Location Information
* Product Categories

---

# 🥉 Bronze Layer (Raw Data)

The Bronze layer stores raw data exactly as received from the source systems.

### Features

* Raw Data Ingestion
* Full Load Processing
* Source Data Preservation
* Minimal Transformations

### Tables

* crm_cust_info
* crm_prd_info
* crm_sales_details
* erp_cust_az12
* erp_loc_a101
* erp_px_cat_g1v2

---

# 🥈 Silver Layer (Cleaned Data)

The Silver layer cleanses, validates, standardizes, and enriches the data before loading it into the analytical model.

### Transformations Performed

* Data Type Conversion
* Duplicate Removal
* Null Handling
* Data Validation
* Business Key Standardization
* Country Standardization
* Gender Standardization
* Product History Tracking
* Data Quality Checks
* Business Rule Implementation

### Example Transformations

#### Business Key Standardization

```text
NASAW00011000
↓
AW00011000
```

#### Country Standardization

```text
USA
US
United States
↓
United States
```

#### Date Conversion

```text
20120630
↓
2012-06-30
```

---

# 🥇 Gold Layer (Business-Ready Data)

The Gold layer implements a dimensional model using a **Star Schema** optimized for reporting and analytics.

## ⭐ Data Modeling Approach

Star Schema

### Dimension Tables

* dim_customers
* dim_products

### Fact Table

* fact_sales

### Reporting Views

* vw_sales_details
* vw_customer_sales_summary
* vw_product_sales_summary
* vw_country_sales_summary
* vw_sales_trends
* vw_sales_kpis

### Gold Layer Features

* Star Schema
* Surrogate Keys
* Business-Friendly Data Model
* Reporting Views
* Business KPIs
* Optimized for Analytics
* Single Source of Truth

---

# 📊 Reporting Views

The reporting layer provides reusable business-ready views for dashboards and analytics.

| View                      | Grain                 | Purpose                      |
| ------------------------- | --------------------- | ---------------------------- |
| vw_sales_details          | One Sales Transaction | Detailed sales reporting     |
| vw_customer_sales_summary | One Customer          | Customer analytics           |
| vw_product_sales_summary  | One Product           | Product performance analysis |
| vw_country_sales_summary  | One Country           | Country-wise sales analysis  |
| vw_sales_trends           | One Month             | Monthly sales trend analysis |
| vw_sales_kpis             | Entire Business       | Executive KPI dashboard      |

---

# 🛠️ Technologies Used

| Category        | Technology             |
| --------------- | ---------------------- |
| Database        | SQL Server             |
| Language        | T-SQL                  |
| Architecture    | Medallion Architecture |
| Data Model      | Star Schema            |
| Version Control | Git                    |
| Repository      | GitHub                 |
| Documentation   | Markdown               |
| Diagramming     | Draw.io                |

---

# 📚 Concepts Covered

* Data Warehousing
* ETL / ELT
* Medallion Architecture
* Data Ingestion
* Data Cleansing
* Data Validation
* Data Standardization
* Data Harmonization
* Dimensional Modeling
* Star Schema
* Fact Tables
* Dimension Tables
* Surrogate Keys
* Business Keys
* Reporting Layer Design
* SQL Views
* KPI Reporting
* Data Quality Management

---

# 🚀 Future Enhancements

* Power BI Dashboard
* Incremental Data Loading
* Change Data Capture (CDC)
* SQL Agent Job Scheduling
* Data Quality Monitoring
* Automated ETL Pipeline

---

# 👨‍💻 Author

**Ravi Teja Shettigari**

This project was built as part of my Data Engineering and Data Warehousing learning journey to strengthen practical skills in SQL, ETL, dimensional modeling, and business reporting.
