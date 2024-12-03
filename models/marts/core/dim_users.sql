-- models/dimensions/dim_users.sql
WITH base AS (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        phone_number,
        address_id,
        created_at,
        updated_at,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__users') }}
)
SELECT
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    address_id,
    created_at,
    updated_at,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base
