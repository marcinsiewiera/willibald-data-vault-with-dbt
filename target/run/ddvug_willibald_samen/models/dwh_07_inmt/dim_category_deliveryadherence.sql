
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_category_deliveryadherence
         as
        (
SELECT  *
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.category_deliveryadherence_bs s
        );
      
  