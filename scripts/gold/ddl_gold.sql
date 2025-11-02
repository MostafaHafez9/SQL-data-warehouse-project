--==========================================
--Gold Layer
--=========================================



--====================
--customers object
--====================

if object_id('gold.dim_customers','v') is not null
	drop view gold.dim_customers

create view gold.dim_customers as
select
	row_number() over(order by cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_first_name as first_name,
	ci.cst_last_name as last_name,
	la.cntry as country,
	ci.cst_marital_status as marital_status,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr --crm is the master for gender info
		 else coalesce(ca.gen,'n/a')
	end gender,
	ca.bdate as birth_date,
	ci.cst_create_date as create_date
from Silver.crm_cust_info ci
left join Silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 la
on ci.cst_key = la.cid;


--check the quality of gold table

select * from gold.dim_customers;



--==================
--product object
--==================

if object_id('gold.dim_products','v') is not null
	drop view gold.dim_products

create view gold.dim_products as
select
	ROW_NUMBER() over(order by pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc 
on pn.cat_id = pc.id
where prd_end_dt is null --filter out all historical data;

  
--check the quality of gold table
  
select * from gold.dim_products;


--============================
--sales object (fact table)
--============================

if object_id('gold.fact_sales','v') is not null
	drop view Gold.fact_sales

create view gold.fact_sales as
select
	sd.sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt as order_date,
	sd.sls_ship_dt as shipping_date,
	sd.sls_due_dt as due_date,
	sd.sls_sales as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join Gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id;


--check the quality of gold table

select * from gold.fact_sales;
