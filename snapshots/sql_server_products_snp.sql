{% snapshot sql_server_products_snp %}

{{
    config(
        target_schema='snapshots',
        unique_key='PRODUCT_ID',
        strategy='timestamp',
        updated_at='_FIVETRAN_SYNCED'
    )
}}

SELECT 
        *
    FROM {{ source('sql_server_dbo', 'products') }} 

{% endsnapshot %}