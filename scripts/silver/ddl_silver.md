````markdown
# 📦 DDL Script: Create Silver Tables

This script defines and creates all required tables under the `silver` schema in the **DataWarehouse**.  
It ensures any existing versions are dropped first to support schema resets or full reinitialization.

> ⚠️ **Warning**  
> Running this script will permanently drop and recreate all tables in the `silver` schema.  
> Ensure any important data is backed up prior to execution.

---

## 📑 Purpose

- Set up **clean and auditable** tables for the Silver layer.
- Standardize column naming, include technical metadata (`dwh_create_date`).
- Align with ETL architecture where Silver tables serve as **refined staging** for the Gold layer.

---

## 🛠️ SQL Script

```sql
/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Purpose:
    Defines and creates the tables under the 'silver' schema.
    If tables already exist, they are dropped before re-creation.

Usage:
    Run this script when resetting the Silver Layer schema structure.

Note:
    All tables include a [dwh_create_date] column for auditing.
===============================================================================
*/

-- ============================================================================
-- Table: silver.crm_cust_info
-- ============================================================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================================
-- Table: silver.crm_prd_info
-- ============================================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================================
-- Table: silver.crm_sales_details
-- ============================================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================================
-- Table: silver.erp_loc_a101
-- ============================================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================================
-- Table: silver.erp_cust_az12
-- ============================================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ============================================================================
-- Table: silver.erp_px_cat_g1v2
-- ============================================================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
```

---

## 📂 Tables Created

| Table Name                    | Description                                 |
|------------------------------|---------------------------------------------|
| `silver.crm_cust_info`       | Customer info from CRM system               |
| `silver.crm_prd_info`        | Product info from CRM system                |
| `silver.crm_sales_details`   | Sales transactions from CRM                 |
| `silver.erp_loc_a101`        | Customer location data from ERP             |
| `silver.erp_cust_az12`       | Demographics data from ERP                  |
| `silver.erp_px_cat_g1v2`     | Product category hierarchy from ERP         |

---
