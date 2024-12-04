-- models/dimensions/dim_addresses.sql
WITH base AS (
    SELECT
        address_id,
        address,
        zipcode,
        country,
        state,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
)
SELECT
    address_id,
    address,
    zipcode,
    country,
    state,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base
