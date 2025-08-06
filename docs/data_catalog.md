# 📘 Data Catalog – Gold Layer

**Overview:**
The **Gold Layer** serves as the final, business-ready data model in a **Star Schema** format. It consists of **dimension** and **fact** views designed to support advanced **analytics**, **reporting**, and **data visualization** use cases.

---

## 🧍 gold.dim\_customers

**Purpose:**
Stores enriched customer information including demographics and location details. Acts as a dimension table to describe customer entities in analysis.

| Column Name       | Data Type    | Description                                                        |
| ----------------- | ------------ | ------------------------------------------------------------------ |
| `customer_key`    | INT          | Surrogate key uniquely identifying each customer record.           |
| `customer_id`     | INT          | System-generated unique ID for the customer.                       |
| `customer_number` | NVARCHAR(50) | Alphanumeric ID for tracking/reference (e.g., from source system). |
| `first_name`      | NVARCHAR(50) | Customer’s first name.                                             |
| `last_name`       | NVARCHAR(50) | Customer’s last name or surname.                                   |
| `country`         | NVARCHAR(50) | Customer’s country of residence (e.g., 'Australia').               |
| `marital_status`  | NVARCHAR(50) | Marital status (e.g., 'Single', 'Married').                        |
| `gender`          | NVARCHAR(50) | Gender of the customer (e.g., 'Male', 'Female', 'n/a').            |
| `birthdate`       | DATE         | Customer’s date of birth (`YYYY-MM-DD`).                           |
| `create_date`     | DATE         | Timestamp when the record was created in the system.               |

---

## 📦 gold.dim\_products

**Purpose:**
Provides product-related metadata such as category, cost, and classification. Enables slicing of sales by product attributes.

| Column Name            | Data Type    | Description                                                      |
| ---------------------- | ------------ | ---------------------------------------------------------------- |
| `product_key`          | INT          | Surrogate key uniquely identifying each product record.          |
| `product_id`           | INT          | System-assigned product identifier.                              |
| `product_number`       | NVARCHAR(50) | Alphanumeric product code for inventory or tracking.             |
| `product_name`         | NVARCHAR(50) | Name of the product (including type, color, or size).            |
| `category_id`          | NVARCHAR(50) | Identifier for the product’s top-level category.                 |
| `category`             | NVARCHAR(50) | General product classification (e.g., 'Bikes', 'Components').    |
| `subcategory`          | NVARCHAR(50) | Specific product type under a category (e.g., 'Mountain Bikes'). |
| `maintenance_required` | NVARCHAR(50) | Indicates if maintenance is required (`Yes` / `No`).             |
| `cost`                 | INT          | Product base price or cost (in whole currency units).            |
| `product_line`         | NVARCHAR(50) | Product series or line (e.g., 'Road', 'Mountain').               |
| `start_date`           | DATE         | Product availability start date.                                 |

> 🔍 **Note:** Historical products (with end dates) are excluded in the view.

---

## 💰 gold.fact\_sales

**Purpose:**
Captures transactional sales data and connects products and customers for fact-based analysis.

| Column Name     | Data Type    | Description                                                          |
| --------------- | ------------ | -------------------------------------------------------------------- |
| `order_number`  | NVARCHAR(50) | Unique identifier for each sales order (e.g., 'SO54496').            |
| `product_key`   | INT          | Foreign key linking to `dim_products.product_key`.                   |
| `customer_key`  | INT          | Foreign key linking to `dim_customers.customer_key`.                 |
| `order_date`    | DATE         | Date when the sales order was placed.                                |
| `shipping_date` | DATE         | Date when the order was shipped.                                     |
| `due_date`      | DATE         | Date when the payment for the order was due.                         |
| `sales_amount`  | INT          | Total value of the sale (quantity × price), in whole currency units. |
| `quantity`      | INT          | Number of product units sold.                                        |
| `price`         | INT          | Unit price of the product.                                           |

---
