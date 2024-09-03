--Create Staging tables in Staging Dataset
create or replace  table vf-grp-gbissdbx-dev-1.customer_service_staging.Customer
(
customer_id string,
customer_name string,
customer_email string,
customer_phone string
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service_staging.Customer;

create or replace  table vf-grp-gbissdbx-dev-1.customer_service_staging.Product
(
product_id string,
product_name string,
product_customer_price float64,
product_purchasing_price float64
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service_staging.Product;

create or replace  table vf-grp-gbissdbx-dev-1.customer_service_staging.Inventory
(
inventory_id string,
inventory_product_id string,
inventory_quantity int64,
inventory_location string
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service_staging.Inventory;

create or replace  table vf-grp-gbissdbx-dev-1.customer_service_staging.Order
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
order_shipping_date string
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service_staging.Order;

create or replace table vf-grp-gbissdbx-dev-1.customer_service_staging.Order_Item
(
order_id string,
order_product_id string,
order_quantity int64  
);

select count(*) from vf-grp-gbissdbx-dev-1.customer_service_staging.Order_Item;
