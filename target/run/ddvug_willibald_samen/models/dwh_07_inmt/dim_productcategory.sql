
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_productcategory
         as
        (
SELECT  *
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.productcategory_bs s
        );
      
  