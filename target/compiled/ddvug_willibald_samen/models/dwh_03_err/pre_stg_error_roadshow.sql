select ROW_NUMBER, ldts_source as LDTS, rsrc_source as RSRC, raw_data, CHK_ALL_MSG
from  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_roadshow_bestellung
where not is_check_ok