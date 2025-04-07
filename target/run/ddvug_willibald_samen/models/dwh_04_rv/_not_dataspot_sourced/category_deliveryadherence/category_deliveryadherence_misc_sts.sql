-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_sts ("CATEGORY_DELIVERYADHERENCE_NK", "LDTS", "RSRC", "CDC")
        (
            select "CATEGORY_DELIVERYADHERENCE_NK", "LDTS", "RSRC", "CDC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_sts__dbt_tmp
        );
    commit;