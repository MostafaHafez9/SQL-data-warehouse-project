
--gold layer checks

--=================
--customer object
--=================

--to make sure there are no any duplicates

select
	cst_id,
	count(*)
from (select
	ci.cst_id,
	ci.cst_key,
	ci.cst_first_name,
	ci.cst_last_name,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	ca.bdate,
	ca.gen,
	la.cntry
from Silver.crm_cust_info ci
left join Silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join Silver.erp_loc_a101 la
on ci.cst_key = la.cid)t
group by cst_id
having COUNT(*) >1;

--we will do the data integration because we have 2 columns of gender

select distinct
	ci.cst_gndr,
	ca.gen,
	case when ci.cst_gndr != 'n/a' then ci.cst_gndr --crm is the master for gender info
		 else coalesce(ca.gen,'n/a')
	end new_gen
from Silver.crm_cust_info ci
left join Silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
order by 1,2;



--================
--product object
--================

--check the uniqueness
select
	prd_key,
	count(*)
from (
		select
			pn.prd_id,
			pn.cat_id,
			pn.prd_key,
			pn.prd_nm,
			pn.prd_cost,
			pn.prd_line,
			pn.prd_start_dt,
			pc.cat,
			pc.subcat,
			pc.maintenance
		from silver.crm_prd_info pn
		left join silver.erp_px_cat_g1v2 pc 
		on pn.cat_id = pc.id
		where prd_end_dt is null)t --filter out all historical data
group by prd_key
having count(*) > 1;


--=============
--fact_sales
--=============

--check if all dimension tables can successfully join to the fact table

--check products
select * 
from gold.fact_sales f 
left join gold.dim_products p
on p.product_key = f.product_key
where p.product_key is null;

--check customers
select * 
from gold.fact_sales f 
left join Gold.dim_customers c
on c.customer_key = f.customer_key
where c.customer_key is null;
