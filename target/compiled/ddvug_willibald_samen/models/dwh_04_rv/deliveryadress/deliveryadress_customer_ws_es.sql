


 

-- depends_on: WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l


with union_sts as
(	
	SELECT *
	FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_ws_sts
), ledts_calculation as 
(
	select 
		  union_sts.hk_deliveryadress_customer_l
		, deliveryadress_customer_l.hk_customer_h
		, deliveryadress_customer_l.hk_deliveryadress_h
		, union_sts.ldts, coalesce(lead(union_sts.ldts- interval '1 microsecond') over (partition by deliveryadress_customer_l.hk_customer_h order by union_sts.ldts),to_timestamp('8888-12-31t23:59:59', 'yyyy-mm-ddthh24:mi:ss')) as ledts
		, row_number() over (partition by deliveryadress_customer_l.hk_customer_h order by union_sts.ldts desc) =1 is_active, union_sts.rsrc 
	, union_sts.cdc
	from union_sts
	inner join  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l 
		on union_sts.hk_deliveryadress_customer_l=deliveryadress_customer_l.hk_deliveryadress_customer_l)
select
*
, CASE WHEN ledts = TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
	THEN TRUE
	ELSE FALSE
END AS IS_CURRENT


from ledts_calculation
where cdc<>'D'

