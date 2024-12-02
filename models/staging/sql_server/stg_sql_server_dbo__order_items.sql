{{ config(materialized='incremental') }}

 SELECT 
       cast( order_id as varchar(36)) as order_id,
       cast( PRODUCT_ID as varchar(36)) as PRODUCT_ID,
       QUANTITY,
       CASE
        WHEN _FIVETRAN_DELETED is null then false
        else true
        END as _FIVETRAN_DELETED,
       CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM {{ source('sql_server_dbo', 'order_items') }} 

--fivetran_deleted  borrar porque todo null