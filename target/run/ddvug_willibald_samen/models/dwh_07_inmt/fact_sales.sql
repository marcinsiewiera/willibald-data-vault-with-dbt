
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.fact_sales
         as
        (
SELECT  *
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.sales_bb s
        );
      
  