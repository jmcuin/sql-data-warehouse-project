
TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
select 
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
		WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
		WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
from(
	SELECT 
	*,
	row_number() over(partition by cst_id order by cst_create_date) as flag_last
	FROM bronze.crm_cust_info
) 
where flag_last = 2

select 
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
		WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
		WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
from(
	SELECT 
	*,
	row_number() over(partition by cst_id order by cst_create_date) as flag_last
	FROM bronze.crm_cust_info
) 
where flag_last = 2

select * from silver.crm_cst_info

------------------------------------------------------ prd_info
select * from bronze.crm_prd_info
select 
	*,
	ROW_NUMBER() OVER(PARTITION BY prd_id order by prd_start_dt) as flag_last
from bronze.crm_prd_info
group by prd_id

TRUNCATE TABLE silver.crm_prd_info;
insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)

select 
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5), '-','_') AS cat_id,
	SUBSTRING(prd_key,7) AS prd_key,
	prd_nm,
	CASE WHEN prd_cost IS NULL THEN 0 ELSE prd_cost END AS prd_cost,
	CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other sales'
		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'n/a' END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER (PARTITION by prd_key order by prd_start_dt)-1 AS DATE) as prd_end_dt
from bronze.crm_prd_info

select * from silver.crm_prd_info
-------------------------------------------------------------------------Sales details
TRUNCATE TABLE silver.crm_sales_details
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,	
	sls_ship_dt,
	sls_due_dt,
	sls_sales,	
	sls_quantity,	
	sls_price
)

select 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN CAST(sls_order_dt AS INT) = 0 OR LENGTH(sls_order_dt)<8 THEN NULL
		ELSE CAST(sls_order_dt AS DATE) END AS sls_order_dt,
	CASE WHEN CAST(sls_ship_dt AS INT) = 0 OR LENGTH(sls_ship_dt)<8 THEN NULL
		ELSE CAST(sls_ship_dt AS DATE) END AS sls_ship_dt,
	CASE WHEN CAST(sls_due_dt AS INT) = 0 OR LENGTH(sls_due_dt)<8 THEN NULL
		ELSE CAST(sls_due_dt AS DATE) END AS sls_due_dt,
	CASE WHEN sls_sales < 0 OR sls_sales IS NULL THEN 0
		ELSE sls_sales END AS sls_sales,
	sls_quantity,
	(nullif(sls_sales,0) * abs(sls_quantity)) as sls_price
from bronze.crm_sales_details

select *
from silver.crm_sales_details

--------------------------------------------------------- erp_cust_az12
TRUNCATE TABLE silver.erp_cust_az12
INSERT INTO silver.erp_cust_az12(
	cid,
	bdate,
	gen
)
select
	case when cid like 'NAS%' THEN SUBSTRING(cid, 4, length(cid))
		ELSE cid END AS cid,
	CASE WHEN bdate > NOW() THEN NULL 
		ELSE bdate END AS bdate,
	CASE WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Male'
	else 'n/a' end as gen	
from bronze.erp_cust_az12


--------------------------------------------------------- erp_loc_a101
TRUNCATE TABLE silver.erp_loc_a101;
INSERT INTO silver.erp_loc_a101(
	cid,
	cntry
)
select
	REPLACE(cid, '-', '') AS cid,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	ELSE TRIM(cntry) END AS cntry
from bronze.erp_loc_a101


--------------------------------------------------------- erp_px_cat_g1v2
TRUNCATE TABLE silver.erp_px_cat_g1v2;
INSERT INTO silver.erp_px_cat_g1v2(
	id_,
	cat,
	subcat,
	maintenance
)
SELECT *
FROM bronze.erp_px_cat_g1v2
