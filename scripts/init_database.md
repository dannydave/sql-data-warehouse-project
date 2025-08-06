# 🛠️ Create Database and Schemas – `DataWarehouse`

This script is used to **initialize the `DataWarehouse` database** by dropping any existing instance, recreating it, and setting up the core schemas: `bronze`, `silver`, and `gold`.

> ⚠️ **Warning**  
> This script will **permanently delete** the existing `DataWarehouse` database and all its contents.  
> Ensure you have valid **backups** before proceeding.

---

## 💾 SQL Script

```sql
/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
```

---

## 🧱 Result

Once executed, this script will provide the following:

| Database        | Schemas Created               |
|------------------|-------------------------------|
| `DataWarehouse` | `bronze`, `silver`, `gold`     |

Use this structure to support a **layered data lake architecture** within your SQL Server environment.

---
