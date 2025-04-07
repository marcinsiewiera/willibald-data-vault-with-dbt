-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_rs ("CATEGORY_DELIVERYADHERENCE_NK", "HD_CATEGORY_DELIVERYADHERENCE_MISC_RS", "RSRC", "LDTS", "COUNT_DAYS_FROM", "COUNT_DAYS_TO", "NAME")
        (
            select "CATEGORY_DELIVERYADHERENCE_NK", "HD_CATEGORY_DELIVERYADHERENCE_MISC_RS", "RSRC", "LDTS", "COUNT_DAYS_FROM", "COUNT_DAYS_TO", "NAME"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_rs__dbt_tmp
        );
    commit;