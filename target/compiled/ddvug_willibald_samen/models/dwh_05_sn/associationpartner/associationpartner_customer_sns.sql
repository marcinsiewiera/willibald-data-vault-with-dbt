



select
  associationpartner_customer_snp.sdts, 
  associationpartner_customer_snp.hk_associationpartner_customer_l, 
  associationpartner_customer_snp.hk_associationpartner_customer_d, 
  associationpartner_customer_l.hk_customer_h,
associationpartner_customer_l.hk_associationpartner_h
,
associationpartner_customer_ws_es.ldts as ldts_associationpartner_customer_ws_es,

associationpartner_customer_ws_es.rsrc as rsrc_associationpartner_customer_ws_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.associationpartner_customer_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_l  
on associationpartner_customer_l.hk_associationpartner_customer_l = associationpartner_customer_snp.hk_associationpartner_customer_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_ws_es 
on associationpartner_customer_snp.hk_associationpartner_customer_ws_es=associationpartner_customer_ws_es.hk_associationpartner_customer_l
and associationpartner_customer_snp.ldts_associationpartner_customer_ws_es=associationpartner_customer_ws_es.ldts 
where  
(
associationpartner_customer_snp.HK_associationpartner_customer_ws_es <>'00000000000000000000000000000000' 

)
AND
    ((associationpartner_customer_ws_es.cdc <>'D' and associationpartner_customer_ws_es.hk_associationpartner_customer_l <>'00000000000000000000000000000000')
)
  