



select
  order_position_snp.sdts, 
  order_position_snp.hk_order_position_l, 
  order_position_snp.hk_order_position_d, 
  order_position_l.hk_position_h,
order_position_l.hk_order_h
,
order_position_rs_sts.ldts as ldts_order_position_rs_sts,

order_position_rs_sts.rsrc as rsrc_order_position_rs_sts,

order_position_ws_sts.ldts as ldts_order_position_ws_sts,

order_position_ws_sts.rsrc as rsrc_order_position_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_position_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_l  
on order_position_l.hk_order_position_l = order_position_snp.hk_order_position_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_rs_sts 
on order_position_snp.hk_order_position_rs_sts=order_position_rs_sts.hk_order_position_l
and order_position_snp.ldts_order_position_rs_sts=order_position_rs_sts.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_ws_sts 
on order_position_snp.hk_order_position_ws_sts=order_position_ws_sts.hk_order_position_l
and order_position_snp.ldts_order_position_ws_sts=order_position_ws_sts.ldts 
where  
(
order_position_snp.HK_order_position_rs_sts <>'00000000000000000000000000000000' 
OR order_position_snp.HK_order_position_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((order_position_rs_sts.cdc <>'D' and order_position_rs_sts.hk_order_position_l <>'00000000000000000000000000000000')
 OR (order_position_ws_sts.cdc <>'D' and order_position_ws_sts.hk_order_position_l <>'00000000000000000000000000000000')
)
  