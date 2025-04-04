
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_productcategory_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_PRODUCT_PRODUCTCATEGORY_L" COMMENT $$$$, 
  
    "HK_PRODUCT_PRODUCTCATEGORY_D" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_H" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "LDTS_PRODUCT_PRODUCTCATEGORY_WS_ES" COMMENT $$$$, 
  
    "RSRC_PRODUCT_PRODUCTCATEGORY_WS_ES" COMMENT $$$$
  
)

   as (
    



select
  product_productcategory_snp.sdts, 
  product_productcategory_snp.hk_product_productcategory_l, 
  product_productcategory_snp.hk_product_productcategory_d, 
  product_productcategory_l.hk_productcategory_h,
product_productcategory_l.hk_product_h
,
product_productcategory_ws_es.ldts as ldts_product_productcategory_ws_es,

product_productcategory_ws_es.rsrc as rsrc_product_productcategory_ws_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_productcategory_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l  
on product_productcategory_l.hk_product_productcategory_l = product_productcategory_snp.hk_product_productcategory_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_ws_es 
on product_productcategory_snp.hk_product_productcategory_ws_es=product_productcategory_ws_es.hk_product_productcategory_l
and product_productcategory_snp.ldts_product_productcategory_ws_es=product_productcategory_ws_es.ldts 
where  
(
product_productcategory_snp.HK_product_productcategory_ws_es <>'00000000000000000000000000000000' 

)
AND
    ((product_productcategory_ws_es.cdc <>'D' and product_productcategory_ws_es.hk_product_productcategory_l <>'00000000000000000000000000000000')
)
  
  );

