/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Purpose:
    Perform ETL to populate 'silver' schema tables from 'bronze' schema.

Actions:
    - Truncate Silver tables
    - Insert transformed and cleansed data from Bronze tables

Parameters:
    None

Usage:
    EXEC silver.load_silver;
===============================================================================
*/

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
            cst_id, 
            cst_key, 
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
            prd_id, 
            cat_id, 
            prd_key, 
            prd_nm, 
            prd_cost, 
            prd_line, 
            prd_start_dt, 
            prd_end_dt
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
            sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt,
            sls_sales, sls_quantity, sls_price
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
            |END,
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
        SELECT 
            id, 
            cat, 
            subcat, 
            maintenance
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
END

-- Execute the procedure
EXEC silver.load_silver;


/*
===============================================================================
Quality Checks: Silver Layer
===============================================================================
Purpose:
    Perform quality checks to ensure data integrity, standardization, and 
    consistency across the 'silver' schema.

Checks Include:
    - NULL or duplicate primary keys
    - Unwanted spaces in string fields
    - Data standardization & consistency
    - Invalid or out-of-order date values
    - Logical field relationships

Usage:
    Run this script after loading the Silver Layer data.
    Investigate and resolve any results returned by the queries below.
===============================================================================
*/

-- =============================================================================
-- Table: silver.crm_cust_info
-- =============================================================================

-- Check: NULLs or Duplicates in Primary Key (Expected: No results)
SELECT 
    cst_id,
    COUNT(*) AS cnt
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check: Unwanted spaces in cst_key (Expected: No results)
SELECT 
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Check: Distinct values in cst_marital_status for standardization review
SELECT DISTINCT 
    cst_marital_status
FROM silver.crm_cust_info;


-- =============================================================================
-- Table: silver.crm_prd_info
-- =============================================================================

-- Check: NULLs or Duplicates in Primary Key (Expected: No results)
SELECT 
    prd_id,
    COUNT(*) AS cnt
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check: Unwanted spaces in prd_nm (Expected: No results)
SELECT 
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check: NULL or negative values in prd_cost (Expected: No results)
SELECT 
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Check: Distinct values in prd_line for standardization
SELECT DISTINCT 
    prd_line
FROM silver.crm_prd_info;

-- Check: Invalid date ranges where start date > end date (Expected: No results)
SELECT 
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- =============================================================================
-- Table: silver.crm_sales_details
-- =============================================================================

-- Check: Invalid date values in sls_due_dt from Bronze layer (Expected: No results)
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LEN(sls_due_dt) != 8 
   OR sls_due_dt > 20500101 
   OR sls_due_dt < 19000101;

-- Check: Order date > Ship/Due dates (Expected: No results)
SELECT 
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check: Sales ≠ Quantity * Price OR any NULL/negative values (Expected: No results)
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


-- =============================================================================
-- Table: silver.erp_cust_az12
-- =============================================================================

-- Check: Out-of-range birthdates (Expected: Between 1924-01-01 and Today)
SELECT DISTINCT 
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Check: Distinct gender values for consistency
SELECT DISTINCT 
    gen
FROM silver.erp_cust_az12;


-- =============================================================================
-- Table: silver.erp_loc_a101
-- =============================================================================

-- Check: Distinct country values for standardization
SELECT DISTINCT 
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- =============================================================================
-- Table: silver.erp_px_cat_g1v2
-- =============================================================================

-- Check: Unwanted spaces in category fields (Expected: No results)
SELECT 
    *
FROM silver.erp_px_cat_g1v2
WHERE cat        != TRIM(cat)
   OR subcat     != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Check: Distinct maintenance values for consistency
SELECT DISTINCT 
    maintenance
FROM silver.erp_px_cat_g1v2;
