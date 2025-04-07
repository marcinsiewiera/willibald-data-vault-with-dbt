-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_customer_h = DBT_INTERNAL_DEST.hk_customer_h
                ) and (
                    DBT_INTERNAL_SOURCE.von = DBT_INTERNAL_DEST.von
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_CUSTOMER_H" = DBT_INTERNAL_SOURCE."HK_CUSTOMER_H","HD_CUSTOMER_WS_LA_MS" = DBT_INTERNAL_SOURCE."HD_CUSTOMER_WS_LA_MS","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","VON" = DBT_INTERNAL_SOURCE."VON","ADRESSZUSATZ" = DBT_INTERNAL_SOURCE."ADRESSZUSATZ","BIS" = DBT_INTERNAL_SOURCE."BIS","HAUSNUMMER" = DBT_INTERNAL_SOURCE."HAUSNUMMER","LAND" = DBT_INTERNAL_SOURCE."LAND","ORT" = DBT_INTERNAL_SOURCE."ORT","PLZ" = DBT_INTERNAL_SOURCE."PLZ","STRASSE" = DBT_INTERNAL_SOURCE."STRASSE"
    

    when not matched then insert
        ("HK_CUSTOMER_H", "HD_CUSTOMER_WS_LA_MS", "RSRC", "LDTS", "VON", "ADRESSZUSATZ", "BIS", "HAUSNUMMER", "LAND", "ORT", "PLZ", "STRASSE")
    values
        ("HK_CUSTOMER_H", "HD_CUSTOMER_WS_LA_MS", "RSRC", "LDTS", "VON", "ADRESSZUSATZ", "BIS", "HAUSNUMMER", "LAND", "ORT", "PLZ", "STRASSE")

;
    commit;