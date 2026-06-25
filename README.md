# SQL Data Warehouse Project

## 📖 About the Project

This project demonstrates the development of a modern Data Warehouse using SQL Server. The goal is to integrate data from multiple source systems, clean and standardize the data, and transform it into a business-ready format for reporting and analytics.

The project follows the **Medallion Architecture** approach with Bronze, Silver, and Gold layers.

---

## 🏛️ Data Architecture

The data warehouse follows the Medallion Architecture (Bronze, Silver, Gold) to ensure scalable and maintainable data processing.
<p align="center">
  <img src="docs/images/data_architecture.png" width="900">
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
```
---

## Source Systems

The project integrates data from the following source systems:

### 🧑‍💼 CRM

* Customer Information
* Product Information
* Sales Details

### 🏢 ERP

* Customer Demographics
* Customer Location Information
* Product Categories

---

## 🥉 Bronze Layer

The Bronze layer stores raw data without applying any business transformations.

### Activities

* Data Ingestion
* Full Load Processing
* Raw Data Storage
* Source Data Preservation

### Tables

* crm_cust_info
* crm_prd_info
* crm_sales_details
* erp_cust_az12
* erp_loc_a101
* erp_px_cat_g1v2

---

## 🥈 Silver Layer

The Silver layer focuses on improving data quality and preparing data for analytics.

### Transformations Performed

* Data Type Conversion
* Data Validation
* Duplicate Removal
* Null Handling
* Date Standardization
* Country Standardization
* Gender Standardization
* Business Key Standardization
* Product History Tracking
* Data Quality Checks

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

## 🥇 Gold Layer

The Gold layer contains business-ready dimensional models designed for reporting and analytics.

### Data Modeling Approach

**Star Schema**

### Dimension Tables

* dim_customers
* dim_products

### Fact Tables

* fact_sales

### Key Features

* Surrogate Keys
* Business-Friendly Data Model
* Optimized for Reporting
* Single Source of Truth

---

## Technologies Used

| Category        | Technology |
| --------------- | ---------- |
| Database        | SQL Server |
| Language        | T-SQL      |
| Version Control | Git        |
| Repository      | GitHub     |
| Documentation   | Markdown   |

## 📚 Concepts Covered

* Data Warehousing
* ETL / ELT
* Data Ingestion
* Data Cleansing
* Data Validation
* Data Standardization
* Data Harmonization
* Data Modeling
* Star Schema
* Fact Tables
* Dimension Tables
* Surrogate Keys
* Data Quality Management

## 👨‍💻 Author

Ravi Teja Shettigari

This project was built as part of my Data Engineering and Data Warehousing learning journey.
