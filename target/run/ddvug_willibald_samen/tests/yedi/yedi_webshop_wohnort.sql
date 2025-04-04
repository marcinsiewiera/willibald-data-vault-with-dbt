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
  WHERE table_name = 'load_webshop_wohnort'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        kundeid
    , adresszusatz
    , bis
    , hausnummer
    , land
    , ort
    , plz
    , strasse
    , von
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_wohnort
    where is_check_ok
)
        
, cte_customer as
(
    with cte_customer_h as
    (
        SELECT
            customer_h.hk_customer_h, IFF(customer_bk != '(unknown)', customer_bk, NULL) as kundeid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h customer_h
    )
    ,cte_customer_ws_la_ms as
    (WITH cte_customer_ws_la_ms_date as
        (
            SELECT                       
                  hk_customer_h
                , ldts
                , COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_customer_h  ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
            FROM 
            (
                SELECT distinct 
                      customer_ws_la_ms.hk_customer_h
                    , customer_ws_la_ms.ldts
                FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms customer_ws_la_ms
            )t
        )
        SELECT    
              cte_customer_h.hk_customer_h
            , adresszusatz
    , bis
    , hausnummer
    , land
    , ort
    , plz
    , strasse
    , von, customer_ws_la_ms.ldts, cte_customer_ws_la_ms_date.ledts
        FROM cte_customer_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms customer_ws_la_ms
            ON cte_customer_h.hk_customer_h = customer_ws_la_ms.hk_customer_h
        INNER JOIN cte_customer_ws_la_ms_date            
            ON  customer_ws_la_ms.hk_customer_h = cte_customer_ws_la_ms_date.hk_customer_h  
            AND customer_ws_la_ms.ldts = cte_customer_ws_la_ms_date.ldts
        WHERE customer_ws_la_ms.hk_customer_h <> '00000000000000000000000000000000'
    ) 
    SELECT  
        cte_customer_h.hk_customer_h
        , cte_customer_h.kundeid
        , cte_customer_ws_la_ms.adresszusatz
        , cte_customer_ws_la_ms.bis
        , cte_customer_ws_la_ms.hausnummer
        , cte_customer_ws_la_ms.land
        , cte_customer_ws_la_ms.ort
        , cte_customer_ws_la_ms.plz
        , cte_customer_ws_la_ms.strasse
        , cte_customer_ws_la_ms.von
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_customer_h
    INNER JOIN  cte_customer_ws_la_ms
        ON cte_customer_ws_la_ms.hk_customer_h = cte_customer_h.hk_customer_h
        AND d.ldts between cte_customer_ws_la_ms.ldts AND cte_customer_ws_la_ms.ledts
)
,
cte_target as
(   
    SELECT
    cte_customer.kundeid
    , cte_customer.adresszusatz
    , cte_customer.bis
    , cte_customer.hausnummer
    , cte_customer.land
    , cte_customer.ort
    , cte_customer.plz
    , cte_customer.strasse
    , cte_customer.von 
         , cte_load_date.ldts
    FROM cte_load_date
    INNER JOIN  cte_customer 
        ON cte_load_date.ldts = cte_customer.ldts
            
)
(
    select
            kundeid
    , adresszusatz
    , bis
    , hausnummer
    , land
    , ort
    , plz
    , strasse
    , von
            , ldts
    from cte_load
    MINUS
    select
            kundeid
    , adresszusatz
    , bis
    , hausnummer
    , land
    , ort
    , plz
    , strasse
    , von
            , ldts
    from cte_target
)    
UNION
(
    select
            kundeid
    , adresszusatz
    , bis
    , hausnummer
    , land
    , ort
    , plz
    , strasse
    , von
            , ldts
    from cte_target
    minus
    select
            kundeid
    , adresszusatz
    , bis
    , hausnummer
    , land
    , ort
    , plz
    , strasse
    , von
            , ldts
    from cte_load
)

      
    ) dbt_internal_test