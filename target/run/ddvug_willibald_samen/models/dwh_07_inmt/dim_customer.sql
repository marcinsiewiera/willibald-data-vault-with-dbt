
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_customer
         as
        (
SELECT  *
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.customer_bs s
        );
      
  