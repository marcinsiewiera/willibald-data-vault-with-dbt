-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.delivery_nhl ("HK_DELIVERY_L", "HK_DELIVERYADRESS_H", "HK_DELIVERYSERVICE_H", "HK_ORDER_H", "HK_POSITION_H", "LDTS", "RSRC", "BESTELLUNGID", "LIEFERDATUM", "POSID")
        (
            select "HK_DELIVERY_L", "HK_DELIVERYADRESS_H", "HK_DELIVERYSERVICE_H", "HK_ORDER_H", "HK_POSITION_H", "LDTS", "RSRC", "BESTELLUNGID", "LIEFERDATUM", "POSID"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.delivery_nhl__dbt_tmp
        );
    commit;