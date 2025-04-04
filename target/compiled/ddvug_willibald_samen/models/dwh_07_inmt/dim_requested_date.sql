SELECT 
date_day AS requested_date
, month_name AS requested_month 
, year_actual AS requested_year
, CAST(year_actual AS char(4))||'-'||CAST(week_of_year AS char(2)) AS requested_week
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.date_bs
WHERE date_day BETWEEN to_date('03/01/2022', 'mm/dd/yyyy') AND to_date('04/01/2022', 'mm/dd/yyyy')