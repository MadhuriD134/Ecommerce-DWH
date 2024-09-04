# Ecommerce-DWH
Coding assignment for Ecommerce-DWH  

**Requirement Analysis :**
The datasources are CSV exports of the operational databases of the ecommerce shop microservices. 5 CSV files received are for - Customer, Product, Order, Order-Item & Inventory.
The ask is to -
1. Create a data model for the datawarehouse.
2. Create a data pipeline to load the data into the datawarehouse.
3. Create a SQL query to calculate the revenue per customer.
4. Create a SQL query to calculate the value of goods stored in the different inventory locations.
5. Create a SQL query to calculate the average order value per customer.
6. Run the data pipeline and execute the SQL queries on the datawarehouse.
7. Have some thought how to improve the usage of the datawarehouse.


**Design Considerations / Assumptions:**
1.	For one time analysis and to fulfill current requirements, the simplest design for dimension tables used is SCD Type-1.
2.	As the source data structure doesn’t provide historical data (using DATE/TIME) ; time dimension is not considered in the fact tables Order/Inventory/Order-Item.  So the design of the fact tables is simply Append-Only.
3.	No CDC ( Change Data Capture ) or BAU scheduling is done.
4.	As the technology was not specified, I have used Google Cloud as :
a.	Google Cloud Storage : To put source csv files
b.	Google Big Query : To load Staging data
c.	Google Big Query : To load DWH data
d.	ETL Pipeline is written in python  
e.	Cloud function is used to execute the pipeline

**Answers :**
1.	Create a data model for the datawarehouse.
  a.	Created Staging area to hold source data as is.
  b.	Created DWH Fact and Dimension tables
  DDLs are available in the Code-Artifact mentioned.
2.	Create a data pipeline to load the data into the datawarehouse.
  a.	Python is used to load CSV from GCS into BQ Staging area.
  b.	Once the data has landed on BQ, its better to use BQ SQL to load it into BQ-DWH.
So, Staging-DWH is written in Stored Procedure and then called from python scipt.

3.	Create a SQL query to calculate the revenue per customer. 
SELECT customer_name, ROUND( SUM(order_total_price) ,2) as revenue_per_customer
FROM vf-grp-gbissdbx-dev-1.customer_service.Fact_Order o
     LEFT JOIN vf-grp-gbissdbx-dev-1.customer_service.Dim_Customer c ON o.order_customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC ;

4.	Create a SQL query to calculate the value of goods stored in the different inventory locations.
SELECT i.inventory_location, ROUND(SUM(product_customer_price),2) AS value_of_goods
FROM vf-grp-gbissdbx-dev-1.customer_service.Fact_Inventory i
     LEFT JOIN vf-grp-gbissdbx-dev-1.customer_service.Dim_Product p ON i.inventory_product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC ;

5.	Create a SQL query to calculate the average order value per customer.
--This is considered as total(order value) of a customer / number of orders of a customer
SELECT order_customer_id, SUM(order_total_price) / COUNT(order_id) as avg_order_value_per_customer 
FROM myfirstproject-269913.customer_service.fact_order o 
GROUP BY 1
ORDER BY 2 DESC;
 
6.	Run the data pipeline and execute the SQL queries on the datawarehouse.
  Done. Screenshots attached.
7.	Have some thought how to improve the usage of the datawarehouse.
  1.	To enable historical analysis, source needs to provide DATE for Inventory data so that month-on-month / year-on-year reports of inventory can be created.
  2.	For historical reporting ( as-was + as-is), its recommended to create SCD Type-2 tables for both the dimensions – Customer & Product.
  3.	Order Fact table is generally accumulating snapshot table; in which the same order record gets updated as the order progresses; resulting in the change of order status and shipping/delivery/payment dates. Updates work very well on traditional DBs like Oracle, TD however updates are very slow on Cloud DB like Bigquery. So we can model this table as “periodic snapshot table” and append the data for specified period (daily/monthly). This will result in multiple records for one order & while reporting, we can always consider the latest record of the Order.
  4.	Once DATES are available in Fact tables, we can partition them based on the time grain requirement by the users ( Monthly/Daily/Weekly)

**Code Artifacts:**
GIT Repository has following artifacts:
https://github.com/MadhuriD134/Ecommerce-DWH
  1.	Staging-DDL.sql : DDL for Staging tables
  2.	DWH -DDL.sql : DDL for DWH tables
  3.	SP_Load_DWH : DDL of Stored procedure which loads from Staging into DWH
  4.	Python scripts to be used in Cloud Function
    a.	CF-main.py : Main cloud function
    b.	CF-cs_env.py : Has env variables like Staging-Dataset, src-bucket etc.
    c.	CF-requirements.txt : Python modules to install 
  5.	File_list.txt : It has the lists of all source files which need to be processed. 
  6.	Screenshots of GCS Bucket & Cloud function created



