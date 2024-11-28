{{ config(materialized='incremental') }}

SELECT 
    CAST(ADDRESS_ID AS VARCHAR(36)) AS ADDRESS_ID,   -- 36 caracteres porque los UUID tienen 36 caracteres
    CAST(ZIPCODE AS INT) AS ZIPCODE,                  -- Se asume que ZIPCODE es numérico
    CAST(COUNTRY AS VARCHAR(56)) AS COUNTRY,          -- El país más largo en inglés tiene 56 caracteres
    ADDRESS,
    STATE,
    CASE
        WHEN _FIVETRAN_DELETED IS NULL THEN FALSE   -- IS NULL  para manejar valores NULL
        ELSE TRUE
    END AS _FIVETRAN_DELETED,
    -- Conversión de la fecha a UTC (suponiendo que _FIVETRAN_SYNCED es un TIMESTAMP WITH ZONE)
    CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
FROM {{ source('sql_server_dbo', 'addresses') }};
