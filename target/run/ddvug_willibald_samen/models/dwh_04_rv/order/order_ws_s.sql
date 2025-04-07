-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_order_h = DBT_INTERNAL_DEST.hk_order_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_ORDER_H" = DBT_INTERNAL_SOURCE."HK_ORDER_H","HD_ORDER_WS_S" = DBT_INTERNAL_SOURCE."HD_ORDER_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","ALLGLIEFERADRID" = DBT_INTERNAL_SOURCE."ALLGLIEFERADRID","BESTELLDATUM" = DBT_INTERNAL_SOURCE."BESTELLDATUM","RABATT" = DBT_INTERNAL_SOURCE."RABATT","WUNSCHDATUM" = DBT_INTERNAL_SOURCE."WUNSCHDATUM"
    

    when not matched then insert
        ("HK_ORDER_H", "HD_ORDER_WS_S", "RSRC", "LDTS", "ALLGLIEFERADRID", "BESTELLDATUM", "RABATT", "WUNSCHDATUM")
    values
        ("HK_ORDER_H", "HD_ORDER_WS_S", "RSRC", "LDTS", "ALLGLIEFERADRID", "BESTELLDATUM", "RABATT", "WUNSCHDATUM")

;
    commit;