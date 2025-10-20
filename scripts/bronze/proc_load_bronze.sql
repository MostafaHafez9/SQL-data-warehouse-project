/*
=============================================================================================
  Stored Procedure: Load Bronze Layer (Source → Bronze)
=============================================================================================
  Script Purpose:
          This stored procedure loads data into the 'bronze' schema from external csv files.
          It performs the following actions:
            - Truncates the bronze tables before loading the data.
            - Uses the 'Bulk Insert' commands to load data from csv files to bronze tables.
=============================================================================================
*/

Create or alter procedure bronze.load_bronze as
	begin
		declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
		begin try

			set @batch_start_time = getdate();

			print 'Loading Bronze Layer'
			print '============================================'

			--Load the whole data from the CSV files(CRM system) to the Bronze layer tables

			print 'Loading CRM Tables'
			print '---------------------------------------------'
			--To avoid loading the data again (Truncate)

			print '>> Truncating The Table: Bronze.crm_cust_info'

			set @start_time = GETDATE();
			truncate table bronze.crm_cust_info;

			print 'Inserting the Data Into: bronze.crm_cust_info'

			bulk insert bronze.crm_cust_info
			from 'D:\Data Analysis\SQL With Baraa\V45 to 53 Data Warehouse Project (Data Engineer)\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds'
			print '>> ------------------'

				print '>> Truncating The Table: Bronze.crm_prd_info'
			set @start_time = GETDATE();
			truncate table bronze.crm_prd_info;

			print 'Inserting the Data Into: bronze.crm_prd_info'

			bulk insert bronze.crm_prd_info
			from 'D:\Data Analysis\SQL With Baraa\V45 to 53 Data Warehouse Project (Data Engineer)\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds'
			print '>> ------------------'

			print '>> Truncating The Table: Bronze.crm_sales_details'

			set @start_time = getdate();

			truncate table bronze.crm_sales_details;

			print 'Inserting the Data Into: bronze.crm_sales_details'

			bulk insert bronze.crm_sales_details
			from 'D:\Data Analysis\SQL With Baraa\V45 to 53 Data Warehouse Project (Data Engineer)\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds'
			print '>> ------------------'

			--Load the whole data from the CSV files(ERP system) to the Bronze layer tables
				print 'Loading ERP Tables'
				print '---------------------------------------------'

				print '>> Truncating The Table: Bronze.erp_cust_az12'
			set @start_time = getdate();
			truncate table bronze.erp_cust_az12;

			print 'Inserting the Data Into: bronze.erp_cust_az12'

			bulk insert bronze.erp_cust_az12
			from 'D:\Data Analysis\SQL With Baraa\V45 to 53 Data Warehouse Project (Data Engineer)\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds'
			print '>> ------------------'

			print '>> Truncating The Table: Bronze.erp_loc_a101'

			set @start_time = getdate()
			truncate table bronze.erp_loc_a101;

			print 'Inserting the Data Into: bronze.erp_loc_a101'

			bulk insert bronze.erp_loc_a101
			from 'D:\Data Analysis\SQL With Baraa\V45 to 53 Data Warehouse Project (Data Engineer)\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds'
			print '>> ------------------'

			print '>> Truncating The Table: Bronze.erp_px_cat_g1v2'

			set @start_time = GETDATE()
			truncate table bronze.erp_px_cat_g1v2;

			print 'Inserting the Data Into: bronze.erp_px_cat_g1v2'

			bulk insert bronze.erp_px_cat_g1v2
			from 'D:\Data Analysis\SQL With Baraa\V45 to 53 Data Warehouse Project (Data Engineer)\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
			with(
				firstrow = 2,
				fieldterminator = ',',
				tablock
				);
			set @end_time = GETDATE();
			print '>> Load Duration ' + cast(datediff(second,@start_time,@end_time) as nvarchar)+' seconds';
			print '>> ------------------'

			set @batch_end_time = getdate();
			print '=============================';
			print 'Loading Bronze Layer is completed';
			print '  -Total load duration: ' + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar)+' seconds';
			print '-----------------------------';
		End try

		begin catch
			print '==================================='
			print 'Error Occured during loading bronze';
			print 'Error Message' + error_message();
			print 'Error number' + cast(error_number() as nvarchar);
			print 'Error State' + cast(error_state() as nvarchar);
		end catch
	end;


--Execute the Stored procedure
	exec Bronze.load_bronze;
