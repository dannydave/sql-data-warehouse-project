---

# 🥉 Stored Procedure Documentation: `bronze.load_bronze`

---

## 📋 Overview

This stored procedure `bronze.load_bronze` is designed to **load raw data into the Bronze layer** of the data warehouse. It serves as the **initial ingestion step** in the ETL pipeline, ingesting data from external CSV files into staging tables.

---

## 🎯 Purpose

* 🚮 **Clean slate:** Truncates existing data in Bronze tables before loading new data.
* 📥 **Bulk load:** Imports CSV data efficiently using `BULK INSERT`.
* 🕒 **Monitor:** Prints load status and duration for each table.
* ⚠️ **Error handling:** Catches and logs errors during loading.

---

## 🔍 Functionality Details

### 📂 Data Loading Process

* Processes two main groups of tables:

  * **CRM tables**: customer, product, and sales data.
  * **ERP tables**: location, customer demographics, product categories.
* For each table:

  * 🧹 Truncates old data.
  * 📊 Bulk loads CSV data.
  * ⏱ Logs duration for the load step.

### 📢 Status and Logging

* Displays console messages for:

  * Load start and completion per table.
  * Duration of load steps in seconds.
  * Overall batch execution time.
* Prints detailed error messages if loading fails.

---

## ⚙️ Parameters

* None (paths and table names are hardcoded).

---

## 🔄 Returns

* None (status printed in console only).

---

## 🚀 Usage

Run the procedure by executing:

```sql
EXEC bronze.load_bronze;
```

---

## ⚠️ Important Notes

* Ensure the CSV file paths exist and are accessible from the SQL Server host.
* Bronze tables must exist and have compatible schemas.
* SQL Server must have permissions to read source files.
* This procedure **does not perform data validation or transformations**.

---
---
