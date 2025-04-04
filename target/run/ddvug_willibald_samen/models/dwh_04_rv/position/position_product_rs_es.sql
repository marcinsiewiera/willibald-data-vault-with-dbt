
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_rs_es
  
    
    
(
  
    "HK_POSITION_PRODUCT_L" COMMENT $$$$, 
  
    "HK_POSITION_H" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "LEDTS" COMMENT $$$$, 
  
    "IS_ACTIVE" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "CDC" COMMENT $$$$, 
  
    "IS_CURRENT" COMMENT $$$$
  
)

   as (
    


 

-- depends_on: WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_l


with union_sts as
(	
	SELECT *
	FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_rs_sts
), ledts_calculation as 
(
	select 
		  union_sts.hk_position_product_l
		, position_product_l.hk_position_h
		, position_product_l.hk_product_h
		, union_sts.ldts, coalesce(lead(union_sts.ldts- interval '1 microsecond') over (partition by position_product_l.hk_position_h order by union_sts.ldts),to_timestamp('8888-12-31t23:59:59', 'yyyy-mm-ddthh24:mi:ss')) as ledts
		, row_number() over (partition by position_product_l.hk_position_h order by union_sts.ldts desc) =1 is_active, union_sts.rsrc 
	, union_sts.cdc
	from union_sts
	inner join  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_l 
		on union_sts.hk_position_product_l=position_product_l.hk_position_product_l)
select
*
, CASE WHEN ledts = TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
	THEN TRUE
	ELSE FALSE
END AS IS_CURRENT


from ledts_calculation
where cdc<>'D'


  );

