
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryadress_customer_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_CUSTOMER_L" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_CUSTOMER_D" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_H" COMMENT $$$$, 
  
    "HK_CUSTOMER_H" COMMENT $$$$, 
  
    "LDTS_DELIVERYADRESS_CUSTOMER_WS_ES" COMMENT $$$$, 
  
    "RSRC_DELIVERYADRESS_CUSTOMER_WS_ES" COMMENT $$$$
  
)

   as (
    



select
  deliveryadress_customer_snp.sdts, 
  deliveryadress_customer_snp.hk_deliveryadress_customer_l, 
  deliveryadress_customer_snp.hk_deliveryadress_customer_d, 
  deliveryadress_customer_l.hk_deliveryadress_h,
deliveryadress_customer_l.hk_customer_h
,
deliveryadress_customer_ws_es.ldts as ldts_deliveryadress_customer_ws_es,

deliveryadress_customer_ws_es.rsrc as rsrc_deliveryadress_customer_ws_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryadress_customer_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l  
on deliveryadress_customer_l.hk_deliveryadress_customer_l = deliveryadress_customer_snp.hk_deliveryadress_customer_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_ws_es 
on deliveryadress_customer_snp.hk_deliveryadress_customer_ws_es=deliveryadress_customer_ws_es.hk_deliveryadress_customer_l
and deliveryadress_customer_snp.ldts_deliveryadress_customer_ws_es=deliveryadress_customer_ws_es.ldts 
where  
(
deliveryadress_customer_snp.HK_deliveryadress_customer_ws_es <>'00000000000000000000000000000000' 

)
AND
    ((deliveryadress_customer_ws_es.cdc <>'D' and deliveryadress_customer_ws_es.hk_deliveryadress_customer_l <>'00000000000000000000000000000000')
)
  
  );

