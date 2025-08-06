# 🛠️ Stored Procedure: `silver.load_silver`

This stored procedure performs ETL from the **Bronze** to **Silver** layer in a Data Warehouse.  
It applies transformations, cleanses data, and ensures schema alignment with `silver` tables.



sql_code = """
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT 'Starting Load: Silver Layer';
        PRINT '================================================';

        --------------------------------------------------------------------------------
        -- CRM TABLES
        --------------------------------------------------------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        -- Load silver.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserting: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cst_id, cst_key, 
            cst_firstname, 
            cst_lastname, 
            cst_marital_status, 
            cst_gndr, 
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname),
            TRIM(cst_lastname),
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END,
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1;

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load silver.crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserting: silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
            SUBSTRING(prd_key, 7, LEN(prd_key)),
            prd_nm,
            ISNULL(prd_cost, 0),
            CASE
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END,
            CAST(prd_start_dt AS DATE),
            CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load silver.crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> Truncating: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserting: silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num, 
            sls_prd_key, 
            sls_cust_id, 
            sls_order_dt, 
            sls_ship_dt, 
            sls_due_dt,
            sls_sales, 
            sls_quantity, 
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
            END,
            CASE 
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
            END,
            CASE 
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
            END,
            CASE
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END,
            sls_quantity,
            CASE
                WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END
        FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        --------------------------------------------------------------------------------
        -- ERP TABLES
        --------------------------------------------------------------------------------
        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

        -- Load silver.erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>> Truncating: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Inserting: silver.erp_cust_az12';
        INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
        SELECT
            CASE 
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
                ELSE cid 
            END,
            CASE 
                WHEN bdate > GETDATE() THEN NULL 
                ELSE bdate 
            END,
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END
        FROM bronze.erp_cust_az12;

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load silver.erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>> Truncating: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Inserting: silver.erp_loc_a101';
        INSERT INTO silver.erp_loc_a101 (cid, cntry)
        SELECT
            REPLACE(cid, '-', ''),
            CASE
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END
        FROM bronze.erp_loc_a101;

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- Load silver.erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>> Truncating: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Inserting: silver.erp_px_cat_g1v2';
        INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
        SELECT id, cat, subcat, maintenance
        FROM bronze.erp_px_cat_g1v2;

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        --------------------------------------------------------------------------------
        -- COMPLETION
        --------------------------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '================================================';
        PRINT 'Silver Layer Load Completed';
        PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '================================================';

    END TRY
    BEGIN CATCH
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '================================================';
    END CATCH
---

## 📌 Summary

- **Schema**: `silver`
- **Object Type**: Stored Procedure
- **Name**: `load_silver`
- **Input Parameters**: _None_
- **Usage**:  
  ```sql
  EXEC silver.load_silver;
  ```

---

## 📑 Purpose

- **Reset** all silver-layer tables via `TRUNCATE`.
- **Load** fresh, cleansed, and transformed data from the `bronze` layer.
- **Standardize** data using trimming, case normalization, null handling, and derived fields.

---

## 🔁 ETL Process Steps

### 1. CRM Tables

#### 🧾 `silver.crm_cust_info`
- **Transforms**:
  - Keep latest customer record (ROW_NUMBER by `cst_id`).
  - Standardize `marital_status` and `gender`.
  - Trim `firstname` and `lastname`.

#### 📦 `silver.crm_prd_info`
- **Transforms**:
  - Parse and split `prd_key`.
  - Map product line codes (e.g. `M`, `R`) to readable values.
  - Derive `prd_end_dt` using `LEAD()` function.

#### 💸 `silver.crm_sales_details`
- **Transforms**:
  - Handle invalid date formats.
  - Derive `sls_sales` if missing or inconsistent.
  - Derive `sls_price` if missing using back-calculation.

---

### 2. ERP Tables

#### 👥 `silver.erp_cust_az12`
- **Transforms**:
  - Strip `"NAS"` prefix from `cid`.
  - Remove invalid future `bdate`.
  - Standardize gender values.

#### 🌍 `silver.erp_loc_a101`
- **Transforms**:
  - Remove hyphens from `cid`.
  - Map country codes to full names (e.g. `DE` → Germany, `US` → United States).

#### 🛒 `silver.erp_px_cat_g1v2`
- **Direct Copy** (No transformations)

---

## 🧪 Error Handling

- Wrapped in `TRY...CATCH` block.
- On error:
  - Logs message, error number, and error state using `PRINT`.

---

## 🕒 Auditing and Monitoring

- Logs:
  - Start and end of each table load.
  - Duration (in seconds) of each load step.
  - Total batch duration.

---

## 📜 Full SQL Script

> You can execute or schedule this script using SQL Agent or orchestration tools.

<details>
<summary>Click to expand SQL</summary>

```sql
-- Script available in your SQL environment
EXEC silver.load_silver;
```

</details>

---

## 📌 Notes

- Assumes `bronze` tables are populated and accessible.
- Assumes Silver schema and tables already exist.  
  If not, refer to the [Create Silver Tables Script](#).
- All inserts exclude `dwh_create_date`, which defaults via column definition (`GETDATE()`).

---

## ✅ Example Usage

```sql
-- Refresh Silver Layer
EXEC silver.load_silver;
```

---
