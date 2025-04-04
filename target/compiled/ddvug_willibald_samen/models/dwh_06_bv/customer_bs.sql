with cte_relevant_date as
(
	select sdts
	from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.relevant_date 
)
select 
  hk_customer_d
, customer_bk
, vorname
, name 
, geschlecht
, geburtsdatum
, telefon
, mobil
, email
, kreditkarte 
, gueltigbis 
, kkfirma 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_sns s
cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts