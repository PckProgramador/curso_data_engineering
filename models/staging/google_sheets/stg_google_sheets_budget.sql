{{ config(materialized='table') }}

SELECT 
   CAST(quantity AS INT) AS quantity,
   month(month) as month,
   year(month) as year,
   cast(product_id as varchar(36)) as product_id,
   CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM {{ source('google_sheets', 'budget') }} -- Fuente original