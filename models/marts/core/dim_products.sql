-- models/dimensions/dim_products.sql
WITH base AS (
    SELECT
        product_id,
        name,
        price,
        inventory,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__products') }}
)
SELECT
    product_id,
    name,
    price,
    inventory,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base
