-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_customer_snp ("TYPE", "RSRC", "HK_ORDER_CUSTOMER_D", "HK_ORDER_CUSTOMER_L", "SDTS", "HK_ORDER_CUSTOMER_RS_ES", "LDTS_ORDER_CUSTOMER_RS_ES", "HK_ORDER_CUSTOMER_RS_STS", "LDTS_ORDER_CUSTOMER_RS_STS", "HK_ORDER_CUSTOMER_WS_ES", "LDTS_ORDER_CUSTOMER_WS_ES", "HK_ORDER_CUSTOMER_WS_STS", "LDTS_ORDER_CUSTOMER_WS_STS")
        (
            select "TYPE", "RSRC", "HK_ORDER_CUSTOMER_D", "HK_ORDER_CUSTOMER_L", "SDTS", "HK_ORDER_CUSTOMER_RS_ES", "LDTS_ORDER_CUSTOMER_RS_ES", "HK_ORDER_CUSTOMER_RS_STS", "LDTS_ORDER_CUSTOMER_RS_STS", "HK_ORDER_CUSTOMER_WS_ES", "LDTS_ORDER_CUSTOMER_WS_ES", "HK_ORDER_CUSTOMER_WS_STS", "LDTS_ORDER_CUSTOMER_WS_STS"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_customer_snp__dbt_tmp
        );
    commit;