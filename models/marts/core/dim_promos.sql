-- models/dimensions/dim_promos.sql
WITH base AS (
    SELECT
        promo_id,
        promo_name,
        discount,
        status_promo,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__promos') }}
)
SELECT
    promo_id,
    promo_name,
    discount,
    status_promo,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base
