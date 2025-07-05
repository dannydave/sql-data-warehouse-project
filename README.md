# Data Warehouse and Analytics Project 🚀
Welcome to the Data Warehouse and Analytics Project repository!

This project presents a full-stack data warehousing and analytics solution — from raw data ingestion to business intelligence reporting. It's designed as a portfolio project to demonstrate core concepts and best practices in data engineering, SQL-based data warehousing, and analytics.

# 🏗️ Data Architecture (Medallion Architecture)
This project adopts the Medallion Architecture framework, organizing data into three structured layers for efficient processing and analysis:

## Medallion Architecture

![Medallion Architecture](images/medallion_architecture.png)

🔹 Bronze Layer
Raw data is ingested directly from the source systems (CSV files) into the SQL Server database without transformations. This layer serves as the single source of truth and preserves data in its original state.

🔸 Silver Layer
In this stage, data undergoes cleansing, validation, and standardization. It’s transformed into a more structured and queryable format, ensuring consistency and quality for downstream analytics.

🏅 Gold Layer
The final layer contains business-ready, aggregated data modeled into a star schema. This layer is optimized for reporting, dashboarding, and generating actionable insights.

## 📖 Project Overview

This project covers the following components:

- **Data Architecture**: Implementation of a modern data warehouse using the Medallion Architecture, structured into Bronze, Silver, and Gold layers.
- **ETL Pipelines**: Processes for extracting, transforming, and loading data from source systems into the warehouse.
- **Data Modeling**: Design of fact and dimension tables optimized for analytical workloads.
- **Analytics & Reporting**: Development of SQL-based reports and dashboards to generate actionable insights.

## 🎯 Target Audience

This repository is ideal for professionals and students aiming to showcase their skills in:

- SQL Development  
- Data Architecture  
- Data Engineering  
- ETL Pipeline Development  
- Data Modeling  
- Data Analytics

# 🚀 Project Requirements

## Building the Data Warehouse (Data Engineering)

**Objective:**  
Create a modern data warehouse using SQL Server to consolidate sales data, supporting analytical reporting and informed decision-making.

**Specifications:**  
- **Data Sources:** Import data from two systems (ERP and CRM) available as CSV files.  
- **Data Quality:** Clean and address data quality issues before analysis.  
- **Integration:** Merge both data sources into a unified, analysis-ready data model.  
- **Scope:** Process only the most recent dataset; no need for historical data tracking.  
- **Documentation:** Provide comprehensive documentation of the data model for business users and analytics teams.

---

## BI: Analytics & Reporting (Data Analysis)

**Objective:**  
Build SQL-driven analytics to generate insights into:

- Customer Behavior  
- Product Performance  
- Sales Trends  

These insights will equip stakeholders with vital metrics for strategic decisions.
