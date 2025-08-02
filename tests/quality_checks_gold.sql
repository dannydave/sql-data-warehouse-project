/*
===============================================================================
Quality Checks: Gold Layer
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of data model relationships for analytics.

Usage Notes:
    - Run these checks after populating the Gold Layer.
    - Investigate and resolve any discrepancies found.
===============================================================================
*/

-- =============================================================================
-- Table: gold.dim_customers
-- =============================================================================

-- Check: Uniqueness of Customer Key (Expected: No duplicate keys)
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- Table: gold.dim_products
-- =============================================================================

-- Check: Uniqueness of Product Key (Expected: No duplicate keys)
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- =============================================================================
-- Table: gold.fact_sales
-- =============================================================================

-- Check: Referential integrity between fact and dimension tables 
--         (Expected: No unmatched keys in fact_sales)
SELECT 
    f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p 
    ON p.product_key = f.product_key
WHERE c.customer_key IS NULL 
   OR p.product_key IS NULL;
