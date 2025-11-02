# 🧠 Complete Data Warehouse (ETL + Modeling + Architecture)

Welcome to the **Data Warehouse Project** repository! 🚀  
This project showcases a **complete end-to-end Data Warehouse (DWH)** built from scratch — covering **ETL design, data modeling, error handling, logging, and architecture visualization**.  
It’s designed as a **portfolio project** demonstrating real-world **data engineering** and **analytics best practices**.

---

## 🏗️ Medallion Data Architecture

The DWH follows the **Medallion Architecture** with three structured layers:

### 🔹 1. Bronze Layer – Raw Data Ingestion
- Stores raw data as-is from source systems (CRM & ERP).  
- Data is ingested from **CSV files** into **SQL Server** using automated load scripts.  
- Ensures full traceability and data lineage.  
- Includes load time tracking and row count validation.

### 🔸 2. Silver Layer – Transformation & Standardization
- Cleanses and standardizes data using **SQL transformations**.  
- Implements **business rules and logic** to unify data definitions.  
- Includes **TRY...CATCH** blocks for error handling and **logging tables** for ETL monitoring.  
- Aggregates and prepares data for analytics.

### 🏆 3. Gold Layer – Business-Ready Data Model
- Builds **fact and dimension tables** following a **Star Schema** design.  
- Implements **business KPIs**, **metrics**, and **hierarchies**.  
- Represents the foundation for reporting and visualization in **Power BI**.  
- Includes **flattened tables** to optimize performance for reporting.

---

## ⚙️ ETL Process Overview

The ETL pipeline is entirely developed using **SQL Stored Procedures**, divided by layers:

1. **Extraction** – Load data from raw CSV files.  
2. **Transformation** – Clean, standardize, and apply business logic.  
3. **Loading** – Move curated data into Silver and Gold layers.  

### Key Features:
- ✅ **Error Handling** with TRY…CATCH.  
- ✅ **Row Count Checks** to ensure data integrity.  
- ✅ **Execution Logging** to monitor process flow and performance.  
- ✅ **Business Logic Integration** for accurate analytics-ready data.

---

## 🧩 Data Modeling

The **Gold Layer** is built on a **Star Schema**, ensuring efficient analytical queries and easy BI integration.

- **Fact Tables** – Store measurable business data (e.g., revenue, transactions, orders).  
- **Dimension Tables** – Contain descriptive details (e.g., customers, products, dates).  
- Includes **primary-foreign key relationships**, **surrogate keys**, and **lookup references**.

A complete **Data Model Diagram** (draw.io) is included in this repository.

---

## 🪄 Logging & Monitoring

To ensure data quality and traceability:
- Every ETL run is logged in a dedicated **logging table** with timestamps.  
- Each process tracks **row counts**, **start/end times**, and **error messages** (if any).  
- Designed for easy debugging and auditing.

---

## 📁 Repository Structure
📂 Data-Warehouse-Project
┣ 📂 Datasets/ → Raw CRM & ERP source data (CSV)
┣ 📂 Scripts/
┃ ┣ 📂 Bronze/ → Ingestion scripts
┃ ┣ 📂 Silver/ → Transformation scripts
┃ ┗ 📂 Gold/ → Data modeling & business layer scripts
┣ 📂 Diagrams/ → Data Architecture & Star Schema (draw.io)
┣ 📂 Documentation/ → Data Dictionary & Business Rules
┗ 📄 README.md → Project Overview (this file)

---


---

## 📊 Analytics & Reporting (Next Phase)

Once the DWH is ready, it’s connected to **Power BI** to create interactive dashboards —  
visualizing KPIs, revenue trends, customer behavior, and performance insights.

📢 *(The Power BI dashboards will be shared in the next project post.)*

---

## 🧰 Tools & Technologies

- **SQL Server** – Database & ETL  
- **T-SQL Stored Procedures** – Data transformation logic  
- **draw.io** – Data Architecture & Star Schema diagrams  
- **Power BI** – Visualization layer  
- **Excel / CSV** – Data sources  
- **GitHub** – Version control & documentation  

---

## 🧾 Deliverables

✅ Full ETL SQL Scripts (Bronze → Silver → Gold)  
✅ Data Dictionary & Business Rules Documentation  
✅ Architecture & Star Schema Diagrams  
✅ Logging and Error Handling Framework  
✅ Source Datasets (CRM & ERP Systems)  

---

## 🔗 GitHub Repository

All scripts, datasets, and diagrams are included here.  
👉 **Full details and files are available in this repository.**

---

> *Built with passion for data, precision, and performance 💡*

---

## 🌐 Connect With Me

I’d love to connect and share ideas about Data Analytics, Warehousing, and Power BI!  
Let’s connect on **[LinkedIn]([https://www.linkedin.com/in/YOUR-LINKEDIN-USERNAME](https://www.linkedin.com/in/mostafa-hafez-115b11241/))** 💼

