
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_associationpartner_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_CUSTOMER_ASSOCIATIONPARTNER_L" COMMENT $$$$, 
  
    "HK_CUSTOMER_ASSOCIATIONPARTNER_D" COMMENT $$$$, 
  
    "HK_CUSTOMER_H" COMMENT $$$$, 
  
    "HK_ASSOCIATIONPARTNER_H" COMMENT $$$$, 
  
    "LDTS_CUSTOMER_ASSOCIATIONPARTNER_WS_ES" COMMENT $$$$, 
  
    "RSRC_CUSTOMER_ASSOCIATIONPARTNER_WS_ES" COMMENT $$$$
  
)

   as (
    



select
  customer_associationpartner_snp.sdts, 
  customer_associationpartner_snp.hk_customer_associationpartner_l, 
  customer_associationpartner_snp.hk_customer_associationpartner_d, 
  customer_associationpartner_l.hk_customer_h,
customer_associationpartner_l.hk_associationpartner_h
,
customer_associationpartner_ws_es.ldts as ldts_customer_associationpartner_ws_es,

customer_associationpartner_ws_es.rsrc as rsrc_customer_associationpartner_ws_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_associationpartner_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_l  
on customer_associationpartner_l.hk_customer_associationpartner_l = customer_associationpartner_snp.hk_customer_associationpartner_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_ws_es 
on customer_associationpartner_snp.hk_customer_associationpartner_ws_es=customer_associationpartner_ws_es.hk_customer_associationpartner_l
and customer_associationpartner_snp.ldts_customer_associationpartner_ws_es=customer_associationpartner_ws_es.ldts 
where  
(
customer_associationpartner_snp.HK_customer_associationpartner_ws_es <>'00000000000000000000000000000000' 

)
AND
    ((customer_associationpartner_ws_es.cdc <>'D' and customer_associationpartner_ws_es.hk_customer_associationpartner_l <>'00000000000000000000000000000000')
)
  
  );

