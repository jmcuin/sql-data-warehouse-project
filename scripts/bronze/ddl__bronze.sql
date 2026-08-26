--bronze layer creation

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
		start_time TIMESTAMP;
		endt_time TIMESTAMP;
		
BEGIN
	RAISE NOTICE 'Loading data...';

		DROP TABLE IF EXISTS bronze.crm_cust_info;
		CREATE TABLE bronze.crm_cust_info(
			cst_id INT,
			cst_key	VARCHAR(50),
			cst_firstname VARCHAR(50),	
			cst_lastname VARCHAR(50),	
			cst_marital_status VARCHAR(50),
			cst_gndr VARCHAR(50),
			cst_create_date DATE
		);
		
		DROP TABLE IF EXISTS bronze.crm_prd_info;
		CREATE TABLE bronze.crm_prd_info(
			prd_id INT,
			prd_key	VARCHAR(50),
			prd_nm VARCHAR(100),
			prd_cost FLOAT,
			prd_line VARCHAR(50),
			prd_start_dt DATE,	
			prd_end_dt DATE
		);
		
		DROP TABLE IF EXISTS bronze.crm_sales_details;
		CREATE TABLE bronze.crm_sales_details(
			sls_ord_num	VARCHAR(50),
			sls_prd_key	VARCHAR(50),
			sls_cust_id	INT,
			sls_order_dt VARCHAR(50),	
			sls_ship_dt	VARCHAR(50),
			sls_due_dt VARCHAR(50),
			sls_sales INT,	
			sls_quantity INT,	
			sls_price FLOAT
		);
		
		DROP TABLE IF EXISTS bronze.erp_cust_az12;
		CREATE TABLE bronze.erp_cust_az12(
			cid	VARCHAR(50),
			bdate DATE,
			gen VARCHAR(50)
		);
		
		DROP TABLE IF EXISTS bronze.erp_loc_a101;
		CREATE TABLE bronze.erp_loc_a101(
			cid	VARCHAR(50),
			cntry VARCHAR(50)
		);
		
		DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
		CREATE TABLE bronze.erp_px_cat_g1v2(
			id_ VARCHAR(50),
			cat VARCHAR(50),
			subcat VARCHAR(50),
			maintenance VARCHAR(50)
		);

		start_time := NOW();
		TRUNCATE TABLE bronze.crm_cust_info;
		\copy bronze.crm_cust_info FROM 'C:/Users/52443/Desktop/data warehouse project/databases/cust_info.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',',  ENCODING 'UTF8');
		
		TRUNCATE TABLE bronze.crm_prd_info;
		\copy bronze.crm_prd_info FROM 'C:/Users/52443/Desktop/data warehouse project/databases/prd_info.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',',  ENCODING 'UTF8');
		
		TRUNCATE TABLE bronze.crm_sales_details;
		\copy bronze.crm_sales_details FROM 'C:/Users/52443/Desktop/data warehouse project/databases/sales_details.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',',  ENCODING 'UTF8');
		
		TRUNCATE TABLE bronze.erp_cust_az12;
		\copy bronze.erp_cust_az12 FROM 'C:/Users/52443/Desktop/data warehouse project/databases/cust_az12.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',',  ENCODING 'UTF8');
		
		TRUNCATE TABLE bronze.erp_loc_a101;
		\copy bronze.erp_loc_a101 FROM 'C:/Users/52443/Desktop/data warehouse project/databases/loc_a101.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',',  ENCODING 'UTF8');
		
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		\copy bronze.erp_px_cat_g1v2 FROM 'C:/Users/52443/Desktop/data warehouse project/databases/px_cat_g1v2.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',',  ENCODING 'UTF8');
		
		end_time := NOW();
	
		RAISE NOTICE 'Data loaded successfully...';

		RAISE NOTICE DATEDIFF(SECOND, start_time, end_time);
	
	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocurrió un error: %', SQLERRM;
END;
$$;
