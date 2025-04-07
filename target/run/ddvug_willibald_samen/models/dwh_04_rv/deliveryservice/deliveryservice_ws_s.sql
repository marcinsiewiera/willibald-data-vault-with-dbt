-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_deliveryservice_h = DBT_INTERNAL_DEST.hk_deliveryservice_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_DELIVERYSERVICE_H" = DBT_INTERNAL_SOURCE."HK_DELIVERYSERVICE_H","HD_DELIVERYSERVICE_WS_S" = DBT_INTERNAL_SOURCE."HD_DELIVERYSERVICE_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","EMAIL" = DBT_INTERNAL_SOURCE."EMAIL","FAX" = DBT_INTERNAL_SOURCE."FAX","HAUSNUMMER" = DBT_INTERNAL_SOURCE."HAUSNUMMER","LAND" = DBT_INTERNAL_SOURCE."LAND","NAME" = DBT_INTERNAL_SOURCE."NAME","ORT" = DBT_INTERNAL_SOURCE."ORT","PLZ" = DBT_INTERNAL_SOURCE."PLZ","STRASSE" = DBT_INTERNAL_SOURCE."STRASSE","TELEFON" = DBT_INTERNAL_SOURCE."TELEFON"
    

    when not matched then insert
        ("HK_DELIVERYSERVICE_H", "HD_DELIVERYSERVICE_WS_S", "RSRC", "LDTS", "EMAIL", "FAX", "HAUSNUMMER", "LAND", "NAME", "ORT", "PLZ", "STRASSE", "TELEFON")
    values
        ("HK_DELIVERYSERVICE_H", "HD_DELIVERYSERVICE_WS_S", "RSRC", "LDTS", "EMAIL", "FAX", "HAUSNUMMER", "LAND", "NAME", "ORT", "PLZ", "STRASSE", "TELEFON")

;
    commit;