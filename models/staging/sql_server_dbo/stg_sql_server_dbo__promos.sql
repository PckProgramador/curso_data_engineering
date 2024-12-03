{{ config(materialized='table') }}

WITH t1 as(
     SELECT 
        *
    FROM {{ source('sql_server_dbo', 'promos') }} 
UNION ALL
    SELECT
    'no promo' AS promo_id, 
    0 AS discount,
    'inactivo' AS status,
    NULL AS _fivetran_deleted, 
    CURRENT_TIMESTAMP AS _fivetran_synced 
)

,base AS (
    SELECT 
        *,
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_surr_key, 
        promo_id AS promo_name
    FROM t1
)

SELECT 
    cast(promo_surr_key as varchar(36)) as promo_id, 
    cast(promo_name as varchar(100)) as promo_name,
    cast(discount as number(10,2)) as discount,
    status,
    CASE
    WHEN _FIVETRAN_DELETED is null then false
    else true
    END as _FIVETRAN_DELETED,
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM base