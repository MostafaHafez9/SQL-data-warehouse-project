/*
==============================================================
Quality Checks
==============================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Do these checks to explore the issues in the bronze layer.
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
==============================================================
*/

==============================================================
--Explore and test the columns in each table
==============================================================

------------------------------
--Explore the crm_cust_info
------------------------------


--Detect the quality issues in the bronze

/*Check if there nulls or duplications in PK
	Expectation: No Result*/

Select
	cst_id,
	count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;



--take a sample and see the issues

select 
	*
from bronze.crm_cust_info
where cst_id = 29466;



--Rank the data to define the correct values

select 
	*,
	ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info;


--use this query as a subquery to know the errors and the right records
--to check the errors Flag_Last != 1 / to chech the correct: flag_last = 1

select
	*
from (select 
			*,
			ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null /*to remove null values*/ )t
where flag_last = 1;


--Quality check
--------------------
/* Check unwanted spaces 
	Expectation: No Results*/

Select 
	cst_first_name /*also check other string columns*/
from bronze.crm_cust_info
where cst_first_name != trim(cst_first_name);



--In the same transformation query 
--Clean the spaces and every previous issues

select
	cst_id,
	cst_key,
	trim(cst_first_name) as cst_first_name,
	trim(cst_last_name) as cst_last_name,
	cst_material_status,
	cst_gndr,
	cst_create_date
from (select 
			*,
			ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null /*to remove null values*/ )t
where flag_last = 1;



--Check the consistency of values in low cordinality columns (cst_gndr & cst_marital_status)

select distinct cst_gndr
from Bronze.crm_cust_info;

--Transform the data (cst_gndr) DWH not allowed abbreviated terms.

select
	cst_id,
	cst_key,
	trim(cst_first_name) as cst_first_name,
	trim(cst_last_name) as cst_last_name,
	case when upper(trim(cst_material_status)) = 'S' then 'Single'
		 when upper(trim(cst_material_status)) = 'M' then 'Married'
		 else 'n/a'
	end cst_marital_status,
	case when upper(trim(cst_gndr)) = 'F' then 'Female'
		 when upper(trim(cst_gndr)) = 'M' then 'Male'
		 else 'n/a'
	end cst_gndr,
	cst_create_date
from (select 
			*,
			ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null /*to remove null values*/ )t
where flag_last = 1;





------------------------------
--Explore the crm_prd_info
------------------------------


--Check the PK
select 
	prd_id,
	count(*)
from Bronze.crm_prd_info
group by prd_id
having count(*) >1;
--There are no nulls


--Go to the 2nd column (prd_key) I'll split this column to 2 columns 1- cat_id 2- prd_key

select
	prd_id,
	prd_key,
	replace(SUBSTRING(prd_key,1,5),'-','_')as cat_id,
	substring(prd_key,7,len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost,0) as prd_cost,
	case when upper(trim(prd_line)) = 'M' then 'Mountain'
		 when upper(trim(prd_line)) = 'R' then 'Road'
		 when upper(trim(prd_line)) = 'S' then 'Other Sales'
		 when upper(trim(prd_line)) = 'T' then 'Touring'
		 else 'n/a'
	end prd_line,
	cast(prd_start_dt as date) as prd_start_dt,
	cast(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_date
from Bronze.crm_prd_info

/*where replace(SUBSTRING(prd_key,1,5),'-','_') not in (select distinct id from Bronze.erp_px_cat_g1v2) 
(Use it when make sure if there are any cat_id not exists in the category table)*/


--Check the crm_prd_info prd_key is mathced with the crm_sales_details sls_prd_key
--where substring(prd_key,7,len(prd_key))  not in (select sls_prd_key from Bronze.crm_sales_details)


--Check the cat_column in the other source to make sure I can connect these columns together
select distinct id from Bronze.erp_px_cat_g1v2;


--Check the crm_sales_details to make sure the prd_key is matched with the prd_key here
select sls_prd_key from Bronze.crm_sales_details



--Check invalid date orders
select * from bronze.crm_prd_info
where prd_start_dt > prd_end_dt;


--Clean up the prd_start_dt and prd_end_date (Take a sample)
select
	prd_id,
	prd_key,
	prd_nm,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt) as prd_end_date_test
from Bronze.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509');



---------------------------------
--Explore the crm_sales_details
---------------------------------



--explore the whole table
select * from bronze.crm_sales_details;


--Explore if there any unwanted spaces (sls_ord_num)
select
	*
from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num);


--check if there any variance between sls_prd_key and silver.crm_prd_info "prd_key"
select *
from Bronze.crm_sales_details
where sls_prd_key not in (select prd_key from Silver.crm_prd_info);


--same check for sls_cust_id
select *
from Bronze.crm_sales_details
where sls_cust_id not in (select cst_id from Silver.crm_cust_info);


--check invalid dates
select 
	sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0

--I'll use NULLIF()
select 
	nullif(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0;


--the char. of date must have 8 char (check if there less than 8 or more than 8)
select 
	nullif(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where len(sls_order_dt) != 8;

--Check everything about dates
select 
	nullif(sls_order_dt,0) sls_order_dt
from bronze.crm_sales_details
where  sls_order_dt <= 0 or 
len(sls_order_dt) != 8 or
sls_order_dt >20500101 /*the outlires*/
or sls_order_dt < 19000101;
--same checks for the other dates columns


--Check if the order date is greater than shipping date or due date
select * 
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;


--check the sales / quantity / price columns
select
	sls_sales as old_sales,
	sls_quantity,
	sls_price as old_price,
	case when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
		 then sls_quantity * abs(sls_price)
		 else sls_sales
	end sls_sales,
	case when sls_price is null or sls_price <= 0 then sls_sales / nullif(sls_quantity,0)
		 else sls_price
	end sls_price
from Bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales <= 0 or sls_quantity <=0 or sls_price <=0
or sls_sales is null or sls_quantity is null or sls_price is null
order by sls_sales,sls_quantity,sls_price;



--======================
--erp system
--======================


------------------------
--erp_cust_az12
------------------------

select 
	cid,
	case when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))
		 else cid
	end cid_,
	bdate,
	case when bdate >GETDATE() then null
		 else bdate
	end bdate_,
	gen,
	case when upper(trim(gen)) in ('F','FEMALE') then 'Female'
		 when upper(trim(gen)) in ('M','MALE') then 'Male'
		 else 'n/a'
	end gen_
from Bronze.erp_cust_az12
--where case when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))
		 else cid
	end not in (select cst_key from Silver.crm_cust_info)

select cst_key from Silver.crm_cust_info


--Check the stadnrdization in gen column
select distinct gen
from Bronze.erp_cust_az12



------------------------
--erp_loc_a101
------------------------


select
	replace(cid,'-','') cid,
	case when trim(cntry) ='DE' then 'Germany'
		 when trim(cntry) in ('US','USA') then 'United States'
		 when trim (cntry) = '' or cntry is null then 'n/a'
		 else trim(cntry)
	end cntry
from Bronze.erp_loc_a101
--where replace(cid,'-','') not in(
select cst_key from Silver.crm_cust_info)


--Data starderdization and consistency (cntry)

select distinct cntry
from Bronze.erp_loc_a101


------------------------
--erp_px_cat_g1v2
------------------------


select 
	id,
	cat,
	subcat,
	maintenance
from bronze.erp_px_cat_g1v2

--check unwanted spaces
select * from bronze.erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)

--data standardization & consistency
select distinct
	subcat
from Bronze.erp_px_cat_g1v2
order by subcat
