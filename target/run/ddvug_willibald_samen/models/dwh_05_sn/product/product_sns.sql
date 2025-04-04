
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "HK_PRODUCT_D" COMMENT $$$$, 
  
    "PRODUCT_BK" COMMENT $$$$, 
  
    "HK_PRODUCT_H_2" COMMENT $$$$, 
  
    "HD_PRODUCT_WS_S" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "BEZEICHNUNG" COMMENT $$$$, 
  
    "PFLANZABSTAND" COMMENT $$$$, 
  
    "PFLANZORT" COMMENT $$$$, 
  
    "PREIS" COMMENT $$$$, 
  
    "TYP" COMMENT $$$$, 
  
    "UMFANG" COMMENT $$$$, 
  
    "HAS_WS_DATA" COMMENT $$$$, 
  
    "LDTS_PRODUCT_WS_STS" COMMENT $$$$, 
  
    "RSRC_PRODUCT_WS_STS" COMMENT $$$$
  
)

   as (
    



select
  product_snp.sdts, 
  product_snp.hk_product_h, 
  product_snp.hk_product_d, 
  product_h.product_bk,product_ws_s.hk_product_h,
  product_ws_s.hd_product_ws_s,
  product_ws_s.rsrc,
  product_ws_s.ldts,
  product_ws_s.bezeichnung,
  product_ws_s.pflanzabstand,
  product_ws_s.pflanzort,
  product_ws_s.preis,
  product_ws_s.typ,
  product_ws_s.umfang,  
  lower(product_ws_s.rsrc)<>'system' has_ws_data
,
product_ws_sts.ldts as ldts_product_ws_sts,

product_ws_sts.rsrc as rsrc_product_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_h  
on product_h.hk_product_h = product_snp.hk_product_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_s 
on product_snp.hk_product_ws_s=product_ws_s.hk_product_h
and product_snp.ldts_product_ws_s=product_ws_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_sts 
on product_snp.hk_product_ws_sts=product_ws_sts.hk_product_h
and product_snp.ldts_product_ws_sts=product_ws_sts.ldts 
where  
(
product_snp.HK_product_ws_s <>'00000000000000000000000000000000' 
OR product_snp.HK_product_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((product_ws_sts.cdc <>'D' and product_ws_sts.hk_product_h <>'00000000000000000000000000000000')
)
  
  );

