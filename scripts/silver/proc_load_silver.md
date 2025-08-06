---

# 🛠️ Stored Procedure: `silver.load_silver`

This stored procedure performs the **ETL process from the Bronze to Silver layer** in the data warehouse.
It cleanses, standardizes, and transforms data, then loads it into the Silver schema tables.

---

## 📑 Overview

* **Schema**: `silver`
* **Object Type**: Stored Procedure
* **Name**: `load_silver`
* **Parameters**: None
* **Execution**:

  ```sql
  EXEC silver.load_silver;
  ```

---

## 🎯 Purpose

* **Truncate** Silver tables to refresh data.
* **Load** cleansed and standardized data from Bronze tables.
* **Apply** data transformations including trimming, normalization, and derived fields.

---

## 🔁 ETL Workflow

### 1. CRM Tables

* `silver.crm_cust_info`: Keeps latest records; standardizes marital status and gender; trims names.
* `silver.crm_prd_info`: Parses product keys; maps product lines; calculates end dates.
* `silver.crm_sales_details`: Validates and converts dates; calculates sales and price fields.

### 2. ERP Tables

* `silver.erp_cust_az12`: Cleans customer IDs; removes invalid birthdates; standardizes gender.
* `silver.erp_loc_a101`: Cleans location IDs; maps country codes to full names.
* `silver.erp_px_cat_g1v2`: Direct copy with no transformation.

---

## 🧪 Error Handling

* Wrapped in `TRY...CATCH`.
* On error, logs the error message, number, and state.

---

## 🕒 Logging

* Logs start, end, and duration of each load step.
* Logs total batch duration.

---

## 📌 Notes

* Requires Bronze tables pre-populated.
* Silver tables must already exist.
* `dwh_create_date` is automatically set by default values.

---

## ✅ Usage Example

```sql
EXEC silver.load_silver;
```

---
