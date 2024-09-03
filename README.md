# Ecommerce-DWH
Coding assignment for Ecommerce-DWH  

Requirement Analysis :
The datasources are CSV exports of the operational databases of the ecommerce shop microservices. 5 CSV files received are for - Customer, Product, Order, Order-Item & Inventory.
The ask is to -
1. Create a data model for the datawarehouse.
2. Create a data pipeline to load the data into the datawarehouse.
3. Create a SQL query to calculate the revenue per customer.
4. Create a SQL query to calculate the value of goods stored in the different inventory locations.
5. Create a SQL query to calculate the average order value per customer.
6. Run the data pipeline and execute the SQL queries on the datawarehouse.
7. Have some thought how to improve the usage of the datawarehouse.

Design :
For one time analysis and as per current requirement, I have taken the simplest design for dimension tables as SCD Type-1.


