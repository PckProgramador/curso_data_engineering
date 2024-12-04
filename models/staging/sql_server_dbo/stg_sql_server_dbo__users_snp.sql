{{ config(materialized='table') }}

 SELECT 
        cast(PRODUCT_ID as varchar(36)) as PRODUCT_ID,
        CAST(PRICE AS number(10,2)) AS PRICE,
        NAME,
        CAST(INVENTORY AS INT) AS INVENTORY,
        CASE
        WHEN _FIVETRAN_DELETED is null then false
        else true
        END as _FIVETRAN_DELETED,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM {{ ref('sql_server_products_snp') }} 

-- quitar total_orders ya que todo null, lo mismo con _FIVETRAN_DELETED