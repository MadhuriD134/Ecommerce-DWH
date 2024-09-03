CREATE OR REPLACE PROCEDURE `vf-grp-gbissdbx-dev-1.customer_service.SP_Load_DWH`()
BEGIN

#Insert all the data from Staging into Dimension
INSERT INTO vf-grp-gbissdbx-dev-1.customer_service.Dim_Customer
SELECT c.*, CURRENT_DATE FROM vf-grp-gbissdbx-dev-1.customer_service_staging.Customer c;

#Insert all the data from Staging into Dimension
INSERT INTO vf-grp-gbissdbx-dev-1.customer_service.Dim_Product
SELECT p.*, CURRENT_DATE FROM vf-grp-gbissdbx-dev-1.customer_service_staging.Product p;

#Insert all the data from Staging into Dimension
INSERT INTO vf-grp-gbissdbx-dev-1.customer_service.Fact_Inventory
SELECT i.*, CURRENT_DATE FROM vf-grp-gbissdbx-dev-1.customer_service_staging.Inventory i;

#Insert all the data from Staging into Dimension
INSERT INTO vf-grp-gbissdbx-dev-1.customer_service.Fact_Order
SELECT o.*, CURRENT_DATE FROM vf-grp-gbissdbx-dev-1.customer_service_staging.Order o;

#Insert all the data from Staging into Dimension
INSERT INTO vf-grp-gbissdbx-dev-1.customer_service.Fact_Order_Item
SELECT oi.*, CURRENT_DATE FROM vf-grp-gbissdbx-dev-1.customer_service_staging.Order_Item oi;

END;