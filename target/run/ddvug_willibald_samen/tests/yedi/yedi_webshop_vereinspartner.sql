select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

WITH
cte_load_date as
(
  SELECT file_ldts as ldts
  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
  WHERE table_name = 'load_webshop_vereinspartner'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        vereinspartnerid
    , kundeidverein
    , rabatt1
    , rabatt2
    , rabatt3
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_vereinspartner
    where is_check_ok
)
        
, cte_associationpartner as
(
    with cte_associationpartner_h as
    (
        SELECT
            associationpartner_h.hk_associationpartner_h, IFF(associationpartner_bk != '(unknown)', associationpartner_bk, NULL) as vereinspartnerid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_h associationpartner_h
    )
    ,cte_associationpartner_ws_s as
    (
        SELECT    
              cte_associationpartner_h.hk_associationpartner_h
            , kundeidverein
    , rabatt1
    , rabatt2
    , rabatt3, associationpartner_ws_s.ldts, COALESCE(LEAD(associationpartner_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_associationpartner_h.hk_associationpartner_h  ORDER BY associationpartner_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_associationpartner_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_s associationpartner_ws_s
            ON cte_associationpartner_h.hk_associationpartner_h = associationpartner_ws_s.hk_associationpartner_h
        WHERE associationpartner_ws_s.hk_associationpartner_h <> '00000000000000000000000000000000'
    )
    ,cte_associationpartner_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_associationpartner_h.hk_associationpartner_h, associationpartner_ws_sts.ldts, associationpartner_ws_sts.cdc, COALESCE(LEAD(associationpartner_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_associationpartner_h.hk_associationpartner_h  ORDER BY associationpartner_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_associationpartner_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_sts associationpartner_ws_sts
            ON cte_associationpartner_h.hk_associationpartner_h = associationpartner_ws_sts.hk_associationpartner_h
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_associationpartner_h.hk_associationpartner_h
        , cte_associationpartner_h.vereinspartnerid
        , cte_associationpartner_ws_s.kundeidverein
        , cte_associationpartner_ws_s.rabatt1
        , cte_associationpartner_ws_s.rabatt2
        , cte_associationpartner_ws_s.rabatt3
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_associationpartner_h
    INNER JOIN  cte_associationpartner_ws_s
        ON cte_associationpartner_ws_s.hk_associationpartner_h = cte_associationpartner_h.hk_associationpartner_h
        AND d.ldts between cte_associationpartner_ws_s.ldts AND cte_associationpartner_ws_s.ledts
    INNER JOIN  cte_associationpartner_ws_sts
        ON cte_associationpartner_ws_sts.hk_associationpartner_h = cte_associationpartner_h.hk_associationpartner_h
        AND d.ldts between cte_associationpartner_ws_sts.ldts AND cte_associationpartner_ws_sts.ledts
)
        
, cte_customer as
(
        SELECT
            customer_h.hk_customer_h, IFF(customer_bk != '(unknown)', customer_bk, NULL) as kundeidverein
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h customer_h
)
        
, cte_associationpartner_customer as
(
    with cte_associationpartner_customer_l as
    (
        SELECT
            associationpartner_customer_l.hk_associationpartner_customer_l, hk_customer_h
    , hk_associationpartner_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_l associationpartner_customer_l
    )
    ,cte_associationpartner_customer_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_associationpartner_customer_l.hk_associationpartner_customer_l, associationpartner_customer_ws_sts.ldts, associationpartner_customer_ws_sts.cdc, COALESCE(LEAD(associationpartner_customer_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_associationpartner_customer_l.hk_associationpartner_customer_l  ORDER BY associationpartner_customer_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_associationpartner_customer_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_ws_sts associationpartner_customer_ws_sts
            ON cte_associationpartner_customer_l.hk_associationpartner_customer_l = associationpartner_customer_ws_sts.hk_associationpartner_customer_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_associationpartner_customer_l.hk_associationpartner_customer_l
        , cte_associationpartner_customer_l.hk_customer_h
        , cte_associationpartner_customer_l.hk_associationpartner_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_associationpartner_customer_l
    INNER JOIN  cte_associationpartner_customer_ws_sts
        ON cte_associationpartner_customer_ws_sts.hk_associationpartner_customer_l = cte_associationpartner_customer_l.hk_associationpartner_customer_l
        AND d.ldts between cte_associationpartner_customer_ws_sts.ldts AND cte_associationpartner_customer_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_associationpartner.vereinspartnerid
    , cte_customer.kundeidverein
    , cte_associationpartner.rabatt1
    , cte_associationpartner.rabatt2
    , cte_associationpartner.rabatt3, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_associationpartner_customer
        ON cte_associationpartner_customer.ldts = cte_load_date.ldts
    INNER JOIN  cte_customer 
        ON cte_associationpartner_customer.hk_customer_h = cte_customer.hk_customer_h
    INNER JOIN  cte_associationpartner 
        ON cte_associationpartner_customer.hk_associationpartner_h = cte_associationpartner.hk_associationpartner_h
        AND cte_associationpartner.ldts =  cte_load_date.ldts
)
(
    select
            vereinspartnerid
    , kundeidverein
    , rabatt1
    , rabatt2
    , rabatt3
            , ldts
    from cte_load
    MINUS
    select
            vereinspartnerid
    , kundeidverein
    , rabatt1
    , rabatt2
    , rabatt3
            , ldts
    from cte_target
)    
UNION
(
    select
            vereinspartnerid
    , kundeidverein
    , rabatt1
    , rabatt2
    , rabatt3
            , ldts
    from cte_target
    minus
    select
            vereinspartnerid
    , kundeidverein
    , rabatt1
    , rabatt2
    , rabatt3
            , ldts
    from cte_load
)

      
    ) dbt_internal_test