select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      with d as
(
    select 
          try_to_number(s.cdm_count_days_from) as tv
        , try_to_number(s.cdm_count_days_to) as tb
        , lead(tv) over (partition by sdts order by tv) next_tv
        , lag(tb) over (partition by sdts order by tb) prev_tb
        , min(tv) over (partition by sdts ) min_tv
        , max(tb) over (partition by sdts ) max_tb
        , cdm_count_days_from
        , cdm_count_days_to
        , rsrc
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.category_deliveryadherence_sns s
 )
select *
from d
where not
(
    (
        (
            prev_tb = tv
        or (prev_tb is null and min_tv = tv)
        )
        and
        (
            next_tv = tb
        or (next_tv is null and max_tb = tb)
        )
    )
    or
    (
        lower(cdm_count_days_from) in ('xxx','zzz')
        or
        lower(cdm_count_days_to) in ('xxx','zzz')
    )
    or rsrc<>'system'
)
--order by sdts, tv
      
    ) dbt_internal_test