{{ config(materialized='table') }}

 SELECT 
        cast(user_id as varchar(36)) as user_id,
        CONVERT_TIMEZONE('UTC', UPDATED_AT) AS UPDATED_AT,
        cast(ADDRESS_ID as varchar(36)) as ADDRESS_ID,
        LAST_NAME,
        CONVERT_TIMEZONE('UTC', CREATED_AT) as CREATED_AT,
        PHONE_NUMBER,
        FIRST_NAME,
        EMAIL,
        CASE
        WHEN _FIVETRAN_DELETED is null then false
        else true
        END as _FIVETRAN_DELETED,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM {{ ref('sql_server_users_snp') }} 

-- borramos campo total_orders, ya que todo nulo y ver que hacer con fivetran_deleted ya que también todo nulo
-- tiene sentido?