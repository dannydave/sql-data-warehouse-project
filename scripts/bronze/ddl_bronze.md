---

# 🥉 Bronze Layer Table Creation Script

---

## 📋 Overview

This script defines and creates all the necessary tables within the **`bronze` schema** for the Bronze layer of the data warehouse.

---

## 🎯 Purpose

* 🔄 **Drop and recreate:** Ensures tables are dropped if they exist and then recreated for a fresh, consistent schema.
* 🏗️ **Structure reset:** Use this script to reset or initialize the Bronze layer table structures before loading any data.
* 📊 **Tables cover:** CRM and ERP source systems, including customer, product, sales, location, and category data.

---

## ⚙️ Table Details

---

### 🧾 CRM Tables

| Table Name          | Description               | Key Columns                  |
| ------------------- | ------------------------- | ---------------------------- |
| `crm_cust_info`     | Customer demographic info | `cst_id`, `cst_key`          |
| `crm_prd_info`      | Product master data       | `prd_id`, `prd_key`          |
| `crm_sales_details` | Sales transaction details | `sls_ord_num`, `sls_prd_key` |

---

### 🏢 ERP Tables

| Table Name        | Description               | Key Columns           |
| ----------------- | ------------------------- | --------------------- |
| `erp_loc_a101`    | Store locations           | `cid`, `cntry`        |
| `erp_cust_az12`   | ERP Customer demographics | `cid`, `bdate`, `gen` |
| `erp_px_cat_g1v2` | Product categories        | `id`, `cat`, `subcat` |

---

## 📝 Full Script

```sql
/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Purpose:
    This script creates all required tables in the 'bronze' schema.
    Existing tables will be dropped and recreated to ensure a consistent schema.
    Run this script to reset the structure of Bronze layer tables.
===============================================================================
*/

/*
===============================================================================
CREATING BRONZE TABLES
===============================================================================
*/

-- =============================================================
-- CRM: Customer Information
-- =============================================================
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);
GO

-- =============================================================
-- CRM: Product Information
-- =============================================================
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

-- =============================================================
-- CRM: Sales Details
-- =============================================================
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO

-- =============================================================
-- ERP: Store Location (A101)
-- =============================================================
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- =============================================================
-- ERP: Customer Info (AZ12)
-- =============================================================
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO

-- =============================================================
-- ERP: Product Categories (G1V2)
-- =============================================================
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO
```

---
