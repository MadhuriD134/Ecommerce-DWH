--Create DWH tables in DWH Dataset - customer_service
create or replace table vf-grp-gbissdbx-dev-1.customer_service.Dim_Customer
(  
customer_id string,
customer_name string,
customer_email string,
customer_phone string,
load_date date
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service.Dim_Customer;

create or replace table vf-grp-gbissdbx-dev-1.customer_service.Dim_Product
( 
product_id string,
product_name string,
product_customer_price float64,
product_purchasing_price float64,
load_date date
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service.Dim_Product;

create or replace  table vf-grp-gbissdbx-dev-1.customer_service.Fact_Inventory
(
inventory_id string,
inventory_product_id string,
inventory_quantity int64,
inventory_location string,
load_date date
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service.Fact_Inventory;

create or replace  table vf-grp-gbissdbx-dev-1.customer_service.Fact_Order
(
order_id string,
order_customer_id string,
order_total_price float64,
order_date string,
order_status string,
order_shipping_address string,
order_billing_address string,
order_delivery_date string,
order_payment_method string,
order_payment_status string,
order_payment_date string,
order_shipping_method string,
order_shipping_status string,
order_shipping_date string,
load_date date
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service.Fact_Order;

create or replace  table vf-grp-gbissdbx-dev-1.customer_service.Fact_Order_Item
(
order_id string,
order_product_id string,
order_quantity int64,
load_date date  
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service.Fact_Order_Item;
