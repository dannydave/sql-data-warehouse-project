# 📘 **Naming Conventions – Data Warehouse**

This document defines the **standard naming conventions** for schemas, tables, views, columns, and stored procedures in the enterprise data warehouse. These standards promote **clarity**, **consistency**, and **maintainability** across all data layers.

---

## 📑 Table of Contents

1. [General Principles](#1-🧭-general-principles)  
2. [Table Naming Conventions](#2-📂-table-naming-conventions)  
   - [Bronze Rules](#bronze-rules)  
   - [Silver Rules](#silver-rules)  
   - [Gold Rules](#gold-rules)  
3. [Column Naming Conventions](#3-🧱-column-naming-conventions)  
   - [Surrogate Keys](#🔑-surrogate-keys)  
   - [Technical Columns](#⚙️-technical-columns)  
4. [Stored Procedure Naming Conventions](#4-🛠️-stored-procedure-naming-conventions)

---

## 1. 🧭 General Principles

- ✅ Use **`snake_case`** for all object names: lowercase letters with underscores (`_`) separating words.  
- ✅ All names must be written in **English**.  
- 🚫 Avoid SQL **reserved keywords** (e.g., `select`, `table`, `group`) in object names.  
- ✅ Keep names **concise but descriptive**, aligning with business terminology where possible.

---

## 2. 📂 Table Naming Conventions

Naming rules differ slightly depending on the **data layer** (Bronze, Silver, or Gold):

### Bronze Rules
- Prefix with the **source system name**.
- Use the **exact table name** from the source system.
- **Pattern:** `source_system_entity`  
- **Example:** `crm_customer_info` → Represents raw customer info from CRM.

### Silver Rules
- Same as Bronze: retain original table structure and source context.
- **Pattern:** `source_system_entity`  
- **Example:** `erp_sales_orders` → Refined version of sales orders from ERP.

### Gold Rules
- Use **business-aligned** names based on dimensional modeling.
- Prefix with `dim_`, `fact_`, or `report_` depending on the table role.
- **Pattern:** `category_entity`  
  - `dim_`: Dimension table (e.g., `dim_products`)  
  - `fact_`: Fact table (e.g., `fact_sales`)  
  - `report_`: Aggregated/reporting view (e.g., `report_monthly_sales`)

#### 📘 Glossary of Table Prefixes

| Prefix       | Description                         | Examples                                |
|--------------|-------------------------------------|-----------------------------------------|
| `dim_`       | Dimension table                     | `dim_customers`, `dim_products`         |
| `fact_`      | Fact table with metrics             | `fact_sales`, `fact_orders`             |
| `report_`    | Aggregated/reporting views          | `report_sales_by_region`, `report_mtd`  |

---

## 3. 🧱 Column Naming Conventions

### 🔑 Surrogate Keys
- Use `_key` suffix for all surrogate (system-generated) primary keys.
- **Pattern:** `<entity>_key`  
- **Example:**  
  - `customer_key` in `dim_customers`  
  - `product_key` in `dim_products`

### ⚙️ Technical Columns
- Prefix all system-generated or metadata columns with `dwh_`.
- Used for tracking data lineage, load status, etc.
- **Pattern:** `dwh_<column_name>`  
- **Examples:**  
  - `dwh_load_date` → Timestamp of data load  
  - `dwh_source_file` → Name of source file (if applicable)

---

## 4. 🛠️ Stored Procedure Naming Conventions

Stored procedures used for ETL processes must follow a clear and layer-specific naming pattern:

- **Pattern:** `load_<layer>`  
  - `<layer>`: Represents one of the data layers (`bronze`, `silver`, `gold`)

**Examples:**

| Procedure Name    | Purpose                                    |
|-------------------|--------------------------------------------|
| `load_bronze`     | Ingest raw data into Bronze layer          |
| `load_silver`     | Transform data into Silver layer           |
| `load_gold`       | Populate star schema views in Gold layer   |

---

✅ **Note:** Following these conventions ensures smooth onboarding, easier debugging, and consistent handovers between data engineers, analysts, and business users.
