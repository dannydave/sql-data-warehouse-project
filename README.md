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

