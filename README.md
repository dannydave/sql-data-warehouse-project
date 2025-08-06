---

# 🚀 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse and Analytics Project** — a comprehensive solution showcasing the full data lifecycle from raw ingestion to actionable business insights.

This project is a portfolio-ready demonstration of core data engineering, warehousing, and analytics skills, designed to be easy to understand, reproduce, and extend.

---

## 🏗️ Data Architecture: Medallion Framework

This project leverages the popular **Medallion Architecture** to organize data through progressive refinement stages for scalability, quality, and usability.

### Medallion Architecture Layers

![Medallion Architecture](docs/data_architecture.png)

| Layer      | Description                                                                                          |
| ---------- | ---------------------------------------------------------------------------------------------------- |
| **Bronze** | Raw data ingested *as-is* from source CSV files into SQL Server. Acts as the single source of truth. |
| **Silver** | Cleansed and standardized data, ready for reliable querying and integration across datasets.         |
| **Gold**   | Business-ready, aggregated data modeled in a star schema optimized for analytics and reporting.      |

---

## 📚 Project Overview

This repository delivers:

* **Data Architecture**
  Design and implementation of a robust data warehouse with Bronze, Silver, and Gold layers.

* **ETL Pipelines**
  Automated workflows to extract, transform, and load data from ERP and CRM CSV files into the warehouse.

* **Data Modeling**
  Creation of dimension and fact tables for analytical workloads, following best practices.

* **Analytics & Reporting**
  SQL views and queries to generate actionable insights on customers, products, and sales trends.

---

## 🎯 Who Is This For?

This project is perfect for:

* Data engineers wanting to demonstrate practical SQL and data warehousing skills.
* Data analysts learning to build structured, clean datasets for reporting.
* Students and professionals preparing portfolios that highlight end-to-end data solutions.

---

## ⚙️ Project Requirements & Objectives

### Data Engineering: Building the Data Warehouse

* **Goal:** Create a SQL Server-based modern data warehouse consolidating sales and customer data.
* **Data Sources:** Import ERP and CRM datasets from CSV files.
* **Quality:** Implement cleansing and validation to ensure data integrity.
* **Integration:** Merge sources into a unified, query-optimized model (star schema).
* **Scope:** Focus on the latest dataset only; no historical tracking required.
* **Documentation:** Deliver clear data model documentation for business and analytics teams.

---

### Business Intelligence: Analytics & Reporting

* **Goal:** Develop SQL-based analytics to uncover insights on:

  * Customer behavior patterns
  * Product performance metrics
  * Sales trends and KPIs

* **Outcome:** Empower stakeholders with reliable data for strategic decisions.

---

### 🌟 About Me

Hi! I’m **Daniel Toluwani Adeleke** — a passionate Data Scientist and IT professional with a strong background in Computer Science and Data Science & Business Analytics.  
I specialize in building end-to-end data solutions, from designing robust data warehouses to crafting insightful analytics that empower data-driven decision-making.

With hands-on experience in SQL, Python, and data modeling, I enjoy sharing knowledge, solving real-world business challenges, and continuously learning innovative ways to turn raw data into valuable insights.

Let’s connect and grow our data skills together!

### 🙏 Acknowledgements

This project is based on the excellent work and tutorials by **Baraa Khatib Salkini** (Data With Baraa).  
I’ve learned a lot from his resources and adapted this project to enhance my skills in data warehousing and analytics.  
Check out his content for more great learning materials:  
[YouTube Channel](https://www.youtube.com/@DataWithBaraa) | [GitHub](https://github.com/DataWithBaraa)
