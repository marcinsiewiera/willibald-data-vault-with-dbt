-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_productcategory_h = DBT_INTERNAL_DEST.hk_productcategory_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_PRODUCTCATEGORY_H" = DBT_INTERNAL_SOURCE."HK_PRODUCTCATEGORY_H","HD_PRODUCTCATEGORY_WS_S" = DBT_INTERNAL_SOURCE."HD_PRODUCTCATEGORY_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","NAME" = DBT_INTERNAL_SOURCE."NAME"
    

    when not matched then insert
        ("HK_PRODUCTCATEGORY_H", "HD_PRODUCTCATEGORY_WS_S", "RSRC", "LDTS", "NAME")
    values
        ("HK_PRODUCTCATEGORY_H", "HD_PRODUCTCATEGORY_WS_S", "RSRC", "LDTS", "NAME")

;
    commit;