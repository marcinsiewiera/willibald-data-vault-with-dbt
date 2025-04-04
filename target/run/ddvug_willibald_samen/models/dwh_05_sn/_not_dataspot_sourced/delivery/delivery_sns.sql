
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.delivery_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_POSITION_H" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_H" COMMENT $$$$, 
  
    "LIEFERDATUM" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$
  
)

   as (
    WITH cte_relevant_date as
(
	select sdts
	from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.relevant_date 
)
select
	  cte_relevant_date.sdts
	, delivery_nhl.hk_position_h
	, delivery_nhl.hk_deliveryadress_h
	, delivery_nhl.lieferdatum
	, delivery_nhl.rsrc 
	, delivery_nhl.ldts
from  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.delivery_nhl
inner join  cte_relevant_date
on cte_relevant_date.sdts >= delivery_nhl.ldts
  );

