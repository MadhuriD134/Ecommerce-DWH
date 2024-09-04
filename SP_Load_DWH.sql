CREATE OR REPLACE PROCEDURE `myfirstproject-269913.customer_service.sp_load_dwh`()
BEGIN

--Insert all the data from Staging into Dimension
INSERT INTO myfirstproject-269913.customer_service.dim_customer
SELECT c.*, CURRENT_DATE FROM myfirstproject-269913.customer_service_staging.customer c;

--Insert all the data from Staging into Dimension
INSERT INTO myfirstproject-269913.customer_service.dim_product
SELECT p.*, CURRENT_DATE FROM myfirstproject-269913.customer_service_staging.product p;

#Insert all the data from Staging into Dimension
INSERT INTO myfirstproject-269913.customer_service.fact_inventory
SELECT i.*, CURRENT_DATE FROM myfirstproject-269913.customer_service_staging.inventory i;

--Insert all the data from Staging into Dimension
INSERT INTO myfirstproject-269913.customer_service.fact_order
SELECT o.*, CURRENT_DATE FROM myfirstproject-269913.customer_service_staging.order o;

--Insert all the data from Staging into Dimension
INSERT INTO myfirstproject-269913.customer_service.fact_order_item
SELECT oi.*, CURRENT_DATE FROM myfirstproject-269913.customer_service_staging.order_item oi;


END;