
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.relevant_date
         as
        (
	select *
	from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v1 b
        );
      
  