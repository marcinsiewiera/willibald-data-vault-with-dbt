-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_product_h = DBT_INTERNAL_DEST.hk_product_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_PRODUCT_H" = DBT_INTERNAL_SOURCE."HK_PRODUCT_H","HD_PRODUCT_WS_S" = DBT_INTERNAL_SOURCE."HD_PRODUCT_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","BEZEICHNUNG" = DBT_INTERNAL_SOURCE."BEZEICHNUNG","PFLANZABSTAND" = DBT_INTERNAL_SOURCE."PFLANZABSTAND","PFLANZORT" = DBT_INTERNAL_SOURCE."PFLANZORT","PREIS" = DBT_INTERNAL_SOURCE."PREIS","TYP" = DBT_INTERNAL_SOURCE."TYP","UMFANG" = DBT_INTERNAL_SOURCE."UMFANG"
    

    when not matched then insert
        ("HK_PRODUCT_H", "HD_PRODUCT_WS_S", "RSRC", "LDTS", "BEZEICHNUNG", "PFLANZABSTAND", "PFLANZORT", "PREIS", "TYP", "UMFANG")
    values
        ("HK_PRODUCT_H", "HD_PRODUCT_WS_S", "RSRC", "LDTS", "BEZEICHNUNG", "PFLANZABSTAND", "PFLANZORT", "PREIS", "TYP", "UMFANG")

;
    commit;