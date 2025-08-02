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
