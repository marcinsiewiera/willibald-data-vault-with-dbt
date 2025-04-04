
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_sales_date
  
    
    
(
  
    "SALES_DATE" COMMENT $$$$, 
  
    "SALES_MONTH" COMMENT $$$$, 
  
    "SALES_YEAR" COMMENT $$$$, 
  
    "SALES_WEEK" COMMENT $$$$
  
)

   as (
    SELECT 
date_day AS sales_date
, month_name AS sales_month 
, year_actual AS sales_year
, CAST(year_actual AS char(4))||'-'||CAST(week_of_year AS char(2)) AS sales_week
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.date_bs
WHERE date_day BETWEEN to_date('03/01/2022', 'mm/dd/yyyy') AND to_date('04/01/2022', 'mm/dd/yyyy')
  );

