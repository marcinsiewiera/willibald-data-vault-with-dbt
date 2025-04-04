



select
  order_customer_snp.sdts, 
  order_customer_snp.hk_order_customer_l, 
  order_customer_snp.hk_order_customer_d, 
  order_customer_l.hk_order_h,
order_customer_l.hk_customer_h
,
order_customer_rs_es.ldts as ldts_order_customer_rs_es,

order_customer_rs_es.rsrc as rsrc_order_customer_rs_es,

order_customer_ws_es.ldts as ldts_order_customer_ws_es,

order_customer_ws_es.rsrc as rsrc_order_customer_ws_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_customer_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_l  
on order_customer_l.hk_order_customer_l = order_customer_snp.hk_order_customer_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_es 
on order_customer_snp.hk_order_customer_rs_es=order_customer_rs_es.hk_order_customer_l
and order_customer_snp.ldts_order_customer_rs_es=order_customer_rs_es.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_ws_es 
on order_customer_snp.hk_order_customer_ws_es=order_customer_ws_es.hk_order_customer_l
and order_customer_snp.ldts_order_customer_ws_es=order_customer_ws_es.ldts 
where  
(
order_customer_snp.HK_order_customer_rs_es <>'00000000000000000000000000000000' 
OR order_customer_snp.HK_order_customer_ws_es <>'00000000000000000000000000000000' 

)
AND
    ((order_customer_rs_es.cdc <>'D' and order_customer_rs_es.hk_order_customer_l <>'00000000000000000000000000000000')
 OR (order_customer_ws_es.cdc <>'D' and order_customer_ws_es.hk_order_customer_l <>'00000000000000000000000000000000')
)
  