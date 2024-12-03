{{ config(materialized='incremental') }}

 SELECT 
        cast(order_id as varchar(36)) as order_id,
        CASE 
        WHEN shipping_service = '' THEN 'preparando entrega' 
        when shipping_service ='usps' THEN 'ups'
        ELSE shipping_service 
        END AS shipping_service,
        cast(shipping_cost as number(10,2)) as shipping_cost,
        cast(address_id as varchar(36)) as address_id,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at,
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
        CASE 
        WHEN promo_id IS NULL OR promo_id = '' THEN 'no promo' 
        ELSE promo_id 
        END AS  promo_name,
        CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at,
        cast(order_cost as number(10,2)) as order_cost,
        cast(user_id as varchar(36)) as user_id,
        cast(order_total as number(10,2)) as order_total,
        CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
        status as status_orders,
        CASE
        WHEN _FIVETRAN_DELETED is null then false
        else true
        END as _FIVETRAN_DELETED,
       CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNsED_UTC
     FROM {{ source('sql_server_dbo', 'orders') }} a 

{% if is_incremental() %}

  where _FIVETRAN_SYNCED_UTC > (select max(_FIVETRAN_SYNCED_UTC) from {{ this }})

{% endif %}