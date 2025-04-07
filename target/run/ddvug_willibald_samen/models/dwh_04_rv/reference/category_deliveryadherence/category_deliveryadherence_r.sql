-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_r ("CATEGORY_DELIVERYADHERENCE_NK", "LDTS", "RSRC")
        (
            select "CATEGORY_DELIVERYADHERENCE_NK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_r__dbt_tmp
        );
    commit;