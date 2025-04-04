
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_associationpartner_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_ORDER_ASSOCIATIONPARTNER_L" COMMENT $$$$, 
  
    "HK_ORDER_ASSOCIATIONPARTNER_D" COMMENT $$$$, 
  
    "HK_ORDER_H" COMMENT $$$$, 
  
    "HK_ASSOCIATIONPARTNER_H" COMMENT $$$$, 
  
    "LDTS_ORDER_ASSOCIATIONPARTNER_RS_ES" COMMENT $$$$, 
  
    "RSRC_ORDER_ASSOCIATIONPARTNER_RS_ES" COMMENT $$$$
  
)

   as (
    



select
  order_associationpartner_snp.sdts, 
  order_associationpartner_snp.hk_order_associationpartner_l, 
  order_associationpartner_snp.hk_order_associationpartner_d, 
  order_associationpartner_l.hk_order_h,
order_associationpartner_l.hk_associationpartner_h
,
order_associationpartner_rs_es.ldts as ldts_order_associationpartner_rs_es,

order_associationpartner_rs_es.rsrc as rsrc_order_associationpartner_rs_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_associationpartner_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_associationpartner_l  
on order_associationpartner_l.hk_order_associationpartner_l = order_associationpartner_snp.hk_order_associationpartner_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_associationpartner_rs_es 
on order_associationpartner_snp.hk_order_associationpartner_rs_es=order_associationpartner_rs_es.hk_order_associationpartner_l
and order_associationpartner_snp.ldts_order_associationpartner_rs_es=order_associationpartner_rs_es.ldts 
where  
(
order_associationpartner_snp.HK_order_associationpartner_rs_es <>'00000000000000000000000000000000' 

)
AND
    ((order_associationpartner_rs_es.cdc <>'D' and order_associationpartner_rs_es.hk_order_associationpartner_l <>'00000000000000000000000000000000')
)
  
  );

