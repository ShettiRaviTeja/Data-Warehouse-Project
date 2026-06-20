# SQL Data Warehouse Project

## About the Project

This project demonstrates the development of a Data Warehouse using SQL Server. The goal is to collect data from multiple source systems, clean and standardize it, and transform it into a format that can be used for reporting and analytics.

The project follows the Medallion Architecture approach with Bronze, Silver, and Gold layers.

## Source Systems

The project uses data from two source systems:

### CRM

* Customer Information
* Product Information
* Sales Details

### ERP

* Customer Demographics
* Customer Location Information
* Product Categories

---

## Bronze Layer

The Bronze layer stores raw data exactly as received from the source systems.

Activities performed:

* Data ingestion
* Full load processing
* Raw data storage

---

## Silver Layer

The Silver layer focuses on cleaning and preparing the data.

Transformations performed:

* Data type conversions
* Duplicate removal
* Date validation
* Null handling
* Data standardization
* Country standardization
* Gender standardization
* Business key standardization
* Data quality checks

Example:

```text
USA
US
United States

→ United States
```

---

## Gold Layer

The Gold layer contains business-ready data models that can be used for reporting and analytics.

Objects created:

* Dimension Tables
* Fact Tables
* Surrogate Keys
* Star Schema Model

---

## Technologies Used

* SQL Server
* T-SQL
* Git
* GitHub

## Concepts Covered

* Data Warehousing
* ETL / ELT
* Data Ingestion
* Data Cleansing
* Data Standardization
* Data Validation
* Data Modeling
* Star Schema
* Fact and Dimension Tables
* Surrogate Keys

## Author

Shettigari Ravi Teja

This project was created as part of my Data Engineering and Data Warehousing learning journey.
