
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_hierarchy_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_HIERARCHY_L" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_HIERARCHY_D" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_PARENT_H" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_H" COMMENT $$$$, 
  
    "LDTS_PRODUCTCATEGORY_HIERARCHY_WS_STS" COMMENT $$$$, 
  
    "RSRC_PRODUCTCATEGORY_HIERARCHY_WS_STS" COMMENT $$$$
  
)

   as (
    



select
  productcategory_hierarchy_snp.sdts, 
  productcategory_hierarchy_snp.hk_productcategory_hierarchy_l, 
  productcategory_hierarchy_snp.hk_productcategory_hierarchy_d, 
  productcategory_hierarchy_l.hk_productcategory_parent_h,
productcategory_hierarchy_l.hk_productcategory_h
,
productcategory_hierarchy_ws_sts.ldts as ldts_productcategory_hierarchy_ws_sts,

productcategory_hierarchy_ws_sts.rsrc as rsrc_productcategory_hierarchy_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_hierarchy_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_l  
on productcategory_hierarchy_l.hk_productcategory_hierarchy_l = productcategory_hierarchy_snp.hk_productcategory_hierarchy_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_ws_sts 
on productcategory_hierarchy_snp.hk_productcategory_hierarchy_ws_sts=productcategory_hierarchy_ws_sts.hk_productcategory_hierarchy_l
and productcategory_hierarchy_snp.ldts_productcategory_hierarchy_ws_sts=productcategory_hierarchy_ws_sts.ldts 
where  
(
productcategory_hierarchy_snp.HK_productcategory_hierarchy_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((productcategory_hierarchy_ws_sts.cdc <>'D' and productcategory_hierarchy_ws_sts.hk_productcategory_hierarchy_l <>'00000000000000000000000000000000')
)
  
  );

