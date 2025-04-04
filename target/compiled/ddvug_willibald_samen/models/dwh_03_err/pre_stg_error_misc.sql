select ROW_NUMBER, ldts_source as LDTS, rsrc_source as RSRC, raw_data, CHK_ALL_MSG, true as IS_CHECK_OK
from  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_misc_kategorie_termintreue
where not is_check_ok