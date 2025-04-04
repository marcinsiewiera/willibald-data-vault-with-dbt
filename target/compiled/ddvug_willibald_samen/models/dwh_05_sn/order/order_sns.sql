



select
  order_snp.sdts, 
  order_snp.hk_order_h, 
  order_snp.hk_order_d, 
  order_h.order_bk,order_ws_s.hk_order_h,
  order_ws_s.hd_order_ws_s,
  order_ws_s.rsrc,
  order_ws_s.ldts,
  order_ws_s.allglieferadrid,
  order_ws_s.bestelldatum,
  order_ws_s.rabatt,
  order_ws_s.wunschdatum,  
  lower(order_ws_s.rsrc)<>'system' has_ws_data
,
order_rs_sts.ldts as ldts_order_rs_sts,

order_rs_sts.rsrc as rsrc_order_rs_sts,

order_ws_sts.ldts as ldts_order_ws_sts,

order_ws_sts.rsrc as rsrc_order_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_h  
on order_h.hk_order_h = order_snp.hk_order_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_rs_sts 
on order_snp.hk_order_rs_sts=order_rs_sts.hk_order_h
and order_snp.ldts_order_rs_sts=order_rs_sts.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_s 
on order_snp.hk_order_ws_s=order_ws_s.hk_order_h
and order_snp.ldts_order_ws_s=order_ws_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_sts 
on order_snp.hk_order_ws_sts=order_ws_sts.hk_order_h
and order_snp.ldts_order_ws_sts=order_ws_sts.ldts 
where  
(
order_snp.HK_order_rs_sts <>'00000000000000000000000000000000' 
OR order_snp.HK_order_ws_s <>'00000000000000000000000000000000' 
OR order_snp.HK_order_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((order_rs_sts.cdc <>'D' and order_rs_sts.hk_order_h <>'00000000000000000000000000000000')
 OR (order_ws_sts.cdc <>'D' and order_ws_sts.hk_order_h <>'00000000000000000000000000000000')
)
  